/**
* write 1 to START starts manager transmission. Can't write when worker.
* in worker mode, data available when AVAIL becomes 1. Write 0 to ack.
* manager spi clock freq = clk
**/ 
module spi_m_main #(
    parameter bit [31:0] ADDR = 'h1000_0000
) (
    Simple_Mem_IF.COWI Bus,
    inout wire CS,
    inout wire SCK,
    output wire DOUT,
    input wire DIN,
);

localparam ADDRBITS = 5;
localparam START_OFFSET = 'h00; // {...[31:1], START}
localparam CLKDIV_OFFSET = 'h04; // {CLKDIV[31:0]}
localparam CS_OFFSET = 'h08; // {...[31:1], CS}
localparam SPIMODE_OFFSET = 'h0c; // {...[31:3] M/~W[2:2], SPIMODE[1:0]}
localparam DATA_OFFSET = 'h10; // {...[31:8], DATA[7:0]}
localparam AVAIL_OFFSET = 'h14; // {...[31:1], AVAIL}

// state registers
logic [15:0] counter = '0;
logic started = '0;
logic [3:0] clkdiv = 'hf;
logic [1:0] spimode = '0;
logic isManager = '0;
logic [7:0] data = '0;

// io registers
logic cs_m = '1;
logic sck_m = '0;
logic dout = '0;
logic din;
assign pins_o = {cs, clk, dout};
assign din = pins_i[0];
assign {CS,SCK,DOUT} = isManager ? {cs_m,sck_m,dout_m} ? {1'z,1'z,dout_w};

function logic [31:0] maskBytes(logic [31:0] old, logic [31:0] in, logic[3:0] en);
    return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
endfunction

// register logic
always_ff @(posedge Bus.clock) begin
    if (!Bus.reset_n) begin
        cs <= '1;
        clk <= '0;
        dout <= '0;
        counter <= '0;
        started <= '0;
        clkdiv <= 'hf;
        spimode <= '0;
        data <= '0;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;
    end else begin
        //defaults
        cs <= cs;
        clk <= clk;
        dout <= dout;
        counter <= counter;
        started <= started;
        clkdiv <= clkdiv;
        spimode <= spimode;
        data <= data;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;

        // clock division
        if(st)
        if(counter == clkdiv)begin
            counter <= '0;
            sck_m <= ~sck_m;
        end else begin
            counter <= counter + 1;
        end
        counter <= (counter == clkdiv) ? '0 : counter + '1;

        // write
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && wr.valid)begin
            Bus.wr_ready <= '1;
            unique case (Bus.wr_addr[ADDRBITS-1:0])
                DIR_OFFSET: oe <= maskBytes(oe, Bus.wr_data, Bus.wr_byteEn);
                WRITE_OFFSET: out <= maskBytes(out, Bus.wr_data, Bus.wr_byteEn);
                default: 
            endcase
        end

        // read
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && rd.valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                DIR_OFFSET: Bus.rd_data <= maskBytes('0, oe, Bus.rd_byteEn);
                WRITE_OFFSET: Bus.rd_data <= maskBytes('0, out, Bus.rd_byteEn);
                READ_OFFSET: Bus.rd_data <= maskBytes('0, pins, Bus.rd_byteEn);
                default:
            endcase
        end
    end
end

    
endmodule
