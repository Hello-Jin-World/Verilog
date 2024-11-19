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

    task display(string name);
        $display("[%s] address: %x, w_data: %x, rw: %x, r_data: %x", name, address, w_data, rw, r_data);
    endtask
endclass  //transaction

class generator;

    transaction trans;
    mailbox #(transaction) gen_ram_gen2drv_mbox;
    event gen_next_event;

    function new(mailbox#(transaction) ram_gen2drv_mbox, event gen_next_event);
        this.gen_ram_gen2drv_mbox = ram_gen2drv_mbox;
        this.gen_next_event = gen_next_event;
        trans = new();
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            assert (trans.randomize())
            else $display("Error!!!!!\n");
            gen_ram_gen2drv_mbox.put(trans);
            trans.display("GEN");
            @(gen_next_event);
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

    task reset ();
            @(posedge v_ram_intf.clk);
        v_ram_intf.w_data  = 0;
        v_ram_intf.address = 0;
        v_ram_intf.rw      = 0;
    endtask //

    task run();
        forever begin
            drv_ram_gen2drv_mbox.get(trans);
            @(posedge v_ram_intf.clk);
            v_ram_intf.address = trans.address;
            v_ram_intf.w_data  = trans.w_data;
            v_ram_intf.rw      = trans.rw;
            //trans.r_data       = v_ram_intf.r_data;
            trans.display("DRV");
        end
    endtask

endclass  //driver

class monitor;
    transaction trans;

    virtual ram_interface ram_interf;
    mailbox #(transaction) ram_mon2scb_mbox;

    function new(mailbox #(transaction) ram_mon2scb_mbox, virtual ram_interface ram_interf);
        this.ram_mon2scb_mbox = ram_mon2scb_mbox;
        this.ram_interf = ram_interf;
    endfunction //new()

    task run ();
       forever begin
            @(posedge ram_interf.clk);
            #1;
            trans = new();
            trans.w_data  = ram_interf.w_data;
            trans.rw      = ram_interf.rw;
            trans.address = ram_interf.address;
            trans.r_data  = ram_interf.r_data;
                /*
            if (ram_interf.rw == 0) begin
                trans.r_data  = ram_interf.r_data;
            end else begin
                trans.r_data   = 'x;
            end
            */
            ram_mon2scb_mbox.put(trans);
            trans.display("MON");
       end 
    endtask 
endclass //monitor

class scoreboard;
    transaction trans;
    mailbox #(transaction) ram_mon2scb_mbox;
    event gen_next_event;

    function new(mailbox #(transaction) ram_mon2scb_mbox, event gen_next_event);
       this.ram_mon2scb_mbox = ram_mon2scb_mbox; 
       this.gen_next_event   = gen_next_event; 
    endfunction //new()

    task run();
        forever begin
            ram_mon2scb_mbox.get(trans);
            trans.display("SCB");
            $display(" ");
            ->gen_next_event;
        end
    endtask
endclass //scoreboard

class envirnment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    event gen_next_event;

    mailbox #(transaction) ram_gen2drv_mbox;
    mailbox #(transaction) ram_mon2scb_mbox;

    function new(virtual ram_interface ram_intf);
        ram_gen2drv_mbox = new();
        ram_mon2scb_mbox = new();

        gen = new(ram_gen2drv_mbox, gen_next_event);
        drv = new(ram_gen2drv_mbox, ram_intf);
        mon = new(ram_mon2scb_mbox, ram_intf);
        scb = new(ram_mon2scb_mbox, gen_next_event);
    endfunction //new()

    task pre_run ();
       drv.reset(); 
    endtask //

    task run();
        fork
            gen.run(1000);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #10 $finish;
    endtask

    task run_test();
        pre_run();
        run();
    endtask
endclass //envirnment

module tb_ram_systemverilog ();

    ram_interface ram_intf ();
    envirnment env;

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
    end

    initial begin
        env = new(ram_intf);
        env.run_test();
    end
endmodule
