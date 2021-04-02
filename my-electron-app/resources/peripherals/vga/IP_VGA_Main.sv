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
    parameter H_DIV_960 = 1 //[0-6]
) (
    Simple_Mem_IF.COWI Bus,
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
localparam COUNTERBITS = $clog2(SM_COUNTER_LIM);
localparam MAX_W = 1280;
localparam MAX_H = 960;

// types
typedef enum bit [1:0] {PH0, PH1, PH2, PH3} BitPhase_e;
typedef enum bit [3:0] {
    BIT0 = 0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7, //{da,cl} = new,0; d,1; samp,1; d,0
    START, //{da,cl} = 1,1; 0,1; 0,0
    PRE, //{da,cl} = 0,0
    ACK, //{da,cl} = 1,0; 1,1; samp, 1; 1,0
    POST, //{da,cl} = 1,0
    STOP, //{da,cl} = 0,0; 0,1; 1,1;
    RESTART //{da,cl} = 1,1; 0,1; 0,0;
} BitNum_e;

// mapped registers
logic en = 'b0; // transmit(ting) address byte
logic [10-W_DIV_1280:0] x_in = 'b0;
logic [9-H_DIV_960:0] y_in = 'b0;
logic [max(DEPTH-1, 0):0] p_in = 'b0;

// additional state registers
logic [10-W_DIV_1280:0] x_out = 'b0;
logic [9-H_DIV_960:0] y_out = 'b0;
wire scanline;

// synchronizers
logic en_s1, en_s2;
always_ff @(posedge VGA_CLK) begin
    en_s1 <= en;
    en_s2 <= en_s1;
end
logic [9-H_DIV_960:0] scanline_s1, scanline_s2;
always_ff @(posedge Bus.clock) begin
    scanline_s1 <= scanline;
    scanline_s2 <= scanline_s1;
end

logic [COUNTERBITS-1:0] counter = '0; // main clock divider
BitNum_e bitNum = START; // bit of byte and protocol
BitPhase_e bitPhase = PH0; // intrabit timing state
logic active = '0; // is bus claimed
wire [7:0] firstByte;
assign firstByte = {addr,r};
wire [COUNTERBITS-1:0] counterLim;
assign counterLim = speed ? FM_COUNTER_LIM : SM_COUNTER_LIM;

// io registers
logic scl = 'b1;
assign SCL = scl ? 'bz : 'b0;
logic sda = 'b1;
assign SDA = sda ? 'bz : 'b0;

// video memory
bit [DEPTH-1:0] vram [0:(MAX_W>>W_DIV_1280)-1][0:(MAX_H>>H_DIV_960)-1];
bit [23:0] palette [0:2**(max(DEPTH-1, 0))]; // {b[7:0], g[7:0], r[7:0]}

// pll
logic [3:0] outclk;
ip_vga_pll pll(
    .refclk(CLK_50MHZ),
    .rst(0),
    .outclk_0 (outclk[0]), // 480p60
    .outclk_1 (outclk[1]), // 600p60
    .outclk_2 (outclk[2]), // 720p60
    .outclk_3 (outclk[3]), // 1080p60
);
assign VGA_CLK = outclk[res];

// helper functions
function logic [31:0] maskBytes(logic [31:0] old, logic [31:0] in, logic[3:0] en);
    return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
endfunction

function reset();
    en <= 'b0;
    x_in <= 'b0;
    y_in <= 'b0;
    p_in = 'b0;
    Bus.wr_ready <= '0;
    Bus.rd_ready <= '0;
    Bus.rd_data <= '0;
endfunction

// Bus side logic
always_ff @(posedge Bus.clock) begin
    if (!Bus.reset_n) begin
        reset();
    end else begin
        // defaults (silent stasis)
        start <= start;
        txn <= txn;
        stop <= stop;
        nack = nack;
        addr <= addr;
        data <= data;
        r <= r;
        speed <= speed;
        counter <= counter;
        bitNum <= bitNum;
        bitPhase <= bitPhase;
        active <= active;
        scl <= 'b1;
        sda <= 'b1;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;

        // clock division
        if(active)begin
            counter <= counter + 1; // will be overridden below when appropriate
            scl <= scl;
            sda <= sda;
        end else begin
            counter <= '0;
        end

        // i2c transaction logic
        // data changes on PH3->PH0
        // data sampled on PH1->PH2
        // clock edges on PH0->PH1, PH2->PH3
        if(active)begin // in any spimode, out first, in second in one spi clock cycle
            scl <= scl;
            sda <= sda;
            if(counter == counterLim)begin // next clock will have edge
                counter <= '0;
                unique case (bitPhase)
                    PH0:begin
                        bitPhase <= PH1;
                        unique case (bitNum)
                            BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7:begin
                                sda <= sda;
                                scl <= 1;
                            end
                            ACK:begin
                                sda <= sda;
                                scl <= 1;
                            end
                        endcase
                    end
                    PH1:begin
                        bitPhase <= PH2;
                        unique case (bitNum)
                            BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7:begin
                                if(SCL)begin // check for clock stretching
                                    sda <= sda;
                                    if(r) data[bitNum] <= SDA;
                                end else begin
                                    counter <= counterLim;
                                    bitPhase <= PH1;
                                end
                            end
                            START: begin
                                sda <= 0;
                                scl <= 1;
                            end
                            ACK:begin
                                if(SCL)begin // check for clock stretching
                                    if(!r) nack <= SDA;
                                end else begin
                                    counter <= counterLim;
                                    bitPhase <= PH1;
                                end
                            end
                            RESTART:begin
                                if(SCL)begin // check for clock stretching
                                    sda <= 0;
                                end else begin
                                    counter <= counterLim;
                                    bitPhase <= PH1;
                                end
                            end
                            STOP:begin
                                sda <= 0;
                                scl <= 1;
                            end
                        endcase
                    end
                    PH2:begin
                        bitPhase <= PH3;
                        unique case (bitNum)
                            BIT0, BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7:begin
                                scl <= 0;
                            end
                            START, RESTART: begin
                                sda <= 0;
                                scl <= 0;
                            end
                            ACK:begin
                                scl <= 0;
                            end
                            STOP:begin
                                if(SCL)begin // check for clock stretching
                                    sda <= 1;
                                end else begin
                                    counter <= counterLim;
                                    bitPhase <= PH2;
                                end
                            end
                        endcase
                    end
                    PH3:begin
                        unique case (bitNum)
                            BIT0:begin
                                sda <= start ? 1 : (r ? nack : 1);
                                scl <= 0;
                                bitPhase <= PH0;
                                bitNum <= ACK;
                            end
                            BIT1, BIT2, BIT3, BIT4, BIT5, BIT6, BIT7:begin
                                scl <= 0;
                                if(start) sda <= firstByte[bitNum-1];
                                else sda <= r ? 1 : data[bitNum-1];
                                bitPhase <= PH0;
                                bitNum <= BitNum_e'(bitNum - 1);
                            end
                            START, RESTART: begin
                                sda <= firstByte[BIT7];
                                scl <= 0;
                                bitPhase <= PH0;
                                bitNum <= BIT7;
                            end
                            ACK:begin
                                sda <= 1;
                                scl <= 0;
                                bitPhase <= PH3;
                                bitNum <= POST;
                                start <= 0;
                                txn <= 0;
                            end
                            POST:begin
                                if(start)begin
                                    sda <= 1;
                                    scl <= 1;
                                    bitPhase <= PH1;
                                    bitNum <= RESTART;
                                    txn <= 0;
                                    stop <= 0;
                                end else if(txn)begin
                                    sda <= 0;
                                    scl <= 0;
                                    bitPhase <= PH3;
                                    bitNum <= PRE;
                                    start <= 0;
                                    stop <= 0;
                                end else if(stop)begin
                                    sda <= 0;
                                    scl <= 0;
                                    bitPhase <= PH1;
                                    bitNum <= STOP;
                                    start <= 0;
                                    txn <= 0;
                                end else begin
                                    counter <= counterLim;
                                end
                            end
                            PRE:begin
                                scl <= 0;
                                if(r)begin
                                    sda <= 1;
                                end else begin
                                    sda <= data[BIT7];
                                end
                                bitPhase <= PH0;
                                bitNum <= BIT7;
                            end
                            STOP:begin
                                stop <= 0;
                                start <= 0;
                                txn <= 0;
                                active <= 0;
                            end
                        endcase
                    end
                endcase
            end
        end

        // write register
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.wr_valid)begin
            Bus.wr_ready <= '1;
            if(!active)begin
                unique case (Bus.wr_addr[ADDRBITS-1:0])
                    START_OFFSET:begin
                        start <= maskBytes({31'd0,start}, Bus.wr_data, Bus.wr_byteEn);
                        // init logic
                        if(maskBytes({31'd0,start}, Bus.wr_data, Bus.wr_byteEn)&32'b1 == 32'b1) begin
                            active <= 'b1;
                            bitPhase <= PH1;
                            bitNum = START;
                        end
                    end
                    TXN_OFFSET:; // do nothing
                    STOP_OFFSET:begin
                        // reset logic
                        if(maskBytes({31'd0,start}, Bus.wr_data, Bus.wr_byteEn)&32'b1 == 32'b1) begin
                            reset();
                            Bus.wr_ready <= '1; // need to reassert cuz got reset
                        end
                    end
                    NACK_OFFSET: nack <= maskBytes({31'd0,nack}, Bus.wr_data, Bus.wr_byteEn);
                    ADDR_OFFSET: addr <= maskBytes({25'd0,addr}, Bus.wr_data, Bus.wr_byteEn);
                    DATA_OFFSET: data <= maskBytes({24'd0,data}, Bus.wr_data, Bus.wr_byteEn);
                    RW_OFFSET: r <= maskBytes({31'd0,r}, Bus.wr_data, Bus.wr_byteEn);
                    SPEED_OFFSET: speed <= maskBytes({31'd0,speed}, Bus.wr_data, Bus.wr_byteEn);
                endcase
            end else begin
                if(bitNum != POST)begin
                    if(Bus.wr_addr[ADDRBITS-1:0] == STOP_OFFSET)begin
                        if(maskBytes({31'd0,start}, Bus.wr_data, Bus.wr_byteEn)&32'b1 == 32'b1) begin
                            stop <= 1;
                            sda <= 0;
                            scl <= 0;
                            bitPhase <= PH1;
                            bitNum <= STOP;
                            start <= 0;
                            txn <= 0;
                        end
                    end
                end else begin
                    unique case (Bus.wr_addr[ADDRBITS-1:0])
                        START_OFFSET: start <= maskBytes({31'd0,start}, Bus.wr_data, Bus.wr_byteEn);
                        TXN_OFFSET: txn <= maskBytes({31'd0,txn}, Bus.wr_data, Bus.wr_byteEn);
                        STOP_OFFSET: stop <= maskBytes({31'd0,stop}, Bus.wr_data, Bus.wr_byteEn);
                        NACK_OFFSET: nack <= maskBytes({31'd0,nack}, Bus.wr_data, Bus.wr_byteEn);
                        ADDR_OFFSET: addr <= maskBytes({25'd0,addr}, Bus.wr_data, Bus.wr_byteEn);
                        DATA_OFFSET: data <= maskBytes({24'd0,data}, Bus.wr_data, Bus.wr_byteEn);
                        RW_OFFSET: r <= maskBytes({31'd0,r}, Bus.wr_data, Bus.wr_byteEn);
                        SPEED_OFFSET:; // not writable while bus held
                    endcase
                end
            end
        end

        // read register
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.rd_valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                START_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,start}, Bus.rd_byteEn);
                TXN_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,txn}, Bus.rd_byteEn);
                STOP_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,stop}, Bus.rd_byteEn);
                NACK_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,nack}, Bus.rd_byteEn);
                ADDR_OFFSET: Bus.rd_data <= maskBytes('0, {25'd0,addr}, Bus.rd_byteEn);
                DATA_OFFSET: Bus.rd_data <= maskBytes('0, {24'd0,data}, Bus.rd_byteEn);
                RW_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,r}, Bus.rd_byteEn);
                SPEED_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,speed}, Bus.rd_byteEn);
            endcase
        end
    end
end

// VGA side logic

always @(posedge VGA_CLK) begin
    
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