`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 09:55:48
// Design Name: 
// Module Name: check_dupl
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


module check_dupl (
    input  [7:0] in_bit,
    output [7:0] out_bit
);

    reg [7:0] r_outbit;

    assign out_bit = r_outbit;

    integer i;


    always @(*) begin
        r_outbit = 0;
        for (i = 7; i > 0; i = i - 1) begin
            if (in_bit[i] == in_bit[i-1]) begin
                r_outbit[i-1] <= 1;
            end else begin
                r_outbit[i-1] <= 0;
            end
        end
    end
endmodule
