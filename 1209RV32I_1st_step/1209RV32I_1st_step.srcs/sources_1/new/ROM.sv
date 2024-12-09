`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 14:29:02
// Design Name: 
// Module Name: ROM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ROM (
    input  logic [31:0] addr,
    output logic [31:0] data
);
    logic [31:0] rom[0:63];

    localparam R_TYPE_OPCODE = 7'b0110011;

    localparam
     ADD_FUNC7  = 7'b0000000, ADD_FUNC3  = 3'b000,
     SUB_FUNC7  = 7'b0100000, SUB_FUNC3  = 3'b000,
     SLL_FUNC7  = 7'b0000000, SLL_FUNC3  = 3'b001,
     SRL_FUNC7  = 7'b0000000, SRL_FUNC3  = 3'b101,
     SRA_FUNC7  = 7'b0100000, SRA_FUNC3  = 3'b101,
     SLT_FUNC7  = 7'b0000000, SLT_FUNC3  = 3'b010,
     SLTU_FUNC7 = 7'b0000000, SLTU_FUNC3 = 3'b011,
     XOR_FUNC7  = 7'b0000000, XOR_FUNC3  = 3'b100,
     OR_FUNC7   = 7'b0000000, OR_FUNC3   = 3'b110,
     AND_FUNC7  = 7'b0000000, AND_FUNC3  = 3'b111
     ;

localparam
    X1 = 5'b00001,
    X2 = 5'b00010,
    X3 = 5'b00011,
    X4 = 5'b00100,
    X5 = 5'b00101,
    X6 = 5'b00110,
    X7 = 5'b00111,
    X8 = 5'b01000,
    X9 = 5'b01001,
    X10 = 5'b01010,
    X11 = 5'b01011,
    X12 = 5'b01100,
    X13 = 5'b01101,
    X14 = 5'b01110,
    X15 = 5'b01111,
    X16 = 5'b10000,
    X17 = 5'b10001,
    X18 = 5'b10010,
    X19 = 5'b10011,
    X20 = 5'b10100,
    X21 = 5'b10101,
    X22 = 5'b10110,
    X23 = 5'b10111,
    X24 = 5'b11000,
    X25 = 5'b11001,
    X26 = 5'b11010,
    X27 = 5'b11011,
    X28 = 5'b11100,
    X29 = 5'b11101,
    X30 = 5'b11110,
    X31 = 5'b11111;


    initial begin
        // rom[x] = 32'b
        //          func7_rs2_rs1_func3_rd_opcode   <-  R-TYPE case
        rom[0] = {
            ADD_FUNC7, X1, X2, ADD_FUNC3, X4, R_TYPE_OPCODE
        };  // add x4, x2, x1;                                          x4 = 2 + 1 = 3;
        rom[1] = {
            SUB_FUNC7, X1, X2, SUB_FUNC3, X5, R_TYPE_OPCODE
        };  // sub x5, x2, x1;                                          x5 = 2 - 1 = 1;
        rom[2] = {
            SLL_FUNC7, X4, X5, SLL_FUNC3, X6, R_TYPE_OPCODE
        };  // shift left logical x6, x5, x4;                           x6 = 1 << 3 = 8;
        rom[3] = {
            SRL_FUNC7, X4, X6, SRL_FUNC3, X7, R_TYPE_OPCODE
        };  // shift right logical x7, x6, x4;                          x7 = 8 >> 3 = 1;
        rom[4] = {
            SRA_FUNC7, X4, X16, SRA_FUNC3, X8, R_TYPE_OPCODE
        };  // shift right arith  x8, x16, x4;                          x8 = 16 >>> 3 = 2 (SIGNED)
        rom[5] = {
            SLT_FUNC7, X5, X20, SLT_FUNC3, X9, R_TYPE_OPCODE
        };  // set less than (Signed) x9, x20, x5                       x9 = (S)10100 < (S)00101 = 01100(-5) < 11011(-27) = 0 (FALSE)
        rom[6] = {
            SLTU_FUNC7, X21, X19, SLTU_FUNC3, X10, R_TYPE_OPCODE
        };  // set less than (Unsigned) x10, x19, x21                   x10 = (U)10011 < (U)10101 = 19 < 21 = 1 (TRUE)
        rom[7] = {
            XOR_FUNC7, X31, X21, XOR_FUNC3, X11, R_TYPE_OPCODE
        }; //  xor x11, x21, x31                                        x11 = 10101 XOR 11111 = 01010
        rom[8] = {
            OR_FUNC7, X16, X15, OR_FUNC3, X12, R_TYPE_OPCODE
        }; //  or x12, x15, x16                                         x12 = 01111 OR 10000 = 11111
        rom[9] = {
            AND_FUNC7, X31, X21, AND_FUNC3, X13, R_TYPE_OPCODE
        }; //  and x13, x21, x31                                        x13 = 10101 AND 11111 = 10101
    end

    assign data = rom[addr[31:2]];
endmodule
