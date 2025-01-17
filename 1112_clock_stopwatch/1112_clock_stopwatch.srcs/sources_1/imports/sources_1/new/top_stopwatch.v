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

module top_stopwatch_clock (
    input        clk,
    input        reset,
    input        sw_mode,
    input        sw_clock_stopwatch,
    input        button0,
    input        button1,
    input        button2,
    output [3:0] fndcom,
    output [7:0] fndfont,
    output [3:0] led
);

    wire [2:0] w_fndsel;
    wire w_button0, w_button1, w_button2;
    wire [7:0] w_stopwatch_fndfont, w_clock_fndfont;

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

    led_state U_led_state(
        .sw_mode(sw_mode),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .led(led)
    );

    clk_div U_clk_div (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk)
    );

    counter U_counter (
        .clk(w_clk),
        .reset(reset),
        .counter(w_fndsel)
    );

    top_clock U_top_clock (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .button0(w_button0),
        .button1(w_button1),
        .button2(w_button2),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .sel(w_fndsel),
        .fndfont(w_clock_fndfont)
    );

    top_stopwatch U_top_stopwatch (
        .clk(clk),
        .reset(reset),
        .sel(w_fndsel),
        .sw_mode(sw_mode),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .btn_run_stop(w_button0),
        .btn_clear(w_button2),
        .fndfont(w_stopwatch_fndfont)
    );

    clock_stopwatch_select U_clock_stopwatch_select (
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .clock_fnd_font(w_clock_fndfont),
        .stopwatch_fnd_font(w_stopwatch_fndfont),
        .fnd_font(fndfont)
    );

    decoder_3x8 U_decoder_3x8 (
        .switch_in (w_fndsel),
        .switch_out(fndcom)
    );
endmodule

module top_stopwatch (
    input        clk,
    input        reset,
    input        sw_mode,
    input        btn_run_stop,
    input        btn_clear,
    input        sw_clock_stopwatch,
    input  [2:0] sel,
    output [7:0] fndfont
);

    wire w_run, w_clear;
    wire [6:0] w_msec, w_sec, w_min, w_hour;
    wire w_btn_run_stop, w_btn_clear;

    stopwatch_control_unit U_stopwatch_control_unit (
        .clk(clk),
        .reset(reset),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .btn_run_stop(btn_run_stop),
        .btn_clear(btn_clear),
        .run(w_btn_run_stop),
        .clear(w_btn_clear)
    );

    stopwatch_datapath U_stopwatch_datapath (
        .clk  (clk),
        .reset(reset),
        .run  (w_btn_run_stop),
        .clear(w_btn_clear),
        .msec (w_msec),
        .sec  (w_sec),
        .min  (w_min),
        .hour (w_hour)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .sel(sel),
        .msec(w_msec),  // 0.01sec
        .sec(w_sec),  // 1sec
        .min(w_min),  // 1min
        .hour(w_hour),
        .fndfont(fndfont)
    );
endmodule

module top_clock (
    input        clk,
    input        reset,
    input        sw_mode,
    input        button0,
    input        button1,
    input        button2,
    input        sw_clock_stopwatch,
    input  [2:0] sel,
    output [7:0] fndfont
);

    wire [6:0] w_msec, w_sec, w_min, w_hour;

    clock_datapath U_clock_datapath (
        .clk  (clk),
        .reset(reset),
        .button0(button0),
        .button1(button1),
        .button2(button2),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .msec (w_msec),
        .sec  (w_sec),
        .min  (w_min),
        .hour (w_hour)
    );

    fnd_control_for_clock U_fnd_control_for_clock (
        .clk    (clk),
        .reset  (reset),
        .sw_mode(sw_mode),
        .sel    (sel),
        .msec   (w_msec),       // 0.1sec
        .sec    (w_sec),   // 1sec
        .min    (w_min),   // 1min
        .hour   (w_hour),  // 1hour
        .fndfont(fndfont)
    );

endmodule

module clock_stopwatch_select (
    input            sw_clock_stopwatch,
    input      [7:0] clock_fnd_font,
    input      [7:0] stopwatch_fnd_font,
    output reg [7:0] fnd_font
);

    always @(*) begin
        case (sw_clock_stopwatch)
            1'b0: fnd_font = clock_fnd_font;
            1'b1: fnd_font = stopwatch_fnd_font;
            default: fnd_font = 8'bx;  // unknown
        endcase
    end
endmodule

module counter (
    input            clk,
    input            reset,
    output reg [2:0] counter
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module clk_div (
    input  clk,
    input  reset,
    output o_clk
);

    reg [16:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;  // enable 'output reg o_clk'

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

module led_state (
    input sw_mode,
    input sw_clock_stopwatch,
    output reg [3:0] led
);
    
    always @(*) begin
        if (sw_clock_stopwatch) begin
            if (sw_mode) begin
                led = 4'b1000;
            end else begin
                led = 4'b0100;
            end
        end else begin
            if (sw_mode) begin
                led = 4'b0010;
            end else begin
                led = 4'b0001;
            end
        end
    end
endmodule
