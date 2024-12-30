`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/29 21:51:52
// Design Name: 
// Module Name: SCCB
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


module SCCB (
    input  logic       clk,
    input  logic       reset,
    input  logic [7:0] wData,
    input  logic [7:0] addrwe,
    input  logic       start,
    output logic [7:0] rData,
    inout  wire        SDA,
    output logic       SCL
);
    logic SDA_in, SDA_out;
    logic [ 7:0] rData_reg;
    logic [11:0] half_freq;
    logic [3 : 0] state_reg, state_next;
    logic [3:0] i_reg, i_next;
    logic [10:0] counter_reg, counter_next;
    logic [$clog2(500) - 1 : 0] counter;
    logic manual_clk;
    logic SDA_out_reg, SDA_out_next;
    logic SCL_reg, SCL_next;
    logic write_reg, write_next;

    assign SDA_out = SDA_out_reg;
    assign SCL = SCL_reg;
    assign half_freq = 500;
    assign rData = rData_reg;

    /////////////////       inout mode       ///////////////////
    assign SDA = write_reg ? SDA_out : 1'bz;

    always @(*) begin  // Read Data (INPUT MODE)
        if (!write_reg) begin
            SDA_in <= SDA;
        end
    end
    ///////////////////////////////////////////////////////////

    localparam LOW = 0, HIGH = 1, ACK = 0;
    localparam READ = 0, WRITE = 1;
    localparam 
    IDLE   = 0,
    STAY_4us = 1,
    ADDR_RW0 = 2,
    ADDR_RW1 = 3,
    SLAVE_ACK = 4,
    WRITE_DATA0 = 5,
    WRITE_DATA1 = 6,
    MASTER_ACK = 7,
    READ_DATA0 = 8,
    READ_DATA1 = 9,
    WAIT = 10
    ;

    ///////////////////      clock generator      ////////////////////
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            manual_clk <= 0;
            counter    <= 0;
        end else begin
            if (counter == half_freq - 1) begin
                manual_clk <= 1;
                counter    <= 0;
            end else begin
                manual_clk <= 0;
                counter <= counter + 1;
            end
        end
    end
    /////////////////////////////////////////////////////////////////


    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            counter_reg <= 0;
            SDA_out_reg <= HIGH;
            SCL_reg     <= HIGH;
            i_reg       <= 0;
            write_reg   <= WRITE;
            rData_reg   <= 0;
        end else begin
            state_reg   <= state_next;
            counter_reg <= counter_next;
            SDA_out_reg <= SDA_out_next;
            SCL_reg     <= SCL_next;
            i_reg       <= i_next;
            write_reg   <= write_next;
        end
    end

    always_comb begin
        state_next   = state_reg;
        SDA_out_next = SDA_out_reg;
        SCL_next     = SCL_reg;
        i_next       = i_reg;
        counter_next = counter_reg;
        write_next   = write_reg;
        case (state_reg)
    /////////////////////////////////////////////////////////////////
            IDLE: begin
                if (counter == half_freq / 2 - 1) begin
                    SDA_out_next = HIGH;
                    SCL_next = HIGH;
                end
                if (counter == half_freq / 2 - 1 && start) begin
                    state_next   = STAY_4us;
                    counter_next = 0;
                    SDA_out_next = LOW;
                end
            end
            STAY_4us: begin
                //stay SDA_out LOW for 4us
                if (counter_reg == 500 - 1) begin
                    state_next   = ADDR_RW0;
                    counter_next = 0;
                    SCL_next     = LOW;
                end else begin
                    counter_next = counter_reg + 1;
                end
            end
            ADDR_RW0: begin
                // SCL = LOW
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                    i_next   = i_reg + 1;
                end
                if (manual_clk) begin
                // if (counter == half_freq / 2 - 1) begin
                    if (i_reg == 8) begin
                        state_next = SLAVE_ACK;
                        write_next = READ;
                        i_next     = 0;
                    end else begin
                        state_next   = ADDR_RW1;
                        SDA_out_next = addrwe[7-i_reg];
                    end
                end
            end
            ADDR_RW1: begin
                // SCL = HIGH
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                // if (counter == half_freq / 2 - 1) begin
                if (manual_clk) begin
                    state_next = ADDR_RW0;
                end
            end
            SLAVE_ACK: begin
                // wait SLAVE ACK
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (SCL_reg == 1 && SCL_next == 0) begin
                    if (SDA_in == ACK) begin
                        if (addrwe[0] == WRITE) begin
                            state_next = WRITE_DATA0;
                            write_next = WRITE;
                        end else begin
                            state_next = READ_DATA0;
                            write_next = READ;
                        end
                    end else begin
                        state_next = IDLE;
                        write_next = WRITE;
                    end
                end
            end
            WRITE_DATA0: begin
                // SCL = LOW
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                    i_next   = i_reg + 1;
                end
                if (manual_clk) begin
                // if (counter == half_freq / 2 - 1) begin
                    if (i_reg == 8) begin
                        SDA_out_next = LOW;
                        state_next   = MASTER_ACK;
                        i_next       = 0;
                    end else begin
                        state_next   = WRITE_DATA1;
                        SDA_out_next = wData[7-i_reg];
                    end
                end
            end
            WRITE_DATA1: begin
                // SCL = HIGH
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                // if (counter == half_freq / 2 - 1) begin
                if (manual_clk) begin
                    state_next = WRITE_DATA0;
                end
            end
            READ_DATA0: begin
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                    i_next   = i_reg + 1;
                end
                // if (counter == half_freq / 2 - 1) begin
                if (manual_clk) begin
                    if (i_reg == 8) begin
                        i_next     = 0;
                        state_next = MASTER_ACK;
                    end else begin
                        state_next         = READ_DATA1;
                        rData_reg[7-i_reg] = SDA_in;
                    end
                end
            end
            READ_DATA1: begin
                // if (manual_clk) begin
                if (counter == half_freq / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                // if (counter == half_freq / 2 - 1) begin
                    state_next = READ_DATA0;
                end
            end
            MASTER_ACK: begin
                SDA_out_next = LOW;
                if (counter == half_freq / 2 - 1) begin
                // if (manual_clk) begin
                    SCL_next = ~SCL_reg;
                end
                // if (counter == half_freq / 2 - 1) begin
                if (manual_clk) begin
                    state_next = WAIT;
                end
            end
            WAIT: begin
                SDA_out_next = HIGH;
                SCL_next = HIGH;
                if (manual_clk) begin
                // if (counter == half_freq / 2 - 1) begin
                    state_next = IDLE;
                end
            end
        endcase
    end
endmodule

