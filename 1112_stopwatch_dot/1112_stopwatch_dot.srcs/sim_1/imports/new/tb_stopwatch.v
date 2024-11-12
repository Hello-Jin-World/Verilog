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
    reg sw_mode;
    wire [6:0] w_msec;
    wire [6:0] w_sec;
    wire [6:0] w_min;
    wire [6:0] w_hour;
    wire [3:0] fndcom;
    wire [7:0] fndfont;

    stopwatch_datapath dut (
        .clk  (clk),
        .reset(reset),
        .run  (run),
        .clear(clear),
        .msec (w_msec),
        .sec  (w_sec),
        .min  (w_min),
        .hour (w_hour)
    );

    fnd_controller dut1 (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .msec(w_msec),    // 0.1sec
        .sec(w_sec),     // 1sec
        .min(w_min),     // 1min
        .hour(w_hour),    // 1hour
        .fndcom(fndcom),
        .fndfont(fndfont)
    );

    always #5 clk = ~clk;

    initial begin
        #00 clk = 1'b0;
        reset = 1'b1;
        run   = 1'b0;
        clear = 1'b0;
        sw_mode = 1'b0;
        #10 reset = 1'b0;
        #10 run = 1'b1;
        wait (w_min == 2);
        sw_mode = 1'b1;
        /*
        wait (sec == 4);
        @(posedge clk) run = 1'b0;
        repeat (10) @(posedge clk);
        run = 1'b1;
        wait (sec == 6);
        clear = 1'b1;
        */
    end


endmodule
