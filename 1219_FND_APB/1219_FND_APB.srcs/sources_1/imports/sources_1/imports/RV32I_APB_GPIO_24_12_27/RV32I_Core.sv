`timescale 1ns / 1ps
`include "defines.sv"

module RV32I_Core (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic [31:0] dataAddr,
    input  logic [31:0] readData,
    output logic [31:0] writeData,
    input  logic        ready,
    output logic        enable,
    output logic        ramWe
);
    logic regFileWe, JAL, JALR;
    logic ALUSrcMuxSel, branch;
    logic PCEn, PrePCRegEn, DecRegEn, ExeRegEn, MemAccRegEn;
    logic [ 3:0] aluControl;
    logic [ 2:0] RFWDSrcMuxSel;
    logic [31:0] IR_instrCode;

    ControlUnit U_ControlUnit (.*);
    DataPath U_DataPath (.*);

endmodule

module ControlUnit (
    // global signal
    input  logic        clk,
    input  logic        reset,
    // control unit signal
    input  logic [31:0] instrCode,
    output logic        regFileWe,
    output logic        ALUSrcMuxSel,
    output logic [ 2:0] RFWDSrcMuxSel,
    output logic [ 3:0] aluControl,
    output logic        branch,
    output logic        JAL,
    output logic        JALR,
    output logic        PCEn,
    output logic        PrePCRegEn,
    output logic        DecRegEn,
    output logic        ExeRegEn,
    output logic        MemAccRegEn,
    // port
    input  logic        ready,
    output logic        enable,
    output logic        ramWe
);
    wire [6:0] opcode = instrCode[6:0];
    wire [2:0] func3 = instrCode[14:12];
    wire [6:0] func7 = instrCode[31:25];

    logic [14:0] controls;
    //   logic [3:0] state, state_next;

    typedef enum {
        FETCH,
        DECODE,
        R_EXE,
        IL_EXE,
        IL_MEM_SETUP,   // LOAD, Read
        IL_MEM_ACCESS,  // LOAD, Read
        IL_WB,
        I_EXE,
        S_EXE,
        S_MEM_SETUP,    // STORE, Write
        S_MEM_ACCESS,   // STORE, Write
        B_EXE,
        U_EXE,
        UA_EXE,
        J_EXE,
        JI_EXE
    } state_e;

    state_e state, state_next;
    assign {regFileWe, ALUSrcMuxSel, RFWDSrcMuxSel, ramWe, branch, JAL, JALR, PCEn, PrePCRegEn, DecRegEn, ExeRegEn, MemAccRegEn, enable} = controls;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= FETCH;
        else state <= state_next;
    end

    always_comb begin
        state_next = state;
        case (state)
            FETCH:        state_next = DECODE;
            DECODE: begin
                case (opcode)
                    `OP_TYPE_R:  state_next = R_EXE;
                    `OP_TYPE_IL: state_next = IL_EXE;
                    `OP_TYPE_I:  state_next = I_EXE;
                    `OP_TYPE_S:  state_next = S_EXE;
                    `OP_TYPE_B:  state_next = B_EXE;
                    `OP_TYPE_U:  state_next = U_EXE;
                    `OP_TYPE_UA: state_next = UA_EXE;
                    `OP_TYPE_J:  state_next = J_EXE;
                    `OP_TYPE_JI: state_next = JI_EXE;
                    default:     state_next = FETCH;
                endcase
            end
            R_EXE:        state_next = FETCH;
            IL_EXE:       state_next = IL_MEM_SETUP;
            IL_MEM_SETUP: state_next = IL_MEM_ACCESS;
            IL_MEM_ACCESS: begin
                if (ready) state_next = IL_WB;
                else state_next = IL_MEM_ACCESS;
            end
            IL_WB:        state_next = FETCH;
            I_EXE:        state_next = FETCH;
            S_EXE:        state_next = S_MEM_SETUP;
            S_MEM_SETUP:  state_next = S_MEM_ACCESS;
            S_MEM_ACCESS: begin
                if (ready) state_next = FETCH;
                else state_next = S_MEM_ACCESS;
            end
            B_EXE:        state_next = FETCH;
            U_EXE:        state_next = FETCH;
            UA_EXE:       state_next = FETCH;
            J_EXE:        state_next = FETCH;
            JI_EXE:       state_next = FETCH;
            default:      state_next = FETCH;
        endcase
    end

    always_comb begin
        controls   = 14'b0;
        aluControl = `ADD;
        case (state)
            //{regFileWe_ALUSrcMuxSel_RFWDSrcMuxSel(3)_ramWe_branch_JAL_JALR_PCEn_PrePCRegEn_DecRegEn_ExeRegEn_MemAccRegEn_enable}
            FETCH:         controls = 15'b0_0_000_0_0_0_0_1_0_0_0_0_0;
            DECODE:        controls = 15'b0_0_000_0_0_0_0_0_0_1_0_0_0;
            R_EXE: begin
                controls   = 15'b1_0_000_0_0_0_0_0_1_0_0_0_0;
                aluControl = {func7[5], func3};
            end
            IL_EXE:        controls = 15'b0_1_001_0_0_0_0_0_1_0_1_0_0;
            IL_MEM_SETUP:  controls = 15'b0_1_001_0_0_0_0_0_0_0_0_1_0;
            IL_MEM_ACCESS: controls = 15'b0_1_001_0_0_0_0_0_0_0_0_1_1;
            IL_WB:         controls = 15'b1_1_001_0_0_0_0_0_0_0_0_0_0;
            I_EXE: begin
                controls = 15'b1_1_000_0_0_0_0_0_1_0_0_0_0;
                case ({
                    func7[5], func3
                })
                    4'b1101: aluControl = {1'b1, func3};
                    default: aluControl = {1'b0, func3};
                endcase
            end
            S_EXE:         controls = 15'b0_1_000_0_0_0_0_0_1_0_1_0_0;
            S_MEM_SETUP:   controls = 15'b0_1_000_1_0_0_0_0_0_0_0_0_0;
            S_MEM_ACCESS:  controls = 15'b0_1_000_1_0_0_0_0_0_0_0_0_1;
            B_EXE: begin
                controls   = 15'b0_0_000_0_1_0_0_0_1_0_0_0_0;
                aluControl = {1'b0, func3};
            end
            U_EXE:         controls = 15'b1_0_011_0_0_0_0_0_1_0_0_0_0;
            UA_EXE:        controls = 15'b1_0_100_0_0_0_0_0_1_0_0_0_0;
            J_EXE:         controls = 15'b1_0_010_0_0_1_0_0_1_0_0_0_0;
            JI_EXE:        controls = 15'b1_0_010_0_0_0_1_0_1_0_0_0_0;
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
    input  logic [ 3:0] aluControl,
    input  logic        JAL,
    input  logic        JALR,
    input  logic        PCEn,
    input  logic        PrePCRegEn,
    input  logic        DecRegEn,
    input  logic        ExeRegEn,
    input  logic        MemAccRegEn,
    // port
    input  logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic [31:0] dataAddr,
    input  logic [31:0] readData,
    output logic [31:0] writeData
);
    logic [31:0] w_PC_Imm_Data, w_PC_4_Data, w_AluResult, w_RegFileRData1, w_RegFileRData2;
    logic [31:0] w_ImmExt, w_ALUSrcMuxOut, w_RFWDSrcMuxOut, w_PCAdderSrcMuxOut;
    logic [31:0] w_PCImmAdderSrcMuxOut;
    logic w_PCAdderSrcMuxSel, w_btaken;
    logic [31:0] DecReg_ImmExt, MemAccReg_readData;
    logic [31:0] DecReg_RegFileRData1, DecReg_RegFileRData2;
    logic [31:0] w_PrePCReg;

    assign w_PCAdderSrcMuxSel = JALR | JAL | (branch & w_btaken);

    register U_EXE_Reg1 (
        .clk  (clk),
        .reset(reset),
        .en   (ExeRegEn),
        .d    (w_AluResult),
        .q    (dataAddr)
    );

    register U_EXE_Reg2 (
        .clk  (clk),
        .reset(reset),
        .en   (ExeRegEn),
        .d    (DecReg_RegFileRData2),
        .q    (writeData)
    );

    register U_MemAcc_Reg (
        .clk  (clk),
        .reset(reset),
        .en   (MemAccRegEn),
        .d    (readData),
        .q    (MemAccReg_readData)
    );

    mux_2x1 U_PCImmAdderSrcMux (
        .sel(JALR),
        .x0 (instrMemAddr),
        .x1 (DecReg_RegFileRData1),
        .y  (w_PCImmAdderSrcMuxOut)
    );

    adder U_Adder_PC_Imm (
        .a(w_PCImmAdderSrcMuxOut),
        .b(DecReg_ImmExt),
        .y(w_PC_Imm_Data)
    );

    adder U_Adder_PC_4 (
        .a(instrMemAddr),
        .b(4),
        .y(w_PC_4_Data)
    );

    mux_2x1 U_PCAdderSrcMux (
        .sel(w_PCAdderSrcMuxSel),
        .x0 (w_PC_4_Data),
        .x1 (w_PC_Imm_Data),
        .y  (w_PCAdderSrcMuxOut)
    );


    register U_PrePCReg (
        .clk  (clk),
        .reset(reset),
        .en   (PrePCRegEn),
        .d    (w_PCAdderSrcMuxOut),
        .q    (w_PrePCReg)
    );

    register U_PC (
        .clk  (clk),
        .reset(reset),
        .en   (PCEn),
        .d    (w_PrePCReg),
        .q    (instrMemAddr)
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


    register U_DecReg1 (
        .clk  (clk),
        .reset(reset),
        .en   (DecRegEn),
        .d    (w_RegFileRData1),
        .q    (DecReg_RegFileRData1)
    );

    register U_DecReg2 (
        .clk  (clk),
        .reset(reset),
        .en   (DecRegEn),
        .d    (w_RegFileRData2),
        .q    (DecReg_RegFileRData2)
    );

    mux_2x1 U_ALUSrcMux (
        .sel(ALUSrcMuxSel),
        .x0 (DecReg_RegFileRData2),
        .x1 (DecReg_ImmExt),
        .y  (w_ALUSrcMuxOut)
    );

    alu U_ALU (
        .a         (DecReg_RegFileRData1),
        .b         (w_ALUSrcMuxOut),
        .aluControl(aluControl),
        .result    (w_AluResult),
        .btaken    (w_btaken)
    );

    mux_5x1 U_RFWDSrcMux (
        .sel(RFWDSrcMuxSel),
        .x0 (w_AluResult),
        .x1 (MemAccReg_readData),
        .x2 (w_PC_4_Data),
        .x3 (DecReg_ImmExt),
        .x4 (w_PC_Imm_Data),
        .y  (w_RFWDSrcMuxOut)
    );

    extend U_Extend (
        .instrCode(instrCode),
        .immExt(w_ImmExt)
    );

    register U_DecReg3 (
        .clk  (clk),
        .reset(reset),
        .en   (DecRegEn),
        .d    (w_ImmExt),
        .q    (DecReg_ImmExt)
    );

endmodule

module register (
    input  logic        clk,
    input  logic        reset,
    input  logic        en,
    input  logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk, posedge reset) begin
        if (reset) q <= 0;
        else if (en) q <= d;
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

    // initial begin  // for test
    //     for (int i = 0; i < 32; i = i + 1) begin
    //         RegFile[i] = i;
    //     end
    // end

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
            `BLTU:    btaken = (a < b);
            `BGEU:    btaken = (a >= b);
            default: btaken = 1'b0;
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
                    default: begin
                        if (func3 == 3'b011) immExt = {20'b0, instrCode[31:20]};
                        else immExt = {{20{instrCode[31]}}, instrCode[31:20]};
                    end
                endcase
            end
            `OP_TYPE_S: immExt = {{20{instrCode[31]}}, instrCode[31:25], instrCode[11:7]};
            `OP_TYPE_B: immExt = {{20{instrCode[31]}}, instrCode[7], instrCode[30:25], instrCode[11:8], 1'b0};
            `OP_TYPE_U: immExt = {instrCode[31:12], 12'b0};
            `OP_TYPE_UA: immExt = {instrCode[31:12], 12'b0};
            `OP_TYPE_J: immExt = {{12{instrCode[31]}}, instrCode[19:12], instrCode[20], instrCode[30:21], 1'b0};
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
