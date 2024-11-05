`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 10:32:17
// Design Name: 
// Module Name: adder
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


module adder(

    );
endmodule

module half_adder (
    input a,
    input b,
    output sum,
    output carry
)

//1st method
    assign sum = a ^ b;
    assign carry = a & b;
///2nd method
    xor(sum, a, b);
    and(carry, a, b);
endmodule

