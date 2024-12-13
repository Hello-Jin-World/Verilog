`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 01:53:42 AM
// Design Name: 
// Module Name: tb_floating_point
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


// module tb_floating_point ();
//     reg [15:0] a, b;
//     wire [15:0] result;
//     wire overflow, underflow;

//     // DUT 인스턴스화
//     floating_point dut (
//         .a(a),
//         .b(b),
//         .result(result),
//         .overflow(overflow),
//         .underflow(underflow)
//     );

//     // 테스트 시퀀스
//     initial begin
//         // 테스트 케이스 1: 양의 정규화된 숫자 덧셈
//         a = 16'b0_01000_0100000000;  // 1.0
//         b = 16'b0_01000_0010000000;  // 0.5
//         #10;
//         $display("Test Case 1: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         // 테스트 케이스 2: 부호가 다른 숫자 덧셈
//         a = 16'b0_01000_0100000000;  // 1.0
//         b = 16'b1_01000_0100000000;  // -1.0
//         #10;
//         $display("Test Case 2: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         // 테스트 케이스 3: 큰 오버플로우 케이스
//         a = 16'b0_11110_1111111111;  // 최대 양의 값
//         b = 16'b0_01000_0100000000;  // 1.0
//         #10;
//         $display("Test Case 3: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         $finish;
//     end
// endmodule

interface fp_interface;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] result;
    logic        overflow;
    logic        underflow;
endinterface  //fp_interface

class transaction;
    rand logic [31:0] a;
    rand logic [31:0] b;
    logic      [31:0] result;
    logic             overflow;
    logic             underflow;

    // constraint range {
    //     set_up_time dist {
    //         26 :/ 80,
    //         70 :/ 20
    //     };
    // }

    //constraint value_c {set_up_time inside {26, 70};}

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
        fp_intf.reset    <= 1'b1;
        fp_intf.clk      <= 1'b0;
        fp_intf.mode     <= 1'b1;
        fp_intf.hum_int  <= 0;
        fp_intf.hum_dec  <= 0;
        fp_intf.tem_int  <= 0;
        fp_intf.tem_dec  <= 0;
        fp_intf.checksum <= 0;
        fp_intf.out_data <= 0;
        fp_intf.sw_40bit <= 0;
        // fp_intf.tem <= 0;
        repeat (5) @(posedge fp_intf.clk);
        fp_intf.reset <= 1'b0;
        repeat (5) @(posedge fp_intf.clk);
        $display("[DRV] DUT Reset Done!");
        $display("---------------------");
    endtask

    task tick(int count);  // count * 1us tick
        repeat (count) begin
            repeat (100) @(posedge fp_intf.clk);
        end
    endtask  //tick

    task start_dht11();
        fp_intf.mode = 1'b0;
        wait (fp_intf.ioport == 0);  // 18ms    LOW
        $display("READ 18ms LOW");
        wait (fp_intf.ioport == 1);  // 20~40us HIGH
        $display("READ 20~40us HIGH");
        tick(25);
        fp_intf.mode = 1'b1;

        fp_intf.out_data = 1'b0;
        tick(60);
        fp_intf.out_data = 1'b1;
        tick(75);

        //////////////////////////////////////////////////////////// humidity int
        fp_intf.out_data = 1'b0;
        tick(50);
        fp_intf.out_data = 1'b1;
        tick(26);
        trans.sw_40bit = {trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]};

        for (int i = 0; i < 7; i++) begin
            trans.randomize();
            fp_intf.out_data = 1'b0;
            tick(50);
            fp_intf.out_data = 1'b1;
            tick(trans.set_up_time);
            // #2;
            if (trans.set_up_time > 40) begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b1, trans.sw_40bit[7:0]
                };
            end else begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]
                };
            end

            $display("%d", trans.set_up_time);
        end
        //////////////////////////////////////////////////////////// humidity dec
        fp_intf.out_data = 1'b0;
        tick(50);
        fp_intf.out_data = 1'b1;
        tick(26);
        trans.sw_40bit = {trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]};

        for (int i = 0; i < 7; i++) begin
            trans.randomize();
            fp_intf.out_data = 1'b0;
            tick(50);
            fp_intf.out_data = 1'b1;
            tick(trans.set_up_time);
            // #2;
            if (trans.set_up_time > 40) begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b1, trans.sw_40bit[7:0]
                };
            end else begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]
                };
            end

            $display("%d", trans.set_up_time);
        end
        //////////////////////////////////////////////////////////// temperature int
        fp_intf.out_data = 1'b0;
        tick(50);
        fp_intf.out_data = 1'b1;
        tick(26);
        trans.sw_40bit = {trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]};

        for (int i = 0; i < 7; i++) begin
            trans.randomize();
            fp_intf.out_data = 1'b0;
            tick(50);
            fp_intf.out_data = 1'b1;
            tick(trans.set_up_time);
            // #2;
            if (trans.set_up_time > 40) begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b1, trans.sw_40bit[7:0]
                };
            end else begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]
                };
            end

            $display("%d", trans.set_up_time);
        end
        //////////////////////////////////////////////////////////// temperature dec
        fp_intf.out_data = 1'b0;
        tick(50);
        fp_intf.out_data = 1'b1;
        tick(26);
        trans.sw_40bit = {trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]};

        for (int i = 0; i < 7; i++) begin
            trans.randomize();
            fp_intf.out_data = 1'b0;
            tick(50);
            fp_intf.out_data = 1'b1;
            tick(trans.set_up_time);
            // #2;
            if (trans.set_up_time > 40) begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b1, trans.sw_40bit[7:0]
                };
            end else begin
                trans.sw_40bit = {
                    trans.sw_40bit[38:8], 1'b0, trans.sw_40bit[7:0]
                };
            end

            $display("%d", trans.set_up_time);
        end
        /////////////////////////////////////////////////////////// check sum
        trans.sw_40bit[7:0] = trans.sw_40bit[39:32] + trans.sw_40bit[31:24] + trans.sw_40bit[23:16] + trans.sw_40bit[15:8];
        for (int i = 0; i < 8; i++) begin
            if (trans.sw_40bit[7-i] == 1) begin
                fp_intf.out_data = 1'b0;
                tick(50);
                fp_intf.out_data = 1'b1;
                tick(70);
            end else begin
                fp_intf.out_data = 1'b0;
                tick(50);
                fp_intf.out_data = 1'b1;
                tick(27);
            end
        end


        fp_intf.out_data = 1'b0;
        tick(50);
        fp_intf.out_data = 1'b1;
        tick(27);

    endtask  //start_dht11

    task run();
        forever begin
            gen2drv_mbox.get(trans);
            fp_intf.hum_int  = trans.hum_int;
            fp_intf.hum_dec  = trans.hum_dec;
            fp_intf.tem_int  = trans.tem_int;
            fp_intf.tem_dec  = trans.tem_dec;
            fp_intf.checksum = trans.checksum;
            #1;
            // fp_intf.rand_hum_tem = trans.rand_hum_tem;
            trans.display("DRV");
            // dht11_trigger();
            // send_start_signal_high();
            start_dht11();
            #1;
            fp_intf.sw_40bit = trans.sw_40bit;
            #1;
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
            repeat (5) @(posedge fp_intf.clk);
            trans.hum_int  = fp_intf.hum_int;
            trans.hum_dec  = fp_intf.hum_dec;
            trans.tem_int  = fp_intf.tem_int;
            trans.tem_dec  = fp_intf.tem_dec;
            trans.checksum = fp_intf.checksum;
            trans.sw_40bit = fp_intf.sw_40bit;
            // trans.rand_hum_tem = fp_intf.rand_hum_tem;
            @(posedge fp_intf.clk);
            mon2scb_mbox.put(trans);
            trans.display("MON");
            #2;
            ->scb_next_event;
        end
    endtask  //run
endclass  //monitor

class scoreboard;
    transaction                  trans;

    mailbox #(transaction)       mon2scb_mbox;
    event                        gen_next_event;
    event                        scb_next_event;

    // reg                    [39:0] sw_result;
    reg                    [7:0] sw_hum_int;
    reg                    [7:0] sw_hum_dec;
    reg                    [7:0] sw_tem_int;
    reg                    [7:0] sw_tem_dec;
    reg                    [7:0] sw_checksum;

    int                          total_cnt,      pass_cnt, fail_cnt;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event,
                 event scb_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        this.scb_next_event = scb_next_event;
        // sw_result           = 0;
        sw_hum_int          = 0;
        sw_hum_dec          = 0;
        sw_tem_int          = 0;
        sw_tem_dec          = 0;
        sw_checksum         = 0;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;
    endfunction  //new()

    task run();
        forever begin
            @(scb_next_event);
            mon2scb_mbox.get(trans);
            $display("PASS1");
            sw_hum_int  = trans.sw_40bit[39:32];
            sw_hum_dec  = trans.sw_40bit[31:24];
            sw_tem_int  = trans.sw_40bit[23:16];
            sw_tem_dec  = trans.sw_40bit[15:8];
            sw_checksum = trans.sw_40bit[7:0];
            #5;
            if (sw_hum_int == trans.hum_int && sw_hum_dec == trans.hum_dec && sw_tem_int == trans.tem_int && sw_tem_dec == trans.tem_dec) begin
                $display("PASS!!!!");
                pass_cnt++;
            end else begin
                $display("FAIL....");
                fail_cnt++;
            end
            total_cnt++;
            $display("hardware : %d,    software : %d", trans.hum_int,
                     sw_hum_int);
            $display("hardware : %d,    software : %d", trans.hum_dec,
                     sw_hum_dec);
            $display("hardware : %d,    software : %d", trans.tem_int,
                     sw_tem_int);
            $display("hardware : %d,    software : %d", trans.tem_dec,
                     sw_tem_dec);
            $display("hardware : %d,    software : %d", trans.checksum,
                     sw_checksum);
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
            gen.run(10000);
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

module tb_floating_point ();

    fp_interface fp_intf ();

    environment env;

    floating_point_adder dut (
        .a(fp_intf.a),
        .b(fp_intf.b),
        .result(fp_intf.result),
        .overflow(fp_intf.overflow),
        .underflow(fp_intf.underflow)
    );

    initial begin
        env = new(fp_intf);
        env.run_test();
    end

endmodule

