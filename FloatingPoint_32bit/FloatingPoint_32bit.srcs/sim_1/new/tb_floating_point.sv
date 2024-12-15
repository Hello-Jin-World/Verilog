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
//     reg [31:0] a, b;
//     wire [31:0] result;
//     wire overflow, underflow;

//     // DUT 인스턴스화
//     floating_point_adder dut (
//         .a(a),
//         .b(b),
//         .result(result),
//         .overflow(overflow),
//         .underflow(underflow)
//     );

//     // 테스트 시퀀스
//     initial begin
//         // 테스트 케이스 1: 양의 정규화된 숫자 덧셈
//         a = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         b = 32'b0_01111110_00000000000000000000000;  // 0.5 (IEEE 754)
//         #10;
//         $display("Test Case 1: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         // 테스트 케이스 2: 부호가 다른 숫자 덧셈
//         a = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         b = 32'b1_01111111_00000000000000000000000;  // -1.0 (IEEE 754)
//         #10;
//         $display("Test Case 2: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         // 테스트 케이스 3: 큰 오버플로우 케이스
//         a = 32'b0_11111110_11111111111111111111111;  // 최대 양의 값 (IEEE 754)
//         b = 32'b0_01111111_00000000000000000000000;  // 1.0 (IEEE 754)
//         #10;
//         $display("Test Case 3: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

//         // 테스트 케이스 4: 작은 언더플로우 케이스
//         a = 32'b0_00000001_00000000000000000000000;  // 가장 작은 정규화된 수
//         b = 32'b0_00000000_00000000000000000000001;  // 가장 작은 비정규화된 수
//         #10;
//         $display("Test Case 4: %h + %h = %h (Overflow: %b, Underflow: %b)", a,
//                  b, result, overflow, underflow);

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
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] result;
    logic        overflow;
    logic        underflow;
    // logic [31:0] sw_result;
    // logic        sw_overflow;
    // logic        sw_underflow;
endinterface  //fp_interface

