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
    input        sw_clock_stopwatch,
    input        dht_sw_clock_sw,
    input        ultrasonic_active,
    input        button0,
    input        button1,
    input        button2,
    input        button3,
    input        echopulse,
    input        rx,
    // input  [7:0] u_command,
    output       tx,
    output       trigger,
    output [3:0] led,
    // output       string_command,
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire wr_en, tx_busy, tx_start, fifo_en, tx_done, rx_done, w_button3;
    wire [7:0] r_data;
    wire [7:0] hum_int;
    wire [7:0] hum_dec;
    wire [7:0] tem_int;
    wire [7:0] tem_dec;
    wire [7:0] fifo_data;
    wire [7:0] rx_data;

    wire [7:0] selected_msec;
    wire [7:0] selected_sec;
    wire [7:0] selected_min;
    wire [7:0] selected_hour;

    wire [7:0] data_a;
    wire [7:0] data_b;
    wire [7:0] data_c;
    wire [7:0] data_d;

    wire [7:0] set_hour;
    wire [7:0] set_min;
    wire [7:0] set_sec;
    wire [7:0] set_msec;

    wire [7:0] ultrasonic_1;
    wire [7:0] ultrasonic_10;
    wire [7:0] ultrasonic_100;
    wire [7:0] ultrasonic_1000;

    wire [3:0] string_command;

    wire [13:0] distance;
    wire measure_done;

    button_detector U_ultrasonic_button_detector (
        .clk  (clk),
        .reset(reset),
        .i_btn(button3),
        .o_btn(w_button3)
    );

    string_process U_string_process (
        .clk     (clk),
        .reset   (reset),
        .rx_done (rx_done),
        .rx_data (rx_data),
        .button3 (w_button3),
        .set_hour(set_hour),
        .set_min (set_min),
        .set_sec (set_sec),
        .set_msec(set_msec),
        .result  (string_command)
    );

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

    ultrasonic_top U_ultrasonic_top (
        .clk            (clk),
        .reset          (reset),
        .echopulse      (echopulse),
        .btn_start      (w_button3),
        .string_command (string_command),
        .trigger        (trigger),
        .measure_done   (measure_done),
        .ultrasonic_1   (ultrasonic_1),
        .ultrasonic_10  (ultrasonic_10),
        .ultrasonic_100 (ultrasonic_100),
        .ultrasonic_1000(ultrasonic_1000)
    );

    stopwatch_clock U_stopwatch_clock (
        .clk               (clk),
        .reset             (reset),
        .sw_mode           (sw_mode),
        .sw_clock_stopwatch(sw_clock_stopwatch),
        .button0           (button0),
        .button1           (button1),
        .button2           (button2),
        .u_command         (rx_data),
        .string_command    (string_command),
        .rx_done           (rx_done),
        .set_hour          (set_hour),
        .set_min           (set_min),
        .set_sec           (set_sec),
        .set_msec          (set_msec),
        .led               (led),
        .seleted_msec      (selected_msec),
        .seleted_sec       (selected_sec),
        .seleted_min       (selected_min),
        .seleted_hour      (selected_hour)
    );

    // top_stopwatch U_top_stopwatch (
    //     .clk         (clk),
    //     .reset       (reset),
    //     .sw_mode     (sw_mode),
    //     .btn_run_stop(btn_run_stop),
    //     .btn_clear   (btn_clear),
    //     .u_command   (rx_data),
    //     .rx_done     (rx_done),
    //     .msec        (msec),
    //     .sec         (sec),
    //     .min         (min),
    //     .hour        (hour)
    // );

    dht_swclock_switch U_dht_swclock_switch (
        .dht_sw_clock_sw  (dht_sw_clock_sw),
        .ultrasonic_active(ultrasonic_active),
        .hum_int          (hum_int),
        .hum_dec          (hum_dec),
        .tem_int          (tem_int),
        .tem_dec          (tem_dec),
        .msec             (selected_msec),
        .sec              (selected_sec),
        .min              (selected_min),
        .hour             (selected_hour),
        .ultrasonic_1     (ultrasonic_1),
        .ultrasonic_10    (ultrasonic_10),
        .ultrasonic_100   (ultrasonic_100),
        .ultrasonic_1000  (ultrasonic_1000),
        .data_a           (data_a),
        .data_b           (data_b),
        .data_c           (data_c),
        .data_d           (data_d)
    );

    fnd_controller U_fnd_controller (
        .clk              (clk),
        .reset            (reset),
        .sw_mode          (sw_mode),
        .ultrasonic_active(ultrasonic_active),
        .u_command        (rx_data),
        .string_command   (string_command),
        .msec             (data_a),
        .sec              (data_b),
        .min              (data_c),
        .hour             (data_d),
        .fndcom           (fndcom),
        .fndfont          (fndfont)
    );

    fifo_data U_fifo_data (
        .clk            (clk),
        .reset          (reset),
        .wr_en          (wr_en),
        .hum_int        (hum_int),
        .hum_dec        (hum_dec),
        .tem_int        (tem_int),
        .tem_dec        (tem_dec),
        .string_command (string_command),
        .set_hour       (set_hour),
        .set_min        (set_min),
        .set_sec        (set_sec),
        .set_msec       (set_msec),
        .ultrasonic_1   (ultrasonic_1),
        .ultrasonic_10  (ultrasonic_10),
        .ultrasonic_100 (ultrasonic_100),
        .ultrasonic_1000(ultrasonic_1000),
        .measure_done   (measure_done),
        .fifo_en        (fifo_en),
        .fifo_data      (fifo_data)
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
        .rx      (rx),
        .rx_data (rx_data),
        .rx_done (rx_done)
    );
endmodule

module dht_swclock_switch (
    input            dht_sw_clock_sw,
    input            ultrasonic_active,
    input      [7:0] hum_int,
    input      [7:0] hum_dec,
    input      [7:0] tem_int,
    input      [7:0] tem_dec,
    input      [7:0] msec,
    input      [7:0] sec,
    input      [7:0] min,
    input      [7:0] hour,
    input      [3:0] ultrasonic_1,
    input      [3:0] ultrasonic_10,
    input      [3:0] ultrasonic_100,
    input      [3:0] ultrasonic_1000,
    output reg [7:0] data_a,
    output reg [7:0] data_b,
    output reg [7:0] data_c,
    output reg [7:0] data_d
);

    always @(*) begin
        case ({
            dht_sw_clock_sw, ultrasonic_active
        })
            2'b00: begin
                data_a = msec;
                data_b = sec;
                data_c = min;
                data_d = hour;
            end
            2'b10: begin
                data_a = hum_dec;
                data_b = hum_int;
                data_c = tem_dec;
                data_d = tem_int;
            end
            2'b01: begin
                data_a = ultrasonic_10 * 10 + ultrasonic_1;
                data_b = ultrasonic_1000 * 10 + ultrasonic_100;
                data_c = 0;
                data_d = 0;
            end
            2'b11: ;
        endcase
    end

endmodule
