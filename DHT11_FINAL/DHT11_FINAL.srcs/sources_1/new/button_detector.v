`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 21:22:21
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
    reg r_clk;
    localparam N = 7;
    reg [N : 0] q_reg, q_next;
    reg edge_reg;
    wire w_debounce;

//clock devider (1khz)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end

//debounce circuit
    always @(posedge r_clk, posedge reset) begin
        if (reset) q_reg <= 0;
        else q_reg <= q_next;
    end

    always @(i_btn, q_reg) begin
        q_next = {i_btn, q_reg[N : 1]};  // general shift register code.
    end

    assign w_debounce = &q_reg; // & -> all

//edge detector
    always @(posedge clk ) begin
        edge_reg <= w_debounce; // Flip Flop
    end

    assign o_btn = w_debounce & ~edge_reg; // Rising Edge Detector

endmodule

