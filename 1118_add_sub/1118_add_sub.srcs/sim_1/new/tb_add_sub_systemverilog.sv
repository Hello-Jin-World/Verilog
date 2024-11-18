`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/18 11:38:24
// Design Name: 
// Module Name: tb_add_sub_systemverilog
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


class transaction;
    rand logic [7:0] a;
    rand logic [7:0] b;
endclass //transaction

module tb_add_sub_systemverilog ();
    transaction trans; // handler for instance

    reg  [7:0] a;
    reg  [7:0] b;
    reg        mode_select;
    wire [7:0] sum;
    wire       carry;

    add_sub dut (
        .a(a),
        .b(b),
        .cin(cin),
        .mode_select(mode_select),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        trans = new(); // make instance on handler
        mode_select = 1'b0; // add
        repeat(1000) begin // 
            trans.randomize();
            a = trans.a;
            b = trans.b;
            #10;
            $display("%t : a(%d) + b(%d) = sum(%d)", $time, trans.a, trans.b, {carry, sum});
            if ((trans.a + trans.b) == {carry, sum}) begin
                $display("pass!!!\n");
            end else begin
                $display("fail...\n");
            end
        end
    end
endmodule
