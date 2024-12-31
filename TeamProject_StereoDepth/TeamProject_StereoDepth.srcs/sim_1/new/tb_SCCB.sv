`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/31 09:45:06
// Design Name: 
// Module Name: tb_SCCB
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


module tb_SCCB ();
    logic clk;
    logic reset;
    wire  SDA;
    logic SCL;
    logic mode;
    logic SDA_out;

    assign SDA = !mode ? SDA_out : 1'bz;

    SCCB dut (
        .clk  (clk),
        .reset(reset),
        .SDA  (SDA),
        .SCL  (SCL)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        mode = 1;
        SDA_out = 0;
        #10;
        reset = 0;
        repeat (8) @(posedge SCL);
        @(negedge SCL);
        mode = 0;
        repeat (2) @(posedge SCL);
        mode = 1;
    end

endmodule
