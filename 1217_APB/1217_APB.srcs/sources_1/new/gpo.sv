`timescale 1ns / 1ps
module gpo (
    // global signal
    input  logic        PCLK,
    input  logic        PRESET,
    // apb bus
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // port
    output logic [ 3:0] outPort
);

    logic [3:0] mode, outData;

    APB_Intf U_APB_Intf (
        // global signal
        .pclk   (PCLK), 
        .preset (PRESET), 
        .paddr  (PADDR),
        .pwrite (PWRITE),
        .psel   (PSEL), 
        .penable(PENABLE), 
        .pwdata (PWDATA), 
        .prdata (PRDATA),
        .pready (PREADY),
        .mode   (mode),
        .outData(outData)
    );

    gpo_ip U_gpo_ip (
        .mode   (mode),
        .outData(outData),
        .outPort(outPort)
    );
endmodule

module APB_Intf (
    // global signal
    input  logic        pclk,
    input  logic        preset, 
    // apb bus
    input  logic [ 2:0] paddr,
    input  logic        pwrite,
    input  logic        psel,
    input  logic        penable,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    // port
    output logic [ 3:0] mode,
    output logic [ 3:0] outData
);

    logic [31:0] MODER;
    logic [31:0] ODR;

    assign mode = MODER;
    assign outData = ODR;

    always_ff @(posedge pclk) begin
        if (psel & pwrite & penable) begin
            case (paddr[2])
                1'b0: MODER <= pwdata;
                1'b1: ODR <= pwdata;
            endcase
        end
    end

    always_ff @(posedge pclk) begin
        if (psel & !pwrite & penable) begin
            case (paddr[2])
                1'b0: prdata <= MODER;
                1'b1: prdata <= ODR;
            endcase
        end
    end

    always_ff @(posedge pclk) begin
        if (psel & penable) pready <= 1'b1;
        else pready <= 1'b0;
    end
/*
    typedef enum {
        IDLE,
        WRITE,
        READ
    } state_e;

    logic [31:0] MODER_reg, MODER_next;  // offset 0x00
    logic [31:0] ODR_reg, ODR_next;  // offset 0x04
    logic [31:0] prdata_reg, prdata_next;

    state_e state, state_next;
    logic pready_reg, pready_next;

    assign mode    = MODER_reg[3:0];
    assign outData = ODR_reg[3:0];
    assign pready  = pready_reg;
    assign prdata  = prdata_reg;

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            state      <= IDLE;
            pready_reg <= 0;
            ODR_reg    <= 0;
            MODER_reg  <= 0;
            prdata_reg <= 0;
        end else begin
            state      <= state_next;
            pready_reg <= pready_next;
            ODR_reg    <= ODR_next;
            MODER_reg  <= MODER_next;
            prdata_reg <= prdata_next;
        end
    end

    always_comb begin
        // state_next  = state;
        pready_next = pready_reg;
        ODR_next    = ODR_reg;
        MODER_next  = MODER_reg;
        prdata_next = prdata_reg;
        case (state)
            IDLE: begin
                // pready = 1'b0;
                pready_next = 1'b0;
            end
            WRITE: begin
                // pready = 1'b0;
                pready_next = 1'b0;
                if (penable) begin
                    // pready = 1'b1;
                    pready_next = 1'b1;
                    case (paddr[2])
                        // why only used paddr[2]?
                        // addr is increased +4.
                        1'b0: begin
                            MODER_next = pwdata;
                        end
                        1'b1: begin
                            ODR_next = pwdata;
                        end
                        // default: begin
                        //     MODER_reg = 32'b0;
                        //     ODR_reg   = 32'b0;
                        // end
                    endcase
                end
            end
            READ: begin
                pready_next = 1'b0;
                if (penable) begin
                    pready_next = 1'b1;
                    case (paddr[2])
                        1'b0: begin
                            prdata_next = MODER_reg;
                        end
                        1'b1: begin
                            prdata_next = ODR_reg;
                        end
                        default: begin
                            prdata = 32'b0;
                        end
                    endcase
                end
            end
        endcase
    end

    always_comb begin
        state_next = state;
        case (state)
            IDLE: begin
                if (psel && pwrite) begin
                    state_next = WRITE;
                end else if (psel && !pwrite) begin
                    state_next = READ;
                end
            end
            WRITE: begin
                if (psel && penable && pready_reg) begin
                    state_next = IDLE;
                end
            end
            READ: begin
                if (psel && penable && pready_reg) begin
                    state_next = IDLE;
                end
            end
        endcase
    end
    */
endmodule

module gpo_ip (
    input  logic [3:0] mode,
    output logic [3:0] outData,
    output logic [3:0] outPort
);

    // assign outPort[0] = (mode[0]) ? outData[0] : 1'bz;
    // assign outPort[1] = (mode[1]) ? outData[1] : 1'bz;
    // assign outPort[2] = (mode[2]) ? outData[2] : 1'bz;
    // assign outPort[3] = (mode[3]) ? outData[3] : 1'bz;

    genvar i;

    generate
        for (i = 0; i < 4; i++) begin
            assign outPort[i] = mode[i] ? outData[i] : 1'bz;
        end
    endgenerate
endmodule
