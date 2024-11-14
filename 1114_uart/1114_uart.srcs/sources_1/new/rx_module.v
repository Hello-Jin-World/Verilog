`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 16:14:39
// Design Name: 
// Module Name: rx_module
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


module rx_module (
    input        receive_data,
    input        start,
    input        tick,
    output [7:0] o_receive_data
);

    parameter IDLE = 4'b0000, START = 4'b0001, DATA0 = 4'b0010, DATA1 = 4'b0011, DATA2 = 4'b0100
    , DATA3 = 4'b0101, DATA4 = 4'b0110, DATA5 = 4'b0111, DATA6 = 4'b1000, DATA7 = 4'b1001, STOP = 4'b1010;

    reg [3:0] state;
    reg [7:0] r_rx_data, save_rx_data;

    assign o_receive_data = save_rx_data;

    always @(*) begin
        if (start && state == IDLE) begin
            state = START;
        end
        if (tick) begin
            case (state)
                IDLE: state = IDLE;
                START: state = DATA0;
                DATA0: state = DATA1;
                DATA1: state = DATA2;
                DATA2: state = DATA3;
                DATA3: state = DATA4;
                DATA4: state = DATA5;
                DATA5: state = DATA6;
                DATA6: state = DATA7;
                DATA7: state = STOP;
                STOP: state = IDLE;
                default: state = IDLE;
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: r_rx_data = 8'b11111111;
            START: r_rx_data = 8'b00000000;
            DATA0: r_rx_data[0] = receive_data;
            DATA1: r_rx_data[1] = receive_data;
            DATA2: r_rx_data[2] = receive_data;
            DATA3: r_rx_data[3] = receive_data;
            DATA4: r_rx_data[4] = receive_data;
            DATA5: r_rx_data[5] = receive_data;
            DATA6: r_rx_data[6] = receive_data;
            DATA7: r_rx_data[7] = receive_data;
            STOP: begin 
                save_rx_data = r_rx_data;
                r_rx_data = 8'b11111111;
            end
            default: begin
                state = IDLE;
                save_rx_data = 0;
            end
        endcase
    end
endmodule

