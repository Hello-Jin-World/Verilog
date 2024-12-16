`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 13:58:40
// Design Name: 
// Module Name: FPU
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


module FPU(
    input         clk,
    input         reset,
    input  [31:0] a_in,
    input  [31:0] b_in,
    output [31:0] y,
    output        overflow,
    output        underflow,
    output        busy
);

    reg [2:0] state_reg, state_next;
    reg busy_reg, busy_next;
    reg a_signed_reg, a_signed_next;
    reg b_signed_reg, b_signed_next;
    reg [7:0] a_exp_reg, a_exp_next;
    reg [7:0] b_exp_reg, b_exp_next;
    reg [7:0] temp_exp_reg, temp_exp_next;
    reg [23:0] a_man_reg, a_man_next;
    reg [23:0] b_man_reg, b_man_next;
    reg result_signed_reg, result_signed_next;
    reg [7:0] result_exp_reg, result_exp_next;
    reg [24:0] result_man_reg, result_man_next;
    reg [31:0] result_reg, reuslt_next;
    reg [31:0] a_reg, a_next;
    reg [31:0] b_reg, b_next;
    reg overflow_reg, overflow_next;

    assign y = result_reg;
    assign overflow = overflow_reg;  // overflow: 지수가 최대값
    assign underflow = (result_exp_reg == 8'b00000000 && result_man_reg != 0); // underflow: 지수가 0일 때 가수가 0이 아니면 underflow
    assign busy = busy_reg;


    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            state_reg         <= 0;
            busy_reg          <= 0;
            a_signed_reg      <= 0;
            b_signed_reg      <= 0;
            a_exp_reg         <= 0;
            b_exp_reg         <= 0;
            temp_exp_reg      <= 0;
            a_man_reg         <= 0;
            b_man_reg         <= 0;
            result_signed_reg <= 0;
            result_exp_reg    <= 0;
            result_man_reg    <= 0;
            result_reg        <= 0;
            a_reg             <= 0;
            b_reg             <= 0;
            overflow_reg      <= 0;
        end else begin
            state_reg         <= state_next;
            busy_reg          <= busy_next;
            a_signed_reg      <= a_signed_next;
            b_signed_reg      <= b_signed_next;
            a_exp_reg         <= a_exp_next;
            b_exp_reg         <= b_exp_next;
            temp_exp_reg      <= temp_exp_next;
            a_man_reg         <= a_man_next;
            b_man_reg         <= b_man_next;
            result_signed_reg <= result_signed_next;
            result_exp_reg    <= result_exp_next;
            result_man_reg    <= result_man_next;
            result_reg        <= reuslt_next;
            a_reg             <= a_next;
            b_reg             <= b_next;
            overflow_reg      <= overflow_next;
        end
    end

    localparam IDLE = 0, INITIAL = 1, MAN_SHIFT = 2, OPER = 3, RESULT_MAN_SHIFT = 4, DONE = 5;

    always @(*) begin
        state_next         = state_reg;
        busy_next          = busy_reg;
        a_signed_next      = a_signed_reg;
        b_signed_next      = b_signed_reg;
        a_exp_next         = a_exp_reg;
        b_exp_next         = b_exp_reg;
        temp_exp_next      = temp_exp_reg;
        a_man_next         = a_man_reg;
        b_man_next         = b_man_reg;
        result_signed_next = result_signed_reg;
        result_exp_next    = result_exp_reg;
        result_man_next    = result_man_reg;
        reuslt_next        = result_reg;
        a_next             = a_reg;
        b_next             = b_reg;
        overflow_next      = overflow_reg;
        case (state_reg)
            IDLE: begin
                // if (!busy_reg) begin
                if ((a_reg != a_in || b_reg != b_in) && !busy_reg) begin
                    state_next = INITIAL;
                    busy_next  = 1;
                end
                a_next             = a_in;
                b_next             = b_in;
                // busy_next  = 1;
                // end
                a_signed_next      = 0;
                b_signed_next      = 0;
                a_exp_next         = 0;
                b_exp_next         = 0;
                temp_exp_next      = 0;
                a_man_next         = 0;
                b_man_next         = 0;
                result_signed_next = 0;
                result_exp_next    = 0;
                result_man_next    = 0;
            end
            INITIAL: begin
                a_signed_next = a_reg[31];
                b_signed_next = b_reg[31];
                a_exp_next    = a_reg[30:23];
                b_exp_next    = b_reg[30:23];
                a_man_next    = {1'b1, a_reg[22:0]};
                b_man_next    = {1'b1, b_reg[22:0]};
                state_next    = MAN_SHIFT;
            end
            MAN_SHIFT: begin
                if (a_exp_reg == b_exp_reg) begin
                    result_signed_next = a_signed_reg;
                    result_exp_next    = a_exp_reg;
                    state_next         = OPER;
                end else begin
                    if (a_exp_reg > b_exp_reg) begin
                        b_man_next = b_man_reg >> (a_exp_reg - b_exp_reg);
                        result_exp_next = a_exp_reg;
                        result_signed_next = a_signed_reg;
                        state_next = OPER;
                    end else begin
                        a_man_next = a_man_reg >> (b_exp_reg - a_exp_reg);
                        result_exp_next = b_exp_reg;
                        result_signed_next = b_signed_reg;
                        state_next = OPER;
                    end
                end
            end
            OPER: begin
                if (a_signed_reg == b_signed_reg) begin
                    result_man_next = a_man_reg[23:0] + b_man_reg[23:0];
                end else begin
                    if (a_signed_reg == result_signed_reg) begin
                        result_man_next = a_man_reg[23:0] - b_man_reg[23:0];
                    end else begin
                        result_man_next = b_man_reg[23:0] - a_man_reg[23:0];
                    end
                end
                state_next = RESULT_MAN_SHIFT;
            end
            RESULT_MAN_SHIFT: begin
                if (result_exp_reg + 1 == 8'b00000000) begin
                    overflow_next = 1;
                    reuslt_next = {
                        result_signed_reg, result_exp_reg, result_man_reg[22:0]
                    };
                    busy_next = 0;
                    state_next = IDLE;
                    // state_next    = DONE;
                end else begin
                    if (result_man_reg[24] == 0 && result_man_reg[23] == 1  || result_man_reg == 0) begin
                        // state_next = DONE;         
                        reuslt_next = {
                            result_signed_reg,
                            result_exp_reg,
                            result_man_reg[22:0]
                        };
                        overflow_next = 0;
                        busy_next = 0;
                        state_next = IDLE;
                    end else begin
                        if (result_man_reg[24] == 1) begin
                            result_man_next = {1'b0, result_man_reg[24:1]};
                            result_exp_next = result_exp_reg + 1;
                        end else begin
                            result_man_next = {result_man_reg[23:0], 1'b0};
                            result_exp_next = result_exp_reg - 1;
                        end
                    end
                end
            end
            DONE: begin
                reuslt_next = {
                    result_signed_reg, result_exp_reg, result_man_reg[22:0]
                };
                overflow_next = 0;
                busy_next = 0;
                state_next = IDLE;
            end

        endcase
    end

endmodule

