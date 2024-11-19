`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 15:49:26
// Design Name: 
// Module Name: tb_ram_systemverilog
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

interface ram_interface;
    logic       clk;
    logic [9:0] address;
    logic [7:0] w_data;
    logic       rw;
    logic [7:0] r_data;
endinterface  //ram_interface

class transaction;
    rand logic [9:0] address;
    rand logic [7:0] w_data;
    rand logic       rw;
    logic            r_data;
endclass  //transaction

class generator;

    virtual ram_interface v_ram_intf;
    transaction trans;

    function new(virtual ram_interface v_ram_intf);
        this.v_ram_intf = v_ram_intf;
        trans = new();
    endfunction  //new()

    task run();
        repeat (10000) begin
            trans.randomize();
            v_ram_intf.address = trans.address;
            v_ram_intf.w_data = trans.w_data;
            v_ram_intf.rw = trans.rw;
            trans.r_data = v_ram_intf.r_data;
            @(posedge v_ram_intf.clk);
        end
    endtask  //run

endclass  //generator

module tb_ram_systemverilog ();

    ram_interface ram_intf ();
    generator gen;

    // input            clk,
    // input      [9:0] address,
    // input      [7:0] w_data,
    // input            rw,
    // output reg [7:0] r_data
    //wire [7:0] r_data;

    ram dut (
        .clk(ram_intf.clk),
        .address(ram_intf.address),
        .w_data(ram_intf.w_data),
        .rw(ram_intf.rw),
        .r_data(ram_intf.r_data)
    );

    always #5 ram_intf.clk = ~ram_intf.clk;

    initial begin
        ram_intf.clk = 0;
        gen = new(ram_intf);
        gen.run();
    end
endmodule
