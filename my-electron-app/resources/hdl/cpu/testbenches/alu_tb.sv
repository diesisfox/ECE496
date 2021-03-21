import alu_pkg::*;

`timescale 1ns/1ns

`define NUM_TESTS 13

module ALU_TB ();
	logic [31:0] x;
	logic [31:0] y;
	ALU_opcode opcode;
	logic [31:0] out;
	int curr_test_pass;
	int num_passed;

	int test_X [`NUM_TESTS] = 				{0, 2, 32'hFFFFFFFF, 7,
											0, 0, 32'h55555555, 32'hE,
											32'hABCD, 32'hABCD, 32'hF000000F, 0,
											32'hFA8000};
	int test_Y [`NUM_TESTS] = 				{0, 1, 2, 15,
											0, 0, 32'hAAAAAAAA, 32'h7,
											2, 2, 3, 32'hFFFF,
											32'h1};
	ALU_opcode test_opcodes [`NUM_TESTS] = 	{ALU_OP_NOP, ALU_OP_ADD, ALU_OP_ADD, ALU_OP_AND,
											ALU_OP_AND, ALU_OP_OR, ALU_OP_OR, ALU_OP_XOR,
											ALU_OP_LEFTSHIFT, ALU_OP_RIGHTSHIFT_LOGICAL, ALU_OP_RIGHTSHIFT_ARITHMETIC, ALU_OP_ADD_HIGH,
											ALU_OP_ADD_HIGH};
	int test_expected [`NUM_TESTS] = 		{0, 3, 1, 7,
											0, 0, 32'hFFFFFFFF, 32'h9,
											32'h2AF34, 32'h2AF3, 32'hFE000001, 32'h0FFFF000,
											32'hFA9000};

	ALU dut (
		.x(x),
		.y(y),
		.opcode(opcode),
		.out(out)
	);

	initial begin
		// This acts to initialize the bench - our first stimulus sets all inputs to 0
        $display("ALU    :    Hello! Initializing the ALU testbench...");
		testStimulus(test_X[0], test_Y[0], test_opcodes[0], test_expected[0], curr_test_pass);
		num_passed = 0;
        #20

        $display("ALU    :    Starting tests for real now:");
		// Iterate over all test cases
		for (int i = 0; i < `NUM_TESTS; i++) begin
			testStimulus(test_X[i], test_Y[i], test_opcodes[i], test_expected[i], curr_test_pass);
            #20
			num_passed += curr_test_pass;
		end

        #20
		// Display a pass/fail message at the end
		if (num_passed != `NUM_TESTS) begin
			$display("ALU    :    Some tests failed. %0d/%0d passed", num_passed, `NUM_TESTS);
		end else begin
			$display("ALU    :    All tests passed!");
		end
	end

	task testStimulus(
		input int x_in,
		input int y_in,
		input ALU_opcode opcode_in,
		input int expected,
		output int passed
	);
		x = x_in;
		y = y_in;
		opcode = opcode_in;
        #20
		if (out == expected) begin
            $display("ALU    :    PASS    :    x = %0d y = %0d opcode = %b output = %0d, expected = %0d", x, y, opcode, out, expected);
			passed = 1;
		end else begin
            $display("ALU    :    FAIL    :    x = %0d y = %0d opcode = %b output = %0d, expected = %0d", x, y, opcode, out, expected);
			passed = 0;
		end
	endtask
endmodule
