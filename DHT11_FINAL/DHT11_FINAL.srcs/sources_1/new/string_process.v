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
        .probe3(a[counter_reg]),
        .probe4(counter_reg)
    );

    integer i;

    reg [7:0] a[0:15];
    reg [7:0] b[0:5];

    reg [3:0] counter_reg, counter_next;
    reg result_reg, result_next;

    assign result = result_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
            result_reg  <= 0;
        end else begin
            result_reg <= result_next;
            if (rx_done) begin
                a[counter_reg] <= rx_data;
                counter_next   <= counter_reg + 1;
            end else begin
                counter_reg <= counter_next;
            end
        end
    end

    always @(*) begin
        result_next = result_reg;
        if (a[0] == "r" && a[1] == "u" && a[2] == "n") begin
            result_next = 1;
        end else begin
            result_next = 0;
        end
    end
endmodule
