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

    decoder_mem_map U_DECODER_MEM_MAP (
        .addr(dataAddr),
        .sel (sel)
    );

    mux_mem_map U_MUX_MEM_MAP (
        .ready0(ready0),
        .ready1(),
        .ready2(),
        .ready3(),
        .addr  (dataAddr),
        .rData0(rData0),
        .rData1(),
        .rData2(),
        .rData3(),
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

module decoder_mem_map (
    input  logic [31:0] addr,
    output logic [ 3:0] sel
);
    always_comb begin
        casex (addr)
            32'h0000_01xx: sel = 4'b0001;  // ram
            32'h0002_00xx: sel = 4'b0010;  // gpo
            32'h0002_01xx: sel = 4'b0100;  // gpi
            32'h0002_02xx: sel = 4'b1000;
            default: sel = 4'bxxxx;
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
        casex (addr)
            32'h0000_01xx: begin
                ready = ready0;
                rData = rData0;  // ram
            end
            32'h0002_00xx: begin
                ready = ready1;
                rData = rData1;  // gpo
            end
            32'h0002_01xx: begin
                ready = ready2;
                rData = rData2;  // gpi
            end
            32'h0002_02xx: begin
                ready = ready3;
                rData = rData3;
            end
            default: begin
                ready= 0;
                rData = 32'bx;
            end
        endcase
    end
endmodule