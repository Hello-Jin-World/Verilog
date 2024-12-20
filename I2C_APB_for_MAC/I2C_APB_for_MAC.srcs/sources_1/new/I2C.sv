`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 20:15:08
// Design Name: 
// Module Name: I2C
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


module I2C (
    input  logic       clk,
    input  logic       reset,
    input  logic       start,
    input  logic [7:0] addrwe,
    inout  logic       SDA,
    output logic       SCL
);
    wire manual_clk;

    MASTER U_MASTER (
        .clk       (clk),
        .reset     (reset),
        .addrwe    (addrwe),
        .manual_clk(manual_clk),
        .start     (start),
        .SDA       (SDA),
        .SCL       (SCL)
    );

    manual_clk U_manual_clk (
        .clk(clk),
        .reset(reset),
        .manual_clk(manual_clk)
    );
endmodule

module MASTER (
    input  logic       clk,
    input  logic       reset,
    input  logic [7:0] addrwe,
    input  logic       manual_clk,
    input  logic       start,
    // input  logic       pEdge,
    // input  logic       nEdge,
    output logic       SDA,
    output logic       SCL
);

    logic [3:0] state_reg, state_next;
    logic [10:0] counter_reg, counter_next;
    logic SDA_reg, SDA_next;
    logic SCL_reg, SCL_next;
    logic [3:0] i_reg, i_next;

    assign SDA = SDA_reg;
    assign SCL = SCL_reg;

    localparam 
    IDLE   = 0,
    STATE1 = 1,
    STATE2 = 2,
    STATE3 = 3,
    STATE4 = 4,
    STATE5 = 5
    ;

    localparam LOW = 0, HIGH = 1;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            counter_reg <= 0;
            SDA_reg     <= HIGH;
            SCL_reg     <= HIGH;
            i_reg       <= 0;
        end else begin
            state_reg   <= state_next;
            counter_reg <= counter_next;
            SDA_reg     <= SDA_next;
            SCL_reg     <= SCL_next;
            i_reg       <= i_next;
        end
    end

    always_comb begin
        state_next   = state_reg;
        SDA_next     = SDA_reg;
        SCL_next     = SCL_reg;
        i_next       = i_reg;
        counter_next = counter_reg;
        case (state_reg)
            IDLE: begin
                SDA_next = HIGH;
                SCL_next = HIGH;
                if (start) begin
                    state_next   = STATE1;
                    SDA_next     = LOW;
                    counter_next = 0;
                end
            end
            STATE1: begin
                //stay SDA LOW for 4us
                if (counter_reg == 400 - 1) begin
                    state_next   = STATE2;
                    counter_next = 0;
                end else begin
                    counter_next = counter_reg + 1;
                end
            end
            STATE2: begin
                // SCL = LOW
                if (i_reg == 9) begin
                    state_next = STATE4;
                    i_next     = 0;
                end else begin
                    if (manual_clk) begin
                        SCL_next = ~SCL_reg;
                    end
                    if (SCL_reg == HIGH) begin
                        state_next = STATE3;
                    end
                end
            end
            STATE3: begin
                // SCL = HIGH
                if (i_reg == 8) begin
                    SDA_next = LOW;
                end else begin
                    SDA_next = addrwe[i_reg];
                end
                i_next = i_reg + 1;
                if (manual_clk) begin
                    SCL_next = ~SCL_reg;
                end
                if (SCL_reg == LOW) begin
                    state_next = STATE2;
                end
            end
            STATE4: begin
                state_next = STATE5;
            end
            STATE5: begin
                state_next = IDLE;
            end
        endcase
    end
endmodule

// module edge_detector (
//     input  logic clk,
//     input  logic reset,
//     input  logic manual_clk,
//     output logic pEdge,
//     output logic nEdge
// );
//     reg ff_cur, ff_past;

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             ff_cur  <= 0;
//             ff_past <= 0;
//         end else begin
//             ff_cur  <= manual_clk;
//             ff_past <= ff_cur;
//         end
//     end

//     assign pEdge = (ff_cur == 1 && ff_past == 0) ? 1 : 0;  // detect rising edge
//     assign nEdge = (ff_cur == 0 && ff_past == 1) ? 1 : 0; // detect falling edge
// endmodule

module manual_clk (
    input  logic clk,
    input  logic reset,
    output logic manual_clk
);

    reg [$clog2(100_000) - 1 : 0] counter;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            manual_clk <= 0;
            counter    <= 0;
        end else begin
            if (counter == 100_000 - 1) begin
                manual_clk <= 1;
                counter    <= 0;
            end else begin
                manual_clk <= 0;
                counter <= counter + 1;
            end
        end
    end

endmodule
