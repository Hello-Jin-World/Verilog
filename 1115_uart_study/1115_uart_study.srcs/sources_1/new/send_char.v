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
