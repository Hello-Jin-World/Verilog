`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 13:28:43
// Design Name: 
// Module Name: fnd_controller
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


module fnd_controller (
    input        clk,
    input        reset,
    input        switch,
    input  [6:0] msec,    // 0.1sec
    input  [5:0] sec,     // 1sec
    input  [5:0] min,     // 1min
    input  [4:0] hour,    // 1hour
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire [3:0] w_msec_digit_1, w_msec_digit_10;
    wire [3:0] w_sec_digit_1, w_sec_digit_10;
    wire [3:0] w_min_digit_1, w_min_digit_10;
    wire [3:0] w_hour_digit_1, w_hour_digit_10;
    wire [3:0] w_bcd;
    wire [3:0] w_x0, w_x1, w_x2, w_x3;
    wire [1:0] w_fndsel;
    wire w_clk, w_dot;

    clk_div U_clk_div (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk)
    );

    counter U_counter (
        .clk(w_clk),
        .reset(reset),
        .counter(w_fndsel)
    );

    decoder_2x4 U_decoder_2x4 (
        .switch_in (w_fndsel),
        .switch_out(fndcom)
    );

    digit_splitter U_msec_splitter (
        .digit(msec),
        .digit_1(w_msec_digit_1),
        .digit_10(w_msec_digit_10)
    );

    digit_splitter U_sec_splitter (
        .digit({1'b0, sec}),
        .digit_1(w_sec_digit_1),
        .digit_10(w_sec_digit_10)
    );

    digit_splitter U_min_splitter (
        .digit({1'b0, min}),
        .digit_1(w_min_digit_1),
        .digit_10(w_min_digit_10)
    );

    digit_splitter U_hour_splitter (
        .digit({2'b00, hour}),
        .digit_1(w_hour_digit_1),
        .digit_10(w_hour_digit_10)
    );

    select_fnd U_select_fnd (
        .switch(switch),
        .msec_0(w_msec_digit_1),
        .msec_1(w_msec_digit_10),
        .sec_0(w_sec_digit_1),
        .sec_1(w_sec_digit_10),
        .min_0(w_min_digit_1),
        .min_1(w_min_digit_10),
        .hour_0(w_hour_digit_1),
        .hour_1(w_hour_digit_10),
        .x0(w_x0),
        .x1(w_x1),
        .x2(w_x2),
        .x3(w_x3),
        .dot(w_dot)
    );

    mux_4x1 U_mux_4x1 (
        .sel(w_fndsel),
        .x0 (w_x0),
        .x1 (w_x1),
        .x2 (w_x2),
        .x3 (w_x3),
        .y  (w_bcd)
    );

    BCDtoSEG_decoder U_BCDtoSEG (
        .bcd(w_bcd),
        .fndcom(fndcom),
        .dot(w_dot),
        .seg(fndfont)
    );
endmodule

module select_fnd (
    input            switch,
    input      [3:0] msec_0,
    input      [3:0] msec_1,
    input      [3:0] sec_0,
    input      [3:0] sec_1,
    input      [3:0] min_0,
    input      [3:0] min_1,
    input      [3:0] hour_0,
    input      [3:0] hour_1,
    output reg [3:0] x0,
    output reg [3:0] x1,
    output reg [3:0] x2,
    output reg [3:0] x3,
    output reg       dot
);

    always @(*) begin
        x0  = 0;
        x1  = 0;
        x2  = 0;
        x3  = 0;
        dot = 0;
        if (switch == 1'b1) begin
            x0 = msec_0;
            x1 = msec_1;
            x2 = sec_0;
            x3 = sec_1;
        end else begin
            x0 = min_0;
            x1 = min_1;
            x2 = hour_0;
            x3 = hour_1;
        end
        if (sec_0 % 2 == 0) begin
            dot = 1'b1;
        end else begin
            dot = 1'b0;
        end
    end

endmodule

module counter (
    input            clk,
    input            reset,
    output reg [1:0] counter
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module clk_div (
    input  clk,
    input  reset,
    output o_clk
);

    reg [16:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;  // enable 'output reg o_clk'

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

module digit_splitter (
    input  [6:0] digit,
    output [3:0] digit_1,
    output [3:0] digit_10
);

    assign digit_1  = digit % 10;
    assign digit_10 = digit / 10 % 10;

endmodule

module mux_4x1 (
    input [1:0] sel,
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    output reg [3:0] y
);


    always @(*) begin  // all input
        case (sel)
            2'b00:   y = x0;
            2'b01:   y = x1;
            2'b10:   y = x2;
            2'b11:   y = x3;
            default: y = 4'bx;  // unknown
        endcase
    end

endmodule

module decoder_2x4 (
    input [1:0] switch_in,
    output reg [3:0] switch_out
);

    always @(switch_in) begin
        case (switch_in)
            2'b00:   switch_out = 4'b1110;
            2'b01:   switch_out = 4'b1101;
            2'b10:   switch_out = 4'b1011;
            2'b11:   switch_out = 4'b0111;
            default: switch_out = 4'b1111;
        endcase
    end
endmodule


module BCDtoSEG_decoder (
    input [3:0] bcd,
    input dot,
    input [3:0] fndcom,
    output reg [7:0] seg

);

    always @(bcd, fndcom) begin
        if (fndcom == 4'b1011 & dot == 1'b1) begin
            case (bcd)
                4'h0: seg = 8'hc0 - 8'h80;
                4'h1: seg = 8'hf9 - 8'h80;
                4'h2: seg = 8'ha4 - 8'h80;
                4'h3: seg = 8'hb0 - 8'h80;
                4'h4: seg = 8'h99 - 8'h80;
                4'h5: seg = 8'h92 - 8'h80;
                4'h6: seg = 8'h82 - 8'h80;
                4'h7: seg = 8'hf8 - 8'h80;
                4'h8: seg = 8'h80 - 8'h80;
                4'h9: seg = 8'h90 - 8'h80;
                4'ha: seg = 8'h88 - 8'h80;
                4'hb: seg = 8'h83 - 8'h80;
                4'hc: seg = 8'hc6 - 8'h80;
                4'hd: seg = 8'ha1 - 8'h80;
                4'he: seg = 8'h86 - 8'h80;
                4'hf: seg = 8'h8e - 8'h80;
                default: seg = 8'hff;
            endcase
        end else begin
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
                4'he: seg = 8'h86;
                4'hf: seg = 8'h8e;
                default: seg = 8'hff;
            endcase
        end
    end
endmodule

