`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 15:46:31
// Design Name: 
// Module Name: fnd_control
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

module fnd (
    input  logic        PCLK,
    input  logic        PRESET,
    // apb bus 
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic [ 3:0] fndcom,
    output logic [ 7:0] fndfont
);

    logic [13:0] count_data;

    APB_Intf_gpio apb_int_gpio (
        // global signal
        .pclk   (PCLK),
        .preset (PRESET),
        // apb bus 
        .paddr  (PADDR),
        .pwrite (PWRITE),
        .psel   (PSEL),
        .penable(PENABLE),
        .pwdata (PWDATA), 
        .prdata (PRDATA),
        .pready (PREADY),
        // port
        .mode   (count_data),
        .outData()
    );

    fnd_control_ip U_fnd_control_ip (
        .clk    (PCLK),
        .reset  (PRESET),
        .count  (count_data),  // 0.1sec
        .fndcom (fndcom),
        .fndfont(fndfont)
    );

endmodule

module APB_Intf_gpio (
    // global signal
    input  logic        pclk,
    input  logic        preset,
    // apb bus 
    input  logic [ 2:0] paddr,
    input  logic        pwrite,
    input  logic        psel,
    input  logic        penable,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    // port
    output logic [13:0] mode,
    output logic [ 3:0] outData
);

    logic [31:0] FND;
    logic [31:0] ODR;

    assign mode = FND[13:0];
    assign outData = ODR;

    always_ff @(posedge pclk) begin
        if (psel & pwrite & penable) begin
            case (paddr[2])
                1'b0: FND <= pwdata;
                1'b1: ODR <= pwdata;
            endcase
        end
    end

    always_ff @(posedge pclk) begin
        if (psel & !pwrite & penable) begin
            case (paddr[2])
                1'b0: prdata <= FND;
                1'b1: prdata <= ODR;
            endcase
        end
    end

    always_ff @(posedge pclk) begin
        if (psel & penable) pready <= 1'b1;
        else pready <= 1'b0;
    end
endmodule

module fnd_control_ip (
    input  logic        clk,
    input  logic        reset,
    input  logic [13:0] count,   // 0.1sec
    output logic [ 3:0] fndcom,
    output logic [ 7:0] fndfont
);

    wire [3:0] w_digit_1, w_digit_10;
    wire [3:0] w_digit_100, w_digit_1000;
    wire [2:0] w_fndsel;
    wire [3:0] w_bcd, w_min_hour_bcd, w_sec_msec_bcd, w_dot;
    wire w_clk;

    clk_div U_clk_div (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk)
    );

    counter U_counter (
        .clk    (w_clk),
        .reset  (reset),
        .counter(w_fndsel)
    );

    decoder_3x8 U_decoder_3x8 (
        .switch_in (w_fndsel),
        .switch_out(fndcom)
    );

    digit_splitter U_msec_splitter (
        .digit     (count),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    // comparator U_msec_comparator (
    //     .x(msec),
    //     .y(w_dot)
    // );

    mux_8x1 U_msec_sec_mux_8x1 (
        .sel(w_fndsel),
        .x0 (w_digit_1),
        .x1 (w_digit_10),
        .x2 (w_digit_100),
        .x3 (w_digit_1000),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (4'hf),
        .x7 (4'hf),
        .y  (w_sec_msec_bcd)
    );

    BCDtoSEG_decoder U_BCDtoSEG (
        .bcd(w_sec_msec_bcd),
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
    input  [13:0] digit,
    output [ 3:0] digit_1,
    output [ 3:0] digit_10,
    output [ 3:0] digit_100,
    output [ 3:0] digit_1000
);

    assign digit_1    = digit % 10;
    assign digit_10   = digit / 10 % 10;
    assign digit_100  = digit / 100 % 10;
    assign digit_1000 = digit / 1000 % 10;

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

// module mux_2x1 (
//     input            sel,
//     input      [3:0] x0,
//     input      [3:0] x1,
//     output reg [3:0] y
// );
//     always @(*) begin  // all input
//         case (sel)
//             1'b0: y = x0;
//             1'b1: y = x1;
//             default: y = 4'bx;  // unknown
//         endcase
//     end

// endmodule

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
    input  [6:0] x,
    output [3:0] y
);

    assign y = (x < 50) ? 4'he : 4'hf;  // dot on : off
endmodule

