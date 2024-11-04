`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 14:26:01
// Design Name: 
// Module Name: tb_gates
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


module tb_gates();

    reg a; // input -> reg
    reg b;
    wire y0; // output -> wire
    wire y1;
    wire y2;
    wire y3;
    wire y4;
    wire y5;
    wire y6;

gates dut(
    .a (a),
    .b (b),
    .y0(y0),
    .y1(y1),
    .y2(y2),
    .y3(y3),
    .y4(y4),
    .y5(y5),
    .y6(y6)
    );
    
    initial begin
        #00 a = 1'b0; b = 1'b0;
        #10 a = 1'b0; b = 1'b1;
        #10 a = 1'b1; b = 1'b0;
        #10 a = 1'b1; b = 1'b1;
        #10 $finish;
    end
    
endmodule
