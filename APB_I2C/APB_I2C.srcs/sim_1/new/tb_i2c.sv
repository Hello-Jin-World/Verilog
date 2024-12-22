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


// module tb_i2c ();
//     logic       clk;
//     logic       reset;
//     logic [7:0] wData;
//     logic [7:0] addrwe;
//     logic       start;
//     logic       write;
//     logic       SDA_in;
//     wire        SDA;
//     logic       SCL;

//     assign SDA = (write == 0) ? SDA_in : 1'bz;

//     MASTER dut (
//         .clk   (clk),
//         .reset (reset),
//         .wData (wData),
//         .addrwe(addrwe),
//         .start (start),
//         .write (write),
//         .SDA   (SDA),
//         .SCL   (SCL)
//     );

//     always #5 clk = ~clk;

//     initial begin
//         clk = 0;
//         reset = 1;
//         start = 0;
//         addrwe = 8'b01001111;
//         wData = 8'h55;
//         SDA_in = 0;
//         #5;
//         reset = 0;
//         #5;
//         start = 1;
//         #5;
//         start = 0;
//         wait (write == 0);
//         #5;
//     end
// endmodule
