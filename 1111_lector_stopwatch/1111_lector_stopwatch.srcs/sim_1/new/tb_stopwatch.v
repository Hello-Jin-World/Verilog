`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/11 15:06:05
// Design Name: 
// Module Name: tb_stopwatch
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


module tb_stopwatch ();

    reg clk;
    reg reset;
    reg run;
    reg clear;
    wire [5:0] msec;
    wire [5:0] sec;
    wire [5:0] min;

    stopwatch_datapath dut (
        .clk  (clk),
        .reset(reset),
        .run  (run),
        .clear(clear),
        .msec (msec),
        .sec  (sec),
        .min  (min)
    );

    always #5 clk = ~clk;

    initial begin
        #00 clk = 1'b0; reset = 1'b1; run   = 1'b0; clear = 1'b0;
        #10 reset = 1'b0;
        #10 run = 1'b1;
        wait (sec == 4);
        @(posedge clk) run = 1'b0;
        repeat (10) @(posedge clk);
        run = 1'b1;
        wait (sec == 6);
        clear = 1'b1;
    end


endmodule
