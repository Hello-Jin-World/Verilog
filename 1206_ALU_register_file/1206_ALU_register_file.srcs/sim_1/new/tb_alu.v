`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 17:54:50
// Design Name: 
// Module Name: tb_alu
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


module tb_alu ();

    reg         clk;
    reg         reset;
    wire [15:0] outport;


    alu_dedicated_processor dut (
        .clk    (clk),
        .reset  (reset),
        .outport(outport)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #5;
        reset = 0;
    end
endmodule
