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


    reg [5:0] state_reg, state_next;
    reg [7:0] fifo_data_reg, fifo_data_next;
    reg fifo_en_reg, fifo_en_next;
    reg [5:0] counter_reg, counter_next;

    localparam IDLE = 0, DATA_1 = 1, DATA_2 = 2, DATA_3 = 3, 
    DATA_4 = 4, DATA_5 = 5, DATA_6 = 6, DATA_7 = 7, DATA_8 = 8, 
    POINT0 = 9, POINT1 = 10, HUM1 = 11, HUM2 = 12, HUM3 = 13, HUM4 = 14, HUM5 = 15, HUM6 = 16, HUM7 = 17, HUM8 = 18,
    TEM1 = 19, TEM2 = 20, TEM3 = 21, TEM4 = 22, TEM5 = 23, TEM6 = 24, TEM7 = 25, TEM8 = 26, TEM9 = 27,
    TEM10 = 28, TEM11 = 29, COLON1 = 30, COLON2 = 31, COMMA = 32, CEL1 = 33, CEL2 = 34, PER = 35, SPACE = 36;

    assign fifo_en   = fifo_en_reg;
    assign fifo_data = fifo_data_reg;

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
                state_next = COMMA;
                fifo_data_next = "%";
            end
            COMMA: begin
                state_next = SPACE;
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
                state_next     = IDLE;
                fifo_data_next = "C";
            end
        endcase
    end
endmodule

