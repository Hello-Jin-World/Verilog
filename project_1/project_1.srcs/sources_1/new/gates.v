`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 11:20:34
// Design Name: 
// Module Name: gates
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


module gates(
    input a,
    input b,
    output y0,
    output y1,
    output y2,
    output y3,
    output y4,
    output y5,
    output y6
    );
    
    assign y0 = a & b; // AND OPERATION
    assign y1 = ~(a & b); // NAND OPERATION
    assign y2 = a | b; // OR OPERATION
    assign y3 = ~(a | b); // NOR OPERATION
    assign y4 = a ^ b; // XOR OPERATION
    assign y5 = ~(a ^ b); // NOTXOR OPERATION
    assign y6 = ~a; // NOT OPERATION
endmodule
