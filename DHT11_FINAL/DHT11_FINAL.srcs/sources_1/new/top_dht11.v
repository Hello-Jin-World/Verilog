`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 16:34:30
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
    output       tx,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire wr_en, tx_busy, tx_start, fifo_en, tx_done;
    wire [7:0] r_data;
    wire [7:0] hum_int;
    wire [7:0] hum_dec;
    wire [7:0] tem_int;
    wire [7:0] tem_dec;
    wire [7:0] fifo_data;

    DHT11_control U_dht11_control (
        .clk(clk),
        .reset(reset),
        .ioport(ioport),
        .wr_en(wr_en),
        .hum_int(hum_int),
        .hum_dec(hum_dec),
        .tem_int(tem_int),
        .tem_dec(tem_dec)
    );

    fnd_controller U_fnd_controller (
        .clk      (clk),
        .reset    (reset),
        .sw_mode  (sw_mode),
        .u_command(),
        .msec     (hum_dec),
        .sec      (hum_int),
        .min      (tem_dec),
        .hour     (tem_int),
        .fndcom   (fndcom),
        .fndfont  (fndfont)
    );

    fifo_data U_fifo_data (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .hum_int(hum_int),
        .hum_dec(hum_dec),
        .tem_int(tem_int),
        .tem_dec(tem_dec),
        .fifo_en(fifo_en),
        .fifo_data(fifo_data)
    );


    fifo U_Tx_fifo (
        .clk  (clk),
        .reset(reset),
        .wdata(fifo_data),
        .wr_en(fifo_en),
        .rd_en(~tx_busy),
        .rdata(r_data),
        .full (),
        .empty(tx_start)
    );

    uart U_uart (
        .clk     (clk),
        .reset   (reset),
        .tx_start(~tx_start),
        .tx_data (r_data),
        .tx      (tx),
        .tx_busy (tx_busy),
        .tx_done (tx_done),
        .rx      (),
        .rx_data (),
        .rx_done ()
    );
endmodule

