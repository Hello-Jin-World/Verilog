`timescale 1ns / 1ps

// module dff #(
//     parameter WIDTH = 1
// ) (
//     input wire clk,
//     input wire rst,

//     input  wire [WIDTH-1:0] inp,
//     output reg  [WIDTH-1:0] outp
// );

//     always @(posedge clk) begin
//         outp <= rst ? 0 : inp;
//     end

// endmodule

module dff #(
    parameter WIDTH = 1
) (
    input  logic             clk,
    input  logic [WIDTH-1:0] d_in,
    output logic [WIDTH-1:0] q_out
);

    always_ff @(posedge clk) begin
        q_out <= d_in;
    end

endmodule
