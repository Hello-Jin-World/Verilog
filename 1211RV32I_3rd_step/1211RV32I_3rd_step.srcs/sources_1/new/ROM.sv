`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 09:26:13
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

    initial begin  // for test
        // rom[x] = 32'b func7 _ rs2 _ rs1 _f3 _  rd _ opcode; // R-TYPE
        rom[0] = 32'b0000000_00001_00010_000_00100_0110011;// add x4, x2, x1; ==>  x4 = 2 + 1 = 3;
        rom[1] = 32'b0100000_00001_00010_000_00101_0110011;// sub x5, x2, x1; ==>  x5 = 2 - 1 = 1;
        rom[2] = 32'b0000000_00101_00100_000_00110_0110011;// add x6, x4, x5; ==>  x6 = 3 + 1 = 4;
        rom[3] = 32'b0100000_00101_00100_000_00111_0110011;// sub x7, x4, x5; ==>  x7 = 3 - 1 = 2;
        // rom[x] = 32'b imm(7)_ rs2 _ rs1 _f3 _imm(5)_ opcode; // S-TYPE
        rom[4] = 32'b0000000_00010_00001_010_00011_0100011; // sw x2, x1, 3; ==> M[1+3] = 2
        // rom[x] = 32'b imm(12)    _ rs1 _f3 _  rd _ opcode; // IL-TYPE
        rom[5] = 32'b000000000011_00001_010_01000_0000011;//lw x8, x1, 3; ==> x8 = M[1+3]
        //J-TYPE
        // rom[6] = 32'b0000000_10100_00000_000_01010_1101111; // x10 = PC + 4; PC += 20;
        //JI-TYPE
        // rom[6] = 32'b0000000_10000_10000_000_01011_1100111; // x11 = PC + 4; PC = x16 + 16;
        rom[6] = 32'b0000000_00000_00000_001_01100_0110111; // x12 = 1_0000_0000_0000 << 12 = 16,777,216;
        rom[7] = 32'b0000000_00000_00000_001_01101_0010111; // x13 = PC + (1_0000_0000_0000 << 12) = 16,777,216 + 28;
    end

    assign data = rom[addr[31:2]];

endmodule

