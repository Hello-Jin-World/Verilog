`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 14:04:27
// Design Name: 
// Module Name: tb_counter
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


module tb_counter ();
    reg        clk;
    reg        reset;
    wire [7:0] led;

    dedicated dut (
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk   = 0;
        reset = 1;
        #5;
        reset = 0;
    end
endmodule
