`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 15:29:11
// Design Name: 
// Module Name: MCU
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


module MCU(
    input logic clk,
    input logic reset
);
    logic [31:0] w_instrCode, w_instrMemAddr;
    logic [31:0] dataAddr, readData, writeData;
    logic ramWe;

    RV32I_core U_RV32I_CORE (
        .clk(clk),
        .reset(reset),
        .instrCode(w_instrCode),
        .instrMemAddr(w_instrMemAddr),
        .dataAddr(dataAddr),
        .readData(readData),
        .writeData(writeData),
        .ramWe(ramWe)
    );

    ROM U_InstrMemory (
        .addr(w_instrMemAddr),
        .data(w_instrCode)
    );

    RAM U_DataMemory (
        .clk(clk),
        .we(ramWe),
        .addr(dataAddr[7:0]),
        .wData(writeData),
        .rData(readData)
    );
endmodule
