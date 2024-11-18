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

interface adder_intf;
    logic [7:0] a;
    logic [7:0] b;
    logic mode_select;
endinterface  //adder_intf


class transaction;
    rand logic [7:0] a;
    rand logic [7:0] b;
    rand logic       mode_select;
endclass  //transaction


class generator;
    virtual adder_intf adder_if;
    transaction        tr;

    function new(virtual adder_intf adder_interface);
        this.adder_if = adder_interface;
        tr            = new();
    endfunction  //new()

    task run();
        repeat (100000) begin
            tr.randomize();
            adder_if.a           = tr.a;
            adder_if.b           = tr.b;
            adder_if.mode_select = tr.mode_select;
        end
    endtask
endclass  //generator


module tb_add_sub_systemverilog ();

    adder_intf adder_interface ();  // interface instance

    // transaction       trans;  // handler for instance
    generator       gen;

    //reg       [7:0] a;
    //reg       [7:0] b;
    //reg             mode_select;
    wire      [7:0] sum;
    wire            carry;
    //byte              b_sum;
    //int i_a, i_b, i_sum;

    add_sub dut (
        .a(adder_interface.a),
        .b(adder_interface.b),
        .cin(cin),
        .mode_select(adder_interface.mode_select),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        gen = new(adder_interface);
        gen.run();  // member_fuction

        //$srandom(10); // seed
        // trans = new();  // make instance on handler
        //mode_select = 1'b1;  // 0 : add, 1: sub
        /*    repeat (100000) begin  // 
            trans.randomize();
            a = trans.a;
            b = trans.b;
            mode_select = trans.mode_select;
            i_a = trans.a;
            i_b = trans.b;
            i_sum = i_a - i_b;
            #10;
            //b_sum = sum;
            case (trans.mode_select)
                1'b0: begin
                    $write("%d : a(%d) + b(%d) = result(%0d)", $time, trans.a,
                           trans.b, sum);
                    if ((trans.a + trans.b) == sum) begin
                        $display("\t pass!!!\n");
                    end else begin
                        $display("\t fail...\n");
                    end
                end
                1'b1: begin
                    $write("%d : a(%d) - b(%d) = result(%0d)", $time, trans.a,
                           trans.b, i_sum);
                    if ((trans.a - trans.b) == i_sum) begin
                        $display("\t pass!!!\n");
                    end else begin
                        $display("\t fail...\n");
                    end
                end
            endcase
        end*/
    end
endmodule
