`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 10:26:18
// Design Name: 
// Module Name: bram
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


module bram #(
    parameter DATA_WIDTH = 8,
    ADDR_WIDTH = 10
) (
    input                     clk,
    input                     write,
    input  [ADDR_WIDTH - 1:0] addr,
    input  [DATA_WIDTH - 1:0] wdata,
    output [DATA_WIDTH - 1:0] rdata
);

    reg [DATA_WIDTH - 1:0] mem[0:2**ADDR_WIDTH - 1];

    always @(posedge clk) begin
        if (write) begin
            mem[addr] <= wdata;
        end
    end

    assign rdata = mem[addr];  // combination logic
    /*
    // sequencial logic
    always @(posedge clk) begin
        if (!write) begin
            rdata <= mem[addr];
        end
    end
    */
endmodule
