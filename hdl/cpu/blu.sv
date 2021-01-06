import blu_pkg::*;

module BLU (
    input [31:0] x,
    input [31:0] y,
    BLU_opcode opcode,
    output logic [31:0] out
);

    logic signed [31:0] x_signed;
    logic signed [31:0] y_signed;
    logic bool;

    always_comb begin
        x_signed = x;
        y_signed = y;

        case (opcode)
            BLU_OP_NOP: begin
                bool = 'b0;
            end
            BLU_OP_LESS_THAN_UNSIGNED: begin
                bool = (x < y);
            end
            BLU_OP_LESS_THAN_SIGNED: begin
                bool = (x_signed < y_signed);
            end
            BLU_OP_EQUAL: begin
                bool = (x == y);
            end
            BLU_OP_NOT_EQUAL: begin
                bool = (x != y);
            end
            BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED: begin
                bool = (x >= y);
            end
            BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED: begin
                bool = (x_signed >= y_signed);
            end
            default: begin
                bool = 'b0;
            end
        endcase

        out = (bool) ? 32'h1 : 32'h0;
    end

endmodule
