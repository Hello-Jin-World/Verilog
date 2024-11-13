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
    input        sw_mode,
    input        sw_clock_stopwatch,
    input        button0,
    input        button1,
    input        button2,
    output [3:0] led,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire w_button0, w_button1, w_button2;
    wire w_run, w_clear;
    wire [6:0] w_msec, w_sec, w_min, w_hour;
    wire [6:0] w_clock_msec, w_clock_sec, w_clock_min, w_clock_hour;
    wire [6:0] w_seleted_msec, w_seleted_sec, w_seleted_min, w_seleted_hour;

    led_mode_state U_led_mode_state (
        .sw_mode(sw_mode),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .led(led)
    );

    button_detector U_button0_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(button0),
        .o_btn(w_button0)
    );

    button_detector U_button1_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(button1),
        .o_btn(w_button1)
    );

    button_detector U_button2_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(button2),
        .o_btn(w_button2)
    );

    clock_controlunit U_clock_controlunit (
        .sec_btn(w_button0),
        .min_btn(w_button1),
        .hour_btn(w_button2),
        .chipselect(sw_clock_stopwatch),
        .o_sec_btn(w_sec_btn),
        .o_min_btn(w_min_btn),
        .o_hour_btn(w_hour_btn)
    );

    clock_datapath U_clock_datapath (
        .sec_btn(w_sec_btn),
        .min_btn(w_min_btn),
        .hour_btn(w_hour_btn),
        .clk(clk),
        .reset(reset),
        .msec(w_clock_msec),
        .sec(w_clock_sec),
        .min(w_clock_min),
        .hour(w_clock_hour)
    );

    stopwatch_control_unit U_stopwatch_control_unit (
        .clk(clk),
        .reset(reset),
        .btn_run_stop(w_button0),
        .btn_clear(w_button2),
        .chipselect(sw_clock_stopwatch),
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
        .min  (w_min),
        .hour (w_hour)
    );

    select_clock_stopwatch U_select_clock_stopwatch (
        .clock_msec(w_clock_msec),
        .clock_sec(w_clock_sec),
        .clock_min(w_clock_min),
        .clock_hour(w_clock_hour),
        .stopwatch_msec(w_msec),
        .stopwatch_sec(w_sec),
        .stopwatch_min(w_min),
        .stopwatch_hour(w_hour),
        .chipselect(sw_clock_stopwatch),
        .o_msec(w_seleted_msec),
        .o_sec(w_seleted_sec),
        .o_min(w_seleted_min),
        .o_hour(w_seleted_hour)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .msec(w_seleted_msec),  // 0.01sec
        .sec(w_seleted_sec),  // 1sec
        .min(w_seleted_min),  // 1min
        .hour(w_seleted_hour),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );
endmodule
