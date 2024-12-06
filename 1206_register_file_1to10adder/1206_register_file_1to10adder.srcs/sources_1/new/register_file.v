`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 14:31:43
// Design Name: 
// Module Name: register_file
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


module register_file (
    input         clk,
    input         reset,
    output [15:0] outport
    // output [3:0] fndcom,
    // output [7:0] fndfont
);


    // wire [15:0] outport;
    wire       i_less_equal_10;
    wire       rf_src_sel;
    wire       write_en;
    wire [1:0] write_addr;
    wire [1:0] read_addr1;
    wire [1:0] read_addr2;
    wire       out_load;

    controlunit U_controlunit (
        .clk            (clk),
        .reset          (reset),
        .i_less_equal_10(i_less_equal_10),
        .rf_src_sel     (rf_src_sel),
        .write_en       (write_en),
        .write_addr     (write_addr),
        .read_addr1     (read_addr1),
        .read_addr2     (read_addr2),
        .out_load       (out_load)
    );


    datapath U_datapath (
        .clk            (clk),
        .reset          (reset),
        .rf_src_sel     (rf_src_sel),
        .write_en       (write_en),
        .write_addr     (write_addr),
        .read_addr1     (read_addr1),
        .read_addr2     (read_addr2),
        .out_load       (out_load),
        .i_less_equal_10(i_less_equal_10),
        .outport        (outport)
    );
    // fnd_controller U_fnd_controller (
    //     .clk       (clk),
    //     .reset     (reset),
    //     .sum_result(outport),
    //     .fndcom    (fndcom),
    //     .fndfont   (fndfont)
    // );
endmodule


module controlunit (
    input        clk,
    input        reset,
    input        i_less_equal_10,
    output       rf_src_sel,
    output       write_en,
    output [1:0] write_addr,
    output [1:0] read_addr1,
    output [1:0] read_addr2,
    output       out_load
);

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;

    reg [2:0] state_reg, state_next;
    reg [8:0] controlsignal;

    assign {rf_src_sel, read_addr1, read_addr2, write_addr, write_en, out_load} = controlsignal;

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
                state_next = S2;
            end
            S2: begin
                state_next = S3;
            end
            S3: begin
                if (i_less_equal_10) begin
                    state_next = S4;
                end else begin
                    state_next = S7;
                end
            end
            S4: begin
                state_next = S5;
            end
            S5: begin
                state_next = S6;
            end
            S6: begin
                state_next = S3;
            end
            S7: begin
                state_next = S7;
            end
        endcase
    end

    // assign {rf_src_sel, read_addr1, read_addr2, write_addr, write_en, out_load} = controlsignal;
    always @(*) begin
        controlsignal = 0;
        case (state_reg)

            S0: begin
                controlsignal = 9'b0_00_00_01_1_0;
            end
            S1: begin
                controlsignal = 9'b0_00_00_10_1_0;
            end
            S2: begin
                controlsignal = 9'b1_xx_xx_11_1_0;
            end
            S3: begin
                controlsignal = 9'bx_01_xx_xx_0_0;
            end
            S4: begin
                controlsignal = 9'b0_10_01_10_1_0;
            end
            S5: begin
                controlsignal = 9'b0_01_11_01_1_0;
            end
            S6: begin
                controlsignal = 9'bx_10_xx_xx_0_1;
            end
            S7: begin
                controlsignal = 9'bx_xx_xx_xx_0_0;
            end
        endcase
    end
endmodule

module datapath (
    input         clk,
    input         reset,
    input         rf_src_sel,
    input         write_en,
    input  [ 1:0] write_addr,
    input  [ 1:0] read_addr1,
    input  [ 1:0] read_addr2,
    input         out_load,
    output        i_less_equal_10,
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

    adder U_adder (
        .a_in  (read_data1),
        .b_in  (read_data2),
        .result(result)
    );

    comparator U_comparator (
        .i_in           (read_data1),
        .object         (16'd10),
        .i_less_equal_10(i_less_equal_10)
    );

    out_register U_out_register (
        .clk     (clk),
        .reset   (reset),
        .result  (read_data1),
        .out_load(out_load),
        .outport (outport)
    );
endmodule

module RegisterFile (
    input         clk,
    input         write_en,
    input  [ 1:0] write_addr,
    input  [15:0] write_data,  // WD
    input  [ 1:0] read_addr1,
    input  [ 1:0] read_addr2,
    output [15:0] read_data1,
    output [15:0] read_data2
);

    reg [15:0] registerfile[0:3];

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

