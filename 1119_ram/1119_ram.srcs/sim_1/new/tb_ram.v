`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 15:41:51
// Design Name: 
// Module Name: tb_ram
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


module tb_ram ();

    reg        clk;
    reg  [9:0] address;
    reg  [7:0] w_data;
    reg        rw;
    wire [7:0] r_data;

    ram dut (
        .clk(clk),
        .address(address),
        .w_data(w_data),
        .rw(rw),
        .r_data(r_data)
    );

    always #5 clk = ~clk;

    initial begin
        #00 clk = 0;
        address = 10'b0000010011;
        w_data = 8'h55;
        rw = 1;
        #50;
        address = 10'b0011010011;
        w_data = 8'h1f;
        #50;
        address = 10'b0000010011;
        rw = 0;
        #50;
        address = 10'b0011010011;
    end
endmodule
