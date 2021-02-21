`ifdef ICARUSVERILOG `include "i2c_m_main.sv" `endif

module spi_main_tb ();

localparam START_OFFSET = 'h00; // {...[31:1], START}
localparam CLKDIV_OFFSET = 'h04; // {CLKDIV[31:0]}
localparam CS_OFFSET = 'h08; // {...[31:1], CS}
localparam SPIMODE_OFFSET = 'h0c; // {...[31:2], SPIMODE[1:0] ({CPOL,CPHA})}
localparam DATA_OFFSET = 'h10; // {...[31:8], DATA[7:0]}

Simple_Mem_IF Bus();

logic CS,SCK,DOUT;
logic DIN=0;

spi_m_main #(
    .ADDR('h0000_0000)
) dut (
    .Bus,
    .CS,
    .SCK,
    .DOUT,
    .DIN
);

always #5 Bus.clock = ~Bus.clock;

logic [31:0] out;

initial begin
    // DIN = 1;
    Bus.clock = '0;
    Bus.reset_n = '1;
    Bus.CWrite(CLKDIV_OFFSET, 2, 10);
    Bus.CWrite(SPIMODE_OFFSET, 0, 10);
    Bus.CWrite(DATA_OFFSET, 'hC3, 10);
    Bus.CWrite(CS_OFFSET, '0, 10);
    Bus.CWrite(START_OFFSET, '1, 10);
    do Bus.CRead(START_OFFSET, out, 10);
    while (out == 1);
    Bus.CWrite(CS_OFFSET, '1, 10);
    #100
    
    Bus.CWrite(CLKDIV_OFFSET, 0, 10);
    Bus.CWrite(SPIMODE_OFFSET, 3, 10);
    Bus.CWrite(DATA_OFFSET, 'h0, 10);
    Bus.CWrite(CS_OFFSET, '0, 10);
    Bus.CWrite(START_OFFSET, '1, 10);
    #20 DIN = 1;
    #20 DIN = 0;
    #20 DIN = 1;
    #20 DIN = 0;
    #20 DIN = 1;
    #20 DIN = 0;
    #20 DIN = 1;
    #20 DIN = 0;
    do Bus.CRead(START_OFFSET, out, 10);
    while (out == 1);
    Bus.CWrite(CS_OFFSET, '1, 10);
    $finish;
end

endmodule