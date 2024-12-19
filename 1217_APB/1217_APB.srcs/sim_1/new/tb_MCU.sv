`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2024 11:37:29
// Design Name: 
// Module Name: tb_MCU
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

module tb_MCU ();

    logic       clk;
    logic       reset;
    logic [3:0] GPO_A;

    MCU dut (.*);

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #10; 
        reset = 0;
    end
endmodule


/*
module tb_MCU ();
    logic        PCLK;
    logic        PRESET;
    logic [ 2:0] PADDR;
    logic        PWRITE;
    logic        PSEL;
    logic        PENABLE;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    logic        PREADY;

    logic [ 3:0] outPort;

    gpo dut (.*);

    always #5 PCLK = ~PCLK;

    initial begin
        PCLK   = 0;
        PRESET = 1;
        #10;
        PRESET = 0;
        @(posedge PCLK);
        PADDR   = 0;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 0;
        PWDATA  = 32'b1111;
        @(posedge PCLK);
        PADDR   = 0;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 1;
        PWDATA  = 32'b1111;
        @(posedge PREADY);

        @(posedge PCLK);
        PADDR   = 4;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 0;
        PWDATA  = 32'b0001;
        @(posedge PCLK);
        PADDR   = 4;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 1;
        PWDATA  = 32'b0001;
        @(posedge PREADY);

        @(posedge PCLK);
        PADDR   = 4;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 0;
        PWDATA  = 32'b1000;
        @(posedge PCLK);
        PADDR   = 4;
        PWRITE  = 1;
        PSEL    = 1;
        PENABLE = 1;
        PWDATA  = 32'b1000;
        @(posedge PREADY);
    end
endmodule
*/
