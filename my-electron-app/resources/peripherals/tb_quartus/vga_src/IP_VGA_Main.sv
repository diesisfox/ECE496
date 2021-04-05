/**
* REQUIRES 50.00 MHz clock on CLK_50MHZ, which should be available on the DE1-SoC
* 
* write 1 to START sends start condition and sends address byte.
* STARTing while bus claimed sends repeat START and address byte.
* START becomes 0 when start condition + address sent.
*
* write 1 to TXN after start to read/write a byte into/from DATA.
* TXN becomes 0 when byte done. Bus is not automatically released.
*
* writing 1 to STOP to send stop condition and releases bus.
* writing 1 to STOP while transacting aborts txn.
* STOP becomes 0 when done.
* writing 1 to STOP when already stopped resets the peripheral.
*
* read from NACK for the ACK/NACK status of the last byte read. 1 is NACK.
* write to NACK before reading a byte to send appropriate ack.
*
* set ADDR, R/Wn appropriately before START.
* set DATA appropriately before TXN.
*
* R/Wn is the R/W bit in i2c protocol, and controls what TXN does.
* changing R/Wn while bus calimed without issuing a restart breaks the rules.
*
* speed may be changed when bus released. 1 = 400k, 0 = 100k.
*
* regs writeable while bus claimed when start|stop|txn == 0.
**/ 
module IP_VGA_Main #(
    parameter ADDR = 'h1000_0000,
    parameter DEPTH = 3, // [0-8], max 1228800 bits total vram (1280x960 @ 1bpp), 0 means no palette
    parameter W_DIV_1280 = 1, //[0-8]
    parameter H_DIV_960 = 1, //[0-6]
    parameter VRAM_MIF_HEX = "",
    parameter PALETTE_MIF_HEX = ""
) (
    Simple_Worker_Mem_IF.WORKER Bus,
    IP_VGA_IF.Peripheral VGA_IF
);

// memory map
localparam ADDRBITS = 5;
localparam EN_OFFSET = 'h00; // {...[31:1], EN}
localparam X_ADDR_OFFSET = 'h04; // {...[31:11], X[10:0]}
localparam Y_ADDR_OFFSET = 'h08; // {...[31:10], Y[9:0]}
localparam DATA_OFFSET = 'h0c; // {...[31:DEPTH], COLOR[DEPTH-1:0]} OR {...[31:24], B[7:0], G[7:0], R[7:0]}
localparam PALETTE_ADDR_OFFSET = 'h10; // {...[31:DEPTH], P[DEPTH-1:0]}
localparam COLOR_OFFSET = 'h14; // {...[31:24], B[7:0], G[7:0], R[7:0]}
localparam UNUSED_OFFSET = 'h18;
localparam SCANLINE_OFFSET = 'h1c; // {...[31:10], SCANLINE[9:0]}

`define max(a, b) (((a) > (b)) ? (a) : (b))

// params and constants
localparam MAX_W = 1280 >> W_DIV_1280;
localparam MAX_H = 960 >> H_DIV_960;

// mapped registers
logic en = 'b0; // transmit(ting) address byte
logic [10-W_DIV_1280:0] x_in = 'b0;
logic [9-H_DIV_960:0] y_in = 'b0;
logic [`max(DEPTH-1, 0):0] p_in = 'b0;

// additional state registers
wire [9-H_DIV_960:0] scanline;
logic twoBusCycle = '0;

// synchronizers
logic en_s1, en_s2;
always_ff @(posedge VGA_IF.VGA_CLK) begin
    en_s1 <= en;
    en_s2 <= en_s1;
end
logic [9-H_DIV_960:0] scanline_s1, scanline_s2;
always_ff @(posedge Bus.clock) begin
    scanline_s1 <= scanline;
    scanline_s2 <= scanline_s1;
end

// video memory
bit [DEPTH==0?23:(DEPTH-1):0] vram [0:MAX_W-1][0:MAX_H-1];
initial if(VRAM_MIF_HEX != "") $readmemh(VRAM_MIF_HEX, vram);
logic [DEPTH-1:0] vram_out_bus = '0;
always_ff @(posedge Bus.clock) vram_out_bus <= vram[x_in][y_in];

