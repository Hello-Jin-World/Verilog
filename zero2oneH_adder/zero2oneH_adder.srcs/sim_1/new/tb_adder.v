`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 10:37:14
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

    reg        clk;
    reg        reset;
    wire [3:0] fndcom;
    wire [7:0] fndfont;


    adder dut (
        .clk(clk),
        .reset(reset),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );

    always #5 clk = ~clk;

    initial begin
        reset = 1;
        clk   = 0;
        #5;
        reset = 0;
    end
endmodule
