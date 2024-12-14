`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 01:30:58 AM
// Design Name: 
// Module Name: floating_point
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

module floating_point_adder (
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] result,
    output reg        overflow,
    output reg        underflow
);

    reg a_signed_bit, b_signed_bit;
    reg [7:0] a_exp, b_exp;
    reg [7:0] temp_exp;
    reg [23:0] a_man, b_man;
    reg [23:0] sum_man;
    reg result_sign;
    reg [22:0] result_man;

    always @(*) begin
        overflow     = 0;
        underflow    = 0;
        a_signed_bit = a[31];
        b_signed_bit = b[31];
        a_exp        = a[30:23];
        b_exp        = b[30:23];
        a_man        = {1'b1, a[22:0]};
        b_man        = {1'b1, b[22:0]};

        if (a_exp < b_exp) begin
            b_man = b_man >> (a_exp - b_exp);  // b의 가수를 오른쪽으로 시프트
            temp_exp = a_exp;
        end else if (a_exp > b_exp) begin
            a_man = a_man >> (b_exp - a_exp);  // a의 가수를 오른쪽으로 시프트
            temp_exp = b_exp;
        end else begin
            temp_exp = a_exp;
        end

        if (a_signed_bit == b_signed_bit) begin
            sum_man = a_man + b_man;
            result_sign = a_signed_bit;
        end else begin
            if (a_man > b_man) begin
                sum_man = a_man - b_man;
                result_sign = a_signed_bit;
            end else begin
                sum_man = b_man - a_man;
                result_sign = b_signed_bit;
            end
        end

        if (sum_man[24]) begin
            sum_man = sum_man >> 1'b1;
            temp_exp = temp_exp + 1;
        end else if (sum_man[23] == 0 && temp_exp > 0) begin
            sum_man = sum_man << 1'b1;
            temp_exp = temp_exp - 1;
        end

        result_man = sum_man[22:0];
        result     = {result_sign, temp_exp, result_man};

        if (temp_exp == 8'hff) begin
            overflow = 1;
        end
        if (temp_exp == 0 && result_man == 0) begin
            underflow = 1;  // 언더플로우
        end
    end
endmodule

/*

module floating_point (
    input  wire [31:0] a,         // 첫 번째 32bit 부동소수점 입력
    input  wire [31:0] b,         // 두 번째 32bit 부동소수점 입력
    output reg  [31:0] result,    // 32bit 부동소수점 결과
    output reg         overflow,  // 오버플로우 플래그
    output reg         underflow  // 언더플로우 플래그
);

    // 내부 reg 변수 선언
    reg sign_a, sign_b;
    reg [7:0] exp_a, exp_b;
    reg [24:0] mantissa_a, mantissa_b;
    reg [7:0] exp_diff, larger_exp;
    reg [24:0] shifted_mantissa;
    reg [26:0] mantissa_sum;
    reg result_sign;
    reg [7:0] normalized_exp;
    reg [22:0] normalized_mantissa;
    reg is_overflow, is_underflow;

    // 주요 연산 always 블록
    always @(*) begin
        // 부호 비트 추출
        sign_a = a[31];
        sign_b = b[31];

        // 지수 비트 추출 (8bit)
        exp_a = a[30:23];
        exp_b = b[30:23];

        // 가수 비트 추출 (24bit - 암묵적 1 추가)
        mantissa_a = {1'b1, a[22:0]};
        mantissa_b = {1'b1, b[22:0]};

        // 지수 정렬
        exp_diff = (exp_a > exp_b) ? exp_a - exp_b : exp_b - exp_a;
        larger_exp = (exp_a > exp_b) ? exp_a : exp_b;

        // 작은 지수 쪽 가수 오른쪽 시프트
        shifted_mantissa = (exp_a > exp_b) ? 
            {1'b0, mantissa_b} >> exp_diff : 
            {1'b0, mantissa_a} >> exp_diff;

        // 가수 덧셈/뺄셈 연산
        mantissa_sum = (sign_a == sign_b) ? 
            {1'b0, mantissa_a} + {1'b0, shifted_mantissa} :
            (mantissa_a > shifted_mantissa) ? 
            {1'b0, mantissa_a} - shifted_mantissa : 
            {1'b0, shifted_mantissa} - mantissa_a;

        // 결과 부호 결정
        result_sign = (sign_a == sign_b) ? sign_a : 
            (mantissa_a > shifted_mantissa) ? sign_a : sign_b;

        // 오버플로우/언더플로우 검출
        is_overflow = (larger_exp == 8'b11111111);
        is_underflow = (larger_exp == 8'b00000000);

        // 결과 정규화
        if (mantissa_sum[26]) begin
            // 오버플로우 발생 시
            normalized_exp = larger_exp + 1;
            normalized_mantissa = mantissa_sum[24:2];
        end else begin
            normalized_exp = larger_exp;
            normalized_mantissa = mantissa_sum[22:0];
        end

        // 최종 결과 조립
        result = {result_sign, normalized_exp, normalized_mantissa};
        overflow = is_overflow;
        underflow = is_underflow;
    end
endmodule
*/
