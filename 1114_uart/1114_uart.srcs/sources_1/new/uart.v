`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 13:11:45
// Design Name: 
// Module Name: uart
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


module uart (
    input        clk,
    input        reset,
    input        start,
    input  [7:0] data,
    output [7:0] out_data
);

    wire w_tick, w_out_data;

    clk_div_9600 U_clk_div_9600 (
        .clk(clk),
        .reset(reset),
        .tick_9600(w_tick)
    );

    tx_module U_tx_module (
        .tick (w_tick),
        .data (data),
        .start(start),
        .o_bit(w_out_data)
    );

    rx_module U_rx_module (
        .receive_data(w_out_data),
        .start(start),
        .tick(w_tick),
        .o_receive_data(out_data)
    );
endmodule

module clk_div_9600 (
    input  clk,
    input  reset,
    output tick_9600
);

    reg r_tick, r_tick_next;

    reg [$clog2(10416) - 1 : 0] r_counter, r_counter_next;

    assign tick_9600 = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_counter_next <= 0;
        end else begin
            r_counter <= r_counter_next;
            r_tick <= r_tick_next;
        end
    end

    always @(*) begin
        r_counter_next = r_counter;
        r_tick_next = 1'b0;
        if (r_counter == 10416 - 1) begin
            r_counter_next = 0;
            r_tick_next = 1'b1;
        end else begin
            r_counter_next = r_counter + 1;
            r_tick_next = 1'b0;
        end
    end


endmodule
