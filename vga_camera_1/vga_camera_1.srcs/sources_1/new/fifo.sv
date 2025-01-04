`timescale 1ns / 1ps

// This is a basic flip-flip FIFO with synchronous reset.
module fifo #(
    parameter WIDTH = 1,
    parameter DEPTH = 1
) (
    input wire clk,
    input wire rst,

    input  wire [WIDTH-1:0] inp,
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

    genvar i;
    generate
        for (i = 0; i < DEPTH - 1; i++) begin : shift
            dff #(WIDTH) sr (
                clk,
                rst,
                regs[i],
                regs[i+1]
            );
        end
    endgenerate

endmodule
