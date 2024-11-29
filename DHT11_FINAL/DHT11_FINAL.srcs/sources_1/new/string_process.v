`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 02:03:22
// Design Name: 
// Module Name: string_process
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


module string_process (
    input        clk,
    input        reset,
    input        rx_done,
    input        button3,
    input  [7:0] rx_data,
    output [7:0] set_hour,
    output [7:0] set_min,
    output [7:0] set_sec,
    output [7:0] set_msec,
    output [3:0] result
);

    localparam IDLE = 0, RUN = 1, STOP = 2, CLEAR = 3, MODE = 4, SET_TIME = 5, TIME_SET_ERROR = 6, MEASURE_DISTANCE = 7;

    integer i;

    reg [7:0] a[0:255];

    reg [7:0] counter_reg, counter_next;
    reg [3:0] result_reg, result_next;
    reg [3:0] time_setting_state_reg, time_setting_state_next;
    reg [7:0] set_hour_reg, set_hour_next;
    reg [7:0] set_min_reg, set_min_next;
    reg [7:0] set_sec_reg, set_sec_next;
    reg [7:0] set_msec_reg, set_msec_next;


    assign result   = result_reg;
    assign set_hour = set_hour_reg;
    assign set_min  = set_min_reg;
    assign set_sec  = set_sec_reg;
    assign set_msec = set_msec_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg  <= 0;
            result_reg   <= 0;
            set_hour_reg <= 0;
            set_min_reg  <= 0;
            set_sec_reg  <= 0;
            set_msec_reg <= 0;
        end else begin
            result_reg   <= result_next;
            set_hour_reg <= set_hour_next;
            set_min_reg  <= set_min_next;
            set_sec_reg  <= set_sec_next;
            set_msec_reg <= set_msec_next;
            if (rx_done) begin
                a[counter_reg] <= rx_data;
                counter_next   <= counter_reg + 1;
            end else begin
                if (result_reg != IDLE) begin
                    a[0] <= 0;
                    a[1] <= 0;
                    a[2] <= 0;
                    a[3] <= 0;
                    a[4] <= 0;
                    a[5] <= 0;
                    a[6] <= 0;
                    a[7] <= 0;
                    a[8] <= 0;
                    a[9] <= 0;
                    a[10] <= 0;
                    a[11] <= 0;
                    a[12] <= 0;
                    a[13] <= 0;
                    a[14] <= 0;
                    a[15] <= 0;
                    a[16] <= 0;
                    a[17] <= 0;
                    a[18] <= 0;
                    a[19] <= 0;
                    a[20] <= 0;
                    a[21] <= 0;
                    a[22] <= 0;
                    a[23] <= 0;
                    a[24] <= 0;
                    // for (i = 0; i < 256; i = i + 1) begin
                    //     a[i] <= 0;
                    // end
                    counter_next <= 0;
                end else begin
                    counter_reg <= counter_next;
                end
            end
        end
    end
    

    // localparam COMMAND_RUN = "run\n", COMMAND_;    

    


    always @(*) begin
        result_next   = result_reg;
        set_hour_next = set_hour_reg;
        set_min_next  = set_min_reg;
        set_sec_next  = set_sec_reg;
        set_msec_next = set_msec_reg;


        if (a[0] == "r" && a[1] == "u" && a[2] == "n" && a[3] == "\n") begin
            result_next = RUN;
        end else if (a[0] == "s" && a[1] == "t" && a[2] == "o" && a[3] == "p" && a[4] == "\n") begin
            result_next = STOP;
        end else if (a[0] == "c" && a[1] == "l" && a[2] == "e" && a[3] == "a" && a[4] == "r" && a[5] == "\n") begin
            result_next = CLEAR;
        end else if (a[0] == "m" && a[1] == "o" && a[2] == "d" && a[3] == "e" && a[4] == "\n") begin
            result_next = MODE;
        end else if (a[0] == "t" && a[1] == "i" && a[2] == "m" && a[3] == "e" && a[4] == " " && a[5] == "s" && a[6] == "e" && a[7] == "t" && a[8] == "t" && a[9] == "i" && a[10] == "n" && a[11] == "g" && a[12] == " " && a[24] == "\n") begin
            if (((a[13] - "0") * 10 + (a[14] - "0") > 23) || ((a[16] - "0") * 10 + (a[17] - "0") > 59) || ((a[19] - "0") * 10 + (a[20] - "0") > 59) || ((a[22] - "0") * 10 + (a[23] - "0") > 99)) begin
                result_next = TIME_SET_ERROR;
            end else begin
                set_hour_next = (a[13] - "0") * 10 + (a[14] - "0");
                set_min_next  = (a[16] - "0") * 10 + (a[17] - "0");
                set_sec_next  = (a[19] - "0") * 10 + (a[20] - "0");
                set_msec_next = (a[22] - "0") * 10 + (a[23] - "0");
                result_next   = SET_TIME;
            end
        end else if (a[0] == "m" && a[1] == "e" && a[2] == "a" && a[3] == "s" && a[4] == "u" && a[5] == "r" && a[6] == "e" && a[7] == "\n") begin
            result_next = MEASURE_DISTANCE;
        end else begin
            result_next = IDLE;
        end
        
        if (button3) begin
            result_next = MEASURE_DISTANCE;
        end
    end

    // TIME SETTING MODE
endmodule

