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
    input         clk,
    input         reset,
    //input  [19:0] bcddata,
    output [ 3:0] fndcom,
    output [ 7:0] fndfont
);

    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000, w_bcd;
    wire [1:0] w_fndsel;
    wire w_clk;
    wire [13:0] w_bcddata;

    clk_div_100ms U_clk_div_100ms(
        .clk(clk),
        .reset(reset),
        .digit(w_bcddata)
    );

    clk_div U_clk_div(
        .clk(clk),
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

    digit_splitter U_digit_splitter (
        .digit(w_bcddata),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_4x1 U_mux_4x1 (
        .sel(w_fndsel),
        .x0 (w_digit_1),
        .x1 (w_digit_10),
        .x2 (w_digit_100),
        .x3 (w_digit_1000),
        .y  (w_bcd)
    );

    BCDtoSEG_decoder U_BCDtoSEG (
        .bcd(w_bcd),
        .seg(fndfont)
    );
endmodule

module clk_div_100ms (
    input  clk,
    input  reset,
    output [13:0] digit
);

    reg [23:0] r_counter;
    reg [13:0] r_digit;

    assign digit = r_digit; // enable 'output reg o_clk'

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_digit <= 14'b0;
        end
        else begin
            if (r_counter == 10_000_000 - 1) begin
                r_counter <= 0;
                r_digit <= r_digit + 1;
            end else begin
                r_counter <= r_counter + 1;
            end
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

    assign o_clk = r_clk; // enable 'output reg o_clk'

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end
        else begin
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
    input  [13:0] digit,
    output [ 3:0] digit_1,
    output [ 3:0] digit_10,
    output [ 3:0] digit_100,
    output [ 3:0] digit_1000
);

    assign digit_1 = digit % 10;
    assign digit_10 = digit / 10 % 10;
    assign digit_100 = digit / 100 % 10;
    assign digit_1000 = digit / 1000 % 10;
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
    output reg [4:0] switch_out
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
            4'he: seg = 8'h86;
            4'hf: seg = 8'h8e;
            default: seg = 8'hff;
        endcase
    end
endmodule

