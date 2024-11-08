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
    wire w_tick, w_run_stop, w_clear;
    wire [13:0] w_counter;

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
        .counter(w_counter)
    );
    //////////////
    control_unit U_control_unit (
        .clk(clk),
        .reset(reset),
        .i_run_stop(run_stop),
        .i_clear(clear),
        .o_run_stop(w_run_stop),
        .o_clear(w_clear)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .bcddata(w_counter),
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
    output [13:0] counter
);
    reg [13:0] counter_reg, counter_next;

    // output logic
    assign counter = counter_reg;

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    // next combinational logic
    always @(*) begin
        counter_next = counter_reg;  // prediction useless latch
        if (clear == 1'b1) begin
            counter_next = 0;
        end else if (tick == 1'b1) begin
            if (counter_reg == 10_000 - 1) begin
                counter_next = 0;
            end else if (run_stop == 1'b1) begin
                counter_next = counter_reg + 1;
            end
        end
    end

endmodule

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
    reg r_button_state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= STOP;
            r_button_state <= 1'b0;
        end else begin
            r_button_state <= r_button_state;
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin
        state_next = state;
        /*
        if (i_clear == 1'b1 & state == STOP) begin
            state_next = CLEAR;
        end else begin
            if (i_run_stop == 1'b1) begin
                if (state == STOP & r_button_state == 1'b0) begin
                    r_button_state = 1'b1;
                    state_next = RUN;
                end else if (state == RUN & r_button_state == 1'b1) begin
                    r_button_state = 1'b0;
                    state_next = STOP;
                end
            end
        end
        */
        r_button_state = 1'b0;
        case (state)
            STOP: begin
                if (i_run_stop == 1'b1 & r_button_state == 1'b0) begin
                    state_next = RUN;
                    r_button_state = 1'b1;
                end
                else if (i_clear == 1'b1) state_next = CLEAR;
            end
            RUN: begin
                if (i_run_stop == 1'b1) begin
                    state_next = STOP;
                    r_button_state = 1'b0;
                end
            end
            CLEAR: begin
                if (i_clear == 1'b0) state_next = STOP;
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
        /*
        case (r_button_state)
            1'b0 : begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
            end
            1'b1 : begin
                o_run_stop = 1'b1;
                o_clear = 1'b0;
            end
        endcase
        */
    end
endmodule
