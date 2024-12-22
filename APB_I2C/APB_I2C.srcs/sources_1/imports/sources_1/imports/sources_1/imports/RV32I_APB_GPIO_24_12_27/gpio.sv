`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 09:50:29
// Design Name: 
// Module Name: gpio
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


module gpio (
    input  logic        PCLK,
    input  logic        PRESET,
    input  logic [ 3:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    inout  wire  [ 3:0] inoutPort
);

    logic [3:0] mode;
    logic [3:0] inData;
    logic [3:0] outData;

    APB_Intf_gpio U_APB_Intf_gpio (
        .pclk   (PCLK),
        .preset (PRESET),
        .paddr  (PADDR),
        .pwrite (PWRITE),
        .psel   (PSEL),
        .penable(PENABLE),
        .pwdata (PWDATA),
        .prdata (PRDATA),
        .pready (PREADY),
        .mode   (mode),
        .inData (inData),
        .outData(outData)
    );

    gpio_ip U_gpio_ip (
        .mode     (mode),
        .outData  (outData),
        .inData   (inData),
        .inoutPort(inoutPort)
    );
endmodule

module APB_Intf_gpio (
    input logic       pclk,
    input logic       preset,
    input logic [3:0] paddr,
    input logic       pwrite,
    input logic       psel,
    input logic       penable,

    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,

    output logic [3:0] mode,
    input  logic [3:0] inData,
    output logic [3:0] outData
);

    logic [31:0] MODER, IDR, ODR;

    assign mode    = MODER[3:0];
    assign IDR     = {28'b0, inData};
    assign outData = ODR[3:0];

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            MODER <= 0;
            ODR   <= 0;
        end else begin
            if (psel && pwrite && penable) begin
                case (paddr[3:2])
                    2'b00: MODER <= pwdata;
                    2'b10: ODR <= pwdata;
                    default: begin
                        MODER <= MODER;
                        ODR   <= ODR;
                    end
                endcase
            end
        end
    end 
    
    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            prdata <= 0;
        end else begin
            if (psel && ~pwrite && penable) begin
                case (paddr[3:2])
                    2'b00:   prdata <= MODER;
                    2'b01:   prdata <= IDR;
                    2'b10:   prdata <= ODR;
                    default: prdata <= 32'b0;
                endcase
            end
        end
    end

    //APB Ready Process
    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            pready <= 0;
        end else begin
            if (psel && penable) begin
                pready <= 1;
            end else begin
                pready <= 0;
            end
        end
    end
endmodule

module gpio_ip (
    input  logic [3:0] mode,
    input  logic [3:0] outData,
    output logic [3:0] inData,
    inout  wire  [3:0] inoutPort
);

    always_comb begin
        for (int j = 0; j < 4; j++) begin
            if (!mode[j]) begin
                inData[j] = inoutPort[j];
            end else begin
                inData[j] = 1'bz;
            end
        end
    end

    genvar i;

    generate
        for (i = 0; i < 4; i++) begin
            assign inoutPort[i] = mode[i] ? outData[i] : 1'bz;
        end
    endgenerate
endmodule