bit [23:0] palette [0:2**(`max(DEPTH-1, 0))]; // {b[7:0], g[7:0], r[7:0]}
initial if(PALETTE_MIF_HEX != "") $readmemh(PALETTE_MIF_HEX, palette);
logic [23:0] palette_out_bus = '0;
always_ff @(posedge Bus.clock) palette_out_bus <= palette[p_in];

// pll
IP_VGA_PLL_Altera pll(
    .refclk(CLK_50MHZ),
    .rst(0),
    .outclk_0 (VGA_IF.VGA_CLK)
);

// helper functions
function logic [31:0] maskBytes(logic [31:0] old, logic [31:0] in, logic[3:0] en);
    return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
endfunction

task reset();
    en <= 'b1;
    x_in <= 'b0;
    y_in <= 'b0;
    p_in <= 'b0;
    twoBusCycle = '0;
    Bus.wr_ready <= '0;
    Bus.rd_ready <= '0;
    Bus.rd_data <= '0;
endtask

// Bus side logic
always_ff @(posedge Bus.clock) begin
    if (!Bus.reset_n) begin
        reset();
    end else begin
        // defaults (silent stasis)
        en <= en;
        x_in <= x_in;
        y_in <= y_in;
        p_in <= p_in;
        twoBusCycle <= twoBusCycle;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;

        // write register
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.wr_valid)begin
            Bus.wr_ready <= '1;
            unique case (Bus.wr_addr[ADDRBITS-1:0])
                EN_OFFSET: en <= maskBytes({31'd0,en}, Bus.wr_data, Bus.wr_byteEn);
                X_ADDR_OFFSET:begin
                    if(twoBusCycle) twoBusCycle <= 1'b0;
                    else begin
                        x_in <= maskBytes({31'd0,x_in}, Bus.wr_data, Bus.wr_byteEn);
                        twoBusCycle <= 1'b1;
                        Bus.wr_ready <= 1'b0;
                    end
                end
                Y_ADDR_OFFSET:begin
                    if(twoBusCycle) twoBusCycle <= 1'b0;
                    else begin
                        y_in <= maskBytes({31'd0,y_in}, Bus.wr_data, Bus.wr_byteEn);
                        twoBusCycle <= 1'b1;
                        Bus.wr_ready <= 1'b0;
                    end
                end
                DATA_OFFSET: begin
                    if(twoBusCycle) twoBusCycle <= 1'b0;
                    else begin
                        vram[x_in][y_in] <= maskBytes({31'd0,vram_out_bus}, Bus.wr_data, Bus.wr_byteEn);
                        twoBusCycle <= 1'b1;
                        Bus.wr_ready <= 1'b0;
                        x_in <= (x_in == MAX_W-1) ? '0 : (x_in + '1);
                        y_in <= (x_in == MAX_W-1) ? ((y_in == MAX_H-1) ? '0 : (y_in + '1)) : y_in;
                    end
                end
                PALETTE_ADDR_OFFSET: begin
                    if(DEPTH!=0)begin
                        if(twoBusCycle) twoBusCycle <= 1'b0;
                        else begin
                            p_in <= maskBytes({31'd0,p_in}, Bus.wr_data, Bus.wr_byteEn);
                            twoBusCycle <= 1'b1;
                            Bus.wr_ready <= 1'b0;
                        end
                    end
                end
                COLOR_OFFSET: begin
                    if(DEPTH!=0)begin
                        if(twoBusCycle) twoBusCycle <= 1'b0;
                        else begin
                            palette[p_in] <= maskBytes({31'd0,palette_out_bus}, Bus.wr_data, Bus.wr_byteEn);
                            twoBusCycle <= 1'b1;
                            Bus.wr_ready <= 1'b0;
                            p_in <= (p_in == 2**DEPTH-1) ? '0 : (p_in + '1);
                        end
                    end
                end
            endcase
        end

        // read register
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.rd_valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                EN_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,en}, Bus.rd_byteEn);
                X_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,x_in}, Bus.rd_byteEn);
                Y_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,y_in}, Bus.rd_byteEn);
                DATA_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,vram_out_bus}, Bus.rd_byteEn);
                PALETTE_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,p_in}, Bus.rd_byteEn);
                COLOR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,palette_out_bus}, Bus.rd_byteEn);
                SCANLINE_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,scanline_s2}, Bus.rd_byteEn);
            endcase
        end
    end
end

// VGA side logic

// params and constants
localparam H_SYNC_PX = 136-1;
localparam H_BACK_PX = 216-1;
localparam H_ACTIVE_PX = 1280-1;
localparam H_FRONT_PX = 80-1;
localparam V_SYNC_LN = 3-1;
localparam V_BACK_LN = 30-1;
localparam V_ACTIVE_LN = 960-1;
localparam V_FRONT_LN = 1-1;

// types
typedef enum bit [1:0] {
    SYNC,
    BACK,
    ACTIVE,
    FRONT
} TState_e;

// additional state registers
TState_e xState = SYNC;
TState_e yState = SYNC;
logic [10-W_DIV_1280:0] x_out = 'b0;
logic [9-H_DIV_960:0] y_out = 'b0;
logic [10-W_DIV_1280:0] x_comp;
logic [9-H_DIV_960:0] y_comp;
logic [23:0] p_out = 'b0;
logic blank_1, hsync_1, vsync_1;

// IO init
initial begin
    {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.IF_VGA.R} = 24'b0;
    VGA_IF.VGA_SYNC_N = 'b1;
    VGA_IF.VGA_BLANK_N = 'b0;
    VGA_IF.VGA_HS = 'b0;
    VGA_IF.VGA_VS = 'b0;
end

// VGA controller
always_comb begin : xyComp
    unique case(xState)
        SYNC: x_comp = H_SYNC_PX;
        BACK: x_comp = H_BACK_PX;
        ACTIVE: x_comp = H_ACTIVE_PX;
        FRONT: x_comp = H_FRONT_PX;
    endcase
    unique case(yState)
        SYNC: y_comp = V_SYNC_LN;
        BACK: y_comp = V_BACK_LN;
        ACTIVE: y_comp = V_ACTIVE_LN;
        FRONT: y_comp = V_FRONT_LN;
    endcase
end

assign scanline = yState == ACTIVE ? y_out : 'b0;

always @(posedge VGA_IF.VGA_CLK) begin : VgaController
    if(!en_s2)begin
        x_out <= 'b0;
        y_out <= 'b0;
        xState <= SYNC;
        yState <= SYNC;
    end else begin
        // defaults (count up)
        x_out <= x_out + 'b1;
        y_out <= 'b0;
        xState <= xState;
        yState <= yState;
        if(x_out == x_comp)begin
            x_out <= 'b0;
            y_out <= y_out + 'b1;
            unique case(xState)
                SYNC: xState <= BACK;
                BACK: xState <= ACTIVE;
                ACTIVE: xState <= FRONT;
                FRONT: xState <= SYNC;
            endcase
            if(y_out == y_comp)begin
                y_out <= 'b0;
                unique case(yState)
                    SYNC: yState <= BACK;
                    BACK: yState <= ACTIVE;
                    ACTIVE: yState <= FRONT;
                    FRONT: yState <= SYNC;
                endcase
            end
        end
    end
end

always @(posedge VGA_IF.VGA_CLK) begin : VgaDatapath
    if(!en_s2)begin
        p_out <= 'b0;
        blank_1 <= 'b0;
        hsync_1 <= 'b0;
        vsync_1 <= 'b0;
        {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA.R} <= 24'b0;
        VGA_IF.VGA_SYNC_N <= 'b1;
        VGA_IF.VGA_BLANK_N <= 'b0;
        VGA_IF.VGA_HS <= 'b0;
        VGA_IF.VGA_VS <= 'b0;
    end else begin
        // defaults (stasis)
        p_out <= p_out;
        blank_1 <= blank_1;
        hsync_1 <= hsync_1;
        vsync_1 <= vsync_1;
        {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA.R} <= {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA.R};
        VGA_IF.VGA_SYNC_N <= VGA_IF.VGA_SYNC_N;
        VGA_IF.VGA_BLANK_N <= VGA_IF.VGA_BLANK_N;
        VGA_IF.VGA_HS <= VGA_IF.VGA_HS;
        VGA_IF.VGA_VS <= VGA_IF.VGA_VS;
        // cycle 0: FSM logic
        // cycle 1:
        if(DEPTH == 0)begin
            p_out <= 'b0;
        end else begin
            p_out <= vram[x_out][y_out];
        end
        blank_1 <= xState != ACTIVE || yState != ACTIVE;
        hsync_1 <= xState == SYNC;
        vsync_1 <= yState == SYNC;
        // cycle 2:
        {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA.R} <= DEPTH == 0 ? p_out : palette[p_out];
        VGA_IF.VGA_SYNC_N <= ~(hsync_1 | vsync_1);
        VGA_IF.VGA_BLANK_N <= ~blank_1;
        VGA_IF.VGA_HS <= hsync_1;
        VGA_IF.VGA_VS <= vsync_1;
    end
end
    
endmodule


/*
    Name          640x480p60
    Standard      Historical
    VIC                    1
    Short Name       DMT0659
    Aspect Ratio         4:3

    Pixel Clock       25.175 MHz
    TMDS Clock       251.750 MHz
    Pixel Time          39.7 ns ±0.5%
    Horizontal Freq.  31.469 kHz
    Line Time           31.8 μs
    Vertical Freq.    59.940 Hz
    Frame Time          16.7 ms

    Horizontal Timings
    Active Pixels        640
    Front Porch           16
    Sync Width            96
    Back Porch            48
    Blanking Total       160
    Total Pixels         800
    Sync Polarity        neg

    Vertical Timings
    Active Lines         480
    Front Porch           10
    Sync Width             2
    Back Porch            33
    Blanking Total        45
    Total Lines          525
    Sync Polarity        neg

    Active Pixels    307,200 
    Data Rate           0.60 Gbps

    Frame Memory (Kbits)
     8-bit Memory      2,400
    12-bit Memory      3,600
    24-bit Memory      7,200
    32-bit Memory      9,600
*/

/*
    1280x960p60
    
    Screen refresh rate	60 Hz
    Vertical refresh	59.63785046729 kHz
    Pixel freq.	        102.1 MHz

    Horizontal timing (line)
    Scanline part	    Pixels	Time [µs]
    Visible area	    1280	12.536728697356
    Front porch	        80	    0.78354554358472
    Sync pulse	        136	    1.332027424094
    Back porch	        216	    2.1155729676787
    Whole line	        1712	16.767874632713

    Vertical timing (frame)
    Frame part	        Lines	Time [ms]
    Visible area	    960	    16.097159647405
    Front porch	        1	    0.016767874632713
    Sync pulse	        3	    0.050303623898139
    Back porch	        30	    0.50303623898139
    Whole frame	        994	    16.667267384917

*/