`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/11 16:06:23
// Design Name: 
// Module Name: stopwatch_control_unit
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


module stopwatch_control_unit (
    input      clk,
    input      reset,
    input      btn_run_stop,
    input      btn_clear,
    output reg run,
    output reg clear
);

    localparam STOP = 2'b00, RUN = 2'b01, CLEAR = 2'b10; // operate in only control_unit
    reg [1:0] state, state_next;

    // state register
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
                if (btn_run_stop == 1'b1) begin
                    state_next = RUN;
                end else if (btn_clear == 1'b1) begin
                    state_next = CLEAR;
                end
            end
            RUN: begin
                if (btn_run_stop == 1'b1) begin
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
        run   = 1'b0;
        clear = 1'b0;
        case (state)
            STOP: begin
                run   = 1'b0;
                clear = 1'b0;
            end
            RUN: begin
                run   = 1'b1;
                clear = 1'b0;
            end
            CLEAR: begin
                run   = 1'b0;
                clear = 1'b1;
            end
        endcase
    end
endmodule
