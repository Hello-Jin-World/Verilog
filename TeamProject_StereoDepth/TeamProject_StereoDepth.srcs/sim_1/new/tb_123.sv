`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/31 20:55:28
// Design Name: 
// Module Name: tb_123
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


module tb_123 ();
    logic        clk;
    logic        reset;
    logic [14:0] rAddr;
    logic [15:0] data1;
    logic [15:0] data2;
    logic [15:0] displayData;

    Disparity dut (
        .clk        (clk),
        .reset      (reset),
        .rAddr      (rAddr),
        .data1      (data1),
        .data2      (data2),
        .displayData(displayData)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        data1 = 16'h0000;
        data2 = 16'h0000;
        #10;
        reset = 0;

        data1 = 16'h0001;
        data2 = 16'h0000;

        repeat (4) @(posedge clk);
        data1 = 16'h0000;
        data2 = 16'h0002;

        repeat (4) @(posedge clk);
        data1 = 16'h0003;
        data2 = 16'h0001;

        repeat (4) @(posedge clk);
        data1 = 16'h0008;
        data2 = 16'h0004;

        repeat (4) @(posedge clk);
        data1 = 16'h0002;
        data2 = 16'h0005;

    end
endmodule
