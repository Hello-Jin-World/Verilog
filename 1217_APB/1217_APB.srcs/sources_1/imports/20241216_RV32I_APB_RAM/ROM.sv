`timescale 1ns / 1ps

module ROM (
    input  logic [31:0] addr,
    output logic [31:0] data
);
    logic [31:0] rom[0:127];

    initial begin // for test
   /* 
    // rom[x] = 32'b func7 _ rs2 _ rs1 _f3 _  rd _ opcode; // R-TYPE
       rom[0] = 32'b0000000_00001_00010_000_00100_0110011;// add x4, x2, x1; ==>  x4 = 2 + 1 = 3;
       rom[1] = 32'b0100000_00001_00010_000_00101_0110011;// sub x5, x2, x1; ==>  x5 = 2 - 1 = 1;
       rom[2] = 32'b0000000_00101_00100_000_00110_0110011;// add x6, x4, x5; ==>  x6 = 3 + 1 = 4;
       rom[3] = 32'b0100000_00101_00100_000_00111_0110011;// sub x7, x4, x5; ==>  x7 = 3 - 1 = 2;
    // rom[x] = 32'b imm(7)_ rs2 _ rs1 _f3 _imm(5)_ opcode; // S-TYPE
       rom[4] = 32'b0000000_00010_00001_010_00011_0100011; // sw x2, x1, 3; ==> M[1+3] = 2
    // rom[x] = 32'b imm(12)    _ rs1 _f3 _  rd _ opcode; // IL-TYPE
       rom[5] = 32'b000000000011_00001_010_01000_0000011;//lw x8, x1, 3; ==> x8 = M[1+3]
    */   
       $readmemh("code.mem", rom);
    end

    assign data = rom[addr[31:2]];

endmodule
