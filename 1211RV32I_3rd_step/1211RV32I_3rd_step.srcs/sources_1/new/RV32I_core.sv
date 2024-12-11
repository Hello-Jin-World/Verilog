`timescale 1ns / 1ps
`include "defines.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 09:25:54
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
    input  logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic [31:0] dataAddr,
    input  logic [31:0] readData,
    output logic [31:0] writeData,
    output logic        ramWe
);
    logic [2:0] RFWDSrcMuxSel;
    logic ALUSrcMuxSel, regFileWe, branch, jal, jalr;
    logic [3:0] aluControl;

    ControlUnit U_ControlUnit (.*);
    DataPath U_DataPath (.*);

    /*
    ControlUnit U_ControlUnit (
        .instrCode    (instrCode),
        // control unit signal
        .regFileWe    (regFileWe),
        .ALUSrcMuxSel (ALUSrcMuxSel),
        .RFWDSrcMuxSel(RFWDSrcMuxSel),
        .extType      (extType),
        .aluControl   (aluControl),
        // port
        .ramWe        (ramWe)
    );

    DataPath U_DataPath (
        // global signal
        .clk          (clk),
        .reset        (reset),
        // control unit signal
        .regFileWe    (regFileWe),
        .ALUSrcMuxSel (ALUSrcMuxSel),
        .RFWDSrcMuxSel(RFWDSrcMuxSel),
        .extType      (extType),
        .aluControl   (aluControl),
        // port
        .instrCode    (instrCode),
        .instrMemAddr (instrMemAddr),
        .dataAddr     (dataAddr),
        .readData     (readData)
    );
*/
endmodule

