`timescale 1ns / 1ps

module MCU (
    input  logic       clk,
    input  logic       reset,
    // output logic [3:0] GPO_A,
    // inout  wire  [3:0] GPIO_A,
    // inout  wire  [3:0] GPIO_B,
    // output logic [3:0] fndCom,
    // output logic [7:0] fndFont,
    inout  wire        SDA,
    output logic       SCL
);
    logic [31:0] instrCode, instrMemAddr;
    logic [31:0]
        dataAddr,
        readData,
        writeData,
        ram_rData,
        rData,
        gpo_rData,
        gpioa_rData,
        gpiob_rData,
        fnd_rData,
        i2c_rData;
    logic [5:0] sel;
    logic
        write,
        ready,
        enable,
        ram_ready,
        gpo_ready,
        gpioa_ready,
        gpiob_ready,
        fnd_ready,
        i2c_ready;



    RV32I_Core U_RV32I_CORE (
        .clk         (clk),
        .reset       (reset),
        .instrCode   (instrCode),
        .instrMemAddr(instrMemAddr),
        .dataAddr    (dataAddr), 
        .readData    (rData),
        .writeData   (writeData),
        .ready       (ready),
        .enable      (enable),
        .ramWe       (write)
    );

    decoder_mem_map U_Decoder_Mem_Map (
        .addr(dataAddr),
        .sel (sel)
    );

    mux_mem_map U_Mux_Map (
        .addr  (dataAddr),
        .ready0(ram_ready),
        .ready1(gpo_ready),
        .ready2(gpioa_ready),
        .ready3(gpiob_ready),
        .ready4(fnd_ready),
        .ready5(i2c_ready),
        .rData0(ram_rData),
        .rData1(gpo_rData),
        .rData2(gpioa_rData),
        .rData3(gpiob_rData),
        .rData4(fnd_rData),
        .rData5(i2c_rData),
        .ready (ready),
        .rData (rData)
    );

    ROM U_InstrMemory (
        .addr(instrMemAddr),
        .data(instrCode)
    );

    ram U_DataMemory (
        .clk   (clk),
        .we    (write),
        .sel   (sel[0]),
        .enable(enable),
        .ready (ram_ready),
        .addr  (dataAddr),
        .wData (writeData),
        .rData (ram_rData)
    );

    gpo U_GPO (
        // global signal
        .PCLK   (clk),
        .PRESET (reset),
        .PADDR  (dataAddr),
        .PWRITE (write),
        .PSEL   (sel[1]),
        .PENABLE(enable),
        .PWDATA (writeData),
        .PRDATA (gpo_rData),
        .PREADY (gpo_ready),
        .outPort(GPO_A)
    );

    gpio U_GPIO_A (
        .PCLK     (clk),
        .PRESET   (reset),
        .PADDR    (dataAddr),
        .PWRITE   (write),
        .PSEL     (sel[2]),
        .PENABLE  (enable),
        .PWDATA   (writeData),
        .PRDATA   (gpioa_rData),
        .PREADY   (gpioa_ready),
        .inoutPort(GPIO_A)
    );

    gpio U_GPIO_B (
        .PCLK     (clk),
        .PRESET   (reset),
        .PADDR    (dataAddr),
        .PWRITE   (write),
        .PSEL     (sel[3]),
        .PENABLE  (enable),
        .PWDATA   (writeData),
        .PRDATA   (gpiob_rData),
        .PREADY   (gpiob_ready),
        .inoutPort(GPIO_B)
    );

    FND U_FND (
        .PCLK   (clk),
        .PRESET (reset),
        .PADDR  (dataAddr),
        .PWRITE (write),
        .PSEL   (sel[4]), 
        .PENABLE(enable),
        .PWDATA (writeData),
        .PRDATA (fnd_rData),
        .PREADY (fnd_ready),
        .fndCom (fndCom),
        .fndFont(fndFont)
    );

    I2C_Master U_I2C_Master (
        .PCLK   (clk),
        .PRESET (reset),
        .PADDR  (dataAddr),
        .PWRITE (write),
        .PSEL   (sel[5]),
        .PENABLE(enable),
        .PWDATA (writeData),
        .PRDATA (i2c_rData),
        .PREADY (i2c_ready), 
        .SDA    (SDA),
        .SCL    (SCL)
    );
endmodule

module decoder_mem_map (
    input  logic [31:0] addr,
    output logic [ 5:0] sel
);
    always_comb begin
        casex (addr)
            32'h0001_0xxx: sel = 6'b000001;  // ram
            32'h0002_00xx: sel = 6'b000010;  // gpo
            32'h0002_01xx: sel = 6'b000100;  // gpio_a
            32'h0002_02xx: sel = 6'b001000;  // gpio_b
            32'h0002_03xx: sel = 6'b010000;  // fnd_gpo
            32'h0002_04xx: sel = 6'b100000;  // i2c_master 
            default: sel = 6'bxxxxxx;
        endcase
    end
endmodule

module mux_mem_map (

    input  logic        ready0,
    input  logic        ready1,
    input  logic        ready2,
    input  logic        ready3,
    input  logic        ready4,
    input  logic        ready5,
    input  logic [31:0] addr,
    input  logic [31:0] rData0,
    input  logic [31:0] rData1,
    input  logic [31:0] rData2,
    input  logic [31:0] rData3,
    input  logic [31:0] rData4,
    input  logic [31:0] rData5,
    output logic        ready,
    output logic [31:0] rData
);

    always_comb begin
        casex (addr)
            32'h0001_0xxx: begin
                ready = ready0;
                rData = rData0;  // ram
            end
            32'h0002_00xx: begin
                ready = ready1;
                rData = rData1;  // gpo
            end
            32'h0002_01xx: begin
                ready = ready2;
                rData = rData2;  // gpio_a
            end
            32'h0002_02xx: begin
                ready = ready3;
                rData = rData3;  // gpio_b
            end
            32'h0002_03xx: begin
                ready = ready4;
                rData = rData4;  // fnd_out 
            end
            32'h0002_04xx: begin
                ready = ready5;
                rData = rData5;  // i2c 
            end
            default: begin
                rData = 32'bx;
            end
        endcase
    end
endmodule
