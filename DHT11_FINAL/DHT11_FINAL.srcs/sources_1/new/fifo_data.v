`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 14:35:51
// Design Name: 
// Module Name: fifo_data
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


module fifo_data (
    input        clk,
    input        reset,
    input        wr_en,
    input  [7:0] hum_int,
    input  [7:0] hum_dec,
    input  [7:0] tem_int,
    input  [7:0] tem_dec,
    input  [3:0] string_command,
    input  [7:0] set_hour,
    input  [7:0] set_min,
    input  [7:0] set_sec,
    input  [7:0] set_msec,
    input  [3:0] ultrasonic_1,
    input  [3:0] ultrasonic_10,
    input  [3:0] ultrasonic_100,
    input  [3:0] ultrasonic_1000,
    input        measure_done,
    output       fifo_en,
    output [7:0] fifo_data
);

    wire [3:0]
        hum_int1,
        hum_int10,
        hum_dec1,
        hum_dec10,
        tem_int1,
        tem_int10,
        tem_dec1,
        tem_dec10;

    digit_splitter hum_int_spl (
        .digit(hum_int),
        .digit_1(hum_int1),
        .digit_10(hum_int10)
    );
    digit_splitter hum_dec_spl (
        .digit(hum_dec),
        .digit_1(hum_dec1),
        .digit_10(hum_dec10)
    );
    digit_splitter tem_int_spl (
        .digit(tem_int),
        .digit_1(tem_int1),
        .digit_10(tem_int10)
    );
    digit_splitter tem_dec_spl (
        .digit(tem_dec),
        .digit_1(tem_dec1),
        .digit_10(tem_dec10)
    );

    wire [3:0]
        set_hour1,
        set_hour10,
        set_min1,
        set_min10,
        set_sec1,
        set_sec10,
        set_msec1,
        set_msec10;

    digit_splitter set_hour_spl (
        .digit   (set_hour),
        .digit_1 (set_hour1),
        .digit_10(set_hour10)
    );
    digit_splitter set_min_spl (
        .digit   (set_min),
        .digit_1 (set_min1),
        .digit_10(set_min10)
    );
    digit_splitter set_sec_spl (
        .digit   (set_sec),
        .digit_1 (set_sec1),
        .digit_10(set_sec10)
    );
    digit_splitter set_msec_spl (
        .digit   (set_msec),
        .digit_1 (set_msec1),
        .digit_10(set_msec10)
    );

    reg [7:0] state_reg, state_next;
    reg [7:0] fifo_data_reg, fifo_data_next;
    reg fifo_en_reg, fifo_en_next;

    localparam IDLE = 0, DATA_1 = 1, DATA_2 = 2, DATA_3 = 3, 
    DATA_4 = 4, DATA_5 = 5, DATA_6 = 6, DATA_7 = 7, DATA_8 = 8, 
    POINT0 = 9, POINT1 = 10, HUM1 = 11, HUM2 = 12, HUM3 = 13, HUM4 = 14, HUM5 = 15, HUM6 = 16, HUM7 = 17, HUM8 = 18,
    TEM1 = 19, TEM2 = 20, TEM3 = 21, TEM4 = 22, TEM5 = 23, TEM6 = 24, TEM7 = 25, TEM8 = 26, TEM9 = 27,
    TEM10 = 28, TEM11 = 29, COLON1 = 30, COLON2 = 31, COMMA = 32, CEL1 = 33, CEL2 = 34, PER = 35, SPACE = 36;

    localparam 
           SET_TIME1 = 37, 
           SET_TIME2 = 38, 
           SET_TIME3 = 39, 
           SET_TIME4 = 40, 
           SET_TIME5 = 41, 
           SET_TIME6 = 42, 
           SET_TIME7 = 43, 
           SET_TIME8 = 44, 
           SET_TIME9 = 45, 
           SET_TIME10 = 46, 
           SET_TIME11 = 47, 
           SET_TIME12 = 48, 
           SET_TIME13 = 49, 
           SET_TIME14 = 50, 
           SET_TIME15 = 51, 
           SET_TIME16 = 52, 
           SET_TIME17 = 53, 
           SET_TIME18 = 54, 
           SET_TIME19 = 55, 
           SET_TIME20 = 56, 
           SET_TIME21 = 57, 
           SET_TIME22 = 58, 
           SET_TIME23 = 59, 
           SET_TIME24 = 60, 
           SET_TIME25 = 61, 
           SET_TIME26 = 62, 
           SET_TIME27 = 63, 
           SET_TIME28 = 64, 
           SET_TIME29 = 65, 
           SET_TIME30 = 66, 
           SET_TIME31 = 67, 
           SET_TIME32 = 68, 
           SET_TIME33 = 69, 
           SET_TIME34 = 70, 
           SET_TIME35 = 71, 
           SET_TIME36 = 72, 
           SET_MESSAGE1 = 73,
           SET_MESSAGE2 = 74,
           SET_MESSAGE3 = 75,
           SET_MESSAGE4 = 76,
           NEW_LINE1 = 77,
           NEW_LINE2 = 78,
           DISTANCE1 = 79, 
           DISTANCE2 = 80, 
           DISTANCE3 = 81, 
           DISTANCE4 = 82, 
           DISTANCE5 = 83, 
           DISTANCE6 = 84, 
           DISTANCE7 = 85, 
           DISTANCE8 = 86, 
           DISTANCE9 = 87, 
           DISTANCE10 = 88, 
           DISTANCE11 = 89, 
           DISTANCE12 = 90, 
           DISTANCE13 = 91, 
           DISTANCE14 = 92, 
           DISTANCE15 = 93, 
           DISTANCE16 = 94,
           SET_TIME_ERROR1 = 95, 
           SET_TIME_ERROR2 = 96, 
           SET_TIME_ERROR3 = 97, 
           SET_TIME_ERROR4 = 98, 
           SET_TIME_ERROR5 = 99, 
           SET_TIME_ERROR6 = 100, 
           SET_TIME_ERROR7 = 101, 
           SET_TIME_ERROR8 = 102, 
           SET_TIME_ERROR9 = 103, 
           SET_TIME_ERROR10 = 104, 
           SET_TIME_ERROR11 = 105, 
           SET_TIME_ERROR12 = 106, 
           SET_TIME_ERROR13 = 107, 
           SET_TIME_ERROR14 = 108, 
           SET_TIME_ERROR15 = 109, 
           SET_TIME_ERROR16 = 110, 
           SET_TIME_ERROR17 = 111, 
           SET_TIME_ERROR18 = 112,
           NEW_LINE3 = 113,
           NEW_LINE4 = 114
           ;

    assign fifo_en   = fifo_en_reg;
    assign fifo_data = fifo_data_reg;

    ila_0 U_ila_0 (
        .clk(clk),
        .probe0(fifo_data_reg),
        .probe1(fifo_en_reg),
        .probe2(state_reg)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg     <= 0;
            fifo_data_reg <= 0;
            fifo_en_reg   <= 0;
        end else begin
            state_reg     <= state_next;
            fifo_data_reg <= fifo_data_next;
            fifo_en_reg   <= fifo_en_next;
        end
    end

    always @(*) begin
        state_next     = state_reg;
        fifo_data_next = fifo_data_reg;
        fifo_en_next   = fifo_en_reg;
        case (state_reg)
            IDLE: begin
                fifo_en_next = 1'b0;
                if (wr_en) begin
                    state_next = HUM1;
                end
                if (string_command == 5) begin
                    state_next = SET_MESSAGE1;
                end else if (string_command == 6) begin
                    state_next = SET_TIME_ERROR1;
                end
                if (measure_done) begin
                    state_next = DISTANCE1;
                end
            end
            HUM1: begin
                state_next     = HUM2;
                fifo_en_next   = 1'b1;
                fifo_data_next = "H";
            end
            HUM2: begin
                state_next     = HUM3;
                fifo_data_next = "U";
            end
            HUM3: begin
                state_next     = HUM4;
                fifo_data_next = "M";
            end
            HUM4: begin
                state_next     = HUM5;
                fifo_data_next = "I";
            end
            HUM5: begin
                state_next     = HUM6;
                fifo_data_next = "D";
            end
            HUM6: begin
                state_next     = HUM7;
                fifo_data_next = "I";
            end
            HUM7: begin
                state_next     = HUM8;
                fifo_data_next = "T";
            end
            HUM8: begin
                state_next     = COLON1;
                fifo_data_next = "Y";
            end
            COLON1: begin
                state_next = DATA_1;
                fifo_data_next = ":";
            end

            DATA_1: begin
                state_next     = DATA_2;
                fifo_data_next = hum_int10 + "0";
            end
            DATA_2: begin
                state_next     = POINT0;
                fifo_data_next = hum_int1 + "0";
            end

            POINT0: begin
                state_next     = DATA_3;
                fifo_data_next = ".";
            end

            DATA_3: begin
                state_next     = DATA_4;
                fifo_data_next = hum_dec10 + "0";
            end
            DATA_4: begin
                state_next     = PER;
                fifo_data_next = hum_dec1 + "0";
            end
            PER: begin
                state_next     = COMMA;
                fifo_data_next = "%";
            end
            COMMA: begin
                state_next     = SPACE;
                fifo_data_next = ",";
            end
            SPACE: begin
                state_next = TEM1;
                fifo_data_next = 8'h20;
            end

            TEM1: begin
                state_next = TEM2;
                fifo_data_next = "T";
            end
            TEM2: begin
                state_next = TEM3;
                fifo_data_next = "E";
            end
            TEM3: begin
                state_next = TEM4;
                fifo_data_next = "M";
            end
            TEM4: begin
                state_next = TEM5;
                fifo_data_next = "P";
            end
            TEM5: begin
                state_next = TEM6;
                fifo_data_next = "E";
            end
            TEM6: begin
                state_next = TEM7;
                fifo_data_next = "R";
            end
            TEM7: begin
                state_next = TEM8;
                fifo_data_next = "A";
            end
            TEM8: begin
                state_next = TEM9;
                fifo_data_next = "T";
            end
            TEM9: begin
                state_next = TEM10;
                fifo_data_next = "U";
            end
            TEM10: begin
                state_next = TEM11;
                fifo_data_next = "R";
            end
            TEM11: begin
                state_next = COLON2;
                fifo_data_next = "E";
            end

            COLON2: begin
                state_next = DATA_5;
                fifo_data_next = ":";
            end

            DATA_5: begin
                state_next     = DATA_6;
                fifo_data_next = tem_int10 + "0";
            end
            DATA_6: begin
                state_next     = POINT1;
                fifo_data_next = tem_int1 + "0";
            end

            POINT1: begin
                state_next     = DATA_7;
                fifo_data_next = ".";
            end

            DATA_7: begin
                state_next     = DATA_8;
                fifo_data_next = tem_dec10 + "0";
            end
            DATA_8: begin
                state_next     = CEL1;
                fifo_data_next = tem_dec1 + "0";
            end
            CEL1: begin
                state_next     = CEL2;
                fifo_data_next = "'";
            end
            CEL2: begin
                state_next     = NEW_LINE1;
                fifo_data_next = "C";
            end
            NEW_LINE1: begin
                state_next     = IDLE;
                fifo_data_next = "\n";
            end
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////

            SET_MESSAGE1: begin
                state_next = SET_MESSAGE2;
                fifo_en_next = 1'b1;
                fifo_data_next = "S";
            end
            SET_MESSAGE2: begin
                state_next = SET_MESSAGE3;
                fifo_data_next = "E";
            end
            SET_MESSAGE3: begin
                state_next = SET_MESSAGE4;
                fifo_data_next = "T";
            end
            SET_MESSAGE4: begin
                state_next = SET_TIME1;
                fifo_data_next = " ";
            end
            SET_TIME1: begin
                state_next = SET_TIME2;
                fifo_data_next = "H";
            end
            SET_TIME2: begin
                state_next = SET_TIME3;
                fifo_data_next = "O";
            end
            SET_TIME3: begin
                state_next = SET_TIME4;
                fifo_data_next = "U";
            end
            SET_TIME4: begin
                state_next = SET_TIME5;
                fifo_data_next = "R";
            end
            SET_TIME5: begin
                state_next = SET_TIME6;
                fifo_data_next = ":";
            end
            SET_TIME6: begin
                state_next = SET_TIME7;
                fifo_data_next = set_hour10 + "0";
            end
            SET_TIME7: begin
                state_next = SET_TIME8;
                fifo_data_next = set_hour1 + "0";
            end
            SET_TIME8: begin
                state_next = SET_TIME9;
                fifo_data_next = " ";
            end
            SET_TIME9: begin
                state_next = SET_TIME10;
                fifo_data_next = "M";
            end
            SET_TIME10: begin
                state_next = SET_TIME11;
                fifo_data_next = "I";
            end
            SET_TIME11: begin
                state_next = SET_TIME12;
                fifo_data_next = "N";
            end
            SET_TIME12: begin
                state_next = SET_TIME13;
                fifo_data_next = "U";
            end
            SET_TIME13: begin
                state_next = SET_TIME14;
                fifo_data_next = "T";
            end
            SET_TIME14: begin
                state_next = SET_TIME15;
                fifo_data_next = "E";
            end
            SET_TIME15: begin
                state_next = SET_TIME16;
                fifo_data_next = ":";
            end
            SET_TIME16: begin
                state_next = SET_TIME17;
                fifo_data_next = set_min10 + "0";
            end
            SET_TIME17: begin
                state_next = SET_TIME18;
                fifo_data_next = set_min1 + "0";
            end
            SET_TIME18: begin
                state_next = SET_TIME19;
                fifo_data_next = " ";
            end
            SET_TIME19: begin
                state_next = SET_TIME20;
                fifo_data_next = "S";
            end
            SET_TIME20: begin
                state_next = SET_TIME21;
                fifo_data_next = "E";
            end
            SET_TIME21: begin
                state_next = SET_TIME22;
                fifo_data_next = "C";
            end
            SET_TIME22: begin
                state_next = SET_TIME23;
                fifo_data_next = "O";
            end
            SET_TIME23: begin
                state_next = SET_TIME24;
                fifo_data_next = "N";
            end
            SET_TIME24: begin
                state_next = SET_TIME25;
                fifo_data_next = "D";
            end
            SET_TIME25: begin
                state_next = SET_TIME26;
                fifo_data_next = ":";
            end
            SET_TIME26: begin
                state_next = SET_TIME27;
                fifo_data_next = set_sec10 + "0";
            end
            SET_TIME27: begin
                state_next = SET_TIME28;
                fifo_data_next = set_sec1 + "0";
            end
            SET_TIME28: begin
                state_next = SET_TIME29;
                fifo_data_next = " ";
            end
            SET_TIME29: begin
                state_next = SET_TIME30;
                fifo_data_next = "M";
            end
            SET_TIME30: begin
                state_next = SET_TIME31;
                fifo_data_next = "_";
            end
            SET_TIME31: begin
                state_next = SET_TIME32;
                fifo_data_next = "S";
            end
            SET_TIME32: begin
                state_next = SET_TIME33;
                fifo_data_next = "E";
            end
            SET_TIME33: begin
                state_next = SET_TIME34;
                fifo_data_next = "C";
            end
            SET_TIME34: begin
                state_next = SET_TIME35;
                fifo_data_next = ":";
            end
            SET_TIME35: begin
                state_next = SET_TIME36;
                fifo_data_next = set_msec10 + "0";
            end
            SET_TIME36: begin
                state_next = NEW_LINE2;
                fifo_data_next = set_msec1 + "0";
            end
            NEW_LINE2: begin
                state_next = IDLE;
                fifo_data_next = "\n";
            end
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            DISTANCE1: begin
                state_next = DISTANCE2;
                fifo_en_next = 1'b1;
                fifo_data_next = "D";
            end
            DISTANCE2: begin
                state_next = DISTANCE3;
                fifo_data_next = "I";
            end
            DISTANCE3: begin
                state_next = DISTANCE4;
                fifo_data_next = "S";
            end
            DISTANCE4: begin
                state_next = DISTANCE5;
                fifo_data_next = "T";
            end
            DISTANCE5: begin
                state_next = DISTANCE6;
                fifo_data_next = "A";
            end
            DISTANCE6: begin
                state_next = DISTANCE7;
                fifo_data_next = "N";
            end
            DISTANCE7: begin
                state_next = DISTANCE8;
                fifo_data_next = "C";
            end
            DISTANCE8: begin
                state_next = DISTANCE9;
                fifo_data_next = "E";
            end
            DISTANCE9: begin
                state_next = DISTANCE10;
                fifo_data_next = ":";
            end
            DISTANCE10: begin
                state_next = DISTANCE11;
                fifo_data_next = " ";
            end
            DISTANCE11: begin
                state_next = DISTANCE12;
                fifo_data_next = ultrasonic_1000 + "0";
            end
            DISTANCE12: begin
                state_next = DISTANCE13;
                fifo_data_next = ultrasonic_100 + "0";
            end
            DISTANCE13: begin
                state_next = DISTANCE14;
                fifo_data_next = ultrasonic_10 + "0";
            end
            DISTANCE14: begin
                state_next = DISTANCE15;
                fifo_data_next = ultrasonic_1 + "0";
            end
            DISTANCE15: begin
                state_next = DISTANCE16;
                fifo_data_next = "c";
            end
            DISTANCE16: begin
                state_next = NEW_LINE3;
                fifo_data_next = "m";
            end
            NEW_LINE3: begin
                state_next = IDLE;
                fifo_data_next = "\n";
            end

            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            SET_TIME_ERROR1: begin
                state_next = SET_TIME_ERROR2;
                fifo_en_next = 1'b1;
                fifo_data_next = "T";
            end
            SET_TIME_ERROR2: begin
                state_next = SET_TIME_ERROR3;
                fifo_data_next = "I";
            end
            SET_TIME_ERROR3: begin
                state_next = SET_TIME_ERROR4;
                fifo_data_next = "M";
            end
            SET_TIME_ERROR4: begin
                state_next = SET_TIME_ERROR5;
                fifo_data_next = "E";
            end
            SET_TIME_ERROR5: begin
                state_next = SET_TIME_ERROR6;
                fifo_data_next = " ";
            end
            SET_TIME_ERROR6: begin
                state_next = SET_TIME_ERROR7;
                fifo_data_next = "S";
            end
            SET_TIME_ERROR7: begin
                state_next = SET_TIME_ERROR8;
                fifo_data_next = "E";
            end
            SET_TIME_ERROR8: begin
                state_next = SET_TIME_ERROR9;
                fifo_data_next = "T";
            end
            SET_TIME_ERROR9: begin
                state_next = SET_TIME_ERROR10;
                fifo_data_next = "T";
            end
            SET_TIME_ERROR10: begin
                state_next = SET_TIME_ERROR11;
                fifo_data_next = "I";
            end
            SET_TIME_ERROR11: begin
                state_next = SET_TIME_ERROR12;
                fifo_data_next = "N";
            end
            SET_TIME_ERROR12: begin
                state_next = SET_TIME_ERROR13;
                fifo_data_next = "G";
            end
            SET_TIME_ERROR13: begin
                state_next = SET_TIME_ERROR14;
                fifo_data_next = " ";
            end
            SET_TIME_ERROR14: begin
                state_next = SET_TIME_ERROR15;
                fifo_data_next = "E";
            end
            SET_TIME_ERROR15: begin
                state_next = SET_TIME_ERROR16;
                fifo_data_next = "R";
            end
            SET_TIME_ERROR16: begin
                state_next = SET_TIME_ERROR17;
                fifo_data_next = "R";
            end
            SET_TIME_ERROR17: begin
                state_next = SET_TIME_ERROR18;
                fifo_data_next = "O";
            end
            SET_TIME_ERROR18: begin
                state_next = NEW_LINE4;
                fifo_data_next = "R";
            end
            NEW_LINE4: begin
                state_next = IDLE;
                fifo_data_next = "\n";
            end
        endcase
    end

endmodule

