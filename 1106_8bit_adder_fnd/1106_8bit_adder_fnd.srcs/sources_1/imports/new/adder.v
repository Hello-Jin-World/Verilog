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

module calculator (
    input        clk,
    input        reset,
    input  [7:0] a,
    input  [7:0] b,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire [7:0] w_sum;
    wire w_carry;
    wire [13:0] w_bcddata;
    /*
    adder_8bit U_8bit_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(w_sum),
        .carry(w_carry)
    );
    */
    clk_div_100ms U_clk_div_100ms(
        .clk(clk),
        .reset(reset),
        .digit(w_bcddata)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .bcddata(w_bcddata),  // For 14bit format (add MSB 5'b0)
        .fndcom(fndcom),
        .fndfont(fndfont)
    );
endmodule

module clk_div_100ms (
    input clk,
    input reset,
    output [13:0] digit
);

    reg [23:0] r_counter;
    reg [13:0] r_digit;

    assign digit = r_digit;  // enable 'output reg o_clk'

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_digit   <= 14'b0;
        end else begin
            if (r_counter == 10_000_000 - 1) begin
                r_counter <= 0;
                r_digit   <= r_digit + 1;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end
endmodule

module adder_8bit (  // lector version
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       carry
);

    wire w_carry;

    adder_4bit U_adder_4bit_0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .carry(w_carry)
    );

    adder_4bit U_adder_4bit_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(w_carry),
        .sum(sum[7:4]),
        .carry(carry)
    );
endmodule

module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       carry
);

    wire carry0, carry1, carry2, carry3;

    full_adder U_FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .carry(carry0)
    );

    full_adder U_FA1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry0),
        .sum(sum[1]),
        .carry(carry1)
    );

    full_adder U_FA2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry1),
        .sum(sum[2]),
        .carry(carry2)
    );

    full_adder U_FA3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry2),
        .sum(sum[3]),
        .carry(carry)
    );

    assign carry = carry3;

endmodule

module full_adder (
    input a,  // no-enter default : wire 
    input b,  // If you want reg type : input reg b,
    input cin,
    output sum,
    output carry
);

    wire sum1, carry1, sum2, carry2;

    assign carry = carry1 | carry2;
    assign sum   = sum2;

    half_adder U_HA1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );

    half_adder U_HA2 (
        .a(sum1),
        .b(cin),
        .sum(sum2),
        .carry(carry2)
    );


endmodule

module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);

    //1st method
    assign sum   = a ^ b;
    assign carry = a & b;
    ///2nd method
    //xor(sum, a, b);
    //and(carry, a, b);
endmodule

