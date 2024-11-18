`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 10:19:53
// Design Name: 
// Module Name: tb_add_sub
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


module tb_add_sub ();

    reg  [7:0] a;
    reg  [7:0] b;
    reg        cin;
    reg        mode_select;
    wire [7:0] sum;
    wire       carry;

    add_sub dut (
        .a(a),
        .b(b),
        .cin(cin),
        .mode_select(mode_select),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        #5 a = 4;
         b = 8;
        cin = 0;
        mode_select = 1;
    end
endmodule
