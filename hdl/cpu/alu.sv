import alu_pkg::*;

module ALU (
	input [31:0] x,
	input [31:0] y,
	input ALU_opcode opcode,
	output logic [31:0] out
);

logic signed [31:0] x_signed;

always_comb begin
    // We need a copy of x that is specified to be "signed" in order for
    //     the arithmetic rightshift to actually compile to an arithmetic
    //     rightshift - otherwise ">>>" is equivalent to ">>"
    x_signed = x;

	case (opcode)
		ALU_OP_NOP: begin
			out = 'b0;
		end
		ALU_OP_ADD: begin
			out = x + y;
		end
        ALU_OP_AND: begin
            out = x & y;
        end
        ALU_OP_OR: begin
            out = x | y;
        end
        ALU_OP_XOR: begin
            out = x ^ y;
        end
        ALU_OP_LEFTSHIFT: begin
            out = x << y;
        end
        ALU_OP_RIGHTSHIFT_LOGICAL: begin
            out = x >> y;
        end
        ALU_OP_RIGHTSHIFT_ARITHMETIC: begin
            // Turns out, ">>>" performs arithmetic rightshift
            out = x_signed >>> y;
        end
        ALU_OP_ADD_HIGH: begin
            out = x + {y[19:0], 12'b0};
        end
		default: begin
			out = 'b0;
		end
	endcase
end

endmodule
