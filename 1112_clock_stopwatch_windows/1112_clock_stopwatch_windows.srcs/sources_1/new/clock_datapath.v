`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/12 15:51:36
// Design Name: 
// Module Name: clock_datapatch
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


module clock_datapath (
    input        clk,
    input        reset,
    input        button0,
    input        button1,
    input        button2,
    input        sw_clock_stopwatch,
    output [6:0] msec,
    output [6:0] sec,
    output [6:0] min,
    output [6:0] hour
);

    wire w_clk_100hz, w_mil_tick, w_sec_tick;

    clk_div_clock U_clk_div_clock (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_100hz)
    );

    time_clock_counter_for_clock #(
        .TIME_MAX (100),
        .BIT_WIDTH(7)
    ) U_time_counter_for_clock_10ms (
        .clk(clk),
        .reset(reset),
        .i_time_tick(w_clk_100hz),
        .o_time_tick(w_mil_tick),
        .o_time(msec)
    );


    time_clock_counter_for_clock #(
        .TIME_MAX (60),
        .BIT_WIDTH(7)
    ) U_time_counter_for_clock_sec (
        .clk(clk),
        .reset(reset),
        .button(button0),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .i_time_tick(w_mil_tick),
        .o_time_tick(w_sec_tick),
        .o_time(sec)
    );

    time_clock_counter_for_clock #(
        .TIME_MAX (60),
        .BIT_WIDTH(7)
    ) U_time_counter_for_clock_min (
        .clk(clk),
        .reset(reset),
        .button(button1),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .i_time_tick(w_sec_tick),
        .o_time_tick(w_min_tick),
        .o_time(min)
    );

    time_clock_counter_for_clock #(
        .TIME_MAX (24),
        .BIT_WIDTH(7)
    ) U_time_counter_for_clock_hour (
        .clk(clk),
        .reset(reset),
        .button(button2),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .i_time_tick(w_min_tick),
        .o_time_tick(),
        .o_time(hour)
    );
endmodule


module clk_div_clock (
    input  clk,
    input  reset,
    output o_clk
);
    reg [$clog2(1_000_000) - 1 : 0] r_counter_reg, r_counter_next;
    reg r_clk_reg, r_clk_next;

    assign o_clk = r_clk_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter_reg <= 0;
            r_clk_reg <= 1'b0;
        end else begin
            r_counter_reg <= r_counter_next;
            r_clk_reg <= r_clk_next;
        end
    end

    always @(*) begin

        r_clk_next = r_clk_reg;
        r_counter_next = r_counter_reg;
        if (r_counter_reg == 1_000_000 - 1) begin
            r_counter_next = 0;
            r_clk_next = 1'b1;
        end else begin
            r_counter_next = r_counter_reg + 1;
            r_clk_next = 1'b0;
        end
    end
endmodule

module time_clock_counter_for_clock #(
    parameter TIME_MAX = 60,
    BIT_WIDTH = 7
) (
    input                    clk,
    input                    reset,
    input                    button,
    input                    sw_clock_stopwatch,
    input                    i_time_tick,
    output                   o_time_tick,
    output [BIT_WIDTH - 1:0] o_time
);

    reg [$clog2(TIME_MAX) - 1:0] time_counter_reg, time_counter_next;
    reg time_tick_reg, time_tick_next;

    assign o_time = time_counter_reg;
    assign o_time_tick = time_tick_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            time_counter_reg <= 0;
            time_tick_reg    <= 0;
        end else begin
            time_tick_reg    <= time_tick_next;
            time_counter_reg <= time_counter_next;
        end
    end

    always @(*) begin
        time_counter_next = time_counter_reg;
        time_tick_next = 1'b0;
        if (i_time_tick) begin
            if (time_counter_reg == TIME_MAX - 1) begin
                time_counter_next = 0;
                time_tick_next    = 1'b1;
            end else begin
                time_tick_next    = 1'b0;
                time_counter_next = time_counter_reg + 1;
            end
        end
        if (button & sw_clock_stopwatch == 1'b0) begin
            time_counter_next = (time_counter_reg + 1) % 60;
        end
    end
endmodule

