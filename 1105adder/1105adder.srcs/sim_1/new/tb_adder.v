`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 11:18:14
// Design Name: 
// Module Name: tb_adder
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

module tb_adder ();

    reg  [3:0] a;
    reg  [3:0] b;
    wire [3:0] sum;
    wire       carry;

    adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    integer i;
    initial begin
        #00 a = 1;
        b = 2;
        #10 a = 5;
        b = 3;
        #10 a = 1;
        b = 5;
        #10 a = 2;
        b = 4;
        #10 a = 1;
        b = 1;
        for (i = 0; i < 20; i = i + 1) begin
            #10 a = i;
            b = i + 1;
        end
    end
endmodule
