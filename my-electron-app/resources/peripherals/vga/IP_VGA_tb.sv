module IP_VGA_tb ();

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

Simple_Worker_Mem_IF Bus();
IP_VGA_IF VGA_IF();

IP_VGA_Main #(
    .ADDR('h0000_0000),
    .DEPTH(4),
    .W_DIV_1280(1),
    .H_DIV_960(1),
    .VRAM_MIF_HEX("infernet_480_p16_2.png.mif"),
    .PALETTE_MIF_HEX("infernet_palette_2.png.mif")
) dut (
    .Bus,
    .VGA_IF
);

always #5 Bus.clock = ~Bus.clock;

logic [31:0] out;

initial begin
    Bus.clock = '0;
    Bus.reset_n = '1;
    // enable display
    Bus.CWrite(EN_OFFSET, 1, 10);
    // draw O
    Bus.CWrite(X_ADDR_OFFSET, 5, 10);
    Bus.CWrite(Y_ADDR_OFFSET, 5, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(X_ADDR_OFFSET, 6, 10);
    Bus.CWrite(Y_ADDR_OFFSET, 5, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(Y_ADDR_OFFSET, 7, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(X_ADDR_OFFSET, 7, 10);
    Bus.CWrite(Y_ADDR_OFFSET, 5, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    Bus.CWrite(DATA_OFFSET, 15, 10);
    // change green to blue
    Bus.CWrite(PALETTE_ADDR_OFFSET, 13, 10);
    Bus.CWrite(COLOR_OFFSET, 'hff9933, 10);
    // read scanline til frame done
    do Bus.CRead(SCANLINE_OFFSET, out, 10);
    while (out != 'd959);
    #100
    $finish;
end

endmodule