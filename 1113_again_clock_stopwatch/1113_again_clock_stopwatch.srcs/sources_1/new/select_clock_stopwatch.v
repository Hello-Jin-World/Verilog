`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 14:57:13
// Design Name: 
// Module Name: select_clock_stopwatch
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


module select_clock_stopwatch (
    input      [6:0] clock_msec,
    input      [6:0] clock_sec,
    input      [6:0] clock_min,
    input      [6:0] clock_hour,
    input      [6:0] stopwatch_msec,
    input      [6:0] stopwatch_sec,
    input      [6:0] stopwatch_min,
    input      [6:0] stopwatch_hour,
    input            chipselect,
    output reg [6:0] o_msec,
    output reg [6:0] o_sec,
    output reg [6:0] o_min,
    output reg [6:0] o_hour
);


    always @(*) begin
        case (chipselect)
            1'b0: begin
                o_msec = clock_msec;
                o_sec  = clock_sec;
                o_min  = clock_min;
                o_hour = clock_hour;
            end
            1'b1: begin
                o_msec = stopwatch_msec;
                o_sec  = stopwatch_sec;
                o_min  = stopwatch_min;
                o_hour = stopwatch_hour;
            end
            default: begin
                o_msec = 0;
                o_sec  = 0;
                o_min  = 0;
                o_hour = 0;
            end
        endcase
    end

endmodule
