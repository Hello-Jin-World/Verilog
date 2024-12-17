`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 13:59:18
// Design Name: 
// Module Name: tb_FPU
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

interface fp_interface;
    logic        clk;
    logic        reset;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] result;
    logic        overflow;
    logic        underflow;
    logic        busy;
endinterface  //fp_interface

class transaction;
    rand logic [31:0] a;
    rand logic [31:0] b;
    logic      [31:0] result;
    logic             overflow;
    logic             underflow;
    logic             busy;

    constraint fix {
        a[30:23] > 8'b00000000;
        a[30:23] < 8'b11111111;
        b[30:23] > 8'b00000000;
        b[30:23] < 8'b11111111;
    }

    task display(string name);
        $display("[%s] random a : %b,  random b : %b", name, a, b);
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
            $display("Time: %0t, Event: gen_next_event triggered", $time);
        end
    endtask  //run
endclass  //generator

class driver;
    transaction            trans;

    mailbox #(transaction) gen2drv_mbox;
    event                  mon_next_event;
    virtual fp_interface   fp_intf;

    function new(mailbox#(transaction) gen2drv_mbox, event mon_next_event,
                 virtual fp_interface fp_intf);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.mon_next_event = mon_next_event;
        this.fp_intf        = fp_intf;
    endfunction  //new()

    task reset();
        fp_intf.clk       <= 1'b0;
        fp_intf.reset     <= 1'b0;
        fp_intf.a         <= 0;
        fp_intf.b         <= 0;
        fp_intf.result    <= 0;
        fp_intf.overflow  <= 0;
        fp_intf.underflow <= 0;
        fp_intf.busy      <= 0;
        repeat (5) @(posedge fp_intf.clk);
        fp_intf.reset <= 1'b1;
        repeat (5) @(posedge fp_intf.clk);
        $display("[DRV] DUT Reset Done!");
        $display("---------------------");
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(trans);
            fp_intf.a = trans.a;
            fp_intf.b = trans.b;
            wait (fp_intf.busy == 1);
            trans.display("DRV");
            ->mon_next_event;
            @(posedge fp_intf.clk);
        end
    endtask  //run
endclass  //driver

class monitor;
    transaction            trans;

    mailbox #(transaction) mon2scb_mbox;
    event                  mon_next_event;
    virtual fp_interface   fp_intf;
    event                  scb_next_event;


    function new(mailbox#(transaction) mon2scb_mbox, event mon_next_event,
                 virtual fp_interface fp_intf, event scb_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.mon_next_event = mon_next_event;
        this.fp_intf        = fp_intf;
        this.scb_next_event = scb_next_event;
    endfunction  //new()

    task run();
        forever begin
            trans = new();
            @(mon_next_event);
            $display("Time: %0t, Event: mon_next_event triggered", $time);
            wait (fp_intf.busy == 0);
            trans.a         = fp_intf.a;
            trans.b         = fp_intf.b;
            trans.result    = fp_intf.result;
            trans.overflow  = fp_intf.overflow;
            trans.underflow = fp_intf.underflow;
            mon2scb_mbox.put(trans);
            trans.display("MON");
            #2;
            ->scb_next_event;
        end
    endtask  //run
endclass  //monitor

class scoreboard;
    transaction                   trans;
    mailbox #(transaction)        mon2scb_mbox;
    event                         gen_next_event;
    event                         scb_next_event;

    int                           total_cnt,                pass_cnt, fail_cnt;
    shortreal                     a_real;
    shortreal                     b_real;
    shortreal                     y_real;
    shortreal                     result_real;
    logic                  [31:0] sw_result;
    shortreal                     diff            = 0.0001;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event,
                 event scb_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        this.scb_next_event = scb_next_event;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;
        a_real              = 0;
        b_real              = 0;
        y_real              = 0;
        result_real         = 0;
    endfunction  //new()

    task run();
        forever begin
            @(scb_next_event);
            $display("Time: %0t, Event: scb_next_event triggered", $time);
            mon2scb_mbox.get(trans);

            a_real = $bitstoshortreal(trans.a);
            b_real = $bitstoshortreal(trans.b);
            #2;
            y_real = a_real + b_real;
            result_real = $bitstoshortreal(trans.result);
            sw_result = $shortrealtobits(y_real);

            if (y_real - result_real <= diff && y_real - result_real >= 0 || 
                result_real - y_real <= diff && result_real - y_real >= 0 ||
                trans.result - sw_result <= 32'd12 && trans.result - sw_result >= 32'd0 ||
                sw_result - trans.result <= 32'd12 && sw_result - trans.result >= 32'd0 ||
                trans.result == sw_result) begin
                $display("PASS!!!!");
                $display("Diff : %d", (y_real - result_real) / 100);
                pass_cnt++;
            end else begin
                if ((sw_result[30:23] == 8'hff) && trans.overflow == 1) begin
                    $display("PASS!!!!");
                    pass_cnt++;
                end else if ((sw_result[30:23] == 8'h00) && trans.underflow == 1) begin
                    $display("PASS!!!!");
                    pass_cnt++;
                end else begin
                    $display("FAIL....");
                    fail_cnt++;
                end
            end
            total_cnt++;
            trans.display("SCB");
            ->gen_next_event;
        end
    endtask  //run
endclass  //scoreboard

class environment;

    generator              gen;
    driver                 drv;
    monitor                mon;
    scoreboard             scb;
    transaction            trans;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    event                  gen_next_event;
    event                  mon_next_event;
    event                  scb_next_event;

    function new(virtual fp_interface fp_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, gen_next_event);
        drv = new(gen2drv_mbox, mon_next_event, fp_intf);
        mon = new(mon2scb_mbox, mon_next_event, fp_intf, scb_next_event);
        scb = new(mon2scb_mbox, gen_next_event, scb_next_event);
    endfunction  //new()

    task report();
        $display("====================================");
        $display("========    Final Report    ========");
        $display("====================================");
        $display("Total Test : %d", scb.total_cnt);
        $display("========     Read Result    ========");
        $display(" Pass Test : %d ", scb.pass_cnt);
        $display(" Fail Test : %d ", scb.fail_cnt);
        $display("====================================");
        $display("====   Test Bench is finished   ====");
        $display("====================================");
    endtask

    task pre_run();
        drv.reset();
    endtask  //run

    task run();
        fork
            gen.run(100000);
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
endclass  //environment

module tb_FPU ();

    fp_interface fp_intf ();

    environment env;

    FPU dut (
        .clk      (fp_intf.clk),
        .reset    (fp_intf.reset),
        .a_in     (fp_intf.a),
        .b_in     (fp_intf.b),
        .y        (fp_intf.result),
        .overflow (fp_intf.overflow),
        .underflow(fp_intf.underflow),
        .busy     (fp_intf.busy)
    );

    always #5 fp_intf.clk = ~fp_intf.clk;

    initial begin
        env = new(fp_intf);
        env.run_test();
    end

endmodule
