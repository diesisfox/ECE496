interface IP_VGA_IF ();

    logic CLOCK_50;
    logic [7:0] VGA_R, VGA_G, VGA_B;
    logic VGA_CLK;
    logic VGA_SYNC_N, VGA_BLANK_N;
    logic VGA_HS, VGA_VS;

    modport Peripheral(
        input CLOCK_50,
        output VGA_R, VGA_G, VGA_B,
        output VGA_CLK,
        output VGA_SYNC_N, VGA_BLANK_N,
        output VGA_HS, VGA_VS
    );

endinterface : IP_VGA_IF
