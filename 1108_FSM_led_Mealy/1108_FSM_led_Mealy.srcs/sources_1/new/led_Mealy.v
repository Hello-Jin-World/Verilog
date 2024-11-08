`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 09:54:06
// Design Name: 
// Module Name: led_Mealy
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


module led_Mealy (
    input      clk,
    input      reset,
    input      switch,
    output reg led
);
    parameter LED_OFF = 2'b00, LED_ON_1 = 2'b01, LED_ON_2 = 2'b10, LED_ON_3 = 2'b11;
    reg [1:0] state, state_next;

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_OFF;
        end else begin
            state <= state_next;
        end
    end

    // next state combinational logic
    always @(*) begin
        state_next = LED_OFF;  // default
        case (state)
            LED_OFF: begin
                if (switch == 1'b1) state_next = LED_ON_1;
            end
            LED_ON_1: begin
                if (switch == 1'b0) state_next = LED_ON_2;
            end
            LED_ON_2: begin
                if (switch == 1'b1) state_next = LED_OFF;
            end
        endcase
    end

    // output combinational logic
    always @(*) begin
        led = 1'b0;
        case (state)
            LED_OFF: begin
                //            led = 1'b0; // Moore Machine
                if (switch == 1'b1) begin
                    led = 1'b1;  // Mealy Machine
                end else begin
                    led = 1'b0;
                end
            end
            LED_ON_1: begin
                //            led = 1'b1; // Moore Machine
                if (switch == 1'b0) begin
                    led = 1'b0;  // Mealy Machine
                end else begin
                    led = 1'b1;
                end
            end
            LED_ON_2: begin
                //            led = 1'b1; // Moore Machine
                if (switch == 1'b1) begin
                    led = 1'b0;  // Mealy Machine
                end else begin
                    led = 1'b1;
                end
            end
        endcase
    end
endmodule
