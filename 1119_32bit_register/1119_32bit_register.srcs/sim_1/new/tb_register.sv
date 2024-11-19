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
    virtual reg_interface reg_intf;
    int i = 0;

    function new(virtual reg_interface reg_interf);  // create instance
        this.reg_intf = reg_interf;  // When create instance, operate this line
        trans = new();
    endfunction  //new()

    task reset();
        reg_intf.d <= 0;
        reg_intf.reset <= 1'b1;
        repeat (5) @(posedge reg_intf.clk);
        reg_intf.reset <= 1'b0;
        @(posedge reg_intf.clk);  // when appear clk edge, output data
    endtask  //reset

    task run(int count);
        repeat (count) begin
            assert (trans.randomize())
            else $display("[GEN] trans.radomize() error \n");  //error_process
            reg_intf.d = trans.data;
            $display("%d", i);
            trans.display("GEN_IN");
            @(posedge reg_intf.clk);  // when appear clk edge, output data
            trans.out = reg_intf.q;
            trans.display("GEN_OUT");
            i++;
        end
    endtask  //run int countor
endclass

module tb_register ();
    reg_interface reg_intf(); // When this moment, reg_interface be instantiation
    generator gen;

    register dut (  // connect interface cable with dut
        .clk  (reg_intf.clk),
        .reset(reg_intf.reset),
        .d    (reg_intf.d),
        .q    (reg_intf.q)
    );

    always #5 reg_intf.clk = ~reg_intf.clk;  // clk (interface member) toggle

    initial begin
        reg_intf.clk = 0;
        gen = new(reg_intf)
            ;  // connet interface(hardware) with generator(class, software)
        gen.reset();
        gen.run(10);
    end

endmodule
