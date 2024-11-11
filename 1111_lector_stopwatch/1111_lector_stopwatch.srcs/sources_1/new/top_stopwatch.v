`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/11 16:17:44
// Design Name: 
// Module Name: top_stopwatch
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


module top_stopwatch (
    input        clk,
    input        reset,
    input        btn_run_stop,
    input        btn_clear,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire w_btn_run_stop, w_btn_clear;
    wire w_run, w_clear;
    wire [5:0] w_msec, w_sec, w_min;

    button_detector U_run_stop_button_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn_run_stop),
        .o_btn(w_btn_run_stop)
    );

    button_detector U_clear_button_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn_clear),
        .o_btn(w_btn_clear)
    );

    stopwatch_control_unit U_stopwatch_control_unit (
        .clk(clk),
        .reset(reset),
        .btn_run_stop(w_btn_run_stop),
        .btn_clear(w_btn_clear),
        .run(w_run),
        .clear(w_clear)
    );


    stopwatch_datapath U_stopwatch_datapath (
        .clk  (clk),
        .reset(reset),
        .run  (w_run),
        .clear(w_clear),
        .msec (w_msec),
        .sec  (w_sec),
        .min  (w_min)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .msec(w_msec),  // 0.1sec
        .sec(w_sec),  // 1sec
        .min(w_min),  // 1min
        .fndcom(fndcom),
        .fndfont(fndfont)
    );
endmodule
