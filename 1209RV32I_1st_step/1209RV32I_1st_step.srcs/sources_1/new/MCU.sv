`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 14:40:15
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

    wire [31:0] instruction_mem_addr, instruction_code;

    RV32I_core U_RV32I_R_TYPE_core (
        .clk                 (clk),
        .reset               (reset),
        .instruction_code    (instruction_code),
        .instruction_mem_addr(instruction_mem_addr)
    );

    ROM INSTRUCTION_MEM (
        .addr(instruction_mem_addr),
        .data(instruction_code)
    );
endmodule
