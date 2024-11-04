`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 16:31:13
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

module tb_adder();
    
    reg a;
    reg b;
    reg cin;
    wire sum;
    wire carry;
    
    full_adder dut(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry(carry)
    );
    
    initial begin
        #00 cin = 0; b = 0; a = 0;
        #10 cin = 0; b = 0; a = 1;
        #10 cin = 0; b = 1; a = 0;
        #10 cin = 0; b = 1; a = 1;
        #10 cin = 1; b = 0; a = 0;
        #10 cin = 1; b = 0; a = 1;
        #10 cin = 1; b = 1; a = 0;
        #10 cin = 1; b = 1; a = 1;
        #10 $finish;
        
    end

endmodule
