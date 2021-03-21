import alu_pkg::*;
import blu_pkg::*;

module Datapath (
    input clock,
    input reset_n,

    // Memory interface to the AXI component
    // Inputs from the AXI component
    input mem_rd_ready,
    input [31:0] mem_rd_data,
    // Outputs to the AXI component
    output mem_rd_en,
    output mem_wr_en,
    output [31:0] mem_addr,
    output [31:0] mem_wr_data,

    // Control signals
    input ALU_opcode ALU_opcode,
    input [1:0] ALU_x_sel,
    input BLU_opcode BLU_opcode,
    input RF_write_enable,
    input IR_update_enable,
    input DR_update_enable,
    output logic [6:0] DR_opcode,
    output logic [2:0] DR_funct3,
    output logic [6:0] DR_funct7
    // ... whatever other signals we need
);

    // Registers within the datapath
    logic [31:0] PC;
    logic [31:0] IR_inst;

    // Decode "register" (multiple registers, in reality)
    // The intent here is for the decode stage to arrange/sign extend/etc
    //     all the possible data that the execute stage might need
    // This should simplify the execute stage and shorten the critical path there
    logic [31:0] DR_rX;
    logic [31:0] DR_rY;
    logic [31:0] DR_SE_imm_I;
    logic [31:0] DR_SE_imm_S;
    logic [31:0] DR_SE_imm_U;

    // Signals in/out of the various blocks
    // ALU
    logic [31:0] ALU_x;
    logic [31:0] ALU_y;
    logic [31:0] ALU_out;

    // BLU
    logic [31:0] BLU_x;
    logic [31:0] BLU_y;
    logic [31:0] BLU_out;

    // RF
    logic [31:0] RF_rX_out;
    logic [31:0] RF_rY_out;


    Register_File rf (
        .clock(clock),
        .reset_n(reset_n),
        .rX_sel(IR_inst[19:15]),
        .rY_sel(IR_inst[24:20]),
        .rWrite_sel(),
        .write_reg_enable(RF_write_enable),
        .write_data(),
        .rX_data_out(RF_rX_out),
        .rY_data_out(RF_rY_out)
    );

    ALU alu (
        .x(ALU_x),
        .y(ALU_y),
        .opcode(ALU_opcode),
        .out(ALU_out)
    );

    BLU blu (
        .x(BLU_x),
        .y(BLU_y),
        .opcode(BLU_opcode),
        .out(BLU_out)
    );

    always_comb begin
        case (ALU_x_sel)
            2'b00: begin
                ALU_x = DR_rX;
            end
            2'b01: begin
                ALU_x = PC;
            end
            2'b10: begin
                ALU_x = 'b0;
            end
            default: begin
                ALU_x = 'b0;
            end
        endcase
    end

    // Operands we need for ALU_y:
    // rY
    // imm_I
    // imm_S
    // imm_U


    always_ff @(posedge clock) begin
        if (!reset) begin
            // PC
            PC <= 'd0;
            // IR
            IR_inst <= 'd0;
            // DR
            DR_opcode <= 'd0;
            DR_funct3 <= 'd0;
            DR_funct7 <= 'd0;
            DR_rX <= 'd0;
            DR_rY <= 'd0;
            DR_SE_imm_I <= 'd0;
            DR_SE_imm_S <= 'd0;
            DR_SE_imm_U <= 'd0;
        end else begin
            if (IR_update_enable) begin
                IR_inst <= mem_rd_data;
            end
            if (DR_update_enable) begin
                DR_rX <= RF_rX_out;
                DR_rY <= RF_rY_out;
                DR_SE_imm_I <= {{20{IR_inst[31]}}, IR_inst[31:20]};
                DR_SE_imm_S <= {{20{IR_inst[31]}}, IR_inst[31:25], IR_inst[11:7]};
                DR_SE_imm_U <= {{12{IR_inst[31]}}, IR_inst[31:12]};
                DR_opcode <= IR_inst[6:0];
                DR_funct3 <= IR_inst[14:12];
                DR_funct7 <= IR_inst[31:25];
            end
        end
    end

endmodule
