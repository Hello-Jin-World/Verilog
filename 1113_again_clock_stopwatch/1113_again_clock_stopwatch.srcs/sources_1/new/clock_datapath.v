`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 14:04:04
// Design Name: 
// Module Name: clock_datapath
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
    input        sec_btn,
    input        min_btn,
    input        hour_btn,
    input        clk,
    input        reset,
    output [6:0] msec,
    output [6:0] sec,
    output [6:0] min,
    output [6:0] hour
);

    wire w_msec_tick, w_tick_for_sec, w_tick_for_min, w_tick_for_hour;

    clock_clk_div U_clock_clk_div (
        .clk(clk),
        .reset(reset),
        .msec_tick(w_msec_tick)
    );

    clock_counter_time #(
        .CLOCK_TIME_MAX (100),
        .CLOCK_BIT_WIDTH(7)
    ) U_clock_counter_msec (
        .clk(clk),
        .reset(reset),
        .i_tick(w_msec_tick),
        .o_clocktime(msec),
        .o_tick(w_tick_for_sec)
    );

    clock_counter_time #(
        .CLOCK_TIME_MAX (60),
        .CLOCK_BIT_WIDTH(7)
    ) U_clock_counter_sec (
        .clk(clk),
        .reset(reset),
        .button(sec_btn),
        .i_tick(w_tick_for_sec),
        .o_clocktime(sec),
        .o_tick(w_tick_for_min)
    );

    clock_counter_time #(
        .CLOCK_TIME_MAX (60),
        .CLOCK_BIT_WIDTH(7)
    ) U_clock_counter_min (
        .clk(clk),
        .reset(reset),
        .button(min_btn),
        .i_tick(w_tick_for_min),
        .o_clocktime(min),
        .o_tick(w_tick_for_hour)
    );

    clock_counter_time #(
        .CLOCK_TIME_MAX (24),
        .CLOCK_BIT_WIDTH(7)
    ) U_clock_counter_hour (
        .clk(clk),
        .reset(reset),
        .button(hour_btn),
        .i_tick(w_tick_for_hour),
        .o_clocktime(hour),
        .o_tick()
    );

endmodule

module clock_clk_div (
    input  clk,
    input  reset,
    output msec_tick
);

    reg r_clk, r_clk_next;
    reg [$clog2(1_000_000) - 1 : 0] r_counter, r_counter_next;

    assign msec_tick = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 0;
        end else begin
            r_counter <= r_counter_next;
            r_clk <= r_clk_next;
        end
    end

    always @(*) begin
        r_clk_next = r_clk;
        r_counter_next = r_counter;

        if (r_counter == 1_000_000 - 1) begin
            r_clk_next = 1'b1;
            r_counter_next = 0;
        end else begin
            r_clk_next = 1'b0;
            r_counter_next = r_counter + 1;
        end
    end

endmodule

module clock_counter_time #(
    parameter CLOCK_TIME_MAX = 60,
    CLOCK_BIT_WIDTH = 7
) (
    input                        clk,
    input                        reset,
    input                        i_tick,
    input                        button,
    output [CLOCK_BIT_WIDTH-1:0] o_clocktime,
    output                       o_tick
);

    reg r_tick, r_tick_next;
    reg [$clog2(CLOCK_TIME_MAX) - 1:0] r_counter, r_counter_next;

    assign o_tick = r_tick;
    assign o_clocktime = r_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_tick <= 0;
            r_counter <= 0;
        end else begin
            r_tick <= r_tick_next;
            r_counter <= r_counter_next;
        end
    end

    always @(*) begin
        r_tick_next = 1'b0; 
        r_counter_next = r_counter;
        if (i_tick) begin
            if (r_counter == CLOCK_TIME_MAX - 1) begin
                r_counter_next = 0;
                r_tick_next = 1'b1;
            end else begin
                r_tick_next = 1'b0;
                r_counter_next = r_counter + 1;
            end
        end
        if (button) begin
            r_counter_next = r_counter + 1;
        end
    end

endmodule
