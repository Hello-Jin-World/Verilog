`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 11:11:48
// Design Name: 
// Module Name: tb_dedicated
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


module tb_dedicated ();

    reg        clk;
    reg        reset;
    wire [3:0] fndcom;
    wire [7:0] fndfont;

    dedicated_processor dut (
        .clk    (clk),
        .reset  (reset),
        .fndcom (fndcom),
        .fndfont(fndfont)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #5;
        reset = 0;
    end
endmodule
