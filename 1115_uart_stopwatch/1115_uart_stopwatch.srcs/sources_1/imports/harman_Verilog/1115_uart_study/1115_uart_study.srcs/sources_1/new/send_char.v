`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 11:44:12
// Design Name: 
// Module Name: send_char
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


module uart_loopback (
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



/*
module send_char (
    input  clk,
    input  reset,
    input  btn,
    output tx
);

    wire w_btn;

    reg [7:0] send_data_reg, send_data_next;

    button_detector U_button_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn),
        .o_btn(w_btn)
    );

    uart U_uart (
        .clk     (clk),
        .reset   (reset),
        .tx_start(w_btn),
        .tx_data (send_data_reg),
        .tx      (tx),
        .tx_done ()
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            send_data_reg <= 8'h30;  // ascii '0'
        end else begin
            send_data_reg <= send_data_next;
        end
    end

    always @(*) begin
        send_data_next = send_data_reg;
        if (w_btn) begin
            if (send_data_reg == "z") begin
                send_data_next = "0";
            end else begin
                send_data_next = send_data_reg + 1;
            end
        end
    end
endmodule
*/
