`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 15:21:00
// Design Name: 
// Module Name: ram
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


module ram (
    input            clk,
    input      [9:0] address,
    input      [7:0] w_data,
    input            rw,
    output reg [7:0] r_data
);

    reg [7:0] mem[0:1023];

    always @(posedge clk) begin
        case (rw)
            1'b0: begin
                r_data <= mem[address];
            end
            1'b1: begin
                mem[address] <= w_data;
            end
        endcase
    end
endmodule
