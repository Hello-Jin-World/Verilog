`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/12 16:03:29
// Design Name: 
// Module Name: fnd_control_for_clock
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


module fnd_control_for_clock (
    input        clk,
    input        reset,
    input        sw_mode,
    input  [2:0] sel,
    input  [6:0] msec,          // 0.1sec
    input  [6:0] sec,           // 1sec
    input  [6:0] min,           // 1min
    input  [6:0] hour,          // 1hour
    output [7:0] fndfont
);

    wire [3:0] w_msec_digit_1, w_msec_digit_10;
    wire [3:0] w_sec_digit_1, w_sec_digit_10;
    wire [3:0] w_min_digit_1, w_min_digit_10;
    wire [3:0] w_hour_digit_1, w_hour_digit_10;
    wire [3:0] w_bcd, w_min_hour_bcd, w_sec_msec_bcd, w_dot;
    wire w_clk;



    digit_splitter_for_clock U_msec_splitter_for_clock (
        .digit(msec),
        .digit_1(w_msec_digit_1),
        .digit_10(w_msec_digit_10)
    );

    digit_splitter_for_clock U_sec_splitter_for_clock (
        .digit(sec),
        .digit_1(w_sec_digit_1),
        .digit_10(w_sec_digit_10)
    );

    digit_splitter_for_clock U_min_splitter_for_clock (
        .digit(min),
        .digit_1(w_min_digit_1),
        .digit_10(w_min_digit_10)
    );

    digit_splitter_for_clock U_hour_splitter_for_clock (
        .digit(hour),
        .digit_1(w_hour_digit_1),
        .digit_10(w_hour_digit_10)
    );

    comparator_for_clock U_msec_comparator_for_clock (
        .x(msec),
        .y(w_dot)
    );

    mux_8x1_for_clock U_msec_sec_mux_8x1_for_clock (
        .sel(sel),
        .x0 (w_msec_digit_1),
        .x1 (w_msec_digit_10),
        .x2 (w_sec_digit_1),
        .x3 (w_sec_digit_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (w_dot),
        .x7 (4'hf),
        .y  (w_sec_msec_bcd)
    );

    mux_8x1_for_clock U_min_hour_mux_8x1_for_clock (
        .sel(sel),
        .x0 (w_min_digit_1),
        .x1 (w_min_digit_10),
        .x2 (w_hour_digit_1),
        .x3 (w_hour_digit_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (w_dot),
        .x7 (4'hf),
        .y  (w_min_hour_bcd)
    );

    mux_2x1_for_clock U_mux_2x1_for_clock (
        .sel(sw_mode),
        .x0 (w_sec_msec_bcd),
        .x1 (w_min_hour_bcd),
        .y  (w_bcd)
    );

    BCDtoSEG_decoder_for_clock U_BCDtoSEG_for_clock (
        .bcd(w_bcd),
        .seg(fndfont)
    );
endmodule



module digit_splitter_for_clock (
    input  [6:0] digit,
    output [3:0] digit_1,
    output [3:0] digit_10
);

    assign digit_1  = digit % 10;
    assign digit_10 = digit / 10 % 10;

endmodule

module mux_8x1_for_clock (
    input      [2:0] sel,
    input      [3:0] x0,
    input      [3:0] x1,
    input      [3:0] x2,
    input      [3:0] x3,
    input      [3:0] x4,
    input      [3:0] x5,
    input      [3:0] x6,
    input      [3:0] x7,
    output reg [3:0] y
);
    always @(*) begin  // all input
        case (sel)
            3'b000:  y = x0;
            3'b001:  y = x1;
            3'b010:  y = x2;
            3'b011:  y = x3;
            3'b100:  y = x4;
            3'b101:  y = x5;
            3'b110:  y = x6;
            3'b111:  y = x7;
            default: y = 4'bx;  // unknown
        endcase
    end

endmodule

module mux_2x1_for_clock (
    input            sel,
    input      [3:0] x0,
    input      [3:0] x1,
    output reg [3:0] y
);
    always @(*) begin  // all input
        case (sel)
            1'b0: y = x0;
            1'b1: y = x1;
            default: y = 4'bx;  // unknown
        endcase
    end

endmodule

module BCDtoSEG_decoder_for_clock (
    input [3:0] bcd,
    output reg [7:0] seg

);
    always @(bcd) begin
        case (bcd)
            4'h0: seg = 8'hc0;
            4'h1: seg = 8'hf9;
            4'h2: seg = 8'ha4;
            4'h3: seg = 8'hb0;
            4'h4: seg = 8'h99;
            4'h5: seg = 8'h92;
            4'h6: seg = 8'h82;
            4'h7: seg = 8'hf8;
            4'h8: seg = 8'h80;
            4'h9: seg = 8'h90;
            4'ha: seg = 8'h88;
            4'hb: seg = 8'h83;
            4'hc: seg = 8'hc6;
            4'hd: seg = 8'ha1;
            4'he: seg = 8'h7f;  // dot on
            4'hf: seg = 8'hff;  // dot off
            default: seg = 8'hff;
        endcase
    end
endmodule

module comparator_for_clock (
    input  [6:0] x,
    output [3:0] y
);

    assign y = (x < 50) ? 4'he : 4'hf;  // dot on : off
endmodule
