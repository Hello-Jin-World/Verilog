`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 02:03:22
// Design Name: 
// Module Name: string_process
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


module string_process (
    input        clk,
    input        reset,
    input        rx_done,
    input  [7:0] rx_data,
    output       result

);

    ila_0 U_ila_0 (
        .clk(clk),
        .probe0(rx_done),
        .probe1(rx_data),
        .probe2(result),
        .probe3(mem)
    );

    reg [7:0] mem[0:15];
    reg [3:0] counter_reg, counter_next;
    reg result_reg, result_next;

    assign result = result_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
            result_reg  <= 0;
        end else begin
            counter_reg <= counter_next;
            result_reg  <= result_next;
        end
    end

    always @(*) begin
        counter_next = counter_reg;
        result_next  = result_reg;
        if (rx_done) begin
            mem[counter_reg] = rx_data;
            counter_next     = counter_reg + 1;
        end
        if (mem == "abcdefghijklmnop") begin
            result_next = 1;
        end else begin
            result_next = 0;
        end
    end
endmodule
