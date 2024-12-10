`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 09:41:21
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


module MCU (
    input logic clk,
    input logic reset
);
    logic [31:0] w_instrCode, w_instrMemAddr;
    logic [31:0] w_readData, w_dataAddr, w_writeData;
    logic w_ramWe;


    RV32I_core U_RV32I_core (
        .clk         (clk),
        .reset       (reset),
        .instrCode   (w_instrCode),
        .readData    (w_readData),
        .dataAddr    (w_dataAddr),
        .instrMemAddr(w_instrMemAddr),
        .writeData   (w_writeData),
        .ramWe       (w_ramWe)
    );

    RAM U_RAM (
        .clk  (clk),
        .we   (w_ramWe),
        .addr (w_dataAddr),
        .wData(w_writeData),
        .rData(w_readData)
    );

    ROM U_InstrMemory (
        .addr(w_instrMemAddr),
        .data(w_instrCode)
    );
endmodule
