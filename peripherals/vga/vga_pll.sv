module ip_vga_pll(
    input wire refclk,
    input wire rst,
    output wire outclk_0, outclk_1, outclk_2, outclk_3
);

    vga_pll_alt pll_inst (
		.refclk   (refclk),   //  refclk.clk
		.rst      (rst),      //   reset.reset
		.outclk_0 (outclk_0), // outclk0.clk
		.outclk_1 (outclk_1), // outclk1.clk
		.outclk_2 (outclk_2), // outclk2.clk
		.outclk_3 (outclk_3), // outclk3.clk
	);
    
endmodule