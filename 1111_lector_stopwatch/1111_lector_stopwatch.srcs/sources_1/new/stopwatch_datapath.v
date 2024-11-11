`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/11 13:49:47
// Design Name: 
// Module Name: stopwatch_datapath
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


module stopwatch_datapath (
    input clk,
    input reset,
    input run,
    input clear,
    output [5:0] msec,
    output [5:0] sec,
    output [5:0] min
);

    wire w_clk_10hz, w_mil_tick, w_sec_tick;
    wire [3:0] w_msec;
    assign msec = {2'b0, w_msec};

    clk_div_stopwatch U_clk_div_stopwatch (
        .clk  (clk),
        .reset(reset),
        .run  (run),
        .clear(clear),
        .o_clk(w_clk_10hz)
    );

    time_clock_counter #(
        .TIME_MAX(10)
    ) U_time_counter_10ms (
        .clk(clk),
        .reset(reset),
        .i_time_tick(w_clk_10hz),
        .clear(clear),
        .o_time_tick(w_mil_tick),
        .o_time(w_msec)
    );


    time_clock_counter #(
        .TIME_MAX(60)
    ) U_time_counter_sec (
        .clk(clk),
        .reset(reset),
        .i_time_tick(w_mil_tick),
        .clear(clear),
        .o_time_tick(w_sec_tick),
        .o_time(sec)
    );

    time_clock_counter #(
        .TIME_MAX(60)
    ) U_time_counter_min (
        .clk(clk),
        .reset(reset),
        .i_time_tick(w_sec_tick),
        .clear(clear),
        .o_time_tick(),
        .o_time(min)
    );
endmodule


module clk_div_stopwatch (
    input  clk,
    input  reset,
    input  run,
    input  clear,
    output o_clk
);
    reg [$clog2(10) - 1 : 0] r_counter_reg, r_counter_next;
    reg r_clk_reg, r_clk_next;

    assign o_clk = r_clk_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter_reg <= 0;
            r_clk_reg <= 1'b0;
        end
        else begin
            r_counter_reg <= r_counter_next;
            r_clk_reg <= r_clk_next;
        end
    end

    always @(*) begin
        r_clk_next = r_clk_reg;
        r_counter_next = r_counter_reg;

        if (run == 1'b1) begin
            if (r_counter_reg == 10 - 1) begin
                r_counter_next = 0;
                r_clk_next = 1'b1;
            end else begin
                r_counter_next = r_counter_reg + 1;
                r_clk_next = 1'b0;
            end
        end else if (clear == 1'b1) begin
            r_counter_next = 0;
            r_clk_next = 1'b0;
        end
    end
endmodule


module time_clock_counter #(
    parameter TIME_MAX = 60
) (
    input                           clk,
    input                           reset,
    input                           i_time_tick,
    input                           clear,
    output                          o_time_tick,
    output [$clog2(TIME_MAX) - 1:0] o_time
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
        if (clear) begin
            time_counter_next = 0;
            time_tick_next    = 1'b0;
        end else if (i_time_tick) begin
            if (time_counter_reg == TIME_MAX - 1) begin
                time_counter_next = 0;
                time_tick_next    = 1'b1;
            end else begin
                time_tick_next    = 1'b0;
                time_counter_next = time_counter_reg + 1;
            end
        end
    end
endmodule
