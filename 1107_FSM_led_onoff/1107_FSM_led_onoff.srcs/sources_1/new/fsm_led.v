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
    output led
);

    reg state, state_next;

    //state registor
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin  // detect all input
        case (state)
            1'b0: begin
                if (switch == 1'b1) begin
                    state_next = 1'b1;
                end else begin
                    state_next = 1'b0;
                end
            end
            1'b1: begin
                if (switch == 1'b0) begin
                    state_next = 1'b0;
                end else begin
                    state_next = 1'b1;
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
endmodule
