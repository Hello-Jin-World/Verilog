`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 18:35:11
// Design Name: 
// Module Name: DHT11_SV
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

interface dht11_interface;
    logic       clk;
    logic       reset;
    wire        ioport;
    logic       mode;
    logic [7:0] hum_int;
    logic [7:0] hum_dec;
    logic [7:0] tem_int;
    logic [7:0] tem_dec;
    logic       come_data;
    logic       out_data;

    assign ioport.come_data = mode ? out_data : 1'bz;
endinterface  //dht11_interface

class transaction;
    logic      [7:0] hum_int;
    logic      [7:0] hum_dec;
    logic      [7:0] tem_int;
    logic      [7:0] tem_dec;
    logic            out_data;
    logic            come_data;
    logic            mode;
    rand logic [6:0] set_up_time;

    task display(string name);
        $display("[%s] humidity : %d.%d,  temperature : %d.%d", name, hum_int,
                 hum_dec, tem_int, tem_dec);
    endtask  //display
endclass  //transaction

class generator;
    transaction            trans;
    mailbox #(transaction) gen2drv_mbox;
    event                  gen_next_event;

    function new(mailbox#(transaction) gen2drv_mbox, event gen_next_event);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.gen_next_event = gen_next_event;
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            trans = new();
            assert (trans.randomize())
            else $error("randomize errer!!!!!!");
            gen2drv_mbox.put(trans);
            trans.display("GEN");
            @(gen_next_event);
        end
    endtask  //run
endclass  //generator

class driver;
    transaction             trans;

    mailbox #(transaction)  gen2drv_mbox;
    event                   mon_next_event;
    virtual dht11_interface dht11_intf;

    function new(mailbox#(transaction) gen2drv_mbox, event mon_next_event,
                 virtual dht11_interface dht11_intf);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.mon_next_event = mon_next_event;
        this.dht11_intf     = dht11_intf;
    endfunction  //new()

    task reset();
        #0;
        dht11_intf.reset     = 1'b1;
        dht11_intf.clk       = 1'b0;
        dht11_intf.mode      = 1'b1;
        dht11_intf.hum_int   = 0;
        dht11_intf.hum_dec   = 0;
        dht11_intf.tem_int   = 0;
        dht11_intf.tem_dec   = 0;
        dht11_intf.come_data = 0;
        dht11_intf.out_data  = 0;
        dht11_intf.tick      = 0;
        #5;
        dht11_intf.reset = 1'b0;
        repeat (5) @(posedge dht11_intf.clk);
    endtask

    // reg [$clog2(18_000) - 1:0] tick;

    task tick(int count);  // count * 1us tick
        repeat (count) begin
            repeat (100) @(posedge dht11_intf.clk);
        end
    endtask  //tick

    task send_start_signal_high();
        dht11_intf.mode     = 1'b1;
        dht11_intf.out_data = 1'b0;
        @(posedge dht11_intf.clk);
    endtask  //start

    task start_dht11();
        // dht11_intf.mode     = 1'b1;
        // dht11_intf.out_data = 1'b0;
        // @(posedge dht11_intf.clk);
        wait (dht11_intf.ioport == 0);  // 18ms    LOW
        wait (dht11_intf.ioport == 1);  // 20~40us HIGH
        wait (dht11_intf.ioport == 0);  // start receive
        repeat (5) @(posedge dht11_intf.clk);
        dht11_intf.come_data = 1'b0;
        tick(60);
        dht11_intf.come_data = 1'b1;
        tick(75);
        for (int i = 0; i < 40; i++) begin
            dht11_intf.come_data = 1'b0;
            tick(50);
            dht11_intf.come_data = 1'b1; 
            tick(trans.set_up_time);
        end
    endtask  //start_dht11

    task receive_dht11();

    endtask  //receive_dht11

    task dht11_action();

    endtask  //dht11_action

    task dht11_trigger();
        send_start_signal_high();
        tick(18000);
        #2;
        dht11_intf.out_data = 1'b1;
        tick(30);
        @(posedge dht11_intf.clk);
    endtask  //dht11_trigger

    task run();
        forever begin
            gen2drv_mbox.get(trans);
            dht11_intf.hum_int = trans.hum_int;
            dht11_intf.hum_dec = trans.hum_dec;
            dht11_intf.tem_int = trans.tem_int;
            dht11_intf.tem_dec = trans.tem_dec;
            trans.display("DRV");
            #2;
            ->mon_next_event;
            @(posedge dht11_intf.clk);
        end
    endtask  //run
endclass  //driver

class monitor;
    transaction             trans;

    mailbox #(transaction)  mon2scb_mbox;
    event                   mon_next_event;
    virtual dht11_interface dht11_intf;

    function new(mailbox#(transaction) mon2scb_mbox, event mon_next_event,
                 virtual dht11_interface dht11_intf);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.mon_next_event = mon_next_event;
        this.dht11_intf     = dht11_intf;
    endfunction  //new()

    task run();
        forever begin
            @(mon_next_event);
            trans = new();
            trans.hum_int = dht11_intf.hum_int;
            trans.hum_dec = dht11_intf.hum_dec;
            trans.tem_int = dht11_intf.tem_int;
            trans.tem_dec = dht11_intf.tem_dec;
            mon2scb_mbox.put(trans);
            trans.display("MON");
            @(posedge dht11_intf.clk);
        end
    endtask  //run
endclass  //monitor

class scoreboard;
    transaction            trans;

    mailbox #(transaction) mon2scb_mbox;
    event                  gen_next_event;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(trans);
            trans.display("SCB");
            ->gen_next_event;
        end
    endtask  //run

endclass  //scoreboard

class environment;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    generator              gen;
    driver                 drv;
    monitor                mon;
    scoreboard             scb;

    event                  gen_next_event;
    event                  mon_next_event;

    function new(virtual dht11_interface dht11_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen          = new(gen2drv_mbox, gen_next_event);
        drv          = new(gen2drv_mbox, mon_next_event, dht11_intf);
        mon          = new(mon2scb_mbox, mon_next_event, dht11_intf);
        scb          = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

    task pre_run();
        drv.reset();
    endtask  //run

    task run();
        fork
            gen.run(100);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #10 $finish;
    endtask  //run

    task run_test();
        pre_run();
        run();
    endtask  //run_test
endclass  //environment

module DHT11_SV ();

    dht11_interface dht11_intf ();

    environment env;

    DHT11_control dut (
        .clk    (dht11_intf.clk),
        .reset  (dht11_intf.reset),
        .ioport (dht11_intf.ioport),
        .wr_en  (dht11_intf.wr_en),
        .hum_int(dht11_intf.hum_int),
        .hum_dec(dht11_intf.hum_dec),
        .tem_int(dht11_intf.tem_int),
        .tem_dec(dht11_intf.tem_dec)
    );

    always #5 dht11_intf.clk = ~dht11_intf.clk;

    initial begin
        env = new(dht11_intf);
        env.run_test();
    end

endmodule
