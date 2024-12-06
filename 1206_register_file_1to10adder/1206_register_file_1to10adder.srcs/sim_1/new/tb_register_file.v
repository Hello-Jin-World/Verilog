`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 15:15:55
// Design Name: 
// Module Name: tb_register_file
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


module tb_register_file ();

    reg         clk;
    reg         reset;
    wire [15:0] outport;

    register_file dut (
        .clk    (clk),
        .reset  (reset),
        .outport(outport)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #5;
        reset = 0;
    end
endmodule
