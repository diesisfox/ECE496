module IP_VGA_hwtb (
    input CLOCK_50,
    output [7:0] VGA_R, VGA_G, VGA_B,
    output VGA_CLK,
    output VGA_SYNC_N, VGA_BLANK_N,
    output VGA_HS, VGA_VS
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

Simple_Worker_Mem_IF Bus();
IP_VGA_IF VGA_IF();

assign VGA_IF.CLOCK_50 = CLOCK_50;
assign VGA_R = VGA_IF.VGA_R;
assign VGA_G = VGA_IF.VGA_G;
assign VGA_B = VGA_IF.VGA_B;
assign VGA_CLK = VGA_IF.VGA_CLK;
assign VGA_SYNC_N = VGA_IF.VGA_SYNC_N;
assign VGA_BLANK_N = VGA_IF.VGA_BLANK_N;
assign VGA_HS = VGA_IF.VGA_HS;
assign VGA_VS = VGA_IF.VGA_VS;

assign Bus.clock = CLOCK_50;

IP_VGA_Main #(
    .ADDR('h0000_0000),
    .DEPTH(8),
    .W_DIV_1280(1),
    .H_DIV_960(1),
    .VRAM_MIF_HEX("480_1502934674.inkh_59_melloque_waifu2x_art_scale_tta_1 copy_waifu2x_art_noise3_scale_tta_1 copy 2.png.p256.png.mif"),
    .PALETTE_MIF_HEX("480_1502934674.inkh_59_melloque_waifu2x_art_scale_tta_1 copy_waifu2x_art_noise3_scale_tta_1 copy 2.png.palette.png.mif")
) dut (
    .Bus,
    .VGA_IF
);


endmodule