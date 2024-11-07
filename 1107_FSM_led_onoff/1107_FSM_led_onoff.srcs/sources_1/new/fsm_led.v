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
    input            clk,
    input            reset,
    input      [2:0] switch,
    output reg [1:0] led
    //output led
);
    parameter LED_00 = 2'b00, LED_01 = 2'b01, LED_10 = 2'b10, LED_11 = 2'b11;  // like #define on C

    reg [1:0] state;
    reg [1:0] state_next;

    //state registor
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_00;
        end else begin
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin  // detect all input
        case (state)
            LED_00: begin
                if (switch == 3'b001) begin
                    state_next = LED_01;
                end else if (switch == 3'b101) begin
                    state_next = LED_10;
                end else if (switch == 3'b100) begin
                    state_next = LED_11;
                end else begin
                    state_next = LED_00;
                end
            end
            LED_01: begin
                if (switch == 3'b011) begin
                    state_next = LED_10;
                end else if (switch == 3'b000) begin
                    state_next = LED_00;
                end else begin
                    state_next = LED_01;
                end
            end
            LED_10: begin
                if (switch == 3'b010) begin
                    state_next = LED_11;
                end else if (switch == 3'b111) begin
                    state_next = LED_01;
                end else begin
                    state_next = LED_10;
                end
            end
            LED_11: begin
                if (switch == 3'b000) begin
                    state_next = LED_00;
                end else if (switch == 3'b111) begin
                    state_next = LED_01;
                end else if (switch == 3'b110) begin
                    state_next = LED_10;
                end else begin
                    state_next = LED_11;
                end
            end
            default: state_next = state;
        endcase
    end

    // output combinational logic
    always @(*) begin
        case (state)
            LED_00: led = 2'b00;
            LED_01: led = 2'b01;
            LED_10: led = 2'b10;
            LED_11: led = 2'b11;
        endcase
    end

    // assign led = (state == LED_ON) ? 1'b1 : 1'b0;
endmodule
