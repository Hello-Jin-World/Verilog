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
    parameter LED_OFF = 1'b0, LED_ON = 1'b1;
    reg state, state_next;

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
        state_next = state; // default
        case (state)
            LED_OFF : begin
                if (switch == 1'b1) state_next = LED_ON;
            end
            LED_ON : begin
                if (switch == 1'b0) state_next = LED_OFF;
            end
        endcase
    end

    // output combinational logic
    always @(*) begin
       case (state)
        LED_OFF : begin
//            led = 1'b0; // Moore Machine
            if (switch == 1'b1) begin
                led = 1'b1; // Mealy Machine
            end else begin
                led = 1'b0;
            end
        end
        LED_ON : begin
//            led = 1'b1; // Moore Machine
            if (switch == 1'b0) begin
                led = 1'b0; // Mealy Machine
            end else begin
                led = 1'b1;
            end
        end  
        default: begin
            led = 1'b0;
        end 
       endcase 
    end
endmodule
