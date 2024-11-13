`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 15:20:37
// Design Name: 
// Module Name: led_mode_state
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


module led_mode_state (
    input            sw_mode,
    input            sw_clock_stopwatch,
    output reg [3:0] led
);

    always @(*) begin
        led = 4'b0000;
        if (!sw_clock_stopwatch && !sw_mode) begin
            led = 4'b0001;
        end
        if (!sw_clock_stopwatch && sw_mode) begin
            led = 4'b0010;
        end
        if (sw_clock_stopwatch && !sw_mode) begin
            led = 4'b0100;
        end
        if (sw_clock_stopwatch && sw_mode) begin
            led = 4'b1000;
        end
    end

endmodule
