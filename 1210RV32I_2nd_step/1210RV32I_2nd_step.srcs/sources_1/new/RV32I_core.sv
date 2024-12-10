`timescale 1ns / 1ps
`include "defines.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 09:40:55
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
    input  logic [31:0] readData,
    output logic [31:0] dataAddr,
    output logic [31:0] instrMemAddr,
    output logic [31:0] writeData,
    output logic        ramWe
);
    logic regFileWe, ALUSrcMuxSel, RFWDSrcMuxSel;
    logic [3:0] aluControl;
    logic [2:0] extType;


    ControlUnit U_ControlUnit (.*);

    // ControlUnit U_ControlUnit (
    //     .instrCode    (instrCode),
    //     .regFileWe    (w_regFileWe),
    //     .ALUSrcMuxSel (w_ALUSrcMuxSel),
    //     .RFWDSrcMuxSel(w_RFWDSrcMuxSel),
    //     .extType      (w_extType),
    //     .aluControl   (w_aluControl),
    //     .ramWe        (ramWe)
    // );

    DataPath U_DataPath (.*);

    // DataPath U_DataPath (
    //     .clk          (clk),
    //     .reset        (reset),
    //     // Control Unit Signal
    //     .regFileWe    (w_regFileWe),
    //     .ALUSrcMuxSel (w_ALUSrcMuxSel),
    //     .RFWDSrcMuxSel(w_RFWDSrcMuxSel),
    //     .extType      (w_extType),
    //     .aluControl   (w_aluControl),
    //     // port
    //     .instrCode    (instrCode),
    //     .instrMemAddr (instrMemAddr),
    //     .dataAddr     (dataAddr),
    //     .readData     (readData)
    // );


endmodule

module ControlUnit (
    input  logic [31:0] instrCode,
    output logic        regFileWe,
    // Control Unit Signal
    output logic        ALUSrcMuxSel,
    output logic        RFWDSrcMuxSel,
    output logic [ 2:0] extType,
    output logic [ 3:0] aluControl,
    // port
    output logic        ramWe
);
    wire [6:0] opcode = instrCode[6:0];
    wire [2:0] func3 = instrCode[14:12];
    wire [6:0] func7 = instrCode[31:25];

    logic [6:0] controls;
    assign {regFileWe, ALUSrcMuxSel, RFWDSrcMuxSel, extType, ramWe} = controls;


    always_comb begin
        case (opcode)
            // {regFileWe, ALUSrcMuxSel, RFWDSrcMuxSel, extType, ramWe}
            `OP_TYPE_R:  controls = 7'b1_0_0_000_0;  // R-TYPE 
            `OP_TYPE_IL: controls = 7'b1_1_1_001_0;  // IL-TYPE 
            `OP_TYPE_I:  controls = 7'b1_1_0_010_0;  // I-TYPE 
            `OP_TYPE_S:  controls = 7'b0_1_0_011_1;  // S-TYPE 
            `OP_TYPE_B:  controls = 7'bx;  // B-TYPE 
            `OP_TYPE_U:  controls = 7'bx;
            `OP_TYPE_UA: controls = 7'bx;
            `OP_TYPE_J:  controls = 7'bx;
            `OP_TYPE_JI: controls = 7'bx;
            default:     controls = 7'bx;
        endcase
    end

    always_comb begin
        case (opcode)
            `OP_TYPE_R: begin
                aluControl = {func7[5], func3};  // R-TYPE 4bit aluControl
            end
            `OP_TYPE_IL: begin
                case (func3)
                    `BYTE:  aluControl = `ADD_BYTE;
                    `HALF:  aluControl = `ADD_HALF;
                    `WORD:  aluControl = `ADD_WORD;
                    `UBYTE: aluControl = `ADD_UBYTE;
                    `UHALF: aluControl = `ADD_UHALF;
                endcase
            end
            `OP_TYPE_I: begin
                case ({
                    1'b0, func3
                })
                    `ADD:  aluControl = `ADD;
                    `SLT:  aluControl = `SLT;
                    `SLTU: aluControl = `SLTU;
                    `XOR:  aluControl = `XOR;
                    `OR:   aluControl = `OR;
                    `AND:  aluControl = `AND;
                endcase
                case ({
                    func7[5], func3
                })
                    `SLL: aluControl = `SLL;
                    `SRL: aluControl = `SRL;
                    `SRA: aluControl = `SRA;
                endcase
            end
            `OP_TYPE_S: begin
                case (func3)
                    `BYTE: aluControl = `ADD_BYTE;
                    `HALF: aluControl = `ADD_HALF;
                    `WORD: aluControl = `ADD_WORD;
                endcase
            end
            default: aluControl = 4'bx;
        endcase
    end
endmodule

module DataPath (
    input  logic        clk,
    input  logic        reset,
    // Control Unit Signal
    input  logic        regFileWe,
    input  logic        ALUSrcMuxSel,
    input  logic        RFWDSrcMuxSel,
    input  logic [ 2:0] extType,
    input  logic [ 3:0] aluControl,
    // port
    input  logic [31:0] instrCode,
    output logic [31:0] instrMemAddr,
    output logic [31:0] dataAddr,
    input  logic [31:0] readData,
    output logic [31:0] writeData
);
    logic [31:0] w_immExt, w_ALUSrcMuxOut, w_RFWDSrcMuxOut;
    logic [31:0]
        w_PC_Data,
        w_AluResult,
        w_RegFileRData1,
        w_RegFileRData2,
        ww_RegFileRData2,
        w_readData;

    assign dataAddr  = w_AluResult;
    assign writeData = ww_RegFileRData2;

    DataSelector U_DataSelector (
        .aluControl(aluControl),
        .opcode    (instrCode[6:0]),
        .wData_in  (w_RegFileRData2),
        .rData_in  (readData),
        .wData_out (ww_RegFileRData2),
        .rData_out (w_readData)
    );
    register U_PC (
        .clk  (clk),
        .reset(reset),
        .d    (w_PC_Data),
        .q    (instrMemAddr)
    );

    adder U_Adder_PC (
        .a(instrMemAddr),
        .b(32'd4),
        .y(w_PC_Data)
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
        .x1 (w_immExt),
        .y  (w_ALUSrcMuxOut)
    );

    alu U_ALU (
        .a         (w_RegFileRData1),
        .b         (w_ALUSrcMuxOut),
        .aluControl(aluControl),
        .result    (w_AluResult)
    );

    mux_2x1 U_RFWDSrcKMux (
        .sel(RFWDSrcMuxSel),
        .x0 (w_AluResult),
        .x1 (w_readData),
        .y  (w_RFWDSrcMuxOut)
    );

    extend U_extend (
        .instrCode(instrCode[31:7]),
        .extType  (extType),
        .immExt   (w_immExt)
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
        RegFile[31] = 32'hffffffff;
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
    output logic [31:0] result
);

    logic [7:0] temp;

    always_comb begin
        case (aluControl)
            `ADD:       result = a + b;
            `SUB:       result = a - b;
            `SLL:       result = a << b;
            `SRL:       result = a >> b;
            `SRA:       result = $signed(a) >>> b[4:0];
            // b = 32bit / Can shift num of 2^32. So, limit 5bit from LSB (2^5)
            `SLT:       result = $signed(a) < $signed(b);
            `SLTU:      result = a < b;
            `XOR:       result = a ^ b;
            `OR:        result = a | b;
            `AND:       result = a & b;
            `ADD_BYTE:  result = a + b;
            `ADD_HALF:  result = a + b;
            `ADD_WORD:  result = a + b;
            `ADD_UBYTE: result = a + b;
            `ADD_UHALF: result = a + b;
            default:    result = 32'bx;
        endcase
    end
