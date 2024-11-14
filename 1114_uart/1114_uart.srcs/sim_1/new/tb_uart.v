`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 13:37:23
// Design Name: 
// Module Name: tb_uart
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


module tb_uart ();

    reg        clk;
    reg        reset;
    reg        start;
    reg  [7:0] data;
    wire [7:0] out_data;

    uart dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data(data),
        .out_data(out_data)
    );

    always #5 clk = ~clk;
    always #50 data = 8'b10010100;

    initial begin
        #00 clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        #05 reset = 1'b0;
        #5000 start = 1'b1;
        #5050 start = 1'b0;
    end

endmodule
