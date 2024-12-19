`timescale 1ns / 1ps

module gpio (
    // global signal
    input  logic        PCLK,
    input  logic        PRESET,
    // apb bus 
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // port
    input  logic [ 3:0] inPort,
    output logic [ 3:0] outPort
);

    logic [3:0] mode;
    logic [3:0] inData;
    logic [3:0] outData;

    APB_Intf U_APB_INTF (
        // global signal
        .pclk   (PCLK),
        .preset (PRESET),
        // apb bus 
        .paddr  (PADDR),
        .pwrite (PWRITE),
        .psel   (PSEL),
        .penable(PENABLE),
        .pwdata (PWDATA),
        .prdata (PRDATA),
        .pready (PREADY),
        // port
        .mode   (mode),
        .outData(outData)
    );

    gpo_ip U_GPO_IP (
        .mode   (mode),
        .outData(outData),
        .outPort(outPort)
    );
endmodule


module APB_Intf (
    // global signal
    input  logic        pclk,
    input  logic        preset,
    // apb bus 
    input  logic [ 3:0] paddr,
    input  logic        pwrite,
    input  logic        psel,
    input  logic        penable,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    // port
    output logic [ 3:0] mode,
    output logic [ 3:0] inData,
    output logic [ 3:0] outData
);

    logic [31:0] MODER;
    logic [31:0] IDR;
    logic [31:0] ODR;

    assign mode = MODER[3:0];
    assign outData = ODR[3:0];
    assign IDR = {28'b0, inData};

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            MODER <= 0;
            ODR   <= 0;
        end else if (psel & pwrite & penable) begin
            case (paddr[3:2])
                2'b00:   MODER <= pwdata;
                2'b10:   ODR <= pwdata;
                default: ;
            endcase
        end
    end

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            prdata <= 0;
        end else if (psel & !pwrite & penable) begin
            case (paddr[3:2])
                2'b00:   prdata <= MODER;
                2'b01:   prdata <= IDR;
                2'b10:   prdata <= ODR;
                default: ;
            endcase
        end
    end

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            pready <= 1'b0;
        end else if (psel & penable) pready <= 1'b1;
        else pready <= 1'b0;
    end
endmodule

module gpo_ip (
    input  logic [3:0] mode,
    input  logic [3:0] outData,
    output logic [3:0] inData,
    // port
    inout  wire  [3:0] inOutPort
);
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            if (!mode[i]) inData[i] = inOutPort[i];
        end
    end

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign inOutPort[i] = mode[i] ? outData[i] : 1'bz;
        end
    endgenerate
endmodule
