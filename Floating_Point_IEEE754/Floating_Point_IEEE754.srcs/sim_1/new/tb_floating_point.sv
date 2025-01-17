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

/*
module tb_floating_point ();
    reg clk, reset;
    reg [31:0] a_in, b_in;
    wire [31:0] y;
    wire overflow, underflow, busy;

    FPU dut (
        .clk      (clk),
        .reset    (reset),
        .a_in     (a_in),
        .b_in     (b_in),
        .y        (y),
        .overflow (overflow),
        .underflow(underflow),
        .busy     (busy)
    );

    // DUT 인스턴스화

    always #5 clk = ~clk;

    // 테스트 시퀀스
    initial begin
        clk   = 0;
        reset = 0;
        a_in  = 0;
        b_in  = 0;
        #10;
        reset = 1;
        repeat (10) @(posedge clk);
        // 테스트 케이스 1: 양의 정규화된 숫자 덧셈
        a_in = 32'b1_10000011_00110000111101101100011;  // 1.0 (IEEE 754)
        b_in = 32'b01000001100010111001000101110001;  // 0.5 (IEEE 754)
        $display("Test Case 1: %h + %h = %h", a_in, b_in, y);


        repeat (10) @(posedge clk);

        // 테스트 케이스 2: 부호가 다른 숫자 덧셈
        a_in = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
        b_in = 32'b1_01111111_00000000000000000000000;  // -1.0 (IEEE 754)
        $display("Test Case 2: %h + %h = %h", a_in, b_in, y);

        repeat (10) @(posedge clk);

        // 테스트 케이스 3: 큰 오버플로우 케이스
        a_in = 32'b0_11111110_11111111111111111111111;  // 최대 양의 값 (IEEE 754)
        b_in = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
        $display("Test Case 3: %h + %h = %h", a_in, b_in, y);

        repeat (10) @(posedge clk);


        // 테스트 케이스 4: 작은 언더플로우 케이스
        a_in = 32'b0_00000001_00000000000000000000000;  // 가장 작은 정규화된 수
        b_in = 32'b0_00000000_00000000000000000000001;  // 가장 작은 비정규화된 수
        $display("Test Case 4: %h + %h = %h", a_in, b_in, y);

        repeat (10) @(posedge clk);


    end
endmodule
*/

// module tb_floating_point ();
//     reg [31:0] a_in, b_in;
//     wire [31:0] y;

//     FPU dut (
//         .a_in(a_in),
//         .b_in(b_in),
//         .y   (y)
//     );

//     initial begin
//         #5;
//         // 테스트 케이스 1: 양의 정규화된 숫자 덧셈
//         a_in = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         b_in = 32'b0_01111110_00000000000000000000000;  // 0.5 (IEEE 754)
//         $display("Test Case 1: %h + %h = %h", a_in, b_in, y);

//         #5;

//         // 테스트 케이스 2: 부호가 다른 숫자 덧셈
//         a_in = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         b_in = 32'b1_01111111_00000000000000000000000;  // -1.0 (IEEE 754)
//         $display("Test Case 2: %h + %h = %h", a_in, b_in, y);

//         #5;

//         // 테스트 케이스 3: 큰 오버플로우 케이스
//         a_in = 32'b0_11111110_11111111111111111111111;  // 최대 양의 값 (IEEE 754)
//         b_in = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         $display("Test Case 3: %h + %h = %h", a_in, b_in, y);

//         #5;

//         // 테스트 케이스 4: 작은 언더플로우 케이스
//         a_in = 32'b0_00000001_00000000000000000000000;  // 가장 작은 정규화된 수
//         b_in = 32'b0_00000000_00000000000000000000001;  // 가장 작은 비정규화된 수
//         $display("Test Case 4: %h + %h = %h", a_in, b_in, y);

//         #5;

//         $finish;
//     end
// endmodule

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
        a[30:23] >= 8'b01111111;
        a[30:23] < 8'b10000111;
        b[30:23] >= 8'b01111111;
        b[30:23] < 8'b10000111;
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
            $display("1");
            fp_intf.a         = trans.a;
            fp_intf.b         = trans.b;
            fp_intf.overflow  = trans.overflow;
            fp_intf.underflow = trans.underflow;
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
            #1;
            $display("trans.a : %b", trans.a);
            $display("trans.b : %b", trans.b);
            $display("trans.result : %b", trans.result);
            $display("sw_result : %b", sw_result);
            $display("a_real : %f", a_real);
            $display("b_real : %f", b_real);
            $display("y_real : %f", y_real);
            $display("result_real : %f", result_real);

            if (y_real - result_real <= diff && y_real - result_real >= 0 || 
                result_real - y_real <= diff && result_real - y_real >= 0) begin
                $display("PASS!!!!");
                pass_cnt++;
            end else begin
                $display("FAIL....");
                fail_cnt++;
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
