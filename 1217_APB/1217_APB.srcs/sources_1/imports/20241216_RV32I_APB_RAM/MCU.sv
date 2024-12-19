`timescale 1ns / 1ps

module MCU (
    input  logic       clk,
    input  logic       reset,
    output logic [3:0] GPO_A
);
    logic [31:0] instrCode, instrMemAddr;
    logic [31:0] dataAddr, readData, writeData;
    logic [3:0] sel;
    logic write, ready, enable, ram_ready, gpo_ready;
    logic [31:0] gpo_rData, ram_rData;

    RV32I_Core U_RV32I_CORE (
        .clk         (clk),
        .reset       (reset),
        .instrCode   (instrCode),
        .instrMemAddr(instrMemAddr),
        .dataAddr    (dataAddr),
        .readData    (readData),
        .writeData   (writeData),
        .ready       (ready),
        .enable      (enable),
        .ramWe       (write)
    );

    decoder_mem_map U_Decoder_Mem_Map (
        .addr(dataAddr),
        .sel (sel)
    );

    mux_mem_map U_Mux_Map (
        .addr  (dataAddr),
        .ready0(ram_ready),
        .ready1(gpo_ready),
        .ready2(),
        .ready3(),
        .rData0(ram_rData),
        .rData1(gpo_rData),
        .rData2(),
        .rData3(),
        .ready (ready),
        .rData (readData)
    );

    ROM U_InstrMemory (
        .addr(instrMemAddr),
        .data(instrCode)
    );

    ram U_DataMemory (
        .clk   (clk),
        .we    (write),
        .sel   (sel[0]),
        .enable(enable),
        .ready (ram_ready),
        .addr  (dataAddr),
        .wData (writeData),
        .rData (ram_rData)
    );

    gpo U_gpo (
        // global signal
        .PCLK   (clk),
        .PRESET (reset),
        .PADDR  (dataAddr),
        .PWRITE (write),
        .PSEL   (sel[1]),
        .PENABLE(enable),
        .PWDATA (writeData),
        .PRDATA (gpo_rData),
        .PREADY (gpo_ready),
        .outPort(GPO_A)
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
                rData = 32'bx;
                ready = 0;
            end
        endcase
    end
endmodule
