`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 11:19:30
// Design Name: 
// Module Name: tb_uart
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


module tb_uart ();

    reg        clk;
    reg        reset;
    reg        tx_start;
    reg  [7:0] tx_data;
    wire       tx;
    wire       tx_done;

    uart dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin
        #00 clk = 1'b0;
        reset = 1'b1;
        tx_start = 1'b0;
        tx_data = 0;

        #10 reset = 1'b0;

        #10 tx_data = 8'hAA;
        tx_start = 1'b1;

        #10 tx_start = 1'b0;

        @(tx_done);
        #30;

        #10 tx_data = 8'h55;
        tx_start = 1'b1;

        #10 tx_start = 1'b0;

        @(tx_done);
    end
endmodule
