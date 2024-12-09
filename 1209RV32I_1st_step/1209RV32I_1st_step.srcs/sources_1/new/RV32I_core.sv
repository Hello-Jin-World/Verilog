`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 13:13:42
// Design Name: 
// Module Name: RV32I_core
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


module RV32I_core (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instruction_code,
    output logic [31:0] instruction_mem_addr
);

    wire [3:0] alu_control;
    wire       RegFile_write_enable;

    Control_Unit U_Control_Unit (
        .instruction_code    (instruction_code),
        .RegFile_write_enable(RegFile_write_enable),
        .alu_control         (alu_control)
    );

    Data_Path U_Data_Path (
        .clk                 (clk),
        .reset               (reset),
        .instruction_code    (instruction_code),
        .RegFile_write_enable(RegFile_write_enable),
        .alu_control         (alu_control),
        .instruction_mem_addr(instruction_mem_addr)
    );
endmodule


module Control_Unit (
    input  logic [31:0] instruction_code,
    output logic        RegFile_write_enable,
    output logic [ 3:0] alu_control
);

    wire  [6:0] opcode = instruction_code[6:0];
    wire  [2:0] func3 = instruction_code[14:12];
    wire  [6:0] func7 = instruction_code[31:25];

    logic                                        controls;
    assign {RegFile_write_enable} = controls;

    localparam
    R_TYPE  = 7'b0110011,
    IL_TYPE = 7'b0000011,
    I_TYPE  = 7'b0010011,
    S_TYPE  = 7'b0100011,
    B_TYPE  = 7'b1100011
    ;

    localparam
    // func7[5], func3
    R_ADD  = 4'b0_000,
    R_SUB  = 4'b1_000,
    R_SLL  = 4'b0_001,
    R_SRL  = 4'b0_101,
    R_SRA  = 4'b1_101,
    R_SLT  = 4'b0_010,
    R_SLTU = 4'b0_011,
    R_XOR  = 4'b0_100,
    R_OR   = 4'b0_110,
    R_AND  = 4'b0_111
    ;

    localparam OUT_ADD = 0, OUT_SUB = 1, OUT_SLL = 2, OUT_SRL = 3, OUT_SRA = 4, OUT_SLT = 5, OUT_SLTU = 6, OUT_XOR = 7, OUT_OR = 8, OUT_AND = 9;

    always_comb begin
        case (opcode)
            R_TYPE: begin
                controls = 1'b1;
            end
            default: begin
                controls = 1'bx;
            end
        endcase
    end

    always_comb begin
        case (opcode)
            R_TYPE: begin
                case ({
                    func7[5], func3
                })
                    R_ADD: begin
                        alu_control = OUT_ADD;
                    end
                    R_SUB: begin
                        alu_control = OUT_SUB;
                    end
                    R_SLL: begin
                        alu_control = OUT_SLL;
                    end
                    R_SRL: begin
                        alu_control = OUT_SRL;
                    end
                    R_SRA: begin
                        alu_control = OUT_SRA;
                    end
                    R_SLT: begin
                        alu_control = OUT_SLT;
                    end
                    R_SLTU: begin
                        alu_control = OUT_SLTU;
                    end
                    R_XOR: begin
                        alu_control = OUT_XOR;
                    end
                    R_AND: begin
                        alu_control = OUT_AND;
                    end
                    R_OR: begin
                        alu_control = OUT_OR;
                    end
                    default: alu_control = 4'bx;
                endcase
            end
            default: alu_control = 4'bx;
        endcase
    end
endmodule

module Data_Path (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instruction_code,
    input  logic        RegFile_write_enable,
    input  logic [ 3:0] alu_control,
    output logic [31:0] instruction_mem_addr
);

    wire [31:0] PC_data, alu_result, read_data1, read_data2;

    register U_program_counter (
        .clk  (clk),
        .reset(reset),
        .d_in (PC_data),
        .q_out(instruction_mem_addr)
    );

    adder U_adder_program_counter (
        .a_in (instruction_mem_addr),
        .b_in (32'd4),
        .y_out(PC_data)
    );

    register_file U_register_file (
        .clk         (clk),
        .write_enable(RegFile_write_enable),
        .write_addr  (instruction_code[11:7]),
        .read_addr1  (instruction_code[19:15]),
        .read_addr2  (instruction_code[24:20]),
        .write_data  (alu_result),
        .read_data1  (read_data1),
        .read_data2  (read_data2)
    );

    alu U_alu (
        .a_in       (read_data1),
        .b_in       (read_data2),
        .alu_control(alu_control),
        .result     (alu_result)
    );

endmodule

module register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d_in,
    output logic [31:0] q_out
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            q_out <= 0;
        end else begin
            q_out <= d_in;
        end
    end
endmodule

module register_file (
    input  logic        clk,
    input  logic        write_enable,
    input  logic [ 4:0] write_addr,
    input  logic [ 4:0] read_addr1,
    input  logic [ 4:0] read_addr2,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    logic [31:0] RegFile[0:31];

    initial begin
        for (int i = 0; i < 32; i++) begin
            RegFile[i] = i;
        end
    end

    always_ff @(posedge clk) begin
        if (write_enable) begin
            RegFile[write_addr] <= write_data;
        end
    end

    assign read_data1 = (read_addr1 != 0) ? RegFile[read_addr1] : 0;
    assign read_data2 = (read_addr2 != 0) ? RegFile[read_addr2] : 0;
endmodule

module alu (
    input  logic [31:0] a_in,
    input  logic [31:0] b_in,
    input  logic [ 3:0] alu_control,
    output logic [31:0] result
);

    localparam 
    ADD = 0, 
    SUB = 1, 
    SLL = 2, 
    SRL = 3, 
    SRA = 4, 
    SLT = 5, 
    SLTU = 6, 
    XOR = 7, 
    OR = 8,
    AND = 9;

    always @(*) begin
        case (alu_control)
            ADD: begin
                result = a_in + b_in;
            end
            SUB: begin
                result = a_in - b_in;
            end
            SLL: begin
                result = a_in << b_in;
            end
            SRL: begin
                result = a_in >> b_in;
            end
            SRA: begin
                result = $signed(a_in) >>> (b_in);
            end
            SLT: begin
                result = ($signed(a_in) < $signed(b_in)) ? 1 : 0;
            end
            SLTU: begin
                result = (a_in < b_in) ? 1 : 0;
            end
            XOR: begin
                result = a_in ^ b_in;
            end
            AND: begin
                result = a_in & b_in;
            end
            OR: begin
                result = a_in | b_in;
            end
            default: begin
                result = 32'bx;
            end
        endcase
    end
endmodule

module adder (
    input  logic [31:0] a_in,
    input  logic [31:0] b_in,
    output logic [31:0] y_out
);

    assign y_out = a_in + b_in;
endmodule

module instruction_memory ();

endmodule

module data_memory ();

endmodule
