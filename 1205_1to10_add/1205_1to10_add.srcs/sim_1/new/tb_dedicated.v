`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 16:13:54
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
    wire [7:0] led;
    wire [3:0] fndcom;
    wire [7:0] fndfont;

    dedicated dut (
        .clk(clk),
        .reset(reset),
        .led(led),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #5;
        reset = 0;
    end
endmodule
