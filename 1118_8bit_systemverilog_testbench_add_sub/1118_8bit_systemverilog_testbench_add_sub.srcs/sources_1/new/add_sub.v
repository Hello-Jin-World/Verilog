`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 11:35:22
// Design Name: 
// Module Name: add_sub
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


module add_sub (
    input      [7:0] a,
    input      [7:0] b,
    input            mode,
    output reg [7:0] sum,
    output reg       carry
);

    always @(*) begin
        case (mode)
            1'b0: {carry, sum} = a + b;
            1'b1: {carry, sum} = a - b;
        endcase
    end
endmodule