class transaction;
    rand logic [31:0] a;
    rand logic [31:0] b;
    logic      [31:0] result;
    logic             overflow;
    logic             underflow;


    // constraint exp_diff {
    //     abs(a[30:23] - b[30:23]) <= 5;  // 지수 차이를 5 이하로 제한
    // }

    // function int abs(input int value);
    //     return (value < 0) ? -value : value;
    // endfunction

    // logic      [31:0] sw_result;
    // logic             sw_overflow;
    // logic             sw_underflow;

    // constraint range {
    //     set_up_time dist {
    //         26 :/ 80,
    //         70 :/ 20
    //     };
    // }

    //constraint value_c {set_up_time inside {26, 70};}

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
        fp_intf.a         <= 0;
        fp_intf.b         <= 0;
        fp_intf.result    <= 0;
        fp_intf.overflow  <= 0;
        fp_intf.underflow <= 0;
        // fp_intf.sw_result    <= 0;
        // fp_intf.sw_overflow  <= 0;
        // fp_intf.sw_underflow <= 0;
        // fp_intf.tem <= 0;
        $display("[DRV] DUT Reset Done!");
        $display("---------------------");
    endtask


    task run();
        forever begin
            gen2drv_mbox.get(trans);
            #10;
            fp_intf.a         = trans.a;
            fp_intf.b         = trans.b;
            // fp_intf.a[30]     = 1;
            // fp_intf.b[30]     = 1;
            fp_intf.result    = trans.result;
            fp_intf.overflow  = trans.overflow;
            fp_intf.underflow = trans.underflow;
            // fp_intf.sw_result    = trans.sw_result;
            // fp_intf.sw_overflow  = trans.sw_overflow;
            // fp_intf.sw_underflow = trans.sw_underflow;
            trans.display("DRV");
            ->mon_next_event;
            // $display("Time: %0t, Event: mon_next_event triggered", $time);
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
            trans.a         = fp_intf.a;
            trans.b         = fp_intf.b;
            trans.result    = fp_intf.result;
            trans.overflow  = fp_intf.overflow;
            trans.underflow = fp_intf.underflow;
            // trans.sw_result    = fp_intf.sw_result;
            // trans.sw_overflow  = fp_intf.sw_overflow;
            // trans.sw_underflow = fp_intf.sw_underflow;
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

    int                           total_cnt,      pass_cnt,     fail_cnt;

    logic                         a_signed_bit,   b_signed_bit;
    logic                  [ 7:0] a_exp,          b_exp;
    logic                  [ 7:0] temp_exp;
    logic                  [23:0] a_man,          b_man;
    logic                  [23:0] sum_man;
    logic                         result_sign;
    logic                  [22:0] result_man;
    logic                  [31:0] sw_result;
    logic                         sw_overflow;
    logic                         sw_underflow;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event,
                 event scb_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        this.scb_next_event = scb_next_event;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;
        a_signed_bit        = 0;
        a_exp               = 0;
        temp_exp            = 0;
        a_man               = 0;
        sum_man             = 0;
        result_sign         = 0;
        result_man          = 0;
        b_signed_bit        = 0;
        b_exp               = 0;
        b_man               = 0;
    endfunction  //new()

    task add_run();
        // 초기 값 설정
        a_signed_bit = trans.a[31];
        b_signed_bit = trans.b[31];
        a_exp = trans.a[30:23];
        b_exp = trans.b[30:23];
        a_man = {1'b1, trans.a[22:0]};  // 가수에 1을 추가 (암시적 1)
        b_man = {1'b1, trans.b[22:0]};  // 가수에 1을 추가 (암시적 1)

        // 작은 지수에 맞춰 가수 시프트
        if (a_exp < b_exp) begin
            b_man = b_man >> (a_exp - b_exp);  // b의 가수를 a의 지수에 맞게 시프트
            temp_exp = a_exp;
        end else if (a_exp > b_exp) begin
            a_man = a_man >> (b_exp - a_exp);  // a의 가수를 b의 지수에 맞게 시프트
            temp_exp = b_exp;
        end else begin
            temp_exp = a_exp;
        end

        // 부호가 같은 경우 더하고, 다른 경우 뺀다
        if (a_signed_bit == b_signed_bit) begin
            sum_man = a_man + b_man;
            result_sign = a_signed_bit;
        end else begin
            if (a_man > b_man) begin
                sum_man = a_man - b_man;
                result_sign = a_signed_bit;
            end else begin
                sum_man = b_man - a_man;
                result_sign = b_signed_bit;
            end
        end

        // 정규화: 가수가 25번째 비트를 넘을 경우 오른쪽으로 시프트
        if (sum_man[24]) begin
            sum_man  = sum_man >> 1'b1;
            temp_exp = temp_exp + 1;
        end else if (sum_man[23] == 0 && temp_exp > 0) begin
            // 가수의 MSB가 0이면 왼쪽으로 시프트하여 지수 감소
            sum_man  = sum_man << 1'b1;
            temp_exp = temp_exp - 1;
        end

        // 결과 값 정리
        result_man = sum_man[22:0];  // 결과 가수는 23비트로 설정
        sw_result  = {result_sign, temp_exp, result_man};  // 최종 결과

        // 오버플로우 및 언더플로우 체크
        if (temp_exp == 8'hff) begin
            sw_overflow = 1;  // 오버플로우
        end else if (temp_exp == 0 && result_man == 0) begin
            sw_underflow = 1;  // 언더플로우
        end else begin
            sw_overflow  = 0;
            sw_underflow = 0;
        end
    endtask  // add_run
    task run();
        forever begin
            @(scb_next_event);
            $display("Time: %0t, Event: scb_next_event triggered", $time);
            mon2scb_mbox.get(trans);
            add_run();
            #20;
            if (sw_result == trans.result) begin
                $display("PASS!!!!");
                pass_cnt++;
            end else begin
                $display("FAIL....");
                fail_cnt++;
            end
            total_cnt++;
            $display("hardware : %b,    software : %b", trans.result,
                     sw_result);
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
        .a        (fp_intf.a),
        .b        (fp_intf.b),
        .result   (fp_intf.result),
        .overflow (fp_intf.overflow),
        .underflow(fp_intf.underflow)
    );

    initial begin
        env = new(fp_intf);
        env.run_test();
    end

endmodule