endmodule

module DataSelector (
    input  logic [ 3:0] aluControl,
    input  logic [ 6:0] opcode,
    input  logic [31:0] wData_in,
    input  logic [31:0] rData_in,
    output logic [31:0] wData_out,
    output logic [31:0] rData_out
);

    always_comb begin
        if (opcode == `OP_TYPE_IL) begin
            case (aluControl)
                `ADD_BYTE: begin
                    wData_out = wData_in;
                    rData_out = {{24{rData_in[7]}}, rData_in[7:0]};
                end
                `ADD_HALF: begin
                    wData_out = wData_in;
                    rData_out = {{16{rData_in[15]}}, rData_in[15:0]};
                end
                `ADD_WORD: begin
                    wData_out = wData_in;
                    rData_out = rData_in;
                end
                `ADD_UBYTE: begin
                    wData_out = wData_in;
                    rData_out = {24'b0, rData_in[7:0]};
                end
                `ADD_UHALF: begin
                    wData_out = wData_in;
                    rData_out = {16'b0, rData_in[15:0]};
                end
                default: begin
                    wData_out = wData_in;
                    rData_out = rData_in;
                end
            endcase
        end else if (opcode == `OP_TYPE_S) begin
            case (aluControl)
                `ADD_BYTE: begin
                    wData_out = {24'b0, wData_in[7:0]};
                    rData_out = rData_in;
                end
                `ADD_HALF: begin
                    wData_out = {16'b0, wData_in[15:0]};
                    rData_out = rData_in;
                end
                `ADD_WORD: begin
                    wData_out = wData_in;
                    rData_out = rData_in;
                end
                default: begin
                    wData_out = wData_in;
                    rData_out = rData_in;
                end
            endcase
        end else begin
            wData_out = wData_in;
            rData_out = rData_in;
        end
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
    input  logic [31:7] instrCode,
    input  logic [ 2:0] extType,
    output logic [31:0] immExt
);
    typedef enum {
        R_Type,   // 0
        IL_Type,
        I_Type,
        S_Type,
        B_Type,
        U_Type,
        J_Type,
        IS_Type   // 7
    } extType1;

    always_comb begin
        case (extType)
            R_Type: begin
                immExt = 32'bx;
            end
            IL_Type: begin
                immExt = {
                    {20{instrCode[31]}}, instrCode[31:20]
                };  // signed extent 
            end
            I_Type: begin
                immExt = {
                    {20{instrCode[31]}}, instrCode[31:20]
                };  // signed extent 
            end
            S_Type: begin
                immExt = {
                    {20{instrCode[31]}}, instrCode[31:25], instrCode[11:7]
                };
            end
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
