`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 10:53:47
// Design Name: 
// Module Name: counter_10000
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


module counter_10000 (
    input clk,
    input reset,
    input run_stop,
    input clear,
    output [3:0] fndcom,
    output [7:0] fndfont
);
    wire w_tick, w_run_stop, w_clear, w_btn_run__stop, w_btn_clear;
    wire [9:0] w_counter_sec;
    wire [3:0] w_counter_min;


    button_detector U_Btn_RunStop (
        .clk  (clk),
        .reset(reset),
        .i_btn(run_stop),
        .o_btn(w_btn_run__stop)
    );

    button_detector U_Btn_Clear (
        .clk  (clk),
        .reset(reset),
        .i_btn(clear),
        .o_btn(w_btn_clear)
    );

    ///data path///
    clock_div U_clock_div (
        .clk(clk),
        .reset(reset),
        .run_stop(w_run_stop),
        .clear(w_clear),
        .tick(w_tick)
    );

    counter_tick U_counter_tick (
        .clk(clk),
        .reset(reset),
        .run_stop(w_run_stop),
        .clear(w_clear),
        .tick(w_tick),
        //.min_signal(w_min_signal),
        .counter_sec(w_counter_sec), // sec
        .counter_min(w_counter_min)
    );
/*
    counter_tick_min U_counter_tick_min(
    .clk(clk),
    .reset(reset),
    .min_signal(w_min_signal),
    .run_stop(w_run_stop),
    .clear(w_clear),
    .min_counter(w_min) // min
);*/
    //////////////
    control_unit U_control_unit (
        .clk(clk),
        .reset(reset),
        .i_run_stop(w_btn_run__stop),
        .i_clear(w_btn_clear),
        .o_run_stop(w_run_stop),
        .o_clear(w_clear)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .bcddata({w_counter_min, w_counter_sec}),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );
endmodule

module clock_div (
    input  clk,
    input  reset,
    input  run_stop,
    input  clear,
    output tick
);
    reg [$clog2(10_000_000) - 1 : 0] r_counter;  // auto calculate bit (log2)
    reg r_tick;

    assign tick = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick <= 1'b0;
        end else begin
            r_counter <= r_counter;
            r_tick <= r_tick;

            if (clear == 1'b1) begin
                r_counter <= 0;
                r_tick <= 1'b0;
            end else if (r_counter == 10_000_000 - 1) begin
                r_counter <= 0;
                r_tick <= 1'b1;
            end else if (run_stop == 1'b1) begin
                r_counter <= r_counter + 1;
                r_tick <= 1'b0;
            end
        end
    end

endmodule

module counter_tick (
    input clk,
    input reset,
    input tick,
    input run_stop,
    input clear,
    //output min_signal,
    output [9:0] counter_sec,
    output [3:0] counter_min
);
    reg [9:0] counter_reg, counter_next;
    reg [3:0] min_reg, min_next;
    // output logic
    assign counter_sec = counter_reg;
    //assign min_signal = r_min_tick;
    assign counter_min = min_reg;

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
            min_reg <= 0;
            //r_min_tick <= 0;
        end else begin
            counter_reg <= counter_next;
            min_reg <= min_next;
            //r_min_tick <= 1'b0;
        end
    end

    // next combinational logic
    always @(*) begin
        counter_next = counter_reg;  // prediction useless latch
        min_next = min_reg;
        if (clear == 1'b1) begin
            counter_next = 0;
            min_next = 0;
        end else if (tick == 1'b1) begin
            if (counter_reg == 600 - 1) begin
                //r_min_tick = 1'b1;
                counter_next = 0;
                min_next = min_reg + 1;
            end else if (run_stop == 1'b1) begin
                counter_next = counter_reg + 1;
            end
        end
    end

endmodule

/*
module counter_tick_min (
    input clk,
    input reset,
    input min_signal,
    input run_stop,
    input clear,
    output [3:0] min_counter
);

    reg [3:0] r_min_counter, r_min_counter_next;

    assign min_counter = r_min_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_min_counter <= 0;
        end else begin
            r_min_counter <= r_min_counter_next;
        end
  end

    always @(*) begin
    r_min_counter_next = r_min_counter;
        if (clear == 1'b1) begin
            r_min_counter_next = 0;
        end else if (min_signal == 1'b1) begin
            if (r_min_counter == 10 - 1) begin
                r_min_counter_next = 0;
            end else if (run_stop == 1) begin
                r_min_counter_next = r_min_counter + 1;
            end
        end
  end

endmodule*/

module control_unit (
    input      clk,
    input      reset,
    input      i_run_stop,
    input      i_clear,
    output reg o_run_stop,
    output reg o_clear
);
    parameter STOP = 2'b00, RUN = 2'b01, CLEAR = 2'b10;

    reg [1:0] state, state_next;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= STOP;
        end else begin
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            STOP: begin
                if (i_run_stop == 1'b1) begin
                    state_next = RUN;
                end else if (i_clear == 1'b1) state_next = CLEAR;
            end
            RUN: begin
                if (i_run_stop == 1'b1) begin
                    state_next = STOP;
                end
            end
            CLEAR: begin
                state_next = STOP;
            end
        endcase
    end

    // output combinational logic
    always @(*) begin
        o_run_stop = 1'b0;
        o_clear = 1'b0;
        case (state)
            STOP: begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
            end
            RUN: begin
                o_run_stop = 1'b1;
                o_clear = 1'b0;
            end
            CLEAR: begin
                o_clear = 1'b1;
            end
        endcase
    end
endmodule
