`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 16:20:57
// Design Name: 
// Module Name: alu_dedicated_processor
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


module alu_dedicated_processor (
    input         clk,
    input         reset,
    output [15:0] outport
);

    wire       a_equal_b;
    wire       rf_src_sel;
    wire       write_en;
    wire [2:0] write_addr;
    wire [2:0] read_addr1;
    wire [2:0] read_addr2;
    wire [1:0] alu_op;
    wire       out_load;

    controlunit U_controlunit (
        .clk       (clk),
        .reset     (reset),
        .a_equal_b (a_equal_b),
        .rf_src_sel(rf_src_sel),
        .write_en  (write_en),
        .write_addr(write_addr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .alu_op    (alu_op),
        .out_load  (out_load)
    );


    datapath U_datapath (
        .clk       (clk),
        .reset     (reset),
        .rf_src_sel(rf_src_sel),
        .write_en  (write_en),
        .write_addr(write_addr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .out_load  (out_load),
        .a_equal_b (a_equal_b),
        .alu_op    (alu_op),
        .outport   (outport)
    );
endmodule


module controlunit (
    input        clk,
    input        reset,
    input        a_equal_b,
    output       rf_src_sel,
    output       write_en,
    output [2:0] write_addr,
    output [2:0] read_addr1,
    output [2:0] read_addr2,
    output [1:0] alu_op,
    output       out_load
);

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, 
           S8 = 8, S9 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15,
           S16 = 16, S17 = 17, S18 = 18, S19 = 19, S20 = 20, S21 = 21, S22 = 22, S23 = 23,
           S24 = 24, S25 = 25, S26 = 26, S27 = 27, S28 = 28;


    reg [4:0] state_reg, state_next;
    reg [13:0] controlsignal;

    // assign {rf_src_sel, read_addr1, read_addr2, write_addr, write_en, alu_op, out_load} = controlsignal;

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
                state_next = S1;  // R1 initialize
            end
            S1: begin
                state_next = S2;  // R2 initialize
            end
            S2: begin
                state_next = S3;  // R3 initialize
            end
            S3: begin
                state_next = S4;  // compare R1, R3
            end
            S4: begin
                state_next = S5;  // R1 = R1 + R3
            end
            S5: begin
                state_next = S6;  // output R1
            end
            S6: begin
                state_next = S7;  // compare R1, R3
            end
            S7: begin
                state_next = S8;  // R2 = R1 + R3
            end
            S8: begin
                state_next = S9;  // output R2
            end
            S9: begin
                state_next = S10;  // compare R1, R2
            end
            S10: begin
                state_next = S11;  // R4 = R1 AND R2
            end
            S11: begin
                state_next = S12;  // output R4
            end
            S12: begin
                state_next = S13;  // compare R1, R2
            end
            S13: begin
                state_next = S14;  // R5 = R1 OR R2
            end
            S14: begin
                state_next = S15;  // output R5
            end
            S15: begin
                if (a_equal_b) begin
                    state_next = S22;
                end else begin
                    state_next = S16;  // compare R5, 0
                end
            end
            S16: begin
                state_next = S17;  // compare R2, 0
            end
            S17: begin
                state_next = S18;  // R6 = R2 + 0
            end
            S18: begin
                state_next = S19;  // output R6
            end
            S19: begin
                state_next = S20;  // compare R5, R6
            end
            S20: begin
                state_next = S21;  // R6 = R5 - R6
            end
            S21: begin
                state_next = S22;  // output R6
            end
            S22: begin
                state_next = S23;  // compare R1, 0
            end
            S23: begin
                state_next = S24;  // R5 = R1 + 0
            end
            S24: begin
                state_next = S25;  // output R5
            end
            S25: begin
                state_next = S26;  // compare R5, R3
            end
            S26: begin
                state_next = S27;  // R5 = R5 - R3
            end
            S27: begin
                state_next = S28;  // output R5
            end
            S28: begin
                state_next = S28;  // Halt
            end
        endcase


    end

    assign {rf_src_sel, read_addr1, read_addr2, write_addr, write_en, alu_op, out_load} = controlsignal;

    always @(*) begin
        controlsignal = 0;
        case (state_reg)

            S0: begin
                controlsignal = 14'b0_000_000_001_1_00_0;  // R1 initialize
            end
            S1: begin
                controlsignal = 14'b0_000_000_010_1_00_0;  // R2 initialize
            end
            S2: begin
                controlsignal = 14'b1_xxx_xxx_011_1_00_0;  // R3 initialize
            end

            S3: begin
                controlsignal = 14'bx_001_011_xxx_0_xx_0;  // compare R1, R3
            end
            S4: begin
                controlsignal = 14'b0_001_011_001_1_00_0;  // R1 = R1 + R3
            end
            S5: begin
                controlsignal = 14'bx_001_xxx_xxx_0_xx_1;  // output R1
            end

            S6: begin
                controlsignal = 14'bx_001_011_xxx_0_xx_0;  // compare R1, R3
            end
            S7: begin
                controlsignal = 14'b0_001_011_010_1_00_0;  // R2 = R1 + R3
            end
            S8: begin
                controlsignal = 14'bx_010_xxx_xxx_0_xx_1;  // output R2
            end

            S9: begin
                controlsignal = 14'bx_001_010_xxx_0_xx_0;  // compare R1, R2
            end
            S10: begin
                controlsignal = 14'b0_001_010_100_1_10_0;  // R4 = R1 AND R2
            end
            S11: begin
                controlsignal = 14'bx_100_xxx_xxx_0_xx_1;  // output R4
            end

            S12: begin
                controlsignal = 14'bx_001_010_xxx_0_xx_0;  // compare R1, R2
            end
            S13: begin
                controlsignal = 14'b0_001_010_101_1_11_0;  // R5 = R1 OR R2
            end
            S14: begin
                controlsignal = 14'bx_101_xxx_xxx_0_xx_1;  // output R5
            end

            S15: begin
                controlsignal = 14'bx_101_000_xxx_0_xx_0;  // compare R5, 0 
            end

            // if (R5)
            S16: begin
                controlsignal = 14'bx_010_000_xxx_0_xx_0;  // compare R2, 0 
            end
            S17: begin
                controlsignal = 14'b0_010_000_110_1_00_0;  // R6 = R2 + 0
            end
            S18: begin
                controlsignal = 14'bx_110_xxx_xxx_0_xx_1;  // output R6
            end

            S19: begin
                controlsignal = 14'bx_101_110_xxx_0_xx_0;  // compare R5, R6 
            end
            S20: begin
                controlsignal = 14'b0_101_110_110_1_01_0;  // R6 = R5 - R6
            end
            S21: begin
                controlsignal = 14'bx_110_xxx_xxx_0_xx_1;  // output R6
            end

            //else
            S22: begin
                controlsignal = 14'bx_001_000_xxx_0_xx_0;  // compare R1, 0 
            end
            S23: begin
                controlsignal = 14'b0_001_000_101_1_00_0;  // R5 = R1 + 0 
            end
            S24: begin
                controlsignal = 14'bx_101_xxx_xxx_0_xx_1;  // output R5
            end
            //end if
            S25: begin
                controlsignal = 14'bx_101_011_xxx_0_xx_0;  // compare R5, R3 
            end
            S26: begin
                controlsignal = 14'b0_101_011_101_1_01_0;  // R5 = R5 - R3 
            end
            S27: begin
                controlsignal = 14'bx_101_xxx_xxx_0_xx_1;  // output R5
            end

            S28: begin
                controlsignal = 14'bx_xxx_xxx_xxx_0_xx_0;  // Halt
            end
        endcase
    end
endmodule

module datapath (
    input         clk,
    input         reset,
    input         rf_src_sel,
    input         write_en,
    input  [ 2:0] write_addr,
    input  [ 2:0] read_addr1,
    input  [ 2:0] read_addr2,
    input  [ 1:0] alu_op,
    input         out_load,
    output        a_equal_b,
    output [15:0] outport
);

    wire [15:0] result, mux_data, read_data1, read_data2;

    mux_2x1 U_mux_2x1 (
        .x0 (result),
        .x1 (16'd1),
        .sel(rf_src_sel),
        .y  (mux_data)
    );

    RegisterFile U_register_file (
        .clk       (clk),
        .write_en  (write_en),
        .write_addr(write_addr),
        .write_data(mux_data),    // WD
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu_operation U_alu_operation (
        .a_in  (read_data1),
        .b_in  (read_data2),
        .alu_op(alu_op),
        .result(result)
    );

    comparator U_comparator (
        .i_in     (read_data1),
        .j_in     (read_data2),
        .a_equal_b(a_equal_b)
    );

    out_register U_out_register (
        .clk     (clk),
        .reset   (reset),
        .result  (result),
        .out_load(out_load),
        .outport (outport)
    );
endmodule

module RegisterFile (
    input         clk,
    input         write_en,
    input  [ 2:0] write_addr,
    input  [15:0] write_data,  // WD
    input  [ 2:0] read_addr1,
    input  [ 2:0] read_addr2,
    output [15:0] read_data1,
    output [15:0] read_data2
);

    reg [15:0] registerfile[0:7];

    always @(posedge clk) begin
        if (write_en) begin
            registerfile[write_addr] <= write_data;
        end
    end

    assign read_data1 = (read_addr1 != 0) ? registerfile[read_addr1] : 16'd0;
    assign read_data2 = (read_addr2 != 0) ? registerfile[read_addr2] : 16'd0;
    // fix address 0 => data 0
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

// module adder (
//     input  [15:0] a_in,
//     input  [15:0] b_in,
//     output [15:0] result
// );
//     assign result = a_in + b_in;
// endmodule

module alu_operation (
    input      [15:0] a_in,
    input      [15:0] b_in,
    input      [ 1:0] alu_op,
    output reg [15:0] result
);

    localparam ADD = 0, SUB = 1, AND = 2, OR = 3;


    always @(*) begin
        case (alu_op)
            ADD: begin
                result = a_in + b_in;
            end
            SUB: begin
                result = a_in - b_in;
            end
            AND: begin
                result = a_in & b_in;
            end
            OR: begin
                result = a_in | b_in;
            end
        endcase
    end

endmodule

module comparator (
    input  [15:0] i_in,
    input  [15:0] j_in,
    output        a_equal_b
);

    assign a_equal_b = (i_in == j_in);
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


