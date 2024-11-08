`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 10:53:47
// Design Name: 
// Module Name: counter_10000
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


module counter_10000 (
    input clk,
    input reset,
    output [3:0] fndcom,
    output [7:0] fndfont
);
wire w_tick;
wire [13:0] w_counter;

clock_div U_clock_div(
    .clk(clk),
    .reset(reset),
    .tick(w_tick)
);

counter_tick U_counter_tick(
    .clk(clk),
    .reset(reset),
    .tick(w_tick),
    .counter(w_counter)
);

fnd_controller U_fnd_controller(
    .clk(clk),
    .reset(reset),
    .bcddata(w_counter),
    .fndcom(fndcom),
    .fndfont(fndfont)
);
endmodule

module clock_div (
    input  clk,
    input  reset,
    output tick
);
    reg [$clog2(100_000) - 1 : 0] r_counter;  // auto calculate bit (log2)
    reg r_tick;

    assign tick = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_tick <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick <= 1'b0;
            end
        end
    end

endmodule

module counter_tick (
    input clk,
    input reset,
    input tick,
    output [13:0] counter
);
    reg [13:0] counter_reg, counter_next;

    // output logic
    assign counter = counter_reg;

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    // next combinational logic
    always @(*) begin
        counter_next = counter_reg;  // prediction useless latch
        if (tick == 1'b1) begin
            if (counter_reg == 10_000 - 1) begin
                counter_next = 0;
            end else begin
                counter_next = counter_reg + 1;
            end
        end
    end

endmodule
