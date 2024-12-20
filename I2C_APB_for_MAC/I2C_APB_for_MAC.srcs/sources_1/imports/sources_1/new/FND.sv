`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 10:00:14
// Design Name: 
// Module Name: FND
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


module FND (
    input  logic        PCLK,
    input  logic        PRESET,
    input  logic [ 3:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic [ 3:0] fndCom,
    output logic [ 7:0] fndFont
);

    logic [1:0] fndSel;
    logic [3:0] fndNum;

    APB_Intf_fnd U_APB_Intf_fnd (
        .pclk   (PCLK   ),
        .preset (PRESET ),
        .paddr  (PADDR  ),
        .pwrite (PWRITE ),
        .psel   (PSEL   ),
        .penable(PENABLE),
        .pwdata (PWDATA ),
        .prdata (PRDATA ),
        .pready (PREADY ),
        .fndSel (fndSel ),
        .fndNum (fndNum )
    );

    fnd_ip U_fnd_ip (
        .fndSel (fndSel),
        .fndNum (fndNum),
        .fndCom (fndCom),
        .fndFont(fndFont)
    );
endmodule

module APB_Intf_fnd (
    input logic       pclk,
    input logic       preset,
    input logic [3:0] paddr,
    input logic       pwrite,
    input logic       psel,
    input logic       penable,

    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,

    output logic [1:0] fndSel,
    output logic [3:0] fndNum
);

    logic [31:0] FSR, FNR;

    assign fndSel = FSR[1:0];
    assign fndNum = FNR[3:0];

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            FSR <= 0;
            FNR <= 0;
        end else begin
            if (psel && pwrite && penable) begin
                case (paddr[2])
                    1'b0: FSR <= pwdata;
                    1'b1: FNR <= pwdata;
                    default: begin
                        FSR <= FSR;
                        FNR <= FNR;
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
                case (paddr[2])
                    1'b0: prdata <= FSR;
                    1'b1: prdata <= FNR;
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

module fnd_ip (
    input  logic [1:0] fndSel,
    input  logic [3:0] fndNum,
    output logic [3:0] fndCom,
    output logic [7:0] fndFont
);

    always_comb begin
        case (fndSel)
            2'b00:   fndCom = 4'b1110;
            2'b01:   fndCom = 4'b1101;
            2'b10:   fndCom = 4'b1011;
            2'b11:   fndCom = 4'b0111;
            default: fndCom = 4'bxxxx;
        endcase

        case (fndNum)
            4'h0: fndFont = 8'hc0;
            4'h1: fndFont = 8'hf9;
            4'h2: fndFont = 8'ha4;
            4'h3: fndFont = 8'hb0;
            4'h4: fndFont = 8'h99;
            4'h5: fndFont = 8'h92;
            4'h6: fndFont = 8'h82;
            4'h7: fndFont = 8'hf8;
            4'h8: fndFont = 8'h80;
            4'h9: fndFont = 8'h90;
            4'ha: fndFont = 8'h88;
            4'hb: fndFont = 8'h83;
            4'hc: fndFont = 8'hc6;
            4'hd: fndFont = 8'ha1;
            4'he: fndFont = 8'h7f;  // dot on
            4'hf: fndFont = 8'hff;  // dot off
            default: fndFont = 8'hff;
        endcase
    end
endmodule
