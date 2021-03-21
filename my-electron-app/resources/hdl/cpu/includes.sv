package alu_pkg;
	typedef enum logic [3:0] {
		ALU_OP_NOP						=	4'b0000,
		ALU_OP_ADD						= 	4'b0001,
		ALU_OP_AND						= 	4'b0010,
		ALU_OP_OR 						= 	4'b0011,
		ALU_OP_XOR 						= 	4'b0100,
		ALU_OP_LEFTSHIFT				=	4'b0101,
		ALU_OP_RIGHTSHIFT_LOGICAL		=	4'b0110,
		ALU_OP_RIGHTSHIFT_ARITHMETIC	=	4'b0111,
		ALU_OP_ADD_HIGH					=	4'b1000
	} ALU_opcode;
endpackage

package blu_pkg;
    typedef enum logic [2:0] {
        BLU_OP_NOP                              =   3'b000,
        BLU_OP_LESS_THAN_UNSIGNED               =   3'b001,
        BLU_OP_LESS_THAN_SIGNED                 =   3'b010,
        BLU_OP_EQUAL                            =   3'b011,
        BLU_OP_NOT_EQUAL                        =   3'b100,
        BLU_OP_GREATER_THAN_EQUAL_TO_UNSIGNED   =   3'b101,
        BLU_OP_GREATER_THAN_EQUAL_TO_SIGNED     =   3'b110
    } BLU_opcode;
endpackage
