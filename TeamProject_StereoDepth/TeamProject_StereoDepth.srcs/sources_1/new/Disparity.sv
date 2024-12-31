`timescale 1ns / 1ps

module Disparity (
    input  logic        clk,
    input  logic        reset,
    output logic [14:0] rAddr,
    input  logic [15:0] data1,
    input  logic [15:0] data2,
    output logic [15:0] displayData
);
    localparam WIDTH = 160, HEIGHT = 120, BLOCK_SIZE = 3, NUM_DISPARITY = 15, FOCAL_LENGTH = 70, BASELINE = 10;
    logic [15:0] diff;
    logic [16:0] ssd;
    logic [15:0] current_data1, prv_data1;
    logic [15:0] current_data2, prv_data2;
    // logic [15:0] current_data1;
    // logic [15:0] current_data2;
    logic [14:0] rAddr_reg, rAddr_next;
    logic [15:0] data_reg, data_next;
    logic [15:0] gray1, gray2;
    logic state_reg, state_next;

    assign rAddr       = rAddr_reg;
    assign displayData = data_reg;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            rAddr_reg     <= 0;
            current_data1 <= 0;
            current_data2 <= 0;
            prv_data1     <= 0;
            prv_data2     <= 0;
            data_reg      <= 0;
            state_reg     <= 0;
            diff          <= 0;
            ssd           <= 0;
            gray1         <= 0;
            gray2         <= 0;
        end else begin
            rAddr_reg     <= rAddr_next;
            current_data1 <= data1;
            current_data2 <= data2;
            prv_data1     <= current_data1;
            prv_data2     <= current_data2;
            data_reg      <= data_next;
            state_reg     <= state_next;
        end
    end

    localparam RW = 8'h4c, GW = 8'h96, BW = 8'h1e;

    always_comb begin
        rAddr_next = rAddr_reg;
        data_next  = data_reg;
        state_next = state_reg;
        case (state_reg)
            0: begin
                if (current_data1 != prv_data1 || current_data2 != prv_data2) begin
                    gray1 = current_data1[15:11]*RW + current_data1[10:5]*GW + current_data1[4:0]*BW;
                    gray2 = current_data2[15:11]*RW + current_data2[10:5]*GW + current_data2[4:0]*BW;
                    // if (current_data1 != data1 || current_data2 != data2) begin
                    // if (data1 > data2) begin
                    //     diff[15:11] = data1[15:11] - data2[15:11];
                    //     diff[10:5]  = data1[10:5] - data2[10:5];
                    //     diff[4:0]   = data1[4:0] - data2[4:0];
                    // end else begin
                    //     diff[15:11] = data2[15:11] - data1[15:11];
                    //     diff[10:5]  = data2[10:5] - data1[10:5];
                    //     diff[4:0]   = data2[4:0] - data1[4:0];
                    // end
                    diff = (gray1 > gray2) ? (gray1 - gray2) : (gray2 - gray1);
                    ssd = diff * diff;
                    data_next = {ssd[15:11], ssd[15:10], ssd[15:11]};
                    state_next = 1;
                end
            end
            1: begin
                if (rAddr_reg == 160 * 120 - 1) begin
                    rAddr_next = 0;
                end else begin
                    rAddr_next = rAddr_reg + 1;
                end
                state_next = 0;
            end
        endcase
    end
endmodule




