`timescale 1ns / 1ps

module Demo_Project_TB(

);

    localparam PERIOD = 100;
    localparam HALF_PERIOD = 50;

    logic clock, reset_n, cpu_trap;
    wire [7:0] VGA_R, VGA_G, VGA_B;
    wire VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_HS, VGA_VS;
    
    top DUT (
        .clock(clock),
        .reset_n(reset_n),
        .cpu_trap(cpu_trap),
        .CLOCK_50(clock),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_CLK(VGA_CLK),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
    );
    
    always begin
        clock = 1'b0;
        #HALF_PERIOD;
        clock = 1'b1;
        #HALF_PERIOD;
    end
    
    initial begin
        reset_n = 1'b0;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        reset_n = 1'b1;
    end
    
    always @(posedge clock) begin
        if (cpu_trap) begin
            $finish;
        end
    end

endmodule
