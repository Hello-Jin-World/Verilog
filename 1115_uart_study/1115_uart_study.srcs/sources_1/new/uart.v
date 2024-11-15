`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 09:46:03
// Design Name: 
// Module Name: uart
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


module uart (
    input        clk,
    input        reset,
    input        tx_start,
    input  [7:0] tx_data,
    output       tx,
    output       tx_done
);

    wire w_tick;

    baudrate_generator U_baudrate_generator (
        .clk(clk),
        .reset(reset),
        .br_tick(w_tick)
    );

    transmitter U_transmitter (
        .clk(clk),
        .reset(reset),
        .br_tick(w_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

endmodule

module baudrate_generator (
    input  clk,
    input  reset,
    output br_tick
);

    reg [13:0] r_counter;
    reg r_tick;
    reg [3:0] state, state_next;


    assign br_tick = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick    <= 1'b0;
        end else begin
            if (r_counter == 100_000_000 / 9600 - 1) begin
                r_counter <= 0;
                r_tick    <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick    <= 1'b0;
            end
        end
    end

endmodule

module transmitter (
    input        clk,
    input        reset,
    input        br_tick,
    input        tx_start,
    input  [7:0] tx_data,
    output       tx,
    output       tx_done
);

    parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4
    , DATA3 = 5, DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10;

    reg [3:0] state, state_next;
    reg [7:0] tx_temp_data_reg, tx_temp_data_next;  // latching
    reg tx_reg, tx_next, tx_done_reg, tx_done_next;

    assign tx      = tx_reg;
    assign tx_done = tx_done_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state            <= IDLE;
            tx_reg           <= 1'b0;
            tx_done_reg      <= 1'b0;
            tx_temp_data_reg <= 0;
        end else begin
            state            <= state_next;
            tx_reg           <= tx_next;
            tx_done_reg      <= tx_done_next;
            tx_temp_data_reg <= tx_temp_data_next;
        end
    end

    always @(*) begin
        tx_next           = tx_reg;
        tx_done_next      = tx_done_reg;
        tx_temp_data_next = tx_temp_data_reg;
        state_next        = state;
        case (state)
            IDLE: begin
                tx_next      = 1'b1;
                tx_done_next = 1'b0;
                if (tx_start == 1'b1) begin
                    tx_temp_data_next = tx_data;  // data latching
                    state_next = START;
                end
            end
            START: begin
                tx_next = 1'b0;
                if (br_tick == 1'b1) begin
                    state_next = DATA0;
                end
            end
            DATA0: begin
                tx_next = tx_temp_data_reg[0];
                if (br_tick == 1'b1) begin
                    state_next = DATA1;
                end
            end
            DATA1: begin
                tx_next = tx_temp_data_reg[1];
                if (br_tick == 1'b1) begin
                    state_next = DATA2;
                end
            end
            DATA2: begin
                tx_next = tx_temp_data_reg[2];
                if (br_tick == 1'b1) begin
                    state_next = DATA3;
                end
            end
            DATA3: begin
                tx_next = tx_temp_data_reg[3];
                if (br_tick == 1'b1) begin
                    state_next = DATA4;
                end
            end
            DATA4: begin
                tx_next = tx_temp_data_reg[4];
                if (br_tick == 1'b1) begin
                    state_next = DATA5;
                end
            end
            DATA5: begin
                tx_next = tx_temp_data_reg[5];
                if (br_tick == 1'b1) begin
                    state_next = DATA6;
                end
            end
            DATA6: begin
                tx_next = tx_temp_data_reg[6];
                if (br_tick == 1'b1) begin
                    state_next = DATA7;
                end
            end
            DATA7: begin
                tx_next = tx_temp_data_reg[7];
                if (br_tick == 1'b1) begin
                    state_next = STOP;
                end
            end
            STOP: begin
                tx_next = 1'b1;
                if (br_tick == 1'b1) begin
                    tx_done_next = 1'b1;
                    state_next   = IDLE;
                end
            end
        endcase
    end
endmodule
