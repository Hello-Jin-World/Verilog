`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 09:55:48
// Design Name: 
// Module Name: check_dupl
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


module check_dupl (
    input      clk,
    input      reset,
    input      in_bit,
    output reg out_bit
);
    parameter COM = 2'b00, OUT_1 = 2'b01, OUT_0 = 2'b10;

    reg [1:0] state;
    reg [1:0] r_bit, r_bit_next;
    reg [1:0] r_counter, r_counter_next;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_bit          <= 0;
            r_bit_next     <= 0;
            r_counter      <= 0;
            r_counter_next <= 0;
            state          <= COM;
        end else begin
            r_bit_next <= r_bit_next << 1;
            r_bit <= r_bit_next;
            r_counter <= r_counter_next;
        end
    end

            
    always @(*) begin
        if (r_counter == 1) begin
            r_counter_next = 0;
            r_bit = r_bit_next;
            case (r_bit)
                2'b00:   state = OUT_1;
                2'b11:   state = OUT_1;
                2'b01:   state = OUT_0;
                2'b10:   state = OUT_0;
                default: state = 0;
            endcase
        end else begin
            r_counter_next = r_counter + 1;
            r_bit_next = r_bit_next + in_bit;
        end
    end
    always @(r_bit, q_reg) begin
        q_next = {i_btn, q_reg[N : 1]};  // general shift register code.
    end
    always @(*) begin
        case (state)
            OUT_0: begin
                out_bit = 0;
            end
            OUT_1: begin
                out_bit = 1;
            end
            default : out_bit = 0;
        endcase
    end
endmodule
