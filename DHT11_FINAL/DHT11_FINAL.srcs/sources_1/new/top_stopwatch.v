`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 21:25:32
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
    input        sw_mode,
    input        btn_run_stop,
    input        btn_clear,
    input  [7:0] u_command,
    input        rx_done,
    output [3:0] led,
    output [6:0] msec,
    output [6:0] sec,
    output [6:0] min,
    output [6:0] hour
    // output [3:0] fndcom,
    // output [7:0] fndfont
);

    wire w_btn_run_stop, w_btn_clear;
    wire w_run, w_clear;
    wire [6:0] w_msec, w_sec, w_min, w_hour;

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
        .clk         (clk),
        .reset       (reset),
        .btn_run_stop(w_btn_run_stop),
        .btn_clear   (w_btn_clear),
        .u_command   (u_command),
        .rx_done     (rx_done),
        .run         (w_run),
        .clear       (w_clear)
    );


    stopwatch_datapath U_stopwatch_datapath (
        .clk  (clk),
        .reset(reset),
        .run  (w_run),
        .clear(w_clear),
        .msec (msec),
        .sec  (sec),
        .min  (min),
        .hour (hour)
    );

    fnd_controller U_fnd_controller (
        .clk      (clk),
        .reset    (reset),
        .sw_mode  (sw_mode),
        .u_command(u_command),
        .msec     (w_msec),     // 0.01sec
        .sec      (w_sec),      // 1sec
        .min      (w_min),      // 1min
        .hour     (w_hour),
        .fndcom   (fndcom),
        .fndfont  (fndfont)
    );
endmodule
