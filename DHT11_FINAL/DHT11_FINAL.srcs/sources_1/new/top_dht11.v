`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 16:34:30
// Design Name: 
// Module Name: top_dht11
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


module top_dht11 (
    input        clk,
    input        reset,
    inout        ioport,
    input        sw_mode,
    input        dht_sw_clock_sw,
    input        btn_run_stop,
    input        btn_clear,
    // input  [7:0] u_command,
    output       tx,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire wr_en, tx_busy, tx_start, fifo_en, tx_done;
    wire [7:0] r_data;
    wire [7:0] hum_int;
    wire [7:0] hum_dec;
    wire [7:0] tem_int;
    wire [7:0] tem_dec;
    wire [7:0] fifo_data;

    wire [7:0] msec;
    wire [7:0] sec;
    wire [7:0] min;
    wire [7:0] hour;

    wire [7:0] data_a;
    wire [7:0] data_b;
    wire [7:0] data_c;
    wire [7:0] data_d;

    DHT11_control U_dht11_control (
        .clk    (clk),
        .reset  (reset),
        .ioport (ioport),
        .wr_en  (wr_en),
        .hum_int(hum_int),
        .hum_dec(hum_dec),
        .tem_int(tem_int),
        .tem_dec(tem_dec)
    );

    top_stopwatch U_top_stopwatch (
        .clk         (clk),
        .reset       (reset),
        .sw_mode     (sw_mode),
        .btn_run_stop(btn_run_stop),
        .btn_clear   (btn_clear),
        .u_command   (),
        .rx_done     (rx_done),
        .msec        (msec),
        .sec         (sec),
        .min         (min),
        .hour        (hour)
    );

    dht_swclock_switch U_dht_swclock_switch (
        .dht_sw_clock_sw(dht_sw_clock_sw),
        .hum_int        (hum_int),
        .hum_dec        (hum_dec),
        .tem_int        (tem_int),
        .tem_dec        (tem_dec),
        .msec           (msec),
        .sec            (sec),
        .min            (min),
        .hour           (hour),
        .data_a         (data_a),
        .data_b         (data_b),
        .data_c         (data_c),
        .data_d         (data_d)
    );

    fnd_controller U_fnd_controller (
        .clk      (clk),
        .reset    (reset),
        .sw_mode  (sw_mode),
        .u_command(),
        .msec     (data_a),
        .sec      (data_b),
        .min      (data_c),
        .hour     (data_d),
        .fndcom   (fndcom),
        .fndfont  (fndfont)
    );

    fifo_data U_fifo_data (
        .clk      (clk),
        .reset    (reset),
        .wr_en    (wr_en),
        .hum_int  (hum_int),
        .hum_dec  (hum_dec),
        .tem_int  (tem_int),
        .tem_dec  (tem_dec),
        .fifo_en  (fifo_en),
        .fifo_data(fifo_data)
    );


    fifo U_Tx_fifo (
        .clk  (clk),
        .reset(reset),
        .wdata(fifo_data),
        .wr_en(fifo_en),
        .rd_en(~tx_busy),
        .rdata(r_data),
        .full (),
        .empty(tx_start)
    );

    uart U_uart (
        .clk     (clk),
        .reset   (reset),
        .tx_start(~tx_start),
        .tx_data (r_data),
        .tx      (tx),
        .tx_busy (tx_busy),
        .tx_done (tx_done),
        .rx      (),
        .rx_data (),
        .rx_done ()
    );
endmodule

module dht_swclock_switch (
    input            dht_sw_clock_sw,
    input      [7:0] hum_int,
    input      [7:0] hum_dec,
    input      [7:0] tem_int,
    input      [7:0] tem_dec,
    input      [7:0] msec,
    input      [7:0] sec,
    input      [7:0] min,
    input      [7:0] hour,
    output reg [7:0] data_a,
    output reg [7:0] data_b,
    output reg [7:0] data_c,
    output reg [7:0] data_d
);

    always @(*) begin
        case (dht_sw_clock_sw)
            1'b0: begin
                data_a = msec;
                data_b = sec;
                data_c = min;
                data_d = hour;
            end
            1'b1: begin
                data_a = hum_dec;
                data_b = hum_int;
                data_c = tem_dec;
                data_d = tem_int;
            end
        endcase
    end

endmodule
