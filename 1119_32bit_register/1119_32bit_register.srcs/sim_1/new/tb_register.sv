`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 09:41:44
// Design Name: 
// Module Name: tb_register
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

interface reg_interface;
    logic        clk;
    logic        reset;
    logic [31:0] d;
    logic [31:0] q;
endinterface  //reg_interface

class transaction;
    rand logic [31:0] data;
    logic      [31:0] out;

    task display(string name);  // check section
        $display("[%s] data: %x, out: %x", name, data, out);
    endtask  //automatic 
endclass  //transaction

class generator;
    transaction trans;

    mailbox #(transaction) gen2drv_mbox;  // create headler gen2drv_mbox
    event gen_next_event;  // event : default feature in system verilog

    function new(mailbox#(transaction) gen2drv_mbox_v,
                 event gen_next_event);  // create instance
        this.gen2drv_mbox = gen2drv_mbox_v;  // reference
        this.gen_next_event = gen_next_event;
        trans = new();
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            assert (trans.randomize())
            else $display("[GEN] trans.radomize() error \n");  //error_process
            gen2drv_mbox.put(trans);  // put : default feature in system verilog
            trans.display("GEN");
            @(gen_next_event);
        end
    endtask  //run int countor

endclass

class driver;
    transaction trans;
    virtual reg_interface reg_intf;

    mailbox #(transaction) gen2drv_mbox;  // create headler gen2drv_mbox
    event gen_next_event;

    function new(mailbox#(transaction) gen2drv_mbox_v,
                 virtual reg_interface reg_interf, event gen_next_event);
        this.gen2drv_mbox = gen2drv_mbox_v;  // reference
        this.reg_intf = reg_interf;
        this.gen_next_event = gen_next_event;
    endfunction  //new()

    task reset();
        reg_intf.d     <= 0;
        reg_intf.reset <= 1'b1;
        repeat (5) @(posedge reg_intf.clk);
        reg_intf.reset <= 1'b0;
        @(posedge reg_intf.clk);  // when appear clk edge, output data
    endtask  //reset

    task run();
        forever begin
            gen2drv_mbox.get(trans);  // get transaction address, put in trans
            // get -> blocking
            reg_intf.d = trans.data;
            trans.out = reg_intf.q;
            trans.display("DRV_IN");
            @(posedge reg_intf.clk);  // when appear clk edge, output data
            #1 trans.out = reg_intf.q;
            trans.display("DRV_OUT");
            if (trans.data == trans.out) $display("pass!!!");
            else $display("fail...");
            ->gen_next_event; // trig event
        end
    endtask  //run 
endclass  //driver

module tb_register ();
    reg_interface reg_intf(); // When this moment, reg_interface be instantiation
    generator gen;
    driver drv;
    event gen_next_event;

    mailbox #(transaction) gen2drv_mbox;

    register dut (  // connect interface cable with dut
        .clk  (reg_intf.clk),
        .reset(reg_intf.reset),
        .d    (reg_intf.d),
        .q    (reg_intf.q)
    );

    always #5 reg_intf.clk = ~reg_intf.clk;  // clk (interface member) toggle

    initial begin
        reg_intf.clk = 0;

        gen2drv_mbox = new();  // create mailbox instance

        gen = new(gen2drv_mbox, gen_next_event);
        drv = new(gen2drv_mbox, reg_intf, gen_next_event);
        // connet interface(hardware) with generator(class, software)
        //gen = new(reg_intf)
        //    ;  // connet interface(hardware) with generator(class, software)
        drv.reset();
        fork
            drv.run();
            gen.run(5);
        join_any
    end

endmodule
