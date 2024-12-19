`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 14:08:37
// Design Name: 
// Module Name: UVM_GPIO
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

interface gpio_interface ();
    logic        PCLK;
    logic        PRESET;
    logic [ 3:0] PADDR;
    logic        PWRITE;
    logic        PSEL;
    logic        PENABLE;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    logic        PREADY;
    wire  [ 3:0] inoutPort;
endinterface  //gpio_interface

class seq_item extends uvm_sequence_item;
    rand logic [ 3:0] addr;
    rand logic        write;
    rand logic [31:0] wData;
    logic      [31:0] rData;
    logic      [ 3:0] inoutPort;

    constraint addr_c {addr <= 8;}

    function new(input string name = "seq_item");
        super.new(name);
    endfunction  //new()

    `uvm_object_utils_begin(seq_item)  // macro
        `uvm_field_int(addr, UVM_DEFAULT)  // Tere is not ";"
        `uvm_field_int(write, UVM_DEFAULT)
        `uvm_field_int(wData, UVM_DEFAULT)
        `uvm_field_int(rData, UVM_DEFAULT)
        `uvm_field_int(inoutPort, UVM_DEFAULT)
    `uvm_object_utils_end


endclass  //seq_item extends uvm_sequence_item

class gpio_sequence extends uvm_sequence;
    `uvm_object_utils(gpio_sequence)

    seq_item gpio_seq_item;  // handler

    function new(input string name = "gpio_sequence");
        super.new(name);
    endfunction  //new()

    virtual task body();
        gpio_seq_item =
            seq_item::type_id::create("SEQ_ITEM");  // create instance
        repeat (100) begin
            start_item(gpio_seq_item);
            gpio_seq_item.randomize();
            `uvm_info("SEQ", "Data send to Driver", UVM_NONE);
            finish_item(gpio_seq_item);
        end
    endtask
endclass  //gpio_sequence extends uvm_sequence

class gpio_driver extends uvm_driver #(seq_item);  // receive seq_time
    `uvm_component_utils(gpio_driver)

    virtual gpio_interface gpioIntf;
    seq_item               gpio_seq_item;


    function new(input string name = "gpio_driver", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpio_seq_item = seq_item::type_id::create("SEQ_ITEM", this);
        if (!uvm_config_db#(virtual gpio_interface)::get(
                this, ",", "gpioIntf", gpioIntf
            ))
            `uvm_fatal(get_name(), "Unable to access adder interface");
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        $display("display start of simulation phase!");
    endfunction

    task reset_gpio();
        gpioIntf.PRESET  = 1;
        gpioIntf.PSEL    = 0;
        gpioIntf.PENABLE = 0;
        #10;
        gpioIntf.PRESET = 0;
    endtask  //reset

    task write_gpio();
        gpioIntf.PADDR   = gpio_seq_item.addr;
        gpioIntf.PWRITE  = 1;
        gpioIntf.PSEL    = 1;
        gpioIntf.PENABLE = 0;
        gpioIntf.PWDATA  = gpio_seq_item.wData;
        @(posedge gpioIntf.PCLK);
        gpioIntf.PSEL    = 1;
        gpioIntf.PENABLE = 1;
        @(posedge gpioIntf.PREADY);
        @(posedge gpioIntf.PCLK);
        gpioIntf.PSEL    = 0;
        gpioIntf.PENABLE = 0;
    endtask  //write_gpio

    task read_gpio();
        gpioIntf.PADDR   = gpio_seq_item.addr;
        gpioIntf.PADDR   = 8'h04;
        gpioIntf.PWRITE  = 0;
        gpioIntf.PSEL    = 1;
        gpioIntf.PENABLE = 0;
        gpioIntf.PWDATA  = gpio_seq_item.wData;
        @(posedge gpioIntf.PCLK);
        gpioIntf.PENABLE   = 1;
        // gpioIntf.inoutPort = 1;
        @(posedge gpioIntf.PREADY);
        @(posedge gpioIntf.PCLK);
        gpioIntf.PSEL    = 0;
        gpioIntf.PENABLE = 0;
    endtask  //read_gpio

    virtual task run_phase(uvm_phase phase);
        $display("display run phase!");
        reset_gpio();
        forever begin
            seq_item_port.get_next_item(gpio_seq_item);
            if (gpio_seq_item.write) begin
                write_gpio();
            end else begin
                read_gpio();
            end
            `uvm_info("DRV", "Send data to DUT", UVM_NONE);
            #5;
            seq_item_port.item_done();
        end
    endtask  //run_phase
endclass  //gpio_driver extends uvm_driver #(seq_item)

class gpio_monitor extends uvm_monitor;
    `uvm_component_utils(gpio_monitor)

    uvm_analysis_port #(seq_item) send;
    virtual gpio_interface gpioIntf;
    seq_item gpio_seq_item;

    function new(input string name = "gpio_monitor", uvm_component c);
        super.new(name, c);
        send = new("WRITE", this);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        gpio_seq_item = seq_item::type_id::create("SEQ_ITEM", this);
        if (!uvm_config_db#(virtual gpio_interface)::get(
                this, "", "gpioIntf", gpioIntf
            )) begin
            `uvm_fatal(get_name(), "Unable to access reg interface");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge gpioIntf.PREADY);
            #3;
            gpio_seq_item.addr      = gpioIntf.PADDR;
            gpio_seq_item.write     = gpioIntf.PWRITE;
            gpio_seq_item.wData     = gpioIntf.PWDATA;
            gpio_seq_item.rData     = gpioIntf.PRDATA;
            gpio_seq_item.inoutPort = gpioIntf.inoutPort;
            `uvm_info("MON", "Send data to Scoreboard", UVM_NONE);
            send.write(gpio_seq_item);
        end
    endtask  //run_phase
