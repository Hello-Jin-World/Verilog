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
            for (int i = 0; i < 1024; i++) begin
                trans = new();
                assert (trans.randomize())
                else $error("[GEN] trans.randomize() error!!!!");
                trans.write = 1'b1;
                trans.addr  = i;
                //random value is stored sequentially.
                gen2drv_mbox.put(trans);
                trans.display("GEN");
                @(gen_next_event);
            end
            for (int i = 0; i < 1024; i++) begin
                
                trans = new();
                assert (trans.randomize())
                else $error("[GEN] trans.randomize() error!!!!");
                trans.write = 1'b0;
                trans.addr  = i;
                //random value is stored sequentially.
                gen2drv_mbox.put(trans);
                trans.display("GEN");
                @(gen_next_event);
            end
        end
    endtask  //run
endclass  //generator

class driver;
    transaction trans;
    mailbox #(transaction) gen2drv_mbox;
    virtual ram_interface ram_intf;
    event mon_next_event;

    function new(mailbox#(transaction) gen2drv_mbox, event mon_next_event,
                 virtual ram_interface ram_intf);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.mon_next_event = mon_next_event;
        this.ram_intf       = ram_intf;
    endfunction  //new()

    task reset();
        ram_intf.clk   = 1'b0;
        ram_intf.write = 1'b0;
        ram_intf.addr  = 0;
        ram_intf.wdata = 0;
        repeat (5) @(posedge ram_intf.clk);
    endtask  //reset

    task run();
        forever begin
            gen2drv_mbox.get(trans);
            ram_intf.write = trans.write;
            ram_intf.addr  = trans.addr;
            ram_intf.wdata = trans.wdata;
            trans.display("DRV");
            #2;
            ->mon_next_event;  // for dut operation time (delay 2ns)
            @(posedge ram_intf.clk);
        end
    endtask  //run
endclass  //driver

class monitor;
    transaction trans;
    mailbox #(transaction) mon2scb_mbox;
    virtual ram_interface ram_intf;
    event mon_next_event;

    function new(mailbox#(transaction) mon2scb_mbox, event mon_next_event,
                 virtual ram_interface ram_intf);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.mon_next_event = mon_next_event;
        this.ram_intf       = ram_intf;
    endfunction  //new()

    task run();
        forever begin
            @(mon_next_event);
            trans = new();
            trans.write = ram_intf.write;
            trans.addr = ram_intf.addr;
            trans.wdata = ram_intf.wdata;
            trans.rdata = ram_intf.rdata;
            mon2scb_mbox.put(trans);
            trans.display("MON");
            @(posedge ram_intf.clk);
        end
    endtask  //run
endclass  //monitor

class scoreboard;
    transaction trans;
    mailbox #(transaction) mon2scb_mbox;
    event gen_next_event;

    // Golden Data(Reference / Value)
    byte mem[0:1023];  // 8bit * 1024
    byte rdata;

    int total_cnt;
    int pass_cnt;
    int fail_cnt;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event);
        this.mon2scb_mbox = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        total_cnt = 0;
        pass_cnt = 0;
        fail_cnt = 0;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(trans);
            trans.display("SCB");
            if (trans.write) begin
                mem[trans.addr] = trans.wdata;
            end else begin
                rdata = mem[trans.addr];
                if (rdata == trans.rdata) begin
                    $display("rdata : %x == trans.rdata : %x [pass!!!]", rdata,
                             trans.rdata);
                    pass_cnt++;
                end else begin
                    $display("rdata : %x != trans.rdata : %x [fail...]", rdata,
                             trans.rdata);
                    fail_cnt++;
                end
                total_cnt++;
            end
            //$display("%p", mem);
            ->gen_next_event;
        end
    endtask  //run

endclass  //scoreboard

class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    event gen_next_event;
    event mon_next_event;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    function new(virtual ram_interface ram_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_event);
        drv = new(gen2drv_mbox, mon_next_event, ram_intf);
        mon = new(mon2scb_mbox, mon_next_event, ram_intf);
        scb = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

    task report();
        $display("====================================");
        $display("========    Final Report    ========");
        $display("====================================");
        $display("=======    Total Test : %d   =======", scb.total_cnt);
        $display("=======     Pass Test : %d   =======", scb.pass_cnt);
        $display("=======     Fail Test : %d   =======", scb.fail_cnt);
        $display("====================================");
        $display("====   Test Bench is finished   ====");
        $display("====================================");
    endtask

    task pre_run();
        drv.reset();
    endtask  //

    task run();
        fork
            gen.run(10);
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
        env = new(ram_intf);
        env.run_test();
    end
endmodule
