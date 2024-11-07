`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/06 14:22:19
// Design Name: 
// Module Name: top_up_counter
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

module top_up_counter (
    input clk,
    input reset,
    input [1:0] switch,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire w_clk_10hz;
    wire [13:0] w_counter;

    clk_div_10 U_clk_div_10 (
        .clk(clk),
        .reset(reset),
        .o_clk(w_clk_10hz)
    );

    up_counter U_up_counter (
        .clk(w_clk_10hz),
        .reset(reset),
        .switch(switch),
        .counter(w_counter)
    );

    fnd_controller U_fnd_controller (
        .clk(clk),
        .reset(reset),
        .bcddata(w_counter),
        .fndcom(fndcom),
        .fndfont(fndfont)
    );
endmodule
123
module clk_div_10 (
    input  clk,
    input  reset,
    output o_clk
);
    reg [23:0] r_counter;
    reg        r_clk;

    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk     <= 1'b0;
        end else begin
            if (r_counter == 10_000_000 - 1) begin
                r_counter <= 0;
                r_clk     <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk     <= 1'b0;
            end
        end
    end

endmodule

module up_counter (
    input clk,
    input reset,
    input [1:0] switch,
    output [13:0] counter
);

    reg [13:0] r_counter;

    assign counter = r_counter;

always @(posedge clk, posedge reset) begin
        if (reset | switch[1]) begin
            r_counter <= 0;
        end else begin
            if (r_counter == 9999) begin
                r_counter <= 0;
            end else if (switch[0]) begin
                r_counter <= r_counter + 1;
            end
        end
    end
endmodule
