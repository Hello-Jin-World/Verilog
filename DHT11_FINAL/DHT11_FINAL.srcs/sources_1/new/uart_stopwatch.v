`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 21:23:28
// Design Name: 
// Module Name: uart_stopwatch
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


module uart_stopwatch(
    input        clk,
    input        reset,
    input        rx,
    input        sw_mode,
    input        run_stop,
    input        clear,
    output       tx,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire [7:0] w_loopdata;
    wire w_rx_done;

    uart U_uart (
        .clk(clk),
        .reset(reset),
        // UART Tx
        .tx_start(w_rx_done),
        .tx_data(w_loopdata),
        .tx(tx),
        .tx_busy(),
        .tx_done(),
        // UART Rx
        .rx(rx),
        .rx_data(w_loopdata),
        .rx_done(w_rx_done)
    );

    top_stopwatch U_top_stopwatch (
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode),
        .btn_run_stop(run_stop),
        .btn_clear(clear),
        .u_command(w_loopdata),
        .rx_done(w_rx_done),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );


endmodule
