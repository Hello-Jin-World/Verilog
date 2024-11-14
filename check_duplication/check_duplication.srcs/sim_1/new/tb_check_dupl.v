`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 10:07:33
// Design Name: 
// Module Name: tb_check_dupl
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


module tb_check_dupl ();

    reg  clk;
    reg  reset;
    reg  in_bit;
    wire out_bit;

    check_dupl U_check_dupl (
        .clk(clk),
        .reset(reset),
        .in_bit(in_bit),
        .out_bit(out_bit)
    );

    always #05 clk = ~clk;
    //integer i;

    always #10 in_bit = $urandom();

    initial begin
        #00 clk = 1'b1;
        reset = 1'b1;
        in_bit = 1'b0;
        //i = 1'b0;
    end

/*
    task rand_num(output rand_bit);
        reg [31:0] rand_number;
        integer i;
        begin
            rand_number = $urandom;
            $display("random : %b\n", rand_number);
            for (i = 0; i < 32; i = i + 1) begin
                rand_bit = rand_number[0];
                rand_number = rand_number >> 1;
            end
        end
    endtask
*/
endmodule
