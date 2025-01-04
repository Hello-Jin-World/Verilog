`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/31 10:17:29
// Design Name: 
// Module Name: AXI4_Lite_Slave_GPO
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


module AXI4_Lite_Slave_GPO ();
endmodule

module AXI4_Lite_Intf (
    input logic aclk,
    input logic aresetn,

    input  logic [2:0] awaddr,
    input  logic       awvalid,
    output logic       awready,

    input  logic [31:0] wdata,
    input  logic        wvalid,
    output logic        wready,

    output logic [1:0] bresp,
    output logic       bvalid,
    input  logic       bready,

    input  logic [2:0] araddr,
    input  logic       arvalid,
    output logic       arready,

    output logic [31:0] rdata,
    output logic [ 1:0] rresp,
    output logic        rvalid,
    input  logic        rready,

    output logic [15:0] o_moder,
    output logic [15:0] o_odr
);

    logic [31:0] MODER, ODR;

endmodule

module gpo_ip (
    input  logic [15:0] moder,
    input  logic [15:0] odr,
    output logic [15:0] outPort
);

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign outPort[i] = moder[i] ? odr[i] : 1'bz;
        end
    endgenerate

endmodule
