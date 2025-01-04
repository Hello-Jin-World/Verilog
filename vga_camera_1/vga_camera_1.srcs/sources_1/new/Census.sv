`timescale 1ns / 1ps

// This census transform takes the output of line buffers, and performs the
// census transform over a window of pixels, as produced by the lib/line_buffer.
// The census transform is defined for each pixel in the window as:
//   if (current_pixel > center_pixel) then 1 else 0
// It acts as a "signature" for the window that's independent of absolute
// differences between cameras, and is significantly smaller.
//
// It's parameterized in a few ways:
//   WIDTH:         Word size
//   WINDOW_WIDTH:  Width of the window
//   WINDOW_HEIGHT: Height of the window
module Census #(
    parameter WIDTH = 1,
    parameter WINDOW_WIDTH = 2,
    parameter WINDOW_HEIGHT = 2
) (
    input wire clk,
    input wire rst,

    input wire [WIDTH*WINDOW_WIDTH*WINDOW_HEIGHT-1:0] inp,
    output wire [WINDOW_WIDTH*WINDOW_HEIGHT-1:0] outp
);

    localparam INP_WIDTH = WIDTH * WINDOW_WIDTH * WINDOW_HEIGHT;
    localparam CENTER = (WINDOW_WIDTH * WINDOW_HEIGHT - 1) / 2;

    wire [WINDOW_WIDTH*WINDOW_HEIGHT-1:0] outp_next;

    wire [WIDTH-1:0] word[WINDOW_WIDTH*WINDOW_HEIGHT];

    dff #(
        .WIDTH(WINDOW_WIDTH * WINDOW_HEIGHT)
    ) out_ff (
        clk,
        rst,
        outp_next,
        outp
    );

    // Unpack the individual words
    genvar i;
    generate
        for (i = 0; i < WINDOW_WIDTH * WINDOW_HEIGHT; i++) begin
            assign word[i] = inp[(INP_WIDTH-WIDTH*i-1):(INP_WIDTH-WIDTH*(i+1))];
        end
    endgenerate


    // Compute the census transform.
    genvar j;
    generate
        for (j = 0; j < WINDOW_WIDTH * WINDOW_HEIGHT; j++) begin
            if (j == CENTER) begin
                assign outp_next[j] = 0;
            end else begin
                assign outp_next[j] = word[j] > word[CENTER];
            end
        end
    endgenerate

endmodule
