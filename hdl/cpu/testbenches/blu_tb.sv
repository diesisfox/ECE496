import blu_pkg::*;

`timescale 1ns/1ns

`define NUM_TESTS 20

module BLU_TB ();
    // We're not testing sequential logic, so we just have an arbitrary wait
    //     period between stimuli
    const int delay = 20;

    // Inputs to the DUT
    logic [31:0] x;
    logic [31:0] y;
    BLU_opcode opcode;

    // Outputs from the DUT
    logic [31:0] out;

    // Testbench control variables
    int num_passed;

    // Test stimuli
    int test_X [`NUM_TESTS]                 =   {32'h87654321,                              32'hFFFFFFFE,
                                                 32'hFFFFFFFF,                              32'h80000000,
                                                 32'h00000000,                              32'h7FFFFFFF,
                                                 32'hFEDCBA98,                              32'h00000000,
                                                 32'hAAAAAAAA,                              32'hFEDCBA98,
                                                 32'h00000000,                              32'hAAAAAAAA,
                                                 32'hFEDCBA98,                              32'hFFFFFFFF,
                                                 32'h00000000,                              32'hABCDEF00,
                                                 32'h80000000,                              32'h00001000,
                                                 32'h7FFFFFFF,                              32'h80000001};

    int test_Y [`NUM_TESTS]                 =   {32'h12345678,                              32'hFFFFFFFF,
                                                 32'hFFFFFFFE,                              32'h7FFFFFFF,
                                                 32'h00000001,                              32'h80000000,
                                                 32'hFEDCBB98,                              32'hFFFFFFFF,
                                                 32'hAAAAAAAA,                              32'hFEDCBB98,
                                                 32'hFFFFFFFF,                              32'hAAAAAAAA,
                                                 32'hFEDCBA98,                              32'hFFFFFFF0,
                                                 32'hFFFFFFFF,                              32'hABCDEF01,
                                                 32'h7FFFFFFF,                              32'h01234000,
                                                 32'h00000000,                              32'h80000000};

    BLU_opcode test_opcodes [`NUM_TESTS]    =   {BLU_OP_NOP,                                BLU_OP_LESS_THAN_UNSIGNED,
                                                 BLU_OP_LESS_THAN_UNSIGNED,                 BLU_OP_LESS_THAN_SIGNED,
                                                 BLU_OP_LESS_THAN_SIGNED,                   BLU_OP_LESS_THAN_SIGNED,
                                                 BLU_OP_EQUAL,                              BLU_OP_EQUAL,
                                                 BLU_OP_EQUAL,                              BLU_OP_NOT_EQUAL,
                                                 BLU_OP_NOT_EQUAL,                          BLU_OP_NOT_EQUAL,
                                                 BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED,     BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED,
                                                 BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED,     BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED,
                                                 BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED,       BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED,
                                                 BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED,       BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED};

    int test_expected [`NUM_TESTS]          =   {32'h00000000,                              32'h00000001,
                                                 32'h00000000,                              32'h00000001,
                                                 32'h00000001,                              32'h00000000,
                                                 32'h00000000,                              32'h00000000,
                                                 32'h00000001,                              32'h00000001,
                                                 32'h00000001,                              32'h00000000,
                                                 32'h00000001,                              32'h00000001,
                                                 32'h00000000,                              32'h00000000,
                                                 32'h00000000,                              32'h00000000,
                                                 32'h00000001,                              32'h00000001};

    BLU dut (
        .x(x),
        .y(y),
        .opcode(opcode),
        .out(out)
    );

    initial begin
        $display("BLU    :    Hello! Initializing the BLU testbench...");
        x = 'b0;
        y = 'b0;
        opcode = BLU_OP_NOP;
        #delay;

        $display("BLU    :    Starting tests:");
        for (int i = 0; i < `NUM_TESTS; i++) begin
            x = test_X[i];
            y = test_Y[i];
            opcode = test_opcodes[i];
            #delay;
            if (out == test_expected[i]) begin
                $display("BLU    :    PASS    :    x = %0d y = %0d opcode = %0d output = %0d expected = %0d", x, y, opcode, out, test_expected[i]);
                num_passed++;
            end else begin
                $display("BLU    :    FAIL    :    x = %0d y = %0d opcode = %0d output = %0d expected = %0d", x, y, opcode, out, test_expected[i]);
            end
        end

        if (num_passed != `NUM_TESTS) begin
            $display("BLU    :    Some tests failed. %0d/%0d passed", num_passed, `NUM_TESTS);
        end else begin
            $display("BLU    :    All tests passed!");
        end
    end

endmodule
