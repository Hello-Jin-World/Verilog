`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 16:06:00
// Design Name: 
// Module Name: button_detector
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


module button_detector(
    input  clk,
    input  reset,
    input  i_btn,
    output o_btn
    );
    reg [$clog2(100000) - 1 : 0] r_counter;
    reg r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_tick <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick <= 1'b0;
            end
        end
    end

    localparam N = 7;
    reg [N : 0] q_reg, q_next;
    wire w_debounce;

    always @(posedge clk, posedge reset) begin
        if (reset) q_reg <= 0;
        else q_reg <= q_next;
    end

    always @(i_btn, q_reg) begin
        q_next = {i_btn, q_reg[N : 1]};  // general shift
    end

    assign w_debounce = &q_reg; // & -> all

endmodule
