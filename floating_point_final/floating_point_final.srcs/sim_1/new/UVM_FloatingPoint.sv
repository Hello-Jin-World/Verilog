`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 21:13:24
// Design Name: 
// Module Name: UVM_FloatingPoint
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


interface fp_interface ();
    logic        clk;
    logic        resetn;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] result;
    logic        overflow;
    logic        underflow;
    logic        busy;
endinterface  //fp_interface

class seq_item extends uvm_sequence_item;
    rand logic [31:0] a;
    rand logic [31:0] b;
    logic      [31:0] result;
    logic             overflow;
    logic             underflow;
    logic             busy;

    function new(input string name = "seq_item");
        super.new(name);
    endfunction  //new()

    `uvm_object_utils_begin(seq_item)  // macro
        `uvm_field_int(a, UVM_DEFAULT)  // There is not ";"
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(result, UVM_DEFAULT)
        `uvm_field_int(overflow, UVM_DEFAULT)
        `uvm_field_int(underflow, UVM_DEFAULT)
        `uvm_field_int(busy, UVM_DEFAULT)
    `uvm_object_utils_end

    task display(string name);
        $display("[%s] random a : %b,  random b : %b", name, a, b);
    endtask  //$display("");

endclass  //seq_item extends uvm_sequence_item

class fp_sequence extends uvm_sequence;
    `uvm_object_utils(fp_sequence)

    seq_item reg_seq_item;  // handler

    function new(input string name = "fp_sequence");
        super.new(name);
    endfunction  //new()

    virtual task body();
        reg_seq_item =
            seq_item::type_id::create("SEQ_ITEM");  // create instance
        repeat (1000) begin
            start_item(reg_seq_item);
            reg_seq_item.randomize();
            `uvm_info("SEQ", "Data send to Driver", UVM_NONE);
            finish_item(reg_seq_item);
        end
    endtask
endclass  //fp_sequence extends uvm_sequence

class fp_driver extends uvm_driver #(seq_item);  // receive seq_time
    `uvm_component_utils(fp_driver)

    virtual fp_interface fpIntf;
    seq_item             reg_seq_item;


    function new(input string name = "fp_driver", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reg_seq_item = seq_item::type_id::create("SEQ_ITEM", this);
        if (!uvm_config_db#(virtual fp_interface)::get(
                this, ",", "fpIntf", fpIntf
            ))
            `uvm_fatal(get_name(), "Unable to access adder interface");
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        $display("display start of simulation phase!");
    endfunction

    virtual task run_phase(uvm_phase phase);
        $display("display run phase!");
        forever begin
            seq_item_port.get_next_item(reg_seq_item);
            fpIntf.a = reg_seq_item.a;
            fpIntf.b = reg_seq_item.b;
            wait (fpIntf.busy == 1);
            `uvm_info("DRV", "Send data to DUT", UVM_NONE);
            seq_item_port.item_done();
            wait (fpIntf.busy == 0);
        end
    endtask  //run_phase
endclass  //fp_driver extends uvm_driver #(seq_item)

