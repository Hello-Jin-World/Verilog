`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 14:14:58
// Design Name: 
// Module Name: led_sw
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

module led_sw (
    input  [2:0] switch,
    input        clk,
    input        reset,
    output [1:0] led
);
    reg [1:0] r_led;

    assign led = r_led;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_led <= 2'b10;
        end else begin
            if (switch == 3'b001 & r_led == 2'b10) begin
                r_led <= 2'b01;
            end else if (switch == 3'b011 & r_led == 2'b01) begin
                r_led <= 2'b11;
            end else if (switch == 3'b111 & r_led == 2'b11) begin
                r_led <= 2'b10;
            end else if (switch == 3'b110 & r_led == 2'b10) begin
                r_led <= 2'b11;
            end else begin
                r_led <= r_led;
            end
        end
    end
endmodule
