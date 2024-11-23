`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 15:28:40
// Design Name: 
// Module Name: top_dht11
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


module top_dht11 (
    input  clk,
    input  reset,
    inout  ioport,
    output tx
);

    wire wr_en, tx_busy, tx_start;
    wire [39:0] w_data;
    wire [ 7:0] r_data;

    dht11_control_unit U_dht11_control_unit (
        .clk(clk),
        .reset(reset),
        .ioport(io_port),
        .wr_en(wr_en),
        .tem_hum_data(w_data)
    );

    fifo U_fifo (
        .clk  (clk),
        .reset(reset),
        .wdata(w_data),
        .wr_en(wr_en),
        .rd_en(~tx_busy),
        .rdata(r_data),
        .full (),
        .empty(tx_start)
    );

    uart U_uart (
        .clk  (clk),
        .reset(reset),
        .tx_start(~tx_start),
        .tx_data(r_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(),
        .rx(),
        .rx_data(),
        .rx_done()
    );
endmodule
