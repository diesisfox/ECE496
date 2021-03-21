`ifdef ICARUSVERILOG `include "gpio_main.sv" `endif

module IP_GPIO_Main_tb ();

    Simple_Mem_IF Bus();
    wire [4:0] pins;

    IP_GPIO_Main #(
        .PINS(5),
        .ADDR('h1000_0000)
    ) dut (
        .Bus,
        .pins
    );

    always #10 Bus.clock = ~Bus.clock;
    
    logic [31:0] out = 0;

    initial begin
        Bus.clock = '0;
        Bus.reset_n = '1;
        Bus.CWrite('h1000_0000, 32'hffff_ffff, 20);
        Bus.CWrite('h1000_0008, 32'b010101, 20);
        #20;
        Bus.CWrite('h1000_0000, 32'h0, 20);
        force pins = 'b11011;
        Bus.CRead('h1000_0004, out, 20);
        #20;
        $finish;
    end

endmodule