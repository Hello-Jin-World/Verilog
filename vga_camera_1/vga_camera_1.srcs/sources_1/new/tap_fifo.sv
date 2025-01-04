`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/30 10:51:51
// Design Name: 
// Module Name: tap_fifo
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



module tapped_fifo #(
    parameter WIDTH = 1,
    parameter DEPTH = 1
) (
    input wire clk,
    input wire rst,

    input wire [WIDTH-1:0] inp,
    output wire [WIDTH*DEPTH-1:0] taps,
    output wire [WIDTH-1:0] outp
);

    reg [WIDTH-1:0] regs[DEPTH];

    assign outp = regs[DEPTH-1];

    dff #(WIDTH) sr0 (
        clk,
        rst,
        inp,
        regs[0]
    );

    assign taps[(WIDTH*DEPTH-1):(WIDTH*(DEPTH-1))] = regs[0];

    genvar i;
    generate
        for (i = 0; i < DEPTH - 1; i++) begin : shift
            dff #(WIDTH) sr (
                clk,
                rst,
                regs[i],
                regs[i+1]
            );
            assign taps[((WIDTH*DEPTH-1)-(WIDTH*(i+1))):(WIDTH*(DEPTH-(i+2)))] = 
        regs[i+1];
        end
    endgenerate

endmodule

