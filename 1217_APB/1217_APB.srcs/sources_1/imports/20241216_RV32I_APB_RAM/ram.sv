`timescale 1ns / 1ps

module ram (
    input  logic        clk,
    input  logic        we,
    input  logic        sel,
    input  logic        enable,
    output logic        ready,
    input  logic [ 7:0] addr,
    input  logic [31:0] wData,
    output logic [31:0] rData
);
    logic [31:0] mem[0:63];

    always_ff @(posedge clk) begin
        if (sel & we & enable) mem[addr[7:2]] <= wData;
    end

    always_ff @(posedge clk) begin
        if (sel & !we & enable) rData <= mem[addr[7:2]];
    end

    always_ff @(posedge clk) begin
        if (sel & enable) ready <= 1'b1;
        else ready <= 1'b0;
    end
endmodule
