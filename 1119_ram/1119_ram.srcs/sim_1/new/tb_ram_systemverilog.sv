`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 15:49:26
// Design Name: 
// Module Name: tb_ram_systemverilog
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

interface ram_interface;
    logic       clk;
    logic [9:0] address;
    logic [7:0] w_data;
    logic       rw;
    logic [7:0] r_data;
endinterface  //ram_interface

class transaction;
    rand logic [9:0] address;
    rand logic [7:0] w_data;
    rand logic       rw;
    logic      [7:0] r_data;
endclass  //transaction

class generator;

    transaction trans;
    mailbox #(transaction) gen_ram_gen2drv_mbox;

    function new(mailbox#(transaction) ram_gen2drv_mbox);
        this.gen_ram_gen2drv_mbox = ram_gen2drv_mbox;
        trans = new();
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            assert (trans.randomize())
            else $display("Error!!!!!\n");
            gen_ram_gen2drv_mbox.put(trans);
        end
    endtask  //run

endclass  //generator

class driver;

    transaction trans;
    virtual ram_interface v_ram_intf;
    mailbox #(transaction) drv_ram_gen2drv_mbox;

    function new(mailbox#(transaction) gen2drv,
                 virtual ram_interface v_ram_intf);
        this.v_ram_intf           = v_ram_intf;
        this.drv_ram_gen2drv_mbox = gen2drv;
    endfunction  //new()

int i = 0;
    task reset ();
        v_ram_intf.w_data  = 0;
        v_ram_intf.address = 0;
        v_ram_intf.rw      = 0;
        @(posedge v_ram_intf.clk);
    endtask //

    task run();
        forever begin
            drv_ram_gen2drv_mbox.get(trans);
            v_ram_intf.address = trans.address;
            v_ram_intf.w_data  = trans.w_data;
            v_ram_intf.rw      = trans.rw;
            $display("[DRV] address : %x, data : %x, rw : %x", trans.address, trans.w_data, trans.rw);
            trans.r_data       = v_ram_intf.r_data;
            $display("[%d] READ OUTPUT : %x", i, v_ram_intf.r_data);
            i++;
        end
    endtask

endclass  //driver

module tb_ram_systemverilog ();

    ram_interface ram_intf ();
    generator gen;
    driver drv;
    mailbox #(transaction) ram_gen2drv_mbox;

    ram dut (
        .clk    (ram_intf.clk),
        .address(ram_intf.address),
        .w_data (ram_intf.w_data),
        .rw     (ram_intf.rw),
        .r_data (ram_intf.r_data)
    );

    always #5 ram_intf.clk = ~ram_intf.clk;

    initial begin
        ram_intf.clk = 0;
        ram_gen2drv_mbox = new();

        gen = new(ram_gen2drv_mbox);
        drv = new(ram_gen2drv_mbox, ram_intf);

        drv.reset();

        fork
            gen.run(10000);
            drv.run();
        join_any
    end
endmodule
