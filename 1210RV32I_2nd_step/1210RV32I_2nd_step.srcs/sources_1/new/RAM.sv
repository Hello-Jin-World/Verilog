`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2024 11:34:57
// Design Name: 
// Module Name: RAM
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


module RAM (
    input  logic        clk,
    input  logic        we,
    input  logic [ 7:0] addr,
    input  logic [31:0] wData,
    output logic [31:0] rData
);

    logic [31:0] ram[0:10];


    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr[7:2]] <= wData;
        end
    end

    assign rData = ram[addr[7:2]];
endmodule
