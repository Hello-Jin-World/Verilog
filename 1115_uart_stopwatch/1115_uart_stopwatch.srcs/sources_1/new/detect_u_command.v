`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 16:57:11
// Design Name: 
// Module Name: detect_u_command
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


module detect_u_command (
    input [7:0] u_command,
    output reg run_stop,
    output reg clear,
    output reg sw_mode
);

    always @(*) begin
        if (u_command == "r") begin
            run_stop = 1'b1;
        end else if (u_command == "s") begin
            run_stop = 1'b0;
        end else if (u_command == "c") begin
            clear = 1'b1;
        end else if (u_command == "m") begin
            sw_mode = ~sw_mode;
        end
    end
endmodule
