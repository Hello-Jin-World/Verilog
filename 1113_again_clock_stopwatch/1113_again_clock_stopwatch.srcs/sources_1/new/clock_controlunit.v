`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 14:04:34
// Design Name: 
// Module Name: clock_controlunit
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


module clock_controlunit (
    input      sec_btn,
    input      min_btn,
    input      hour_btn,
    input      chipselect,
    output reg o_sec_btn,
    output reg o_min_btn,
    output reg o_hour_btn
);

    always @(*) begin
        o_sec_btn = 0;
        o_min_btn = 0;
        o_hour_btn = 0;
        if (!chipselect && sec_btn) begin
            o_sec_btn = 1'b1;
        end else begin
            o_sec_btn = 1'b0;
        end
        if (!chipselect && min_btn) begin
            o_min_btn = 1'b1;
        end else begin
            o_min_btn = 1'b0;
        end
        if (!chipselect && hour_btn) begin
            o_hour_btn = 1'b1;
        end else begin
            o_hour_btn = 1'b0;
        end
    end

endmodule