module ControlUnit (
    input  logic [31:0] instrCode,
    // control unit signal
    output logic        regFileWe,
    output logic        ALUSrcMuxSel,
    output logic [ 2:0] RFWDSrcMuxSel,
    output logic [ 3:0] aluControl,
    // port
    output logic        ramWe,
    output logic        branch,
    output logic        jal,
    output logic        jalr
);
    wire [6:0] opcode = instrCode[6:0];
    wire [2:0] func3 = instrCode[14:12];
    wire [6:0] func7 = instrCode[31:25];

    logic [9:0] controls;
    assign {regFileWe, ALUSrcMuxSel, RFWDSrcMuxSel, ramWe, branch, jal, jalr} = controls;


    always_comb begin
        case (opcode)
            //{regFileWe_ALUSrcMuxSel_RFWDSrcMuxSel_ramWe_branch_jal_jalr}
            `OP_TYPE_R:  controls = 9'b1_0_000_0_0_0_0;
            `OP_TYPE_IL: controls = 9'b1_1_001_0_0_0_0;
            `OP_TYPE_I:  controls = 9'b1_1_000_0_0_0_0;
            `OP_TYPE_S:  controls = 9'b0_1_000_1_0_0_0;
            `OP_TYPE_B:  controls = 9'b0_0_000_0_1_0_0;
            `OP_TYPE_U:  controls = 9'b1_0_011_0_0_0_0;
            `OP_TYPE_UA: controls = 9'b1_0_100_0_0_0_0;
            `OP_TYPE_J:  controls = 9'b1_0_010_0_0_1_0;
            `OP_TYPE_JI: controls = 9'b1_0_010_0_0_0_1;
            default:     controls = 9'bx;
        endcase
    end

    always_comb begin
        case (opcode)
            `OP_TYPE_R:  aluControl = {func7[5], func3};  // 4bit aluControl
            `OP_TYPE_IL: aluControl = `ADD;
            `OP_TYPE_I: begin
                case ({
                    func7[5], func3
                })
                    4'b1101: aluControl = {1'b1, func3};
                    default: aluControl = {1'b0, func3};
                endcase
            end
            `OP_TYPE_S:  aluControl = `ADD;
            `OP_TYPE_B:  aluControl = {1'b0, func3};
            `OP_TYPE_U:  aluControl = 0;
            `OP_TYPE_UA: aluControl = 0;
            `OP_TYPE_J: aluControl = 0;
            `OP_TYPE_JI: aluControl = 0;
            default:     aluControl = 4'bx;
        endcase
    end
endmodule

module DataPath (
    // global signal
    input  logic        clk,
    input  logic        reset,
    // control unit signal
    input  logic        regFileWe,
    input  logic        ALUSrcMuxSel,
    input  logic [ 2:0] RFWDSrcMuxSel,
    input  logic        branch,
    input  logic        jal,
    input  logic        jalr,
    //input  logic [ 2:0] extType,
    input  logic [ 3:0] aluControl,
    // port
    input  logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic [31:0] dataAddr,
    input  logic [31:0] readData,
    output logic [31:0] writeData
);
    logic [31:0]
        w_PC_Data,
        w_PC_imm_Data,
        w_PC_4_Data,
        w_AluResult,
        w_RegFileRData1,
        w_RegFileRData2;
    logic [31:0] w_ImmExt, w_ALUSrcMuxOut, w_RFWDSrcMuxOut, w_PC_adder_src;
    logic [31:0] JALR_Mux_Out;
    logic w_PC_adder_mux_sel;

    assign dataAddr           = w_AluResult;
    assign writeData          = w_RegFileRData2;
    assign w_PC_adder_mux_sel = jalr | jal | (branch & btaken);

    register U_PC (
        .clk  (clk),
        .reset(reset),
        .d    (w_PC_Data),
        .q    (instrMemAddr)
    );

    mux_2x1 U_JALR_Mux (
        .sel(jalr),
        .x0 (instrMemAddr),
        .x1 (w_RegFileRData1),
        .y  (JALR_Mux_Out)
    );

    adder U_Adder_PC_imm (
        .a(JALR_Mux_Out),
        .b(w_ImmExt),
        .y(w_PC_imm_Data)
    );
    adder U_Adder_PC_4 (
        .a(instrMemAddr),
        .b(32'd4),
        .y(w_PC_4_Data)
    );

    mux_2x1 U_PC_adder_mux_2x1 (
        .sel(w_PC_adder_mux_sel),
        .x0 (w_PC_4_Data),
        .x1 (w_PC_imm_Data),
        .y  (w_PC_Data)
    );


    RegisterFile U_RegisterFile (
        .clk   (clk),
        .we    (regFileWe),
        .RAddr1(instrCode[19:15]),
        .RAddr2(instrCode[24:20]),
        .WAddr (instrCode[11:7]),
        .WData (w_RFWDSrcMuxOut),
        .RData1(w_RegFileRData1),
        .RData2(w_RegFileRData2)
    );


    mux_2x1 U_ALUSrcMux (
        .sel(ALUSrcMuxSel),
        .x0 (w_RegFileRData2),
        .x1 (w_ImmExt),
        .y  (w_ALUSrcMuxOut)
    );

    alu U_ALU (
        .a         (w_RegFileRData1),
        .b         (w_ALUSrcMuxOut),
        .aluControl(aluControl),
        .btaken    (btaken),
        .result    (w_AluResult)
    );

    mux_5x1 U_RFWDSrcMux (
        .sel(RFWDSrcMuxSel),
        .x0 (w_AluResult),
        .x1 (readData),
        .x2 (w_PC_4_Data),
        .x3 (w_ImmExt),
        .x4 (w_PC_imm_Data),
        .y  (w_RFWDSrcMuxOut)
    );

    extend U_Extend (
        .instrCode(instrCode),
        .immExt   (w_ImmExt)
    );
endmodule

module register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk, posedge reset) begin
        if (reset) q <= 0;
        else q <= d;
    end
endmodule

module RegisterFile (
    input  logic        clk,
    input  logic        we,
    input  logic [ 4:0] RAddr1,
    input  logic [ 4:0] RAddr2,
    input  logic [ 4:0] WAddr,
    input  logic [31:0] WData,
    output logic [31:0] RData1,
    output logic [31:0] RData2
);
    logic [31:0] RegFile[0:31];

    initial begin  // for test
        for (int i = 0; i < 32; i = i + 1) begin
            RegFile[i] = i;
        end
    end

    always_ff @(posedge clk) begin
        if (we) RegFile[WAddr] <= WData;
    end

    assign RData1 = (RAddr1 != 0) ? RegFile[RAddr1] : 0;
    assign RData2 = (RAddr2 != 0) ? RegFile[RAddr2] : 0;
endmodule

module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [ 3:0] aluControl,
    output logic [31:0] result,
    output logic        btaken
);

    always_comb begin
        case (aluControl)
            `ADD:    result = a + b;
            `SUB:    result = a - b;
            `SLL:    result = a << b[4:0];
            `SRL:    result = a >> b[4:0];
            `SRA:    result = $signed(a) >>> b[4:0];
            `SLT:    result = ($signed(a) < $signed(b)) ? 1 : 0;
            `SLTU:   result = (a < b) ? 1 : 0;
            `XOR:    result = a ^ b;
            `OR:     result = a | b;
            `AND:    result = a & b;
            default: result = 32'bx;
        endcase
    end

    always_comb begin
        case (aluControl)
            `BEQ:    btaken = (a == b);
            `BNE:    btaken = (a != b);
            `BLT:    btaken = ($signed(a) < $signed(b));
            `BGE:    btaken = ($signed(a) >= $signed(b));
            `BLTU:   btaken = (a < b);
            `BGEU:   btaken = (a >= b);
            default: btaken = 0;
        endcase
    end
