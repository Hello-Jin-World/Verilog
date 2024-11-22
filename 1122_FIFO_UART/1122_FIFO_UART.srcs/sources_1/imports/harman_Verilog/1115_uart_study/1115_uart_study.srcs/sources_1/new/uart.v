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
    // UART Tx
    input        tx_start,
    input  [7:0] tx_data,
    output       tx,
    output       tx_busy,
    output       tx_done,
    // UART Rx
    input        rx,
    output [7:0] rx_data,
    output       rx_done
);

    wire w_tick;
    wire [7:0] w_rx_data;

    assign rx_data = w_rx_data;

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
        .tx_data(w_rx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    reciever U_reciever (
        .clk(clk),
        .reset(reset),
        .br_tick(w_tick),
        .rx(rx),
        .rx_data(w_rx_data),
        .rx_done(rx_done)
    );

endmodule

module baudrate_generator (
    input  clk,
    input  reset,
    output br_tick
);

    reg [$clog2(100_000_000 / 9600 / 16)-1 : 0] r_counter;
    reg r_tick;
    reg [3:0] state, state_next;


    assign br_tick = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick    <= 1'b0;
        end else begin
            if (r_counter == 100_000_000 / 9600 / 16 - 1) begin
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
    output       tx_busy,
    output       tx_done
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state, state_next;
    reg [7:0] tx_temp_data_reg, tx_temp_data_next;  // latching
    reg tx_reg, tx_next, tx_done_reg, tx_done_next;
    reg [3:0] tick_count_reg, tick_count_next;
    reg [2:0] bit_count_reg, bit_count_next;
    reg tx_busy_reg, tx_busy_next;

    assign tx      = tx_reg;
    assign tx_done = tx_done_reg;
    assign tx_busy = tx_busy_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state            <= IDLE;
            tx_reg           <= 1'b0;
            tx_done_reg      <= 1'b1;
            tx_temp_data_reg <= 0;
            tick_count_reg   <= 0;
            bit_count_reg    <= 0;
            tx_busy_reg      <= 0;
        end else begin
            state            <= state_next;
            tx_reg           <= tx_next;
            tx_done_reg      <= tx_done_next;
            tx_temp_data_reg <= tx_temp_data_next;
            tick_count_reg   <= tick_count_next;
            bit_count_reg    <= bit_count_next;
            tx_busy_reg      <= tx_busy_next;
        end
    end

    always @(*) begin
        tx_next           = tx_reg;
        tx_done_next      = tx_done_reg;
        tx_temp_data_next = tx_temp_data_reg;
        state_next        = state;
        tick_count_next   = tick_count_reg;
        bit_count_next    = bit_count_reg;
        tx_busy_next      = tx_busy_reg;
        case (state)
            IDLE: begin
                tx_next      = 1'b1;
                tx_done_next = 1'b0;
                tx_busy_next = 1'b0;
                if (tx_start == 1'b1) begin
                    tx_temp_data_next = tx_data;  // data latching
                    tick_count_next = 0;
                    bit_count_next = 0;
                    tx_busy_next = 1'b1;
                    state_next = START;
                end
            end
            START: begin
                tx_next = 1'b0;
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA: begin
                tx_next = tx_temp_data_reg[0];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        tick_count_next = 0;
                        if (bit_count_reg == 7) begin
                            bit_count_next = 0;
                            state_next = STOP;
                        end else begin
                            tx_temp_data_next = {
                                1'b0, tx_temp_data_reg[7:1]  // shift
                            };
                            bit_count_next = bit_count_reg + 1;
                        end
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            /*
            DATA1: begin
                tx_next = tx_temp_data_reg[1];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA2;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA2: begin
                tx_next = tx_temp_data_reg[2];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA3;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA3: begin
                tx_next = tx_temp_data_reg[3];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA4;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA4: begin
                tx_next = tx_temp_data_reg[4];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA5;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA5: begin
                tx_next = tx_temp_data_reg[5];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA6;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA6: begin
                tx_next = tx_temp_data_reg[6];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = DATA7;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
            DATA7: begin
                tx_next = tx_temp_data_reg[7];
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        state_next = STOP;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end*/
            STOP: begin
                tx_next = 1'b1;
                if (br_tick == 1'b1) begin
                    if (tick_count_reg == 15) begin
                        tx_done_next = 1'b1;
                        state_next = IDLE;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
        endcase
    end
endmodule


module reciever (
    input        clk,
    input        reset,
    input        br_tick,
    input        rx,
    output [7:0] rx_data,
    output       rx_done
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state, state_next;
    reg [3:0] br_tick_count_reg, br_tick_count_next;
    reg [7:0] rx_data_reg, rx_data_next;
    reg [2:0] bit_count_reg, bit_count_next;
    reg rx_done_reg, rx_done_next;

    assign rx_data = rx_data_reg;
    assign rx_done = rx_done_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state             <= IDLE;
            br_tick_count_reg <= 0;
            rx_data_reg       <= 0;
            bit_count_reg     <= 0;
            rx_done_reg       <= 0;
        end else begin
            state             <= state_next;
            br_tick_count_reg <= br_tick_count_next;
            rx_data_reg       <= rx_data_next;
            bit_count_reg     <= bit_count_next;
            rx_done_reg       <= rx_done_next;
        end
    end

    always @(*) begin
        state_next         = state;
        br_tick_count_next = br_tick_count_reg;
        rx_data_next       = rx_data_reg;
        bit_count_next     = bit_count_reg;
        rx_done_next       = rx_done_reg;
        case (state)
            IDLE: begin
                rx_done_next = 1'b0;
                if (rx == 1'b0) begin
                    br_tick_count_next = 0;
                    state_next         = START;
                end
            end
            START: begin
                if (br_tick == 1'b1) begin
                    if (br_tick_count_reg == 7) begin
                        br_tick_count_next = 0;
                        state_next         = DATA;
                    end else begin
                        br_tick_count_next = br_tick_count_reg + 1;
                    end
                end
            end
            DATA: begin
                if (br_tick == 1'b1) begin
                    if (br_tick_count_reg == 15) begin
                        br_tick_count_next = 0;
                        rx_data_next = {rx, rx_data_reg[7:1]};  // shift
                        // first in -> 0'bit (LSB)
                        if (bit_count_reg == 7) begin
                            bit_count_next = 0;
                            state_next     = STOP;
                        end else begin
                            bit_count_next = bit_count_reg + 1;
                        end
                    end else begin
                        br_tick_count_next = br_tick_count_reg + 1;
                    end
                end
            end
            STOP: begin
                if (br_tick == 1'b1) begin
                    if (br_tick_count_reg == 15) begin
                        br_tick_count_next = 0;
                        state_next         = IDLE;
                        rx_done_next       = 1'b1;
                    end else begin
                        br_tick_count_next = br_tick_count_reg + 1;
                    end
                end
            end
        endcase
    end

endmodule
