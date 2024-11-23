`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 05:48:31 PM
// Design Name: 
// Module Name: tb_dht11
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


module tb_dht11 ();

    reg clk;
    reg reset;
    wire        wr_en;
    wire [39:0] tem_hum_data;
    wire        temp_out;

    dht11_control dut (
        .clk(clk),
        .reset(reset),
        .ioport(),
        .wr_en(wr_en),
        .tem_hum_data(tem_hum_data),
        .temp_out(temp_out)
    );

    always #5 clk = ~clk;

    initial begin
        #0 clk = 0;
        reset  = 1'b1;
        #5 reset = 1'b0;
        repeat (20) @(posedge clk);
    end
endmodule
