`ifdef ICARUSVERILOG `include "i2c_m_main.sv" `endif
`timescale 1ns/1ps //#10 is 1MHz

module i2c_main_tb ();

// memory map
localparam START_OFFSET = 'h00; // {...[31:1], START}
localparam TXN_OFFSET = 'h04; // {...[31:1], TXN}
localparam STOP_OFFSET = 'h08; // {...[31:1], STOP}
localparam NACK_OFFSET = 'h0c; // {...[31:1], NACK}
localparam ADDR_OFFSET = 'h10; // {...[31:7], ADDR[6:0]}
localparam DATA_OFFSET = 'h14; // {...[31:8], DATA[7:0]}
localparam RW_OFFSET = 'h18; // {...[31:1], R/Wn}
localparam SPEED_OFFSET = 'h1c; // {...[31:1], FM/SMn}

parameter CYCLETIME = 10;

Simple_Mem_IF Bus();

tri1 SDA,SCL;

ip_i2c_m_main #(
    .ADDR('h0000_0000)
) dut (
    .Bus,
    .SCL,
    .SDA
);

always #(CYCLETIME/2) Bus.clock = ~Bus.clock;

logic [31:0] out;

task i2cForce(input byte data);
    while(dut.bitNum != 7) #CYCLETIME;
    force SDA = data[7];
    while(dut.bitNum != 6) #CYCLETIME;
    force SDA = data[6];
    while(dut.bitNum != 5) #CYCLETIME;
    force SDA = data[5];
    while(dut.bitNum != 4) #CYCLETIME;
    force SDA = data[4];
    while(dut.bitNum != 3) #CYCLETIME;
    force SDA = data[3];
    while(dut.bitNum != 2) #CYCLETIME;
    force SDA = data[2];
    while(dut.bitNum != 1) #CYCLETIME;
    force SDA = data[1];
    while(dut.bitNum != 0) #CYCLETIME;
    force SDA = data[0];
    while(dut.bitPhase != dut.PH2) #CYCLETIME;
    release SDA;
endtask //automatic

initial begin
    // DIN = 1;
    Bus.clock = '0;
    Bus.reset_n = '1;
    Bus.CWrite(ADDR_OFFSET, 7'b1100111, CYCLETIME);
    Bus.CWrite(RW_OFFSET, 0, CYCLETIME);
    Bus.CWrite(SPEED_OFFSET, 0, CYCLETIME);
    Bus.CWrite(START_OFFSET, 1, CYCLETIME);

    do Bus.CRead(START_OFFSET, out, CYCLETIME);
    while (out == 1);
    
    Bus.CWrite(DATA_OFFSET, 'hbeef, CYCLETIME);
    Bus.CWrite(TXN_OFFSET, 1, CYCLETIME);
    
    do Bus.CRead(TXN_OFFSET, out, CYCLETIME);
    while (out==1);

    Bus.CWrite(RW_OFFSET, 1, CYCLETIME);
    Bus.CWrite(START_OFFSET, 1, CYCLETIME);
    do Bus.CRead(START_OFFSET, out, CYCLETIME);
    while (out == 1);

    Bus.CWrite(TXN_OFFSET, 1, CYCLETIME);

    i2cForce('h45);

    do Bus.CRead(TXN_OFFSET, out, CYCLETIME);
    while (out==1);

    Bus.CWrite(STOP_OFFSET, '1, CYCLETIME);

    do Bus.CRead(STOP_OFFSET, out, CYCLETIME);
    while (out == 1);

    Bus.CRead(DATA_OFFSET, out, CYCLETIME);
    
    #500
    $finish;
end

endmodule