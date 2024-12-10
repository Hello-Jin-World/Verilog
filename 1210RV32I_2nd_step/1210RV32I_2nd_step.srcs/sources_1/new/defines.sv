`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SRL 4'b0101
`define SRA 4'b1101
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define OR 4'b0110
`define AND 4'b0111

`define OP_TYPE_R 7'b0110011  // R-TYPE 
`define OP_TYPE_IL 7'b0000011  // IL-TYPE 
`define OP_TYPE_I 7'b0010011  // I-TYPE 
`define OP_TYPE_S 7'b0100011  // S-TYPE 
`define OP_TYPE_B 7'b1100011   // B-TYPE 
`define OP_TYPE_U 7'b0110111  // U-TYPE 1
`define OP_TYPE_UA 7'b0010111  // U-TYPE 2
`define OP_TYPE_J 7'b1101111  // J-TYPE
`define OP_TYPE_JI 7'b1100111  // JI-TYPE

`define BYTE  3'b000
`define HALF  3'b001
`define WORD  3'b010
`define UBYTE 3'b100
`define UHALF 3'b101

`define ADD_BYTE  4'b0011
`define ADD_HALF  4'b1001
`define ADD_WORD  4'b1010
`define ADD_UBYTE 4'b1011
`define ADD_UHALF 4'b1100