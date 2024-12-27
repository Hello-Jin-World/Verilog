`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/26 11:27:15
// Design Name: 
// Module Name: ov7670_SetData
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


module ov7670_SetData (
    input  logic        pclk,
    input  logic        reset,
    //ov7670 signal
    input  logic        href,
    input  logic        v_sync,
    input  logic [ 7:0] ov7670_data,
    // frame buffer signal
    output logic        we,
    output logic [16:0] wAddr,
    output logic [15:0] wData
);

    logic we_reg, we_next;
    logic [15:0] temp_reg, temp_next;
    logic [9:0] pixel_counter_reg, pixel_counter_next;
    logic [7:0] v_counter_reg, v_counter_next;

    assign we    = we_reg;
    assign wAddr = v_counter_reg * 320 + pixel_counter_reg[9:1];
    assign wData = temp_reg;

    always_ff @(posedge pclk, posedge reset) begin
        if (reset) begin
            we_reg            <= 0;
            temp_reg          <= 0;
            pixel_counter_reg <= 0;
            v_counter_reg     <= 0;
        end else begin
            we_reg            <= we_next;
            temp_reg          <= temp_next;
            pixel_counter_reg <= pixel_counter_next;
            v_counter_reg     <= v_counter_next;
        end
    end

    always_comb begin
        we_next            = we_reg;
        temp_next          = temp_reg;
        pixel_counter_next = pixel_counter_reg;
        if (href) begin
            if (pixel_counter_reg[0]) begin  // odd
                temp_next[15:8] = ov7670_data;  // 1st
                we_next         = 0;
            end else begin  // even
                temp_next[7:0] = ov7670_data;  // 2nd
                we_next        = 1;
            end
            pixel_counter_next = pixel_counter_reg + 1;
        end else begin
            we_next            = 0;
            temp_next          = 0;
            pixel_counter_next = 0;
        end
    end

    always_comb begin
        v_counter_next = v_counter_reg;
        if (!v_sync) begin
            if (pixel_counter_reg == 640 - 1) begin
                v_counter_next = v_counter_reg + 1;
            end
        end else begin
            v_counter_next = 0;
        end
    end
endmodule
