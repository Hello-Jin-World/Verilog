`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 01:38:51 AM
// Design Name: 
// Module Name: tb_i2c
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


module tb_i2c ();
    logic       clk;
    logic       reset;
    logic [7:0] addrwe;
    logic       start;
    wire        SDA;
    wire        SCL;


    I2C dut (
        .clk       (clk),
        .reset     (reset),
        .addrwe    (addrwe),
        .start     (start),
        .SDA       (SDA),
        .SCL       (SCL)
    );


    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        addrwe = 8'b01001110;
        #5;
        reset = 0;
        #5; start = 1;
    end
endmodule
