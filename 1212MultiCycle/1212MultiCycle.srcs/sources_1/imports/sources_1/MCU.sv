`timescale 1ns / 1ps

module MCU (
    input logic clk,
    input logic reset
);
    logic [31:0] w_instrCode, w_instrMemAddr;
    logic [31:0] dataAddr, readData, writeData;
    logic ramWe;

    RV32I_Core U_RV32I_CORE (
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

    ram U_DataMemory (
        .clk(clk),
        .we(ramWe),
        .addr(dataAddr),
        .wData(writeData),
        .rData(readData)
    );
endmodule
