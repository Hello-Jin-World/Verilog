`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 01:53:42 AM
// Design Name: 
// Module Name: tb_floating_point
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


module tb_floating_point ();
    reg [15:0] a, b;
    wire [15:0] result;
    wire overflow, underflow;

    // DUT 인스턴스화
    floating_point dut (
        .a(a),
        .b(b),
        .result(result),
        .overflow(overflow),
        .underflow(underflow)
    );

    // 테스트 시퀀스
    initial begin
        // 테스트 케이스 1: 양의 정규화된 숫자 덧셈
        a = 16'b0_01000_0100000000;  // 1.0
        b = 16'b0_01000_0010000000;  // 0.5
        #10;
        $display("Test Case 1: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
                 b, result, overflow, underflow);

        // 테스트 케이스 2: 부호가 다른 숫자 덧셈
        a = 16'b0_01000_0100000000;  // 1.0
        b = 16'b1_01000_0100000000;  // -1.0
        #10;
        $display("Test Case 2: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
                 b, result, overflow, underflow);

        // 테스트 케이스 3: 큰 오버플로우 케이스
        a = 16'b0_11110_1111111111;  // 최대 양의 값
        b = 16'b0_01000_0100000000;  // 1.0
        #10;
        $display("Test Case 3: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
                 b, result, overflow, underflow);

        $finish;
    end
endmodule
