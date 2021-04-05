/**
* REQUIRES 50.00 MHz clock on VGA_IF.CLOCK_50, which should be available on the DE1-SoC
*
* DEPTH changes the bit width of the palette. maximum of 8 is attainable with the python script.
* Use 0 to bypass the palette and write 24 bit {B,G,R} values straight into vram.
*
* W_DIV_1280 and H_DIV_960 controls the logical resolution. physical resolution is always 1280x960,
* but logical vram-mapped pixels could be made of power of 2 * power of 2 physical pixels.
*
* VRAM_MIF and PALETTE_MIF are initial contents of those memories
* 
* write 1 to EN enables video output.
*
* write logical pixel address to X/Y_ADDR_OFFSET and read/write to DATA_OFFSET to
* access vram data at that pixel.
* The vram address automatically increments left to right then top to bottom upon each write.
* vram MUST be written by whole word access in 24 bit mode (DEPTH=0)
* 
* write palette index to PALETTE_ADDR_OFFSET and read/write to COLOR_OFFSET to
* access palette data at that index.
* The palette index automatically increments upon each write.
* palette MUST be written by whole word access
*
* read from SCANLINE_OFFSET to acquire the current active line the VGA controller is outputting.
* reads 0 when in sync or blank states.
* useful for preventing screen tearing.
**/ 
module IP_VGA_Main #(
    parameter ADDR = 'h1000_0000,
    parameter DEPTH = 3, // [0-8], max 1228800 bits total vram (1280x960 @ 1bpp), 0 means no palette
    parameter W_DIV_1280 = 1, //[0-8]
    parameter H_DIV_960 = 1, //[0-6]
    parameter VRAM_MIF = "",
    parameter PALETTE_MIF = ""
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
logic en = 'b1; // transmit(ting) address byte
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
logic   [(DEPTH==0 ? 24 : DEPTH)-1:0]     vram_data_a;
logic                   vram_wren_a;
wire    [(DEPTH==0 ? 24 : DEPTH)-1:0]     vram_q_a;
wire    [(DEPTH==0 ? 24 : DEPTH)-1:0]     vram_q_b;
IP_VGA_AsyncRam_Altera #(
    .WIDTH(DEPTH==0 ? 24 : DEPTH),
    .DEPTH(307200),
    .MIF(VRAM_MIF)
) vram (
    .address_a(x_in+y_in*MAX_W),
    .address_b((x_out>>W_DIV_1280)+(y_out>>H_DIV_960)*MAX_W),
    .clock_a(Bus.clock),
    .clock_b(VGA_IF.VGA_CLK),
    .data_a(vram_data_a),
    .data_b(0),
    .wren_a(vram_wren_a),
    .wren_b(1'b0),
    .q_a(vram_q_a),
    .q_b(vram_q_b)
);

logic   [23:0]      palette_data_a;
logic               palette_wren_a;
wire    [23:0]      palette_q_a;
wire    [23:0]      palette_q_b;
IP_VGA_AsyncRam_Altera #(
    .WIDTH(24),
    .DEPTH(2**DEPTH),
    .MIF(PALETTE_MIF)
) palette (
    .address_a(p_in),
    .address_b(vram_q_b),
    .clock_a(Bus.clock),
    .clock_b(VGA_IF.VGA_CLK),
    .data_a(palette_data_a),
    .data_b(32'b0),
    .wren_a(palette_wren_a),
    .wren_b(1'b0),
    .q_a(palette_q_a),
    .q_b(palette_q_b)
);

// pll
IP_VGA_PLL_Altera pll(
    .refclk(VGA_IF.CLOCK_50),
    .rst(0),
    .outclk_0(VGA_IF.VGA_CLK)
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
        vram_data_a <= vram_data_a;
        vram_wren_a <= 'b0;
        palette_data_a <= palette_data_a;
        palette_wren_a <= 'b0;

        // read register
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.rd_valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                EN_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,en}, Bus.rd_byteEn);
                X_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,x_in}, Bus.rd_byteEn);
                Y_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,y_in}, Bus.rd_byteEn);
                DATA_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,vram_q_a}, Bus.rd_byteEn);
                PALETTE_ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,p_in}, Bus.rd_byteEn);
                COLOR_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,palette_q_a}, Bus.rd_byteEn);
                SCANLINE_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,scanline_s2}, Bus.rd_byteEn);
            endcase
        end

        // write register (higher prio than read)
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.wr_valid)begin
            Bus.wr_ready <= '1;
            unique case (Bus.wr_addr[ADDRBITS-1:0])
                EN_OFFSET: en <= maskBytes({31'd0,en}, Bus.wr_data, Bus.wr_byteEn);
                X_ADDR_OFFSET:begin
                    x_in <= maskBytes({31'd0,x_in}, Bus.wr_data, Bus.wr_byteEn);
                end
                Y_ADDR_OFFSET:begin
                    y_in <= maskBytes({31'd0,y_in}, Bus.wr_data, Bus.wr_byteEn);
                end
                DATA_OFFSET: begin
                    if(twoBusCycle)begin
                        twoBusCycle <= 1'b0;
                        x_in <= (x_in == MAX_W-1) ? '0 : (x_in + '1);
                        y_in <= (x_in == MAX_W-1) ? ((y_in == MAX_H-1) ? '0 : (y_in + '1)) : y_in;
                    end else begin
                        twoBusCycle <= 1'b1;
                        vram_data_a <= Bus.wr_data;
                        vram_wren_a <= 1'b1;
                        Bus.wr_ready <= 1'b0;
                    end
                end
                PALETTE_ADDR_OFFSET: begin
                    if(DEPTH!=0)begin
                        p_in <= maskBytes({31'd0,p_in}, Bus.wr_data, Bus.wr_byteEn);
                    end
                end
                COLOR_OFFSET: begin
                    if(DEPTH!=0)begin
                        if(twoBusCycle)begin
                            twoBusCycle <= 1'b0;
                            p_in <= (p_in == 2**DEPTH-1) ? '0 : (p_in + '1);
                        end else begin
                            palette_data_a <= Bus.wr_data;
                            palette_wren_a <= 1'b1;
                            twoBusCycle <= 1'b1;
                            Bus.wr_ready <= 1'b0;
                        end
                    end
                end
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
logic [10:0] x_out = 'b0;
logic [9:0] y_out = 'b0;
logic [10:0] x_comp;
logic [9:0] y_comp;
logic [23:0] p_out = 'b0;
logic blank_1, hsync_1, vsync_1;
logic blank_2, hsync_2, vsync_2;

// IO init
initial begin
    {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA_R} = 24'b0;
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

assign scanline = yState == ACTIVE ? y_out<<H_DIV_960 : 'b0;

always @(posedge VGA_IF.VGA_CLK) begin : VgaController
    if(!en_s2)begin
        x_out <= 'b0;
        y_out <= 'b0;
        xState <= SYNC;
        yState <= SYNC;
    end else begin
        x_out <= x_out + 'b1;
        y_out <= y_out;
        xState <= xState;
        yState <= yState;
        if(x_out == x_comp)begin
            x_out <= 'b0;
            unique case(xState)
                SYNC: xState <= BACK;
                BACK: xState <= ACTIVE;
                ACTIVE: xState <= FRONT;
                FRONT:begin
                    xState <= SYNC;
                    y_out <= y_out + 'b1;
                end
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
        blank_2 <= 'b0;
        hsync_2 <= 'b0;
        vsync_2 <= 'b0;
        {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA_R} <= 24'b0;
        VGA_IF.VGA_SYNC_N <= 'b0;
        VGA_IF.VGA_BLANK_N <= 'b0;
        VGA_IF.VGA_HS <= 'b0;
        VGA_IF.VGA_VS <= 'b1;
    end else begin
        // cycle 0: FSM logic
        // cycle 1: vram inputs registered
        blank_1 <= xState != ACTIVE || yState != ACTIVE;
        hsync_1 <= xState == SYNC;
        vsync_1 <= yState == SYNC;
        // cycle 2: palette inputs registered
        p_out <= palette_q_b;
        blank_2 <= blank_1;
        hsync_2 <= hsync_1;
        vsync_2 <= vsync_1;
        // cycle 3:
        // VGA_IF.VGA_SYNC_N <= ~(hsync_2 | vsync_2); // for composite hvsync
        {VGA_IF.VGA_B, VGA_IF.VGA_G, VGA_IF.VGA_R} <= DEPTH == 0 ? p_out : palette_q_b;
        VGA_IF.VGA_SYNC_N <= 'b0;
        VGA_IF.VGA_BLANK_N <= ~blank_2;
        VGA_IF.VGA_HS <= ~hsync_2;
        VGA_IF.VGA_VS <= vsync_2;
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