`timescale 1ns / 1ps
`include "defines.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 09:41:07
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
        X1 = 5'b00001, X2 = 5'b00010, X3 = 5'b00011, X4 = 5'b00100, X5 = 5'b00101, X6 = 5'b00110, X7 = 5'b00111, X8 = 5'b01000, X9 = 5'b01001, X10 = 5'b01010, X11 = 5'b01011, X12 = 5'b01100, X13 = 5'b01101, X14 = 5'b01110, X15 = 5'b01111, X16 = 5'b10000, X17 = 5'b10001, X18 = 5'b10010, X19 = 5'b10011, X20 = 5'b10100, X21 = 5'b10101, X22 = 5'b10110, X23 = 5'b10111, X24 = 5'b11000, X25 = 5'b11001, X26 = 5'b11010, X27 = 5'b11011, X28 = 5'b11100, X29 = 5'b11101, X30 = 5'b11110, X31 = 5'b11111
    ;

    initial begin  // for test
        // rom[x] = 32'b func7 _ rs2 _ rs1 _f3 _  rd _ opcode; // R-TYPE
        rom[0] = 32'b0000000_00001_00010_000_00100_0110011;// add x4, x2, x1; ==>  x4 = 2 + 1 = 3;
        rom[1] = 32'b0100000_00001_00010_000_00101_0110011;// sub x5, x2, x1; ==>  x5 = 2 - 1 = 1;
        rom[2] = 32'b0000000_00001_00100_000_00110_0110011;// add x6, x4, x5; ==>  x6 = 3 + 1 = 4;
        rom[3] = 32'b0100000_00001_00100_000_00111_0110011;// sub x7, x4, x5; ==>  x7 = 3 - 1 = 2;
        // I-TYPE
        rom[4] = 32'b0000000_00010_00001_001_01100_0010011;// x12 = x1 << 2 = 4;
        rom[5] = 32'b0000000_00010_00110_101_01101_0010011;// x13 = x6 >> 2 = 1; 
        rom[6] = 32'b0100000_00010_00100_101_01110_0010011;// x14 = x4 >>> 2 = 0; 
        // rom[x] = 32'b imm(7) _ rs2(5) _ rs1(5) _f3 _  imm(5) _ opcode; // S-TYPE
        rom[7] = 32'b0000000_11111_00001_010_00011_0100011;// Store Word M[1 + 3] = X31 = ffff_ffff;
        // rom[x] = 32'b imm(7) _ imm(5) _ rs1(5) _f3 _ rd(5) _ opcode; // IL-TYPE
        rom[8] = 32'b0000000_00011_00001_100_01000_0000011;// Load Word M[1 + 3] = X8 = 0000_00ff;
        
        rom[9] = 32'b0000000_11111_00001_001_00011_0100011;// Store Half M[1 + 4] = X31 = 0000_ffff;
        rom[10]= 32'b0000000_00011_00001_000_01001_0010011;// Shift 
        rom[11]= 32'b0000000_00100_00001_010_01011_0010011;

    end

    assign data = rom[addr[31:2]];

endmodule
