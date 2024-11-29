`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 01:03:46
// Design Name: 
// Module Name: stopwatch_clock
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


module stopwatch_clock (
    input        clk,
    input        reset,
    input        sw_mode,
    input        sw_clock_stopwatch,
    input        button0,
    input        button1,
    input        button2,
    input  [7:0] u_command,
    input        string_command,
    input        rx_done,
    output [3:0] led,
    output [6:0] seleted_msec,
    output [6:0] seleted_sec,
    output [6:0] seleted_min,
    output [6:0] seleted_hour
);

    wire w_button0, w_button1, w_button2;
    wire w_run, w_clear;
    wire [6:0] w_msec, w_sec, w_min, w_hour;
    wire [6:0] w_clock_msec, w_clock_sec, w_clock_min, w_clock_hour;
    wire [6:0] w_seleted_msec, w_seleted_sec, w_seleted_min, w_seleted_hour;

    led_mode_state U_led_mode_state (
        .sw_mode           (sw_mode),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .led               (led)
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
        .sec_btn   (w_button0),
        .min_btn   (w_button1),
        .hour_btn  (w_button2),
        .chipselect(sw_clock_stopwatch),
        .o_sec_btn (w_sec_btn),
        .o_min_btn (w_min_btn),
        .o_hour_btn(w_hour_btn)
    );

    clock_datapath U_clock_datapath (
        .sec_btn (w_sec_btn),
        .min_btn (w_min_btn),
        .hour_btn(w_hour_btn),
        .clk     (clk),
        .reset   (reset),
        .msec    (w_clock_msec),
        .sec     (w_clock_sec),
        .min     (w_clock_min),
        .hour    (w_clock_hour)
    );

    stopwatch_control_unit U_stopwatch_control_unit (
        .clk         (clk),
        .reset       (reset),
        .btn_run_stop(w_button0),
        .btn_clear   (w_button2),
        .u_command   (u_command),
        .rx_done     (rx_done),
        .chipselect  (sw_clock_stopwatch),
        .run         (w_run),
        .clear       (w_clear)
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
        .clock_msec    (w_clock_msec),
        .clock_sec     (w_clock_sec),
        .clock_min     (w_clock_min),
        .clock_hour    (w_clock_hour),
        .stopwatch_msec(w_msec),
        .stopwatch_sec (w_sec),
        .stopwatch_min (w_min),
        .stopwatch_hour(w_hour),
        .chipselect    (sw_clock_stopwatch),
        .o_msec        (seleted_msec),
        .o_sec         (seleted_sec),
        .o_min         (seleted_min),
        .o_hour        (seleted_hour)
    );

endmodule

module select_clock_stopwatch (
    input      [6:0] clock_msec,
    input      [6:0] clock_sec,
    input      [6:0] clock_min,
    input      [6:0] clock_hour,
    input      [6:0] stopwatch_msec,
    input      [6:0] stopwatch_sec,
    input      [6:0] stopwatch_min,
    input      [6:0] stopwatch_hour,
    input            chipselect,
    output reg [6:0] o_msec,
    output reg [6:0] o_sec,
    output reg [6:0] o_min,
    output reg [6:0] o_hour
);


    always @(*) begin
        case (chipselect)
            1'b0: begin
                o_msec = clock_msec;
                o_sec  = clock_sec;
                o_min  = clock_min;
                o_hour = clock_hour;
            end
            1'b1: begin
                o_msec = stopwatch_msec;
                o_sec  = stopwatch_sec;
                o_min  = stopwatch_min;
                o_hour = stopwatch_hour;
            end
            default: begin
                o_msec = 0;
                o_sec  = 0;
                o_min  = 0;
                o_hour = 0;
            end
        endcase
    end

endmodule

module led_mode_state (
    input            sw_mode,
    input            sw_clock_stopwatch,
    output reg [3:0] led
);

    always @(*) begin
        led = 4'b0000;
        if (!sw_clock_stopwatch && !sw_mode) begin
            led = 4'b0001;
        end
        if (!sw_clock_stopwatch && sw_mode) begin
            led = 4'b0010;
        end
        if (sw_clock_stopwatch && !sw_mode) begin
            led = 4'b0100;
        end
        if (sw_clock_stopwatch && sw_mode) begin
            led = 4'b1000;
        end
    end

endmodule
