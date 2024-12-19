`timescale 1ns / 1ps

module MCU (
    input logic clk,
    input logic reset
);
    logic [31:0] w_instrCode, w_instrMemAddr;
    logic [31:0] dataAddr, readData, writeData;
    logic [31:0] rData, rData0, rData1, rData2, rData3;
    logic [3:0] sel;
    logic write;
    logic ready, ready0, ready1, ready2, ready3;
    logic enable;

    RV32I_Core U_RV32I_CORE (
        .clk         (clk),
        .reset       (reset),
        .instrCode   (w_instrCode),
        .instrMemAddr(w_instrMemAddr),
        .dataAddr    (dataAddr),
        .readData    (rData),
        .writeData   (writeData),
        .ready       (ready),
        .enable      (enable),
        .write       (write)
    );

    ROM U_InstrMemory (
        .addr(w_instrMemAddr),
        .data(w_instrCode)
    );

    Decoder_3x8_MEM U_Decoder_3x8_MEM (
        .addr(dataAddr),
        .sel (sel)
    );

    mux_mem_map U_mux_mem_map (
        .ready0(ready0),
        .ready1(ready1),
        .ready2(ready2),
        .ready3(ready3),
        .addr  (dataAddr),
        .rData0(rData0),
        .rData1(rData1),
        .rData2(rData2),
        .rData3(rData3),
        .ready (ready),
        .rData (rData)
    );

    ram U_DataMemory (
        .clk   (clk),
        .sel   (sel[0]),
        .we    (write),
        .ready0(ready0),
        .enable(enable),
        .addr  (dataAddr),
        .wData (writeData),
        .rData (rData0)
    );
endmodule

module Decoder_3x8_MEM (
    input  logic [31:0] addr,
    output logic [ 3:0] sel
);


    always @(*) begin
        sel = 4'bxxxx;
        case (addr)
            32'h0001_0xxx: begin
                sel = 4'b0001;
            end
            32'h0002_00xx: begin
                sel = 4'b0010;
            end
            32'h0002_01xx: begin
                sel = 4'b0100;
            end
            32'h0002_02xx: begin
                sel = 4'b1000;
            end
            default: begin
                sel = 4'bxxxx;
            end
        endcase
    end
endmodule

module mux_mem_map (
    input  logic        ready0,
    input  logic        ready1,
    input  logic        ready2,
    input  logic        ready3,
    input  logic [31:0] addr,
    input  logic [31:0] rData0,
    input  logic [31:0] rData1,
    input  logic [31:0] rData2,
    input  logic [31:0] rData3,
    output logic        ready,
    output logic [31:0] rData
);
    always_comb begin
        case (addr)
            32'h0001_0xxx: begin
                rData = rData0;
                ready = ready0;
            end
            32'h0002_00xx: begin
                rData = rData1;
                ready = ready1;
            end
            32'h0002_01xx: begin
                rData = rData2;
                ready = ready2;
            end
            32'h0002_02xx: begin
                rData = rData3;
                ready = ready3;
            end
            default: begin
                rData = 32'bx;
                ready = 1'bx;
            end
        endcase
    end
endmodule
