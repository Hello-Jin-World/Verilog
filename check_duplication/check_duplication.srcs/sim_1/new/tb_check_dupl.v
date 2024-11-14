`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 10:07:33
// Design Name: 
// Module Name: tb_check_dupl
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


module tb_check_dupl ();

    reg [7:0] in_bit;
    wire [7:0] out_bit;

    check_dupl U_check_dupl (
        .in_bit(in_bit),
        .out_bit(out_bit)
    );

    initial begin
        in_bit = 8'b01110001;
    end
endmodule