endclass  //gpio_monitor extends uvm_monitor

class gpio_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(gpio_scoreboard)

    uvm_analysis_imp #(seq_item, gpio_scoreboard) recv;

    logic [31:0] scb_moder, scb_idr, scb_odr;

    function new(input string name = "gpio_scoreboard", uvm_component c);
        super.new(name, c);
        recv = new("READ", this);
    endfunction  //new()

    virtual function void write(seq_item data);
        `uvm_info("SCB", "Data received from Monitor", UVM_NONE);

        if (data.write) begin
            case (data.addr[3:2])
                2'b00: scb_moder = data.wData;
                2'b01: scb_idr = data.wData;
                2'b10: scb_odr = data.wData;
            endcase
        end else begin
            if (data.inoutPort == data.rData) begin
                `uvm_info("SCB", $sformatf("PASS!!!, io: %d == r: %d", data.inoutPort,
                                           data.rData), UVM_NONE);
            end else begin
                `uvm_info("SCB", $sformatf("FAIL..., io: %d != r: %d", data.inoutPort,
                                           data.rData), UVM_NONE);
            end
        end

        data.print(uvm_default_line_printer);
    endfunction
endclass  //gpio_scoreboard extends uvm_scoreboard;

class gpio_agent extends uvm_agent;
    `uvm_component_utils(gpio_agent)

    gpio_monitor gpioMonitor;
    gpio_driver gpioDriver;
    uvm_sequencer #(seq_item) gpioSequencer;

    function new(input string name = "gpio_agent", uvm_component c);
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpioMonitor   = gpio_monitor::type_id::create("MON", this);
        gpioDriver    = gpio_driver::type_id::create("DRV", this);
        gpioSequencer = uvm_sequencer#(seq_item)::type_id::create("SQR", this);
        //Create Instance        
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        gpioDriver.seq_item_port.connect(gpioSequencer.seq_item_export);
    endfunction
endclass  //gpio_agent extends uvm_agent

class gpio_env extends uvm_env;
    `uvm_component_utils(gpio_env)

    gpio_scoreboard gpioScoreboard;
    gpio_agent gpioAgent;

    function new(input string name = "gpio_env", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpioScoreboard = gpio_scoreboard::type_id::create("SCB", this);
        gpioAgent      = gpio_agent::type_id::create("AGENT", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        gpioAgent.gpioMonitor.send.connect(gpioScoreboard.recv);
    endfunction
endclass  //gpio_env extendsuvm_env;

class gpio_test extends uvm_test;
    `uvm_component_utils(gpio_test)

    gpio_sequence gpioSequence;
    gpio_env gpioEnv;

    function new(input string name = "gpio_test", uvm_component c);
        super.new(name, c);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpioSequence = gpio_sequence::type_id::create("SEQ", this);
        gpioEnv      = gpio_env::type_id::create("ENV", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        gpioSequence.start(gpioEnv.gpioAgent.gpioSequencer);
        phase.drop_objection(this);
    endtask
endclass  //gpio_test extends uvm_test

module UVM_GPIO ();

    gpio_interface gpioIntf ();
    gpio_test gpiotest;

    gpio dut (
        .PCLK     (gpioIntf.PCLK),
        .PRESET   (gpioIntf.PRESET),
        .PADDR    (gpioIntf.PADDR),
        .PWRITE   (gpioIntf.PWRITE),
        .PSEL     (gpioIntf.PSEL),
        .PENABLE  (gpioIntf.PENABLE),
        .PWDATA   (gpioIntf.PWDATA),
        .PRDATA   (gpioIntf.PRDATA),
        .PREADY   (gpioIntf.PREADY),
        .inoutPort(gpioIntf.inoutPort)
    );

    always #5 gpioIntf.PCLK = ~gpioIntf.PCLK;

    initial begin
        // `uvm_info("Test 1", "Hello World", UVM_NONE);
        // uvm_report_info("Test 2", "This is Reporting", UVM_MEDIUM);
        // uvm_report_info("Test 3", "This is Reporting", UVM_FULL);
        gpioIntf.PCLK = 0;
        gpioIntf.PRESET = 0;
        #10;
        gpioIntf.PRESET = 1;
    end

    initial begin
        gpiotest = new("32bit Register UVM Verification", null);
        uvm_config_db#(virtual gpio_interface)::set(null, "*", "gpioIntf",
                                                    gpioIntf);
        // db -> type : virtual gpio_interface ,       key : "gpioIntf" value : gpioIntf
        run_test();
    end
endmodule
