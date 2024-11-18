`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 09:50:12
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


module adder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       carry
);

    //reg [7:0] temp_sum;

    //assign sum = temp_sum;
    wire w_carry0, w_carry1, w_carry2, w_carry3, w_carry4, w_carry5, w_carry6;

    full_adder U_full_adder0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .carry(w_carry0)
    );
    full_adder U_full_adder1 (
        .a(a[1]),
        .b(b[1]),
        .cin(w_carry0),
        .sum(sum[1]),
        .carry(w_carry1)
    );
    full_adder U_full_adder2 (
        .a(a[2]),
        .b(b[2]),
        .cin(w_carry1),
        .sum(sum[2]),
        .carry(w_carry2)
    );
    full_adder U_full_adder3 (
        .a(a[3]),
        .b(b[3]),
        .cin(w_carry2),
        .sum(sum[3]),
        .carry(w_carry3)
    );
    full_adder U_full_adder4 (
        .a(a[4]),
        .b(b[4]),
        .cin(w_carry3),
        .sum(sum[4]),
        .carry(w_carry4)
    );
    full_adder U_full_adder5 (
        .a(a[5]),
        .b(b[5]),
        .cin(w_carry4),
        .sum(sum[5]),
        .carry(w_carry5)
    );
    full_adder U_full_adder6 (
        .a(a[6]),
        .b(b[6]),
        .cin(w_carry5),
        .sum(sum[6]),
        .carry(w_carry6)
    );
    full_adder U_full_adder7 (
        .a(a[7]),
        .b(b[7]),
        .cin(w_carry6),
        .sum(sum[7]),
        .carry(carry)
    );
endmodule

module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output carry
);

    half_adder U_1st_half_adder (
        .a(a),
        .b(b),
        .sum(w_sum),
        .carry(w_carry1)
    );

    half_adder U_2nd_half_adder (
        .a(w_sum),
        .b(cin),
        .sum(sum),
        .carry(w_carry2)
    );

    assign carry = w_carry1 | w_carry2;
endmodule

module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);

    assign sum   = a ^ b;
    assign carry = a & b;
endmodule
