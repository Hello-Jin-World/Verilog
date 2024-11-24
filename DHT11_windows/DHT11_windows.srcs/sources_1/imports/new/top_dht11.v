`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 02:21:25 PM
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
    input        clk,
    input        reset,
    inout        ioport,
    input        sw_mode,
    // output tx
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire wr_en, tx_busy, tx_start;
    wire [7:0] r_data;
    wire [7:0] int_hum;
    wire [7:0] dec_hum;
    wire [7:0] int_tem;
    wire [7:0] dec_tem;

    dht11_control U_dht11_control (
        .clk(clk),
        .reset(reset),
        .ioport(ioport),
        .wr_en(wr_en),
        .int_hum(int_hum),
        .dec_hum(dec_hum),
        .int_tem(int_tem),
        .dec_tem(dec_tem)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .u_command(),
        .msec(dec_hum),
        .sec(int_hum),
        .min(dec_tem),
        .hour(int_tem),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );

    // fifo U_fifo (
    //     .clk  (clk),
    //     .reset(reset),
    //     .wdata(w_data),
    //     .wr_en(wr_en),
    //     .rd_en(~tx_busy),
    //     .rdata(r_data),
    //     .full (),
    //     .empty(tx_start)
    // );

    // uart U_uart (
    //     .clk(clk),
    //     .reset(reset),
    //     .tx_start(~tx_start),
    //     .tx_data(8'h30),
    //     .tx(tx),
    //     .tx_busy(tx_busy),
    //     .tx_done(),
    //     .rx(),
    //     .rx_data(),
    //     .rx_done()
    // );
endmodule
