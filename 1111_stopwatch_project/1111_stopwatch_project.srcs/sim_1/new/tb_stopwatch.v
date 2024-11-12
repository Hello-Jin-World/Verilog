`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 12:04:27 PM
// Design Name: 
// Module Name: tb_stopwatch
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


module tb_stopwatch();

    reg clk;
    reg reset;
    reg btn_run_stop;
    reg btn_clear;
    reg switch;
    wire [3:0] fndcom;
    wire [7:0] fndfont;
    
top_stopwatch dut(
    .clk(clk),
    .reset(reset),
    .btn_run_stop(btn_run_stop),
    .btn_clear(btn_clear),
    .switch(switch),
    .fndcom(fndcom),
    .fndfont(fndfont)
);

always #5 clk = ~clk;
always #10000000 switch = ~switch;

initial begin
        #00 clk = 1'b0; reset = 1'b1; btn_run_stop = 1'b0; btn_clear = 1'b0; switch = 1'b1;
        #10 reset = 1'b0;
        #10 btn_run_stop = 1'b1;
        repeat (100) @(posedge clk);
        @(posedge clk) btn_run_stop = 1'b0;
        repeat (10) @(posedge clk);
        btn_run_stop = 1'b1;
        repeat (100) @(posedge clk);
        btn_clear = 1'b1;
        repeat (5) @(posedge clk);
        btn_run_stop = 1'b1;
end

endmodule
