`timescale 1ns / 1ps

module ram (
    input  logic        clk,
    input  logic        sel,
    input  logic        enable,
    input  logic        we,
    input  logic [ 9:0] addr,
    input  logic [31:0] wData,
    output logic        ready0,
    output logic [31:0] rData
);
    logic [31:0] mem[0:100];

    reg [1:0] state_reg, state_next;

    always_ff @(posedge clk) begin
        if (we && sel && enable) begin
            mem[addr[9:2]] <= wData;
        end
    end

    always_ff @(posedge clk) begin
        if (sel & !we && enable) begin
            rData = mem[addr[9:2]];
        end
    end

    always_ff @(posedge clk) begin
        if (sel & enable) begin
            ready0 = 1'b1;
        end else begin
            ready0 = 1'b0;
        end
    end

endmodule
