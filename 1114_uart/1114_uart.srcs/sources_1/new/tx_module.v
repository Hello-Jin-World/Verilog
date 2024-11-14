`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 15:16:17
// Design Name: 
// Module Name: tx_module
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


module tx_module (
    input        tick,
    input  [7:0] data,
    input        start,
    output       o_bit
);

    parameter IDLE = 4'b0000, START = 4'b0001, DATA0 = 4'b0010, DATA1 = 4'b0011, DATA2 = 4'b0100
    , DATA3 = 4'b0101, DATA4 = 4'b0110, DATA5 = 4'b0111, DATA6 = 4'b1000, DATA7 = 4'b1001, STOP = 4'b1010;

    reg [3:0] state;
    reg r_out;

    assign o_bit = r_out;

    always @(*) begin
        if (start && state == IDLE) begin
            state = START;
        end
        if (tick) begin
            case (state)
                IDLE:  state = IDLE;
                START: state = DATA0;
                DATA0: state = DATA1;
                DATA1: state = DATA2;
                DATA2: state = DATA3;
                DATA3: state = DATA4;
                DATA4: state = DATA5;
                DATA5: state = DATA6;
                DATA6: state = DATA7;
                DATA7: state = STOP;
                STOP:  state = IDLE;
                default: begin
                    state = IDLE;
                    r_out = 1;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:  r_out = 1'b1;
            START: r_out = 1'b0;
            DATA0: r_out = data[0];
            DATA1: r_out = data[1];
            DATA2: r_out = data[2];
            DATA3: r_out = data[3];
            DATA4: r_out = data[4];
            DATA5: r_out = data[5];
            DATA6: r_out = data[6];
            DATA7: r_out = data[7];
            STOP:  r_out = 1'b1;
            default: begin
                state = IDLE;
                r_out = 1;
            end
        endcase
    end
endmodule