endmodule

module adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);
    assign y = a + b;
endmodule

module extend (
    input  logic [31:0] instrCode,
    output logic [31:0] immExt
);
    wire [6:0] opcode = instrCode[6:0];
    wire [2:0] func3 = instrCode[14:12];
    wire [6:0] func7 = instrCode[31:25];

    always_comb begin
        case (opcode)
            `OP_TYPE_R: immExt = 32'bx;
            `OP_TYPE_IL: immExt = {{20{instrCode[31]}}, instrCode[31:20]};
            `OP_TYPE_I: begin
                case ({
                    func7[5], func3
                })
                    4'b0001: immExt = {27'b0, instrCode[24:20]};
                    4'b0101: immExt = {27'b0, instrCode[24:20]};
                    4'b1101: immExt = {27'b0, instrCode[24:20]};
                    default: immExt = {{20{instrCode[31]}}, instrCode[31:20]};
                endcase
            end
            `OP_TYPE_S:
            immExt = {{20{instrCode[31]}}, instrCode[31:25], instrCode[11:7]};
            `OP_TYPE_B:
            immExt = {
                {20{instrCode[31]}},
                instrCode[7],
                instrCode[30:25],
                instrCode[11:8],
                1'b0
            };
            `OP_TYPE_U: immExt = {instrCode[31:12], 12'b0} << 12;
            `OP_TYPE_UA: immExt = {instrCode[31:12], 12'b0} << 12;
            `OP_TYPE_J:
            immExt = {
                {12{instrCode[31]}},
                instrCode[19:12],
                instrCode[20],
                instrCode[30:21],
                1'b0
            };
            `OP_TYPE_JI: immExt = {{20{instrCode[31]}}, instrCode[31:20]};
            default: immExt = 32'bx;
        endcase
    end
endmodule

module mux_2x1 (
    input  logic        sel,
    input  logic [31:0] x0,
    input  logic [31:0] x1,
    output logic [31:0] y
);
    always_comb begin
        case (sel)
            1'b0:    y = x0;
            1'b1:    y = x1;
            default: y = 32'bx;
        endcase
    end
endmodule

module mux_5x1 (
    input  logic [ 2:0] sel,
    input  logic [31:0] x0,
    input  logic [31:0] x1,
    input  logic [31:0] x2,
    input  logic [31:0] x3,
    input  logic [31:0] x4,
    output logic [31:0] y
);
    always_comb begin
        case (sel)
            3'b000:  y = x0;
            3'b001:  y = x1;
            3'b010:  y = x2;
            3'b011:  y = x3;
            3'b100:  y = x4;
            default: y = 32'bx;
        endcase
    end

endmodule
