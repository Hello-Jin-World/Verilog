`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 09:44:59
// Design Name: 
// Module Name: uart_fifo_loopback
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


module uart_fifo_loopback (
    input  clk,
    input  reset,
    input  rx,
    output tx
);

    wire       tx_start;
    wire [7:0] loop_data0;
    wire [7:0] loop_data1;
    wire [7:0] loop_data2;
    wire       tx_busy;
    wire       rx_done;
    wire       rx_fifo_empty;
    wire       tx_fifo_full;


    uart U_uart (
        .clk(clk),
        .reset(reset),
        .tx_start(~tx_start),
        .tx_data(loop_data2),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(),
        .rx(rx),
        .rx_data(loop_data0),
        .rx_done(rx_done)
    );


    fifo U_TX_fifo (
        .clk  (clk),
        .reset(reset),
        .wdata(loop_data1),
        .wr_en(~rx_fifo_empty),
        .rd_en(~tx_busy),
        .rdata(loop_data2),
        .full (tx_fifo_full),
        .empty(tx_start)
    );

    ila_0 your_instance_name (
        .clk(clk),  // input wire clk


        .probe0(tx),  // input wire [0:0]  tx
        .probe1(rx),  // input wire [0:0]  rx
        .probe2(tx_fifo_full),  // input wire [0:0] tx_start 
        .probe3(rx_fifo_empty),  // input wire [0:0]  rx_done
        .probe4(loop_data2),  // input wire [7:0]  tx_data
        .probe5(loop_data1)  // input wire [7:0] rx_data 
    );

    fifo U_RX_fifo (
        .clk  (clk),
        .reset(reset),
        .wdata(loop_data0),
        .wr_en(rx_done),
        .rd_en(~tx_fifo_full),
        .rdata(loop_data1),
        .full (),
        .empty(rx_fifo_empty)
    );
endmodule
