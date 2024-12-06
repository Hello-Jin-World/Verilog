`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 10:20:34
// Design Name: 
// Module Name: dedicated_processor
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


module dedicated_processor (
    input        clk,
    input        reset,
    // output   [15:0] outport
    output [3:0] fndcom,
    output [7:0] fndfont
);

    wire i_less_equal_10,
     sum_src_sel,
     i_src_sel,
     sum_load,
     i_load,
     adder_sel,
     out_load;

    wire [15:0] outport;

    controlunit U_controlunit (
        .clk            (clk),
        .reset          (reset),
        .i_less_equal_10(i_less_equal_10),
        .sum_src_sel    (sum_src_sel),
        .i_src_sel      (i_src_sel),
        .sum_load       (sum_load),
        .i_load         (i_load),
        .adder_sel      (adder_sel),
        .out_load       (out_load)
    );
    datapath U_datapath (
        .clk            (clk),
        .reset          (reset),
        .sum_src_sel    (sum_src_sel),
        .i_src_sel      (i_src_sel),
        .sum_load       (sum_load),
        .i_load         (i_load),
        .adder_sel      (adder_sel),
        .out_load       (out_load),
        .i_less_equal_10(i_less_equal_10),
        .outport        (outport)
    );

    fnd_controller U_fnd_controller (
        .clk       (clk),
        .reset     (reset),
        .sum_result(outport),
        .fndcom    (fndcom),
        .fndfont   (fndfont)
    );
endmodule


module controlunit (
    input  clk,
    input  reset,
    input  i_less_equal_10,
    output sum_src_sel,
    output i_src_sel,
    output sum_load,
    output i_load,
    output adder_sel,
    output out_load
);

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;

    reg [2:0] state_reg, state_next;
    reg [5:0] controlsignal;

    assign {sum_src_sel,i_src_sel,sum_load,i_load,adder_sel,out_load} = controlsignal;

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
                if (i_less_equal_10) begin
                    state_next = S2;
                end else begin
                    state_next = S5;
                end
            end
            S2: begin
                state_next = S3;
            end
            S3: begin
                state_next = S4;
            end
            S4: begin
                state_next = S1;
            end
            S5: begin
                state_next = S5;
            end
        endcase
    end

    always @(*) begin
        // sum_src_sel = 0;
        // i_src_sel   = 0;
        // sum_load    = 0;
        // i_load      = 0;
        // adder_sel   = 0;
        // out_load    = 0;
        controlsignal = 0;
        case (state_reg)

            S0: begin
                controlsignal = 6'b0011xx;
            end
            S1: begin
                controlsignal = 6'bxx00x0;
            end
            S2: begin
                controlsignal = 6'b1x1000;
            end
            S3: begin
                controlsignal = 6'bx10110;
            end
            S4: begin
                controlsignal = 6'bxx00x1;
            end
            S5: begin
                controlsignal = 6'bxx00x0;
            end

            // S0: begin
            //     sum_src_sel = 0;
            //     i_src_sel   = 0;
            //     sum_load    = 1;
            //     i_load      = 1;
            //     adder_sel   = 0;
            //     out_load    = 0;
            // end
            // S1: begin
            //     sum_src_sel = 0;
            //     i_src_sel   = 0;
            //     sum_load    = 0;
            //     i_load      = 0;
            //     adder_sel   = 0;
            //     out_load    = 0;
            // end
            // S2: begin
            //     sum_src_sel = 1;
            //     i_src_sel   = 0;
            //     sum_load    = 1;
            //     i_load      = 0;
            //     adder_sel   = 0;
            //     out_load    = 0;

            // end
            // S3: begin
            //     sum_src_sel = 0;
            //     i_src_sel   = 1;
            //     sum_load    = 0;
            //     i_load      = 1;
            //     adder_sel   = 1;
            //     out_load    = 0;

            // end
            // S4: begin
            //     sum_src_sel = 0;
            //     i_src_sel   = 0;
            //     sum_load    = 0;
            //     i_load      = 0;
            //     adder_sel   = 0;
            //     out_load    = 1;

            // end
            // S5: begin
            //     sum_src_sel = 0;
            //     i_src_sel   = 0;
            //     sum_load    = 0;
            //     i_load      = 0;
            //     adder_sel   = 0;
            //     out_load    = 0;

            // end
        endcase
    end
endmodule

module datapath (
    input         clk,
    input         reset,
    input         sum_src_sel,
    input         i_src_sel,
    input         sum_load,
    input         i_load,
    input         adder_sel,
    input         out_load,
    output        i_less_equal_10,
    output [15:0] outport
);

    wire [15:0] result, sum_data, i_data, sum_reg_out, i_reg_out, add_mux_out;

    mux_2x1 U_mux_2x1_sum (
        .x0 (16'd0),
        .x1 (result),
        .sel(sum_src_sel),
        .y  (sum_data)
    );

    mux_2x1 U_mux_2x1_i (
        .x0 (16'd0),
        .x1 (result),
        .sel(i_src_sel),
        .y  (i_data)
    );

    register U_register_sum (
        .clk  (clk),
        .reset(reset),
        .d_in (sum_data),
        .load (sum_load),
        .q_out(sum_reg_out)
    );

    register U_register_i (
        .clk  (clk),
        .reset(reset),
        .d_in (i_data),
        .load (i_load),
        .q_out(i_reg_out)
    );

    mux_2x1 U_mux_2x1_adder (
        .x0 (sum_reg_out),
        .x1 (16'd1),
        .sel(adder_sel),
        .y  (add_mux_out)
    );

    adder U_adder (
        .a_in  (add_mux_out),
        .b_in  (i_reg_out),
        .result(result)
    );

    comparator U_comparator (
        .i_in           (i_reg_out),
        .object         (16'd10),
        .i_less_equal_10(i_less_equal_10)
    );

    out_register U_out_register (
        .clk     (clk),
        .reset   (reset),
        .result  (sum_reg_out),
        .out_load(out_load),
        .outport (outport)
    );
endmodule

module mux_2x1 (
    input      [15:0] x0,
    input      [15:0] x1,
    input             sel,
    output reg [15:0] y
);
    always @(*) begin
        case (sel)
            1'b0: begin
                y = x0;
            end
            1'b1: begin
                y = x1;
            end
            default: y = 16'bx;
        endcase
    end
    // assign y = (sel) ? x1 : x0;
endmodule

module register (
    input             clk,
    input             reset,
    input      [15:0] d_in,
    input             load,
    output reg [15:0] q_out
);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            q_out <= 0;
        end else begin
            if (load) begin
                q_out <= d_in;
            end
        end
    end
endmodule

module adder (
    input  [15:0] a_in,
    input  [15:0] b_in,
    output [15:0] result
);
    assign result = a_in + b_in;
endmodule

module comparator (
    input  [15:0] i_in,
    input  [15:0] object,
    output        i_less_equal_10
);

    assign i_less_equal_10 = (i_in <= object);
endmodule

module out_register (
    input             clk,
    input             reset,
    input      [15:0] result,
    input             out_load,
    output reg [15:0] outport
);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            outport <= 0;
        end else begin
            if (out_load) begin
                outport <= result;
            end
        end
    end
endmodule
