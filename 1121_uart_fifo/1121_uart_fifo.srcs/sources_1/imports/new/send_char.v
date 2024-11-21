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
    input  clk,
    input  reset,
    input  rx,
    output tx
);

    wire [7:0] w_loopdata0, w_loopdata1, w_loopdata2;
    wire w_rx_done, w_empty, w_empty1;

    reg rd_en_reg, rd_en_next;

    uart U_uart (
        .clk(clk),
        .reset(reset),
        // UART Tx
        .tx_start(w_rx_done),
        .tx_data(w_loopdata2),
        .tx(tx),
        .tx_busy(w_tx_busy),
        .tx_done(),
        // UART Rx
        .rx(rx),
        .rx_data(w_loopdata0),
        .rx_done(w_rx_done)
    );
    fifo U_fifo1 (
        .clk  (clk),
        .reset(reset),
        .wdata(w_loopdata0),
        .wr_en(w_rx_done),
        .rd_en(~w_empty),
        .rdata(w_loopdata1),
        .full (),
        .empty(w_empty)
    );
    fifo U_fifo2 (
        .clk  (clk),
        .reset(reset),
        .wdata(w_loopdata1),
        .wr_en(~w_empty),
        .rd_en(rd_en_reg),
        .rdata(w_loopdata2),
        .full (),
        .empty(w_empty1)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            rd_en_reg <= 0;
        end else begin
            rd_en_reg <= rd_en_next;
        end
    end

    always @(*) begin
        rd_en_next = 0;
        if (~w_empty1 && ~w_tx_busy) begin
            rd_en_next = 1'b1;
        end
    end
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
