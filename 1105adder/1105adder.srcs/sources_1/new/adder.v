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
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] sum,
    output       carry
);

wire carry0, carry1, carry2, carry3;

full_adder U_FA0(
    .a(a[0]),
    .b(b[0]),
    .cin(1'b0),
    .sum(sum[0]),
    .carry(carry0)
);

full_adder U_FA1(
    .a(a[1]),
    .b(b[1]),
    .cin(carry0),
    .sum(sum[1]),
    .carry(carry1)
);

full_adder U_FA2(
    .a(a[1]),
    .b(b[1]),
    .cin(carry1),
    .sum(sum[2]),
    .carry(carry2)
);

full_adder U_FA3(
    .a(a[1]),
    .b(b[1]),
    .cin(carry2),
    .sum(sum[3]),
    .carry(carry3)
);

assign carry = carry3;

endmodule

module full_adder (
    input a, // no-enter default : wire 
    input b, // If you want reg type : input reg b,
    input cin,
    output sum,
    output carry
);

wire sum1, carry1, sum2, carry2;

assign carry = carry1 | carry2;
assign sum = sum2;

half_adder U_HA1(
    .a(a),
    .b(b),
    .sum(sum1),
    .carry(carry1)
);

half_adder U_HA2(
    .a(sum1),
    .b(cin),
    .sum(sum2),
    .carry(carry2)
);


endmodule

module half_adder (
    input a,
    input b,
    output sum,
    output carry
);

//1st method
    assign sum = a ^ b;
    assign carry = a & b;
///2nd method
    //xor(sum, a, b);
    //and(carry, a, b);
endmodule

