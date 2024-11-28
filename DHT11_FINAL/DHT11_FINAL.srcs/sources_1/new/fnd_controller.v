`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 16:34:17
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


module fnd_controller(
    input        clk,
    input        reset,
    input        sw_mode,
    input  [7:0] u_command,
    input  [7:0] msec,       // 0.1sec
    input  [7:0] sec,        // 1sec
    input  [7:0] min,        // 1min
    input  [7:0] hour,       // 1hour
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire [3:0] w_msec_digit_1, w_msec_digit_10;
    wire [3:0] w_sec_digit_1, w_sec_digit_10;
    wire [3:0] w_min_digit_1, w_min_digit_10;
    wire [3:0] w_hour_digit_1, w_hour_digit_10;
    wire [2:0] w_fndsel;
    wire [3:0] w_bcd, w_min_hour_bcd, w_sec_msec_bcd, w_dot;
    wire w_clk;

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

    decoder_3x8 U_decoder_3x8 (
        .switch_in (w_fndsel),
        .switch_out(fndcom)
    );

    digit_splitter U_msec_splitter (
        .digit(msec),
        .digit_1(w_msec_digit_1),
        .digit_10(w_msec_digit_10)
    );

    digit_splitter U_sec_splitter (
        .digit(sec),
        .digit_1(w_sec_digit_1),
        .digit_10(w_sec_digit_10)
    );

    digit_splitter U_min_splitter (
        .digit(min),
        .digit_1(w_min_digit_1),
        .digit_10(w_min_digit_10)
    );

    digit_splitter U_hour_splitter (
        .digit(hour),
        .digit_1(w_hour_digit_1),
        .digit_10(w_hour_digit_10)
    );

    comparator U_msec_comparator (
        .x(msec),
        .y(w_dot)
    );

    mux_8x1 U_msec_sec_mux_8x1 (
        .sel(w_fndsel),
        .x0 (w_msec_digit_1),
        .x1 (w_msec_digit_10),
        .x2 (w_sec_digit_1),
        .x3 (w_sec_digit_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (4'he),
        .x7 (4'hf),
        .y  (w_sec_msec_bcd)
    );

    mux_8x1 U_min_hour_mux_8x1 (
        .sel(w_fndsel),
        .x0 (w_min_digit_1),
        .x1 (w_mmin_digit_10),
        .x2 (w_hour_digit_1),
        .x3 (w_hour_digit_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (4'he),
        .x7 (4'hf),
        .y  (w_min_hour_bcd)
    );

    mux_2x1 U_mux_2x1 (
        .clk(clk),
        .reset(reset),
        .u_command(u_command),
        .sel(sw_mode),
        .x0(w_sec_msec_bcd),
        .x1(w_min_hour_bcd),
        .y(w_bcd)
    );

    BCDtoSEG_decoder U_BCDtoSEG (
        .bcd(w_bcd),
        .seg(fndfont)
    );
endmodule


module counter (
    input            clk,
    input            reset,
    output reg [2:0] counter
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
    input  [7:0] digit,
    output [3:0] digit_1,
    output [3:0] digit_10
);

    assign digit_1  = digit % 10;
    assign digit_10 = digit / 10 % 10;

    // assign digit_10  = digit[3:0];
    // assign digit_1 = digit[7:4];
endmodule

module mux_8x1 (
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

module mux_2x1 (
    input            clk,
    input            reset,
    input      [7:0] u_command,
    input            sel,
    input      [3:0] x0,
    input      [3:0] x1,
    output reg [3:0] y
);

    localparam STATE0 = 0, STATE1 = 1, STATE2 = 2, STATE3 = 3;

    reg command_sw_mode, command_sw_mode_next;
    reg [7:0] command_state, command_state_next;
    reg sw_state_reg, sw_state_next;
    reg toggle_sw_signal, toggle_sw_signal_next;
    reg [2:0] r_counter, r_counter_next;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            command_state <= 0;
            sw_state_reg <= 0;
            toggle_sw_signal <= 0;
            r_counter <= 0;
            command_sw_mode <= 0;
        end else begin
            command_state <= command_state_next;
            sw_state_reg <= sw_state_next;
            toggle_sw_signal <= toggle_sw_signal_next;
            command_state <= command_state_next;
            command_sw_mode <= command_sw_mode_next;
        end
    end

    always @(*) begin
        command_state_next = command_state;
        sw_state_next = sw_state_reg;
        toggle_sw_signal_next = toggle_sw_signal;
        r_counter_next = r_counter;
        case (sel)
            1'b0: sw_state_next = 0;
            1'b1: sw_state_next = 1;
            default: y = 4'bx;  // unknown
        endcase
        if (sw_state_reg != sw_state_next || command_sw_mode_next) begin
            toggle_sw_signal_next = ~toggle_sw_signal;
        end else begin
            toggle_sw_signal_next = toggle_sw_signal;
        end

        command_state_next = u_command;

        if ((command_state != command_state_next) & command_state == "m") begin
            command_sw_mode_next = 1;
        end else begin
            command_sw_mode_next = 0;
        end
    end

    always @(*) begin  // all input
        case (toggle_sw_signal)
            1'b0: y = x0;
            1'b1: y = x1;
            default: y = 4'bx;  // unknown
        endcase
    end

endmodule

module decoder_3x8 (
    input [2:0] switch_in,
    output reg [3:0] switch_out
);

    always @(switch_in) begin
        case (switch_in)
            3'b000:  switch_out = 4'b1110;
            3'b001:  switch_out = 4'b1101;
            3'b010:  switch_out = 4'b1011;
            3'b011:  switch_out = 4'b0111;
            3'b100:  switch_out = 4'b1110;
            3'b101:  switch_out = 4'b1101;
            3'b110:  switch_out = 4'b1011;
            3'b111:  switch_out = 4'b0111;
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
            4'he: seg = 8'h7f;  // dot on
            4'hf: seg = 8'hff;  // dot off
            default: seg = 8'hff;
        endcase
    end
endmodule

module comparator (
    input  [7:0] x,
    output [3:0] y
);

    assign y = (x < 50) ? 4'he : 4'hf;  // dot on : off
endmodule
