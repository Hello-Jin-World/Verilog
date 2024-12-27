`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/26 14:12:44
// Design Name: 
// Module Name: FrameBuffer
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


module FrameBuffer (
    // write side
    input  logic        wclk,
    input  logic        we,
    input  logic [16:0] wAddr,
    output logic [15:0] wData,
    // read side
    input  logic        rclk,
    input  logic        oe,
    input  logic [16:0] rAddr,
    output logic [15:0] rData
);

    logic [15:0] mem[0:320*240-1];

    always_ff @(posedge wclk) begin
        if (we) begin
            mem[wAddr] <= wData;
        end
    end

    always_ff @(posedge rclk) begin
        if (oe) begin
            rData <= mem[rAddr];
        end
    end
endmodule
