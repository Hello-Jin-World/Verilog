`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 13:05:53
// Design Name: 
// Module Name: dedicated
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


module dedicated (
    input        clk,
    input        reset,
    output [7:0] led,
    output [3:0] fndcom,
    output [7:0] fndfont
);


    wire i_less_than_10, i_src_mux_sel, i_load, out_buff_sel;
    wire w_tick;

    clk_div_count U_clk_div_count (
        .clk  (clk),
        .reset(reset),
        .tick (w_tick)
    );

    counter_control_unit U_counter_control_unit (
        .clk           (clk),
        .reset         (reset),
        .tick          (w_tick),
        .i_less_than_10(i_less_than_10),
        .i_src_mux_sel (i_src_mux_sel),
        .i_load        (i_load),
        .out_buff_sel  (out_buff_sel)
    );

    counter_datapath U_counter_datapath (
        .clk           (clk),
        .reset         (reset),
        .i_src_mux_sel (i_src_mux_sel),
        .i_load        (i_load),
        .out_buff_sel  (out_buff_sel),
        .i_less_than_10(i_less_than_10),
        .outport       (led)
    );

    fnd_controller U_fnd_controller (
        .clk       (clk),
        .reset     (reset),
        .sum_result(led),
        .fndcom    (fndcom),
        .fndfont   (fndfont)
    );
endmodule

module clk_div_count (
    input      clk,
    input      reset,
    output reg tick
);

    reg [$clog2(100_000_000) - 1 : 0] counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            tick <= 0;
        end else begin
            if (counter == 100_000_000 - 1) begin
                counter <= 0;
                tick    <= 1;
            end else begin
                counter <= counter + 1;
                tick    <= 0;
            end
        end
    end

endmodule

module counter_control_unit (
    input      clk,
    input      reset,
    input      i_less_than_10,
    input      tick,
    output reg i_src_mux_sel,
    output reg i_load,
    output reg out_buff_sel
);

    reg [2:0] state_reg, state_next;

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg <= 0;
        end else begin
            state_reg <= state_next;
        end
    end
    always @(*) begin
        state_next = state_reg;
        case (state_reg)
            S0: begin
                state_next = S1;
            end
            S1: begin
                if (i_less_than_10) begin
                    state_next = S2;
                end else begin
                    state_next = S4;
                end
            end
            S2: begin
                state_next = S3;
            end
            S3: begin
                if (tick) begin
                    state_next = S1;
                end
            end
            S4: begin
                state_next = S4;
            end
        endcase
    end

    always @(*) begin
        i_src_mux_sel = 0;
        i_load        = 0;
        out_buff_sel  = 0;
        case (state_reg)
            S0: begin
                i_src_mux_sel = 0;
                i_load        = 1;
                out_buff_sel  = 0;
            end
            S1: begin
                i_src_mux_sel = 0;
                i_load        = 0;
                out_buff_sel  = 0;
            end
            S2: begin
                i_src_mux_sel = 0;
                i_load        = 0;
                out_buff_sel  = 1;
            end
            S3: begin
                i_src_mux_sel = 1;
                i_load        = 1;
                out_buff_sel  = 0;
            end
            S4: begin
                i_src_mux_sel = 0;
                i_load        = 0;
                out_buff_sel  = 0;
            end
        endcase
    end
endmodule


module counter_datapath (
    input        clk,
    input        reset,
    input        i_src_mux_sel,
    input        i_load,
    input        out_buff_sel,
    output       i_less_than_10,
    output [7:0] outport
);

    wire [7:0] w_sum_result, w_mux_out, w_q_out;

    mux_2x1 U_mux_2x1 (
        .sel(i_src_mux_sel),
        .x0 (8'b0),
        .x1 (w_sum_result),
        .y0 (w_mux_out)
    );

    register U_register (
        .clk  (clk),
        .reset(reset),
        .load (i_load),
        .d_in (w_mux_out),
        .q_out(w_q_out)
    );

    comparator U_comparator (
        .a_in(w_q_out),
        .b_in(8'd10),
        .less_than(i_less_than_10)
    );

    adder U_adder (
        .a_in(w_q_out),
        .b_in(8'd1),
        .sum_result(w_sum_result)
    );

    three_state_buffer U_three_state_buffer (
        .a_in(w_q_out),
        .sel(out_buff_sel),
        .selected_out(outport)
    );
endmodule

module mux_2x1 (
    input            sel,
    input      [7:0] x0,
    input      [7:0] x1,
    output reg [7:0] y0
);

    always @(*) begin
        case (sel)
            1'b0: begin
                y0 = x0;
            end
            1'b1: begin
                y0 = x1;
            end
            default: y0 = 8'bx;
        endcase
    end
endmodule

module register (
    input        clk,
    input        reset,
    input        load,
    input  [7:0] d_in,
    output [7:0] q_out
);

    reg [7:0] q_reg;

    assign q_out = q_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            q_reg <= 0;
        end else begin
            if (load) begin
                q_reg <= d_in;
            end
        end
    end
endmodule

module comparator (
    input  [7:0] a_in,
    input  [7:0] b_in,
    output       less_than
);

    assign less_than = (a_in < b_in);
endmodule

module adder (
    input  [7:0] a_in,
    input  [7:0] b_in,
    output [7:0] sum_result
);

    assign sum_result = a_in + b_in;
endmodule

module three_state_buffer (
    input        clk,
    input        reset,
    input  [7:0] a_in,
    input        sel,
    output [7:0] selected_out
);

    reg [7:0] data_reg;

    assign selected_out = data_reg;


    always @(*) begin
        data_reg = data_reg;
        if (sel) begin
            data_reg = a_in;
        end
    end
endmodule
