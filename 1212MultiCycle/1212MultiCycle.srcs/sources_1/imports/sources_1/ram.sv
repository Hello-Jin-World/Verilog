`timescale 1ns / 1ps

module ram (
    input  logic        clk,
    input  logic        we,
    input  logic [9:0] addr,
    input  logic [31:0] wData,
    output logic [31:0] rData
);
    logic [31:0] mem[0:100];

    always_ff @( posedge clk ) begin
        if (we) mem[addr[9:2]] <= wData;
    end

    assign rData = mem[addr[9:2]];
endmodule