class fp_monitor extends uvm_monitor;
    `uvm_component_utils(fp_monitor)

    uvm_analysis_port #(seq_item) send;
    virtual fp_interface fpIntf;
    seq_item reg_seq_item;

    function new(input string name = "fp_monitor", uvm_component c);
        super.new(name, c);
        send = new("WRITE", this);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        reg_seq_item = seq_item::type_id::create("SEQ_ITEM", this);
        if (!uvm_config_db#(virtual fp_interface)::get(
                this, "", "fpIntf", fpIntf
            )) begin
            `uvm_fatal(get_name(), "Unable to access reg interface");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait (fpIntf.busy == 1);
            #2;
            // Never be changed input data from interface.
            wait (fpIntf.busy == 0);
            reg_seq_item.a         = fpIntf.a;
            reg_seq_item.b         = fpIntf.b;
            reg_seq_item.result    = fpIntf.result;
            reg_seq_item.overflow  = fpIntf.overflow;
            reg_seq_item.underflow = fpIntf.underflow;

            `uvm_info("MON", "Send data to Scoreboard", UVM_NONE);
            send.write(reg_seq_item);
        end
    endtask  //run_phase
endclass  //fp_monitor extends uvm_monitor

class fp_scoreboard extends uvm_scoreboard;
    shortreal        a_real;
    shortreal        b_real;
    shortreal        y_real;
    shortreal        result_real;
    logic     [31:0] sw_result;
    shortreal        diff         = 0.0001;
    int              total_cnt,             pass_cnt, fail_cnt;

    `uvm_component_utils(fp_scoreboard)
    uvm_analysis_imp #(seq_item, fp_scoreboard) recv;

    function new(input string name = "fp_scoreboard", uvm_component c);
        super.new(name, c);
        recv        = new("READ", this);
        total_cnt   = 0;
        pass_cnt    = 0;
        fail_cnt    = 0;
        a_real      = 0;
        b_real      = 0;
        y_real      = 0;
        result_real = 0;
        sw_result   = 0;
    endfunction  //new()

    virtual function void write(seq_item data);
        a_real = $bitstoshortreal(data.a);
        b_real = $bitstoshortreal(data.b);
        y_real = a_real + b_real;
        result_real = $bitstoshortreal(data.result);
        sw_result = $shortrealtobits(y_real);

        if (y_real - result_real <= diff && y_real - result_real >= 0 || 
                result_real - y_real <= diff && result_real - y_real >= 0 ||
                data.result - sw_result <= 32'd12 && data.result - sw_result >= 32'd0 ||
                sw_result - data.result <= 32'd12 && sw_result - data.result >= 32'd0 ||
                data.result == sw_result) begin
            `uvm_info("SCB", $sformatf("PASS!!!, sw: %b == hw: %b", sw_result,
                                       data.result), UVM_NONE);
            $display("Diff : %d", (y_real - result_real) / 100);
            pass_cnt++;
        end else begin
            if ((sw_result[30:23] == 8'hff) && data.overflow == 1) begin
                `uvm_info("SCB", $sformatf("PASS!!!, sw: %b == hw: %b",
                                           sw_result, data.result), UVM_NONE);
                pass_cnt++;
            end else if ((sw_result[30:23] == 8'h00) && data.underflow == 1) begin
                `uvm_info("SCB", $sformatf("PASS!!!, sw: %b == hw: %b",
                                           sw_result, data.result), UVM_NONE);
                pass_cnt++;
            end else begin
                `uvm_info("SCB", $sformatf("FAIL..., sw: %b != hw: %b",
                                           sw_result, data.result), UVM_NONE);
                fail_cnt++;
            end
        end
        total_cnt++;
        data.print(uvm_default_line_printer);

        $display("====================================");
        $display("Total Test : %d ", total_cnt);
        $display("========     Oper Result    ========");
        $display(" Pass Test : %d ", pass_cnt);
        $display(" Fail Test : %d ", fail_cnt);
        $display("====================================");
    endfunction
endclass  //fp_scoreboard extends uvm_scoreboard;

class fp_agent extends uvm_agent;
    `uvm_component_utils(fp_agent)

    fp_monitor regMonitor;
    fp_driver regDriver;
    uvm_sequencer #(seq_item) regSequencer;

    function new(input string name = "fp_agent", uvm_component c);
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regMonitor   = fp_monitor::type_id::create("MON", this);
        regDriver    = fp_driver::type_id::create("DRV", this);
        regSequencer = uvm_sequencer#(seq_item)::type_id::create("SQR", this);
        //Create Instance        
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        regDriver.seq_item_port.connect(regSequencer.seq_item_export);
    endfunction
endclass  //fp_agent extends uvm_agent

covergroup pkt_cg with function sample (seq_item reg_seq_item);
    coverpoint reg_seq_item.a;
    coverpoint reg_seq_item.b;
endgroup

class packet_coverage extends uvm_subscriber #(seq_item);
    `uvm_component_utils(packet_coverage)

    pkt_cg tr_cov;
    bit coverage_enable = 1;

    function new(input string name = "packet_coverage", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        if (coverage_enable) begin
            tr_cov = new();
        end
    endfunction

    virtual function void write(seq_item data);
        if (coverage_enable) begin
            tr_cov.sample(data);
            $display("====================================");
            $display("Coverage = %0.2f %%", tr_cov.get_inst_coverage());
            $display("====================================");
        end
    endfunction
endclass

class fp_env extends uvm_env;
    `uvm_component_utils(fp_env)

    fp_scoreboard regScoreboard;
    fp_agent regAgent;
    packet_coverage cov_comp;

    function new(input string name = "fp_env", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regScoreboard = fp_scoreboard::type_id::create("SCB", this);
        regAgent      = fp_agent::type_id::create("AGENT", this);
        cov_comp      = packet_coverage::type_id::create("cov_comp", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        regAgent.regMonitor.send.connect(regScoreboard.recv);
        regAgent.regMonitor.send.connect(cov_comp.analysis_export);
    endfunction
endclass  //fp_env extendsuvm_env;

class fp_test extends uvm_test;
    `uvm_component_utils(fp_test)

    fp_sequence regSequence;
    fp_env regEnv;

    function new(input string name = "fp_test", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regSequence = fp_sequence::type_id::create("SEQ", this);
        regEnv      = fp_env::type_id::create("ENV", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        regSequence.start(regEnv.regAgent.regSequencer);
        phase.drop_objection(this);
    endtask
endclass  //fp_test extends uvm_test

module UVM_FloatingPoint ();

    fp_interface fpIntf ();
    fp_test fpTest;

    FPU dut (
        .clk      (fpIntf.clk),
        .reset    (fpIntf.resetn),
        .a_in     (fpIntf.a),
        .b_in     (fpIntf.b),
        .y        (fpIntf.result),
        .overflow (fpIntf.overflow),
        .underflow(fpIntf.underflow),
        .busy     (fpIntf.busy)
    );

    always #5 fpIntf.clk = ~fpIntf.clk;

    initial begin
        fpIntf.clk = 0;
        fpIntf.resetn = 0;
        #10;
        fpIntf.resetn = 1;
    end

    initial begin
        fpTest = new("32bit Register UVM Verification", null);
        uvm_config_db#(virtual fp_interface)::set(null, "*", "fpIntf", fpIntf);
        // db -> type : virtual fp_interface ,       key : "fpIntf" value : fpIntf
        run_test();
    end
endmodule
