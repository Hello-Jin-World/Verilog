`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 15:27:50
// Design Name: 
// Module Name: fsm_led
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


module fsm_led (
    input  clk,
    input  reset,
    input  switch,
    output reg led
    //output led
);
    parameter LED_OFF = 1'b0, LED_ON = 1'b1;  // like #define on C

    reg state, state_next;

    //state registor
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_OFF;
        end else begin
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin  // detect all input
        case (state)
            LED_OFF: begin
                //led = 1'b0;
                if (switch == 1'b1) begin
                    state_next = LED_ON;
                end else begin
                    state_next = LED_OFF;
                end
            end
            1'b1: begin
                //led = 1'b1;
                if (switch == 1'b0) begin
                    state_next = LED_OFF;
                end else begin
                    state_next = LED_ON;
                end
            end
            default: state_next = state;
        endcase
    end

    // output combinational logic
    always @(*) begin
        case (state)
            1'b0: led = 1'b0;
            1'b1: led = 1'b1;
        endcase
    end

    // assign led = (state == LED_ON) ? 1'b1 : 1'b0;
endmodule
