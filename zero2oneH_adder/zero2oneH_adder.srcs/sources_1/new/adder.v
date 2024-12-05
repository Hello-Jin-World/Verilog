`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 09:34:03
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
    input        clk,
    input        reset,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire [12:0] w_a, w_b, w_result_sum, w_final_sum;

    storage U_storage (
        .clk       (clk),
        .reset     (reset),
        .result_sum(w_result_sum),
        .a         (w_a),
        .b         (w_b),
        .final_sum (w_final_sum)
    );

    adder_13bit U_adder_13bit (
        .a    (w_a),
        .b    (w_b),
        .cin  (0),
        .sum  (w_result_sum),
        .carry(carry)
    );

    fnd_controller U_fnd_controller (
        .clk       (clk),
        .reset     (reset),
        .sum_result(w_final_sum),
        .fndcom    (fndcom),
        .fndfont   (fndfont)
    );
endmodule


module storage (
    input         clk,
    input         reset,
    // input         button,
    input  [12:0] result_sum,
    output [12:0] a,
    output [12:0] b,
    output [12:0] final_sum
);

    reg [12:0] a_reg, a_next, b_reg, b_next;

    assign a = a_reg;
    assign b = b_reg;

    reg [12:0] now_sum_reg, now_sum_next;

    assign final_sum = now_sum_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            a_reg       <= 0;
            b_reg       <= 1;
            now_sum_reg <= 0;
        end else begin
            a_reg       <= a_next;
            b_reg       <= b_next;
            now_sum_reg <= now_sum_next;
        end
    end

    always @(*) begin
        now_sum_next = now_sum_reg;
        a_next       = a_reg;
        b_next       = b_reg;
        // final_sum    = now_sum_reg;
        // if ((now_sum_reg != result_sum) && button) begin
        // if (button) begin
        if (now_sum_reg != result_sum && b_reg <= 100) begin
            now_sum_next = result_sum;
            a_next       = result_sum;
            b_next       = b_reg + 1;
            // final_sum = 0;
        end else begin
            b_next = 0;
        end
    end
endmodule

module adder_13bit (
    input  [12:0] a,
    input  [12:0] b,
    input         cin,
    output [12:0] sum,
    output        carry
);

    wire w_carry0, w_carry1, w_carry2, w_carry3;

    assign carry = w_carry3;

    adder_4bit U_adder_4bit_0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .carry(w_carry0)
    );

    adder_4bit U_adder_4bit_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(w_carry0),
        .sum(sum[7:4]),
        .carry(w_carry1)
    );

    adder_4bit U_adder_4bit_2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(w_carry1),
        .sum(sum[11:8]),
        .carry(w_carry2)
    );

    full_adder U_FA13 (
        .a(a[12]),
        .b(b[12]),
        .cin(w_carry2),
        .sum(sum[12]),
        .carry(w_carry3)
    );
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

