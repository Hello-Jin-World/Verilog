`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 17:29:40
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


module _4bit_adder(
    input a0,
    input b0,
    input a1,
    input b1,
    input a2,
    input b2,
    input a3,
    input b3,
    input cin,
    output sum0,
    output sum1,
    output sum2,
    output sum3,
    output carry
);

 wire carry0, carry1, carry2, carry4, sum0, sum1, sum2, sum3;

full_adder U_FA1( // 1st Full Adder
    .a(a0),
    .b(b0),
    .cin(cin),
    .sum(sum0),
    .carry(carry0)
);

full_adder U_FA2( // 2nd Full Adder
    .a(a1),
    .b(b1),
    .cin(carry0),
    .sum(sum1),
    .carry(carry1)
);

full_adder U_FA3( // 3rd Full Adder
    .a(a2),
    .b(b2),
    .cin(carry1),
    .sum(sum2),
    .carry(carry2)
);

full_adder U_FA4( // 4th Full Adder
    .a(a3),
    .b(b3),
    .cin(carry2),
    .sum(sum3),
    .carry(carry3)
);

assign carry = carry3;

endmodule

///////////////////////////////FULL ADDER/////////////////////////////////////

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output carry
);
    wire sum1, carry1, sum2, carry2;
    
half_adder U_HA1( // 1st Half Adder
    .a(a),
    .b(b),
    .sum(sum1),
    .carry(carry1)
);

half_adder U_HA2( // 2nd Half Adder
    .a(sum1), 
    .b(cin),
    .sum(sum2),
    .carry(carry2)
);

    assign carry = carry1 | carry2;
    assign sum = sum2;

endmodule

///////////////////////////////HALF ADDER/////////////////////////////////////

module half_adder(
    input a,
    input b,
    output sum,
    output carry
    );
    
    assign sum = a ^ b;
    assign carry = a & b;
    
endmodule
