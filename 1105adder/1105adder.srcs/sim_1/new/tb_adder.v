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
        for (i = 0; i < 20; i = i + 1) begin
            #10 a = i;
            b = i + 1;
        end
    end
endmodule
