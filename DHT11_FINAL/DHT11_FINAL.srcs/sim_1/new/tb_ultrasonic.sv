`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/30 10:37:24
// Design Name: 
// Module Name: tb_ultrasonic
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
    rand logic [19:0] echopulse_clk_cnt;
    logic [13:0] distance;

    task display(string name);
        $display("[%s] distance: %d, echopulse_distance: %d, echopulse_clk_cnt: %d", name, distance,
                 echopulse_clk_cnt / 5800, echopulse_clk_cnt);
    endtask  //new()
endclass  //transaction


interface ultrasonic_interface;
    logic clk;
    logic reset;
    logic echopulse;
    logic btn_start;
    logic [19:0] echopulse_clk_cnt;
    logic trigger;
    logic [13:0] distance;
endinterface  //ultrasonic_interface


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
            else $error("[GEN] trans.randomize() error!");
            gen2drv_mbox.put(trans);
            trans.display("GEN");
            @(gen_next_event);
        end
    endtask  //run
endclass  //generator


class driver;
    transaction                  trans;
    mailbox #(transaction)       gen2drv_mbox;
    virtual ultrasonic_interface ultrasonic_intf;
    event                        mon_next_event;
    event                        drv_mon_event;
    event                        mon_next_event2;

    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual ultrasonic_interface ultrasonic_intf,
                 event mon_next_event, event drv_mon_event,
                 event mon_next_event2);
        this.gen2drv_mbox    = gen2drv_mbox;
        this.ultrasonic_intf = ultrasonic_intf;
        this.mon_next_event  = mon_next_event;
        this.drv_mon_event = drv_mon_event;
        this.mon_next_event2 = mon_next_event2;
    endfunction  //new()

    task reset();
        ultrasonic_intf.clk         = 1'b0;
        ultrasonic_intf.reset       = 1'b1;
        ultrasonic_intf.echopulse   = 0;
        ultrasonic_intf.btn_start   = 0;
        repeat (5) @(posedge ultrasonic_intf.clk);
        ultrasonic_intf.reset = 1'b0;
        ultrasonic_intf.btn_start = 1;
    endtask  //reset

    task run();
        forever begin
            gen2drv_mbox.get(trans);
            ultrasonic_intf.echopulse_clk_cnt = trans.echopulse_clk_cnt;
            #2;
            ->mon_next_event;
            @(drv_mon_event);
            #5;
            ultrasonic_intf.echopulse = 1;
            repeat (trans.echopulse_clk_cnt) @(posedge ultrasonic_intf.clk);
            ultrasonic_intf.echopulse = 0;
            #2;
            ->mon_next_event2;
            trans.display("DRV");
        end
    endtask  //run
endclass  //driver


class monitor;
    transaction                  trans;
    mailbox #(transaction)       mon2scb_mbox;
    virtual ultrasonic_interface ultrasonic_intf;
    event                        mon_next_event;
    event                        drv_mon_event;
    event                        mon_next_event2;

    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual ultrasonic_interface ultrasonic_intf,
                 event mon_next_event, event drv_mon_event,
                 event mon_next_event2);
        this.mon2scb_mbox    = mon2scb_mbox;
        this.ultrasonic_intf = ultrasonic_intf;
        this.mon_next_event  = mon_next_event;
        this.drv_mon_event =drv_mon_event;
        this.mon_next_event2 = mon_next_event2;
    endfunction  //new()

    task run();
        forever begin
            @(mon_next_event); // driver 실행 후 값을 받기 위해 사용 
            trans = new();
            #2;
            @(negedge ultrasonic_intf.trigger);
            ->drv_mon_event;
            @(posedge ultrasonic_intf.clk);
            @(mon_next_event2);
            repeat (3) @(posedge ultrasonic_intf.clk);
            trans.distance = ultrasonic_intf.distance;
            trans.echopulse_clk_cnt = ultrasonic_intf.echopulse_clk_cnt;
            mon2scb_mbox.put(trans);
            trans.display("MON");
        end
    endtask  //run
endclass  //monitor


class scoreboard;
    transaction trans;
    mailbox #(transaction) mon2scb_mbox;
    event gen_next_event;

    int total_cnt, pass_cnt, fail_cnt;
    int echopulse_distance;

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
            echopulse_distance = trans.echopulse_clk_cnt / 5800;
            trans.display("SCB");
            if (trans.distance == echopulse_distance) begin
                $display("distance(module) : %d == distance(echopulse_clk_cnt/5800) : %d [PASS!]",
                         trans.distance, echopulse_distance);
                pass_cnt++;
            end else begin
                $display("distance(module) : %d != distance(echopulse_clk_cnt/5800) : %d [FAIL!]",
                         trans.distance, echopulse_distance);
                fail_cnt++;
            end
            total_cnt++;
            ->gen_next_event;
        end
    endtask  //run
endclass  //scoreboard


class environment;

    generator              gen;
    driver                 drv;
    monitor                mon;
    scoreboard             scb;

    event                  gen_next_event;
    event                  mon_next_event;
    event                  drv_mon_event;
    event                  mon_next_event2;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    function new(virtual ultrasonic_interface ultrasonic_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_event);
        drv = new(
            gen2drv_mbox,
            ultrasonic_intf,
            mon_next_event,
            drv_mon_event,
            mon_next_event2
        );
        mon = new(
            mon2scb_mbox,
            ultrasonic_intf,
            mon_next_event,
            drv_mon_event,
            mon_next_event2
        );
        scb = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

    task report();
        $display("=======================================");
        $display("==           Final Report            ==");
        $display("=======================================");
        $display("==         Total Test : %d  ==", scb.total_cnt);
        $display("==         Pass Test  : %d  ==", scb.pass_cnt);
        $display("==         Fail Test  : %d  ==", scb.fail_cnt);
        $display("=======================================");
        $display("==      Test Bench is finished       ==");
        $display("=======================================");
    endtask  //report


    task pre_run();
        drv.reset();
    endtask  //pre_run

    task run();
        fork
            gen.run(500);
            drv.run();
            mon.run();
            scb.run();
        join_any
        report();
        #10 $finish;
    endtask  //run

    task run_test();
        pre_run();
        run();
    endtask  //run_test
endclass  //environmet


module tb_ultrasonic ();

    ultrasonic_interface ultrasonic_intf ();

    environment env;

    ultrasonic dut (
        .clk        (ultrasonic_intf.clk),
        .reset      (ultrasonic_intf.reset),
        .echopulse  (ultrasonic_intf.echopulse),
        .btn_start  (ultrasonic_intf.btn_start),
        .trigger    (ultrasonic_intf.trigger),
        .distance   (ultrasonic_intf.distance)
    );

    always #5 ultrasonic_intf.clk = ~ultrasonic_intf.clk;

/*
    always begin
        if(ultrasonic_intf.btn_start == 1) begin
            #10 ultrasonic_intf.btn_start = 0;
        end
    end
*/

    initial begin
        env = new(ultrasonic_intf);
        env.run_test();
    end

endmodule

