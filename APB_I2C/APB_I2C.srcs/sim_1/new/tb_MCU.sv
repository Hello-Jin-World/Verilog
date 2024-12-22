`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 18:07:57
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
    wire  [3:0] GPIO_A;
    wire  [3:0] GPIO_B;
    logic [3:0] fndCom;
    logic [7:0] fndFont;
    wire        SDA;
    logic       SCL;

    logic       mode;
    logic       SDA_out;

    assign SDA = !mode ? SDA_out : 1'bz;

    MCU dut (
        .clk    (clk),
        .reset  (reset),
        .GPO_A  (GPO_A),
        .GPIO_A (GPIO_A),
        .GPIO_B (GPIO_B),
        .fndCom (fndCom),
        .fndFont(fndFont),
        .SDA    (SDA),
        .SCL    (SCL)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        mode = 1;
        SDA_out = 0;
        #10;
        reset = 0;
        repeat(9) @(posedge SCL);
        mode = 0;
        @(posedge SCL);
        mode = 1;
    end
endmodule
