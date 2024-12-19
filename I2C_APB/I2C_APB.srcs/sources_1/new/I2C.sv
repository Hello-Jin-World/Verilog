`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 20:15:08
// Design Name: 
// Module Name: I2C
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


module I2C (
    input  logic clk,
    input  logic reset,
    input  logic addr,
    inout  logic SDA,
    output logic SCL
);

    always_ff @(posedge clk, posedge reset) begin

    end
endmodule

module temp_i2c (
    input  logic clk,
    input  logic reset,
    input  logic addr,
    input  logic pEdge,
    input  logic nEdge,
    inout  logic SDA,
    output logic SCL
);

    reg [3:0] state_reg, state_next;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg <= 0;
        end else begin
            state_reg <= state_next;
        end
    end


endmodule

module edge_detector (
    input  logic clk,
    input  logic reset,
    input  logic manual_clk,
    output logic pEdge,
    output logic nEdge
);
    reg ff_cur, ff_past;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            ff_cur  <= 0;
            ff_past <= 0;
        end else begin
            ff_cur  <= manual_clk;
            ff_past <= ff_cur;
        end
    end

    assign pEdge = (ff_cur == 1 && ff_past == 0) ? 1 : 0;  // detect rising edge
    assign nEdge = (ff_cur == 0 && ff_past == 1) ? 1 : 0; // detect falling edge
endmodule

module manual_clk (
    input  logic clk,
    input  logic reset,
    output logic manual_clk
);

    reg [$clog2(100_000) - 1 : 0] counter;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            manual_clk <= 0;
            counter    <= 0;
        end else begin
            if (counter == 100_000 - 1) begin
                manual_clk <= 1;
                counter    <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
