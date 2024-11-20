`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 10:44:16
// Design Name: 
// Module Name: tb_bram
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
    logic       write;
    logic [9:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
endinterface  //ram_interface

class transaction;
    rand logic       write;
    rand logic [9:0] addr;
    rand logic [7:0] wdata;
    logic      [7:0] rdata;

    task display(string name);
        $display("[%s] write: %x, addr: %x, wdata: %x, rdata:%x", name, write,
                 addr, wdata, rdata);
    endtask  //display
endclass  //transaction

class generator;

    transaction trans;
    mailbox #(transaction) gen2drv_mbox;
    event gen_next_event;

    function new(mailbox#(transaction) gen2drv_mbox, event gen_next_event);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.gen_next_event = gen_next_event;
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            trans = new();
            assert (trans.randomize())
            else $error("[GEN] trans.randomize() error!!!!"); 
            gen2drv_mbox.put(trans);
            trans.display("GEN");
            @(gen_next_event);
        end
    endtask  //run
endclass  //generator

class driver;
    transaction trans;
    mailbox #(transaction) gen2drv_mbox;
    virtual ram_interface ram_intf;

    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual ram_interface ram_intf);

    endfunction  //new()
endclass  //driver

class monitor;
    function new();

    endfunction  //new()
endclass  //monitor

class scoreboard;
    function new();

    endfunction  //new()
endclass  //scoreboard

class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    event gen_next_event;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    function new(virtual ram_interface ram_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_event);
        drv = new(gen2drv_mbox, ram_intf);
        mon = new(mon2scb_mbox, ram_intf);
        scb = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

    task pre_run();
        drv.reset();
    endtask  //

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_any
        report();
        #10 $finish;
    endtask  //automatic

    task run_test();
        pre_run();
        run();
    endtask  //
endclass  //environment

module tb_bram ();

    ram_interface ram_intf ();

    environment env;

    bram dut (
        .clk  (ram_intf.clk),
        .write(ram_intf.write),
        .addr (ram_intf.addr),
        .wdata(ram_intf.wdata),
        .rdata(ram_intf.rdata)
    );

    always #5 ram_intf.clk = ~ram_intf.clk;

    initial begin
        ram_intf.clk = 0;
    end

    initial begin
        env = new(ram_intf);
        env.run_test();
    end
endmodule
