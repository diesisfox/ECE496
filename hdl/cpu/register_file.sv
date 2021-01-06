module Register_File (
    input clock,
    input reset_n,
    input [4:0] rX_sel,
    input [4:0] rY_sel,
    input [4:0] rWrite_sel,
    input write_reg_enable,
    input [31:0] write_data,
    output [31:0] rX_data_out,
    output [31:0] rY_data_out
);

    // 32 packed arrays of 32 bits each
    logic [31:0] registers [31:0];
    assign rX_data_out = registers[rX_sel];
    assign rY_data_out = registers[rY_sel];

    always_ff @(posedge clock) begin
        if (!reset_n) begin
            registers <= '{32{'0}};
        end else begin
            if (write_reg_enable && rWrite_sel > 0) begin
                registers[rWrite_sel] <= write_data;
            end
        end
    end
endmodule
