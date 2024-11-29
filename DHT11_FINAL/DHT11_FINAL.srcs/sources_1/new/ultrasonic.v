`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 19:22:08
// Design Name: 
// Module Name: ultrasonic
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

module ultrasonic_top (
    input        clk,
    input        reset,
    input        echopulse,
    input        btn_start,
    input  [3:0] string_command,
    output       trigger,
    output       measure_done,
    output [3:0] ultrasonic_1,
    output [3:0] ultrasonic_10,
    output [3:0] ultrasonic_100,
    output [3:0] ultrasonic_1000
);

    wire [13:0] w_distance;

    digit_splitter_for_ultrasonic U_digit_splitter_for_ultrasonic (
        .digit     (w_distance),
        .digit_1   (ultrasonic_1),
        .digit_10  (ultrasonic_10),
        .digit_100 (ultrasonic_100),
        .digit_1000(ultrasonic_1000)
    );


    ultrasonic U_ultrasonic (
        .clk           (clk),
        .reset         (reset),
        .echopulse     (echopulse),
        .string_command(string_command),
        .btn_start     (btn_start),
        .measure_done  (measure_done),
        .trigger       (trigger),
        .distance      (w_distance)
    );
endmodule

module ultrasonic (
    input             clk,
    input             reset,
    input             echopulse,
    input             btn_start,
    input      [ 3:0] string_command,
    output            measure_done,
    output reg        trigger,
    output reg [13:0] distance
);

    localparam IDLE = 2'b00, TRIGGER = 2'b01, ECHO = 2'b10, MEASURE = 2'b11;
    reg [1:0] state, state_next;
    reg [20:0] clk_cnt_tr_reg, clk_cnt_tr_next;
    reg [20:0] clk_cnt_echo_reg, clk_cnt_echo_next;
    reg [13:0] distance_next;
    reg trigger_next;
    reg measure_done_reg, measure_done_next;

    assign measure_done = measure_done_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state            <= IDLE;
            trigger          <= 0;
            distance         <= 0;
            clk_cnt_tr_reg   <= 0;
            clk_cnt_echo_reg <= 0;
            measure_done_reg <= 0;
        end else begin
            state            <= state_next;
            measure_done_reg <= measure_done_next;
            case (state)
                IDLE: begin
                    clk_cnt_tr_reg   <= clk_cnt_tr_next;
                    clk_cnt_echo_reg <= clk_cnt_echo_next;
                end
                TRIGGER: begin
                    if (clk_cnt_tr_reg < 1200 - 1) begin
                        trigger        <= 1'b1;
                        clk_cnt_tr_reg <= clk_cnt_tr_next;
                    end else begin
                        trigger <= 0;
                    end
                end
                ECHO: begin
                    clk_cnt_echo_reg <= clk_cnt_echo_next;
                end
                MEASURE: begin
                    distance <= distance_next;
                end
            endcase
        end
    end

    always @(*) begin
        state_next        = state;
        measure_done_next = measure_done_reg;
        case (state)
            IDLE: begin
                clk_cnt_tr_next   = 0;
                clk_cnt_echo_next = 0;
                measure_done_next = 1'b0;
                if (btn_start || string_command == 7) begin
                    state_next = TRIGGER;
                end
            end
            TRIGGER: begin
                trigger_next = 1;
                clk_cnt_tr_next = clk_cnt_tr_reg + 1;
                if (clk_cnt_tr_reg >= 1200 - 1) begin
                    trigger_next = 0;
                end
                if (echopulse) state_next = ECHO;
            end
            ECHO: begin
                clk_cnt_echo_next <= clk_cnt_echo_reg + 1;
                if (echopulse == 0) begin
                    state_next = MEASURE;
                end
            end
            MEASURE: begin
                distance_next = clk_cnt_echo_reg / 5800;
                state_next = IDLE;
                measure_done_next = 1'b1;
            end
        endcase
    end
endmodule
