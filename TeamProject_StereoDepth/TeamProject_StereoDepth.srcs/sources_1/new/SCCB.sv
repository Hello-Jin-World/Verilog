`timescale 1ns / 1ps

module SCCB (
    input  logic clk,
    input  logic reset,
    inout  wire  SDA,
    output logic SCL
);
    logic SDA_in, SDA_out;
    logic [3:0] state_reg, state_next;
    logic [3:0] i_reg, i_next;
    logic [10:0] counter_reg, counter_next;
    logic [$clog2(500) - 1 : 0] counter;
    logic manual_clk;
    logic SDA_out_reg, SDA_out_next;
    logic SCL_reg, SCL_next;
    logic write_reg, write_next;
    logic [6:0] j_reg, j_next;

    assign SDA_out = SDA_out_reg;
    assign SCL = SCL_reg;

    /////////////////       inout mode       ///////////////////
    assign SDA = write_reg ? SDA_out : 1'bz;

    always @(*) begin  // Read Data (INPUT MODE)
        if (!write_reg) begin
            SDA_in = SDA;
        end
    end
    ///////////////////////////////////////////////////////////

    localparam HALF_FREQ = 500;
    localparam LOW = 0, HIGH = 1, ACK = 0;
    localparam READ = 0, WRITE = 1;
    localparam 
    IDLE   = 0,
    STAY_4us = 1,
    ADDR_RW0 = 2,
    ADDR_RW1 = 3,
    SLAVE_ACK = 4,
    R_ADDR0 = 5,
    R_ADDR1 = 6,
    MASTER_ACK = 7,
    R_DATA0 = 8,
    R_DATA1 = 9,
    WAIT = 10,
    HALF_CLK0 = 11,
    HALF_CLK1 = 12
    ;

    // Register arrays for configuration
    logic [7:0] reg_addr[73:0];
    logic [7:0] reg_data[73:0];
    logic [7:0] slave_address = 8'b100_0010_0;


    ///////////////////      clock generator      ////////////////////
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            manual_clk <= 0;
            counter    <= 0;
        end else begin
            if (counter == HALF_FREQ - 1) begin
                manual_clk <= 1;
                counter    <= 0;
            end else begin
                manual_clk <= 0;
                counter <= counter + 1;
            end
        end
    end
    /////////////////////////////////////////////////////////////////


    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            counter_reg <= 0;
            SDA_out_reg <= HIGH;
            SCL_reg     <= HIGH;
            i_reg       <= 0;
            write_reg   <= WRITE;
            j_reg       <= 0;
            // reg_addr[0]  <= 8'h12;
            // reg_data[0]  <= 8'h80;  // COM7: Reset
            // reg_addr[1]  <= 8'h12;
            // reg_data[1]  <= 8'h10;  // COM7: QQVGA + RGB 
            // reg_addr[2]  <= 8'h0C;
            // reg_data[2]  <= 8'h04;  // COM3: Enable scaling
            // reg_addr[3]  <= 8'h3E;
            // reg_data[3]  <= 8'h19;  // COM14: Manual scaling
            // reg_addr[4]  <= 8'h72;
            // reg_data[4]  <= 8'h11;  // SCALING_DCWC: Downsample by 4
            // reg_addr[5]  <= 8'h73;
            // reg_data[5]  <= 8'hF1;  // SCALING_PCLK_DIV: Divide by 4
            // reg_addr[6]  <= 8'h12;
            // reg_data[6]  <= 8'h14;  // COM7: RGB format
            // reg_addr[7]  <= 8'h40;
            // reg_data[7]  <= 8'hD0;  // COM15: RGB565, full range
            // reg_addr[8]  <= 8'h4F;
            // reg_data[8]  <= 8'h80;  // MTX1
            // reg_addr[9]  <= 8'h50;
            // reg_data[9]  <= 8'h80;  // MTX2
            // reg_addr[10] <= 8'h51;
            // reg_data[10] <= 8'h00;  // MTX3
            // reg_addr[11] <= 8'h52;
            // reg_data[11] <= 8'h22;  // MTX4
            // reg_addr[12] <= 8'h53;
            // reg_data[12] <= 8'h5E;  // MTX5
            // reg_addr[13] <= 8'h54;
            // reg_data[13] <= 8'h80;  // MTX6
            // reg_addr[14] <= 8'h58;
            // reg_data[14] <= 8'h9E;  // MTXS
            // reg_addr[15] <= 8'h11;
            // reg_data[15] <= 8'h80;  // CLKRC: Use external clock
            // reg_addr[16] <= 8'h13;
            // reg_data[16] <= 8'h84;  // COM8: AGC, AWB, AEC enable
            // reg_addr[17] <= 8'h1E;
            // reg_data[17] <= 8'h31;  // MVFP: Mirror/VFlip
            // reg_addr[18] <= 8'h41;
            // reg_data[18] <= 8'h08;  // COM16: Color matrix

            // Fill remaining registers with NOP (No Operation)
            // for (int i = 19; i < 32; i++) begin
            //     reg_addr[i] <= 8'h00;
            //     reg_data[i] <= 8'h00;

            // end
        end else begin
            state_reg   <= state_next;
            counter_reg <= counter_next;
            SDA_out_reg <= SDA_out_next;
            SCL_reg     <= SCL_next;
            i_reg       <= i_next;
            write_reg   <= write_next;
            j_reg       <= j_next;
        end
    end

    always_comb begin
        state_next   = state_reg;
        SDA_out_next = SDA_out_reg;
        SCL_next     = SCL_reg;
        i_next       = i_reg;
        counter_next = counter_reg;
        write_next   = write_reg;
        j_next       = j_reg;
        case (state_reg)
            /////////////////////////////////////////////////////////////////
            IDLE: begin
                if (counter == HALF_FREQ / 2 - 1) begin
                    SDA_out_next = HIGH;
                    SCL_next = HIGH;
                end
                if (counter == HALF_FREQ - 1) begin
                    state_next = STAY_4us;
                    counter_next = 0;
                    i_next = 0;
                    j_next = 0;
                    SDA_out_next = LOW;
                end
            end
            STAY_4us: begin
                //stay SDA_out LOW for 4us
                if (counter_reg == 500 - 1) begin
                    state_next   = ADDR_RW0;
                    counter_next = 0;
                    SCL_next     = LOW;
                end else begin
                    counter_next = counter_reg + 1;
                end
            end
            ADDR_RW0: begin
                // SCL = LOW
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                    i_next   = i_reg + 1;
                end
                if (manual_clk) begin
                    if (i_reg == 8) begin
                        state_next = SLAVE_ACK;
                        // state_next = R_ADDR0;
                        // write_next = READ;
                        // write_next = WRITE;
                        i_next     = 0;
                    end else begin
                        state_next   = ADDR_RW1;
                        SDA_out_next = slave_address[7-i_reg];
                    end
                end
            end
            ADDR_RW1: begin
                // SCL = HIGH
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    state_next = ADDR_RW0;
                end
            end
            SLAVE_ACK: begin
                // wait SLAVE ACK
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                // if (SCL_reg == 1 && SCL_next == 0) begin
                if (manual_clk) begin
                    // if (SDA_in == ACK) begin
                    state_next = R_ADDR0;
                    write_next = WRITE;
                    // end
                    // end else
                    //     state_next = IDLE;
                    //     write_next = WRITE;
                end
            end

            ///////////////////////////////////////////////////////////////////     TRANSMITS SLAVE ADDRESS
            R_ADDR0: begin
                // SCL = LOW
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    if (i_reg == 8) begin
                        if (j_reg == 40) begin
                            state_next   = MASTER_ACK;
                            SDA_out_next = LOW;
                            // state_next = R_DATA0;
                            // i_next     = 0;
                            // j_next     = 0;
                        end else begin
                            SDA_out_next = LOW;
                            state_next   = HALF_CLK0;
                            i_next       = 0;
                        end
                    end else begin
                        state_next   = R_ADDR1;
                        SDA_out_next = reg_addr[j_reg][7-i_reg];
                        i_next       = i_reg + 1;
                    end
                end
            end
            R_ADDR1: begin
                // SCL = HIGH
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    state_next = R_ADDR0;
                end
            end
            HALF_CLK0: begin
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    state_next = R_DATA0;
                end
            end
            ///////////////////////////////////////////////////////////////////////////////////
            R_DATA0: begin
                // SCL = LOW
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    if (i_reg == 8) begin
                        SDA_out_next = LOW;
                        state_next   = HALF_CLK1;
                        // state_next   = R_ADDR0;
                        i_next       = 0;
                        // SCL_next = HIGH;
                        // j_next     = j_reg + 1;
                    end else begin
                        state_next   = R_DATA1;
                        SDA_out_next = reg_data[j_reg][7-i_reg];
                        i_next       = i_reg + 1;
                    end
                end
            end
            R_DATA1: begin
                // SCL = HIGH
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    state_next = R_DATA0;
                end
            end
            HALF_CLK1: begin
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    j_next = j_reg + 1;
                    i_next = 0;
                    state_next = R_ADDR0;
                end
            end

            ///////////////////////////////////////////////////////////////////////////////////
            MASTER_ACK: begin
                if (counter == HALF_FREQ / 2 - 1) begin
                    SCL_next = ~SCL_reg;
                end
                if (manual_clk) begin
                    state_next = WAIT;
                end
            end
            WAIT: begin
                SDA_out_next = HIGH;
                SCL_next     = HIGH;
                state_next   = WAIT;
                // if (manual_clk) begin
                //     state_next = IDLE;
                // end
            end

        endcase
    end

    always_comb begin
    reg_addr[0] = 8'h3A;  reg_data[0] = 8'h04;  // REG_TSLB
    reg_addr[1] = 8'h12;  reg_data[1] = 8'h00;  // REG_COM7
    reg_addr[2] = 8'h13;  reg_data[2] = 8'hE7;  // REG_COM8
    reg_addr[3] = 8'h6A;  reg_data[3] = 8'h9F;  // REG_AWBCTR0
    reg_addr[4] = 8'hB0;  reg_data[4] = 8'h84;  // REG_RESERVED
    reg_addr[5] = 8'h70;  reg_data[5] = 8'h3A;  // REG_HSTART
    reg_addr[6] = 8'h71;  reg_data[6] = 8'h35;  // REG_HSTOP
    reg_addr[7] = 8'h72;  reg_data[7] = 8'h11;  // REG_VSTART
    reg_addr[8] = 8'h73;  reg_data[8] = 8'hF0;  // REG_VSTOP
    reg_addr[9] = 8'h32;  reg_data[9] = 8'h80;  // REG_HREF
    reg_addr[10] = 8'h3C; reg_data[10] = 8'h78; // REG_COM12
    reg_addr[11] = 8'h3D; reg_data[11] = 8'hC0; // REG_COM13
    reg_addr[12] = 8'h4F; reg_data[12] = 8'hB3; // REG_MTX1
    reg_addr[13] = 8'h50; reg_data[13] = 8'hB3; // REG_MTX2
    reg_addr[14] = 8'h51; reg_data[14] = 8'h00; // REG_MTX3
    reg_addr[15] = 8'h52; reg_data[15] = 8'h3D; // REG_MTX4
    reg_addr[16] = 8'h53; reg_data[16] = 8'hA7; // REG_MTX5
    reg_addr[17] = 8'h54; reg_data[17] = 8'hE4; // REG_MTX6
    reg_addr[18] = 8'h58; reg_data[18] = 8'h9E; // REG_MTXS
    reg_addr[19] = 8'h17; reg_data[19] = 8'h14; // REG_HSTART
    reg_addr[20] = 8'h18; reg_data[20] = 8'h02; // REG_HSTOP
    reg_addr[21] = 8'h32; reg_data[21] = 8'h80; // REG_HREF
    reg_addr[22] = 8'h19; reg_data[22] = 8'h03; // REG_VSTART
    reg_addr[23] = 8'h1A; reg_data[23] = 8'h7B; // REG_VSTOP
    reg_addr[24] = 8'h0F; reg_data[24] = 8'h41; // REG_COM6
    reg_addr[25] = 8'h1E; reg_data[25] = 8'h00; // REG_MVFP
    reg_addr[26] = 8'h33; reg_data[26] = 8'h0B; // REG_CHLF
    reg_addr[27] = 8'h69; reg_data[27] = 8'h00; // REG_GFIX
    reg_addr[28] = 8'h74; reg_data[28] = 8'h00; // REG_REG74
    reg_addr[29] = 8'hB0; reg_data[29] = 8'h84; // REG_RESERVED
    reg_addr[30] = 8'hB1; reg_data[30] = 8'h0C; // REG_ABLC1
    reg_addr[31] = 8'hB2; reg_data[31] = 8'h0E; // REG_RESERVED
    reg_addr[32] = 8'hB3; reg_data[32] = 8'h80; // REG_THL_ST
    reg_addr[33] = 8'h70; reg_data[33] = 8'h3A; // Mystery Scaling
    reg_addr[34] = 8'h71; reg_data[34] = 8'h35; // Mystery Scaling
    reg_addr[35] = 8'h72; reg_data[35] = 8'h11; // Mystery Scaling
    reg_addr[36] = 8'h73; reg_data[36] = 8'hF0; // Mystery Scaling
    reg_addr[37] = 8'hA2; reg_data[37] = 8'h02; // Mystery Scaling
    reg_addr[38] = 8'h7A; reg_data[38] = 8'h20; // Gamma Curve
    reg_addr[39] = 8'h7B; reg_data[39] = 8'h10; // Gamma Curve

// reg_addr[0]  = 8'h12;  reg_data[0]  = 8'h80;  // reset
// reg_addr[1]  = 8'hFF;  reg_data[1]  = 8'hF0;  // delay
// reg_addr[2]  = 8'h12;  reg_data[2]  = 8'h04;  // REG_COM7, set RGB color output
// reg_addr[3]  = 8'h11;  reg_data[3]  = 8'h80;  // REG_CLKRC, internal PLL matches input clock
// reg_addr[4]  = 8'h0C;  reg_data[4]  = 8'h00;  // REG_COM3, default settings
// reg_addr[5]  = 8'h3E;  reg_data[5]  = 8'h00;  // REG_COM14, no scaling, normal pclock
// reg_addr[6]  = 8'h04;  reg_data[6]  = 8'h00;  // REG_COM1, disable CCIR656
// reg_addr[7]  = 8'h40;  reg_data[7]  = 8'hD0;  // REG_COM15, RGB565, full output range
// reg_addr[8]  = 8'h3A;  reg_data[8]  = 8'h04;  // REG_TSLB, set correct output data sequence
// reg_addr[9]  = 8'h14;  reg_data[9]  = 8'h18;  // REG_COM9, MAX AGC value x4
// reg_addr[10] = 8'h4F;  reg_data[10] = 8'hB3;  // REG_MTX1, matrix coefficient
// reg_addr[11] = 8'h50;  reg_data[11] = 8'hB3;  // REG_MTX2, matrix coefficient
// reg_addr[12] = 8'h51;  reg_data[12] = 8'h00;  // REG_MTX3, matrix coefficient
// reg_addr[13] = 8'h52;  reg_data[13] = 8'h3D;  // REG_MTX4, matrix coefficient
// reg_addr[14] = 8'h53;  reg_data[14] = 8'hA7;  // REG_MTX5, matrix coefficient
// reg_addr[15] = 8'h54;  reg_data[15] = 8'hE4;  // REG_MTX6, matrix coefficient
// reg_addr[16] = 8'h58;  reg_data[16] = 8'h9E;  // REG_MTXS, matrix coefficient
// reg_addr[17] = 8'h3D;  reg_data[17] = 8'hC0;  // REG_COM13, gamma enable
// reg_addr[18] = 8'h17;  reg_data[18] = 8'h14;  // REG_HSTART, start high 8 bits
// reg_addr[19] = 8'h18;  reg_data[19] = 8'h02;  // REG_HSTOP, stop high 8 bits
// reg_addr[20] = 8'h32;  reg_data[20] = 8'h80;  // REG_HREF, edge offset
// reg_addr[21] = 8'h19;  reg_data[21] = 8'h03;  // REG_VSTART, start high 8 bits
// reg_addr[22] = 8'h1A;  reg_data[22] = 8'h7B;  // REG_VSTOP, stop high 8 bits
// reg_addr[23] = 8'h03;  reg_data[23] = 8'h0A;  // REG_VREF, vsync edge offset
// reg_addr[24] = 8'h0F;  reg_data[24] = 8'h41;  // REG_COM6, reset timings
// reg_addr[25] = 8'h1E;  reg_data[25] = 8'h00;  // REG_MVFP, disable mirror/flip
// reg_addr[26] = 8'h33;  reg_data[26] = 8'h0B;  // REG_CHLF, magic value
// reg_addr[27] = 8'h3C;  reg_data[27] = 8'h78;  // REG_COM12, no HREF when VSYNC low
// reg_addr[28] = 8'h69;  reg_data[28] = 8'h00;  // REG_GFIX, fix gain control
// reg_addr[29] = 8'h74;  reg_data[29] = 8'h00;  // REG_REG74, digital gain control
// reg_addr[30] = 8'hB0;  reg_data[30] = 8'h84;  // REG_RSVD, magic value
// reg_addr[31] = 8'hB1;  reg_data[31] = 8'h0C;  // REG_ABLC1, magic value
// reg_addr[32] = 8'hB2;  reg_data[32] = 8'h0E;  // REG_RSVD, magic value
// reg_addr[33] = 8'hB3;  reg_data[33] = 8'h80;  // REG_THL_ST, magic value
// reg_addr[34] = 8'h70;  reg_data[34] = 8'h3A;  // mystery scaling
// reg_addr[35] = 8'h71;  reg_data[35] = 8'h35;  // mystery scaling
// reg_addr[36] = 8'h72;  reg_data[36] = 8'h11;  // mystery scaling
// reg_addr[37] = 8'h73;  reg_data[37] = 8'hF0;  // mystery scaling
// reg_addr[38] = 8'hA2;  reg_data[38] = 8'h02;  // gamma curve
// reg_addr[39] = 8'h7A;  reg_data[39] = 8'h20;  // gamma curve
// reg_addr[40] = 8'h7B;  reg_data[40] = 8'h10;  // gamma curve
// reg_addr[41] = 8'h7C;  reg_data[41] = 8'h1E;  // gamma curve
// reg_addr[42] = 8'h7D;  reg_data[42] = 8'h35;  // gamma curve
// reg_addr[43] = 8'h7E;  reg_data[43] = 8'h5A;  // gamma curve
// reg_addr[44] = 8'h7F;  reg_data[44] = 8'h69;  // gamma curve
// reg_addr[45] = 8'h80;  reg_data[45] = 8'h76;  // gamma curve
// reg_addr[46] = 8'h81;  reg_data[46] = 8'h80;  // gamma curve
// reg_addr[47] = 8'h82;  reg_data[47] = 8'h88;  // gamma curve
// reg_addr[48] = 8'h83;  reg_data[48] = 8'h8F;  // gamma curve
// reg_addr[49] = 8'h84;  reg_data[49] = 8'h96;  // gamma curve
// reg_addr[50] = 8'h85;  reg_data[50] = 8'hA3;  // gamma curve
// reg_addr[51] = 8'h86;  reg_data[51] = 8'hAF;  // gamma curve
// reg_addr[52] = 8'h87;  reg_data[52] = 8'hC4;  // gamma curve
// reg_addr[53] = 8'h88;  reg_data[53] = 8'hD7;  // gamma curve
// reg_addr[54] = 8'h89;  reg_data[54] = 8'hE8;  // gamma curve
// reg_addr[55] = 8'h13;  reg_data[55] = 8'hE0;  // REG_COM8, disable AGC / AEC
// reg_addr[56] = 8'h00;  reg_data[56] = 8'h00;  // set gain reg to 0 for AGC
// reg_addr[57] = 8'h10;  reg_data[57] = 8'h00;  // set ARCJ reg to 0
// reg_addr[58] = 8'h0D;  reg_data[58] = 8'h40;  // magic reserved bit for COM4
// reg_addr[59] = 8'h14;  reg_data[59] = 8'h18;  // REG_COM9, 4x gain + magic bit
// reg_addr[60] = 8'hA5;  reg_data[60] = 8'h05;  // REG_BD50MAX
// reg_addr[61] = 8'hAB;  reg_data[61] = 8'h07;  // REG_DB60MAX
// reg_addr[62] = 8'h24;  reg_data[62] = 8'h95;  // REG_AGC upper limit
// reg_addr[63] = 8'h25;  reg_data[63] = 8'h33;  // REG_AGC lower limit
// reg_addr[64] = 8'h26;  reg_data[64] = 8'hE3;  // REG_AGC/AEC fast mode op region
// reg_addr[65] = 8'h9F;  reg_data[65] = 8'h78;  // REG_HAECC1
// reg_addr[66] = 8'hA0;  reg_data[66] = 8'h68;  // REG_HAECC2
// reg_addr[67] = 8'hA1;  reg_data[67] = 8'h03;  // magic
// reg_addr[68] = 8'hA6;  reg_data[68] = 8'hD8;  // REG_HAECC3
// reg_addr[69] = 8'hA7;  reg_data[69] = 8'hD8;  // REG_HAECC4
// reg_addr[70] = 8'hA8;  reg_data[70] = 8'hF0;  // REG_HAECC5
// reg_addr[71] = 8'hA9;  reg_data[71] = 8'h90;  // REG_HAECC6
// reg_addr[72] = 8'hAA;  reg_data[72] = 8'h94;  // REG_HAECC7
// reg_addr[73] = 8'h13;  reg_data[73] = 8'hE5;  // REG_COM8, enable AGC / AEC


        // reg_addr[0]  = 8'h3A;
        // reg_data[0]  = 8'h04;  // REG_TSLB
        // reg_addr[1]  = 8'h12;
        // reg_data[1]  = 8'h00;  // REG_COM7
        // reg_addr[2]  = 8'h13;
        // reg_data[2]  = 8'hE7;  // REG_COM8
        // reg_addr[3]  = 8'h6A;
        // reg_data[3]  = 8'h9F;  // REG_AWBCTR0
        // reg_addr[4]  = 8'hB0;
        // reg_data[4]  = 8'h84;
        // reg_addr[5]  = 8'h70;
        // reg_data[5]  = 8'h3A;
        // reg_addr[6]  = 8'h71;
        // reg_data[6]  = 8'h35;
        // reg_addr[7]  = 8'h72;
        // reg_data[7]  = 8'h11;
        // reg_addr[8]  = 8'h73;
        // reg_data[8]  = 8'hF0;
        // reg_addr[9]  = 8'h7A;
        // reg_data[9]  = 8'h20;
        // reg_addr[10] = 8'h7B;
        // reg_data[10] = 8'h10;
        // reg_addr[11] = 8'h7C;
        // reg_data[11] = 8'h1E;
        // reg_addr[12] = 8'h7D;
        // reg_data[12] = 8'h35;
        // reg_addr[13] = 8'h7E;
        // reg_data[13] = 8'h5A;
        // reg_addr[14] = 8'h7F;
        // reg_data[14] = 8'h69;
        // reg_addr[15] = 8'h80;
        // reg_data[15] = 8'h76;
        // reg_addr[16] = 8'h81;
        // reg_data[16] = 8'h80;
        // reg_addr[17] = 8'h82;
        // reg_data[17] = 8'h88;
        // reg_addr[18] = 8'h83;
        // reg_data[18] = 8'h8F;
        // reg_addr[19] = 8'h84;
        // reg_data[19] = 8'h96;
        // reg_addr[20] = 8'h85;
        // reg_data[20] = 8'hA3;
        // reg_addr[21] = 8'h86;
        // reg_data[21] = 8'hAF;
        // reg_addr[22] = 8'h87;
        // reg_data[22] = 8'hC4;
        // reg_addr[23] = 8'h88;
        // reg_data[23] = 8'hD7;
        // reg_addr[24] = 8'h89;
        // reg_data[24] = 8'hE8;
        // reg_addr[25] = 8'h00;
        // reg_data[25] = 8'hFF;  // End of configuration

        // // Reset and Basic Settings
        // reg_addr[26] = 8'h12;
        // reg_data[26] = 8'h80;  // COM7: Reset
        // reg_addr[27] = 8'h12;
        // reg_data[27] = 8'h10;  // COM7: RGB mode

        // // Scaling and Resolution Settings
        // reg_addr[28] = 8'h0C;
        // reg_data[28] = 8'h04;

        // reg_addr[29] = 8'h3E;
        // reg_data[29] = 8'h1A;

        // reg_addr[30] = 8'h70;
        // reg_data[30] = 8'h3A;

        // reg_addr[31] = 8'h71;
        // reg_data[31] = 8'h35;

        // reg_addr[32] = 8'h72;
        // reg_data[32] = 8'h22;

        // reg_addr[33] = 8'h73;
        // reg_data[33] = 8'hF2;

        // reg_addr[34] = 8'hA2;
        // reg_data[34] = 8'h02;

        // reg_addr[35] = 8'hA2;
        // reg_data[35] = 8'h02;
        // // Set Frame QQVGA
        // reg_addr[36] = 8'h17;
        // reg_data[36] = 8'h15;

        // reg_addr[37] = 8'h18;
        // reg_data[37] = 8'h03;

        // reg_addr[38] = 8'h32;
        // reg_data[38] = 8'h16;

        // reg_addr[39] = 8'h19;
        // reg_data[39] = 8'h03;

        // reg_addr[40] = 8'h1A;
        // reg_data[40] = 8'h7B;

        // reg_addr[41] = 8'h03;
        // reg_data[41] = 8'h00;

        // // Set Color Format RGB565
        // reg_addr[42] = 8'h40;
        // reg_data[42] = 8'hD0;


        // reg_addr[15]  = 8'h03;
        // reg_data[15]  = 8'h00; 

        // reg_addr[16]  = 8'h03;
        // reg_data[16]  = 8'h00; 

        // reg_addr[17]  = 8'h03;
        // reg_data[17]  = 8'h00; 

        // Color Format
        // reg_addr[0]  = 8'h12;
        // reg_data[0]  = 8'h80;  // COM7: Reset
        // reg_addr[1]  = 8'h12;
        // reg_data[1]  = 8'h10;  // COM7: QQVGA + RGB 
        // reg_addr[2]  = 8'h0C;
        // reg_data[2]  = 8'h04;  // COM3: Enable scaling
        // reg_addr[3]  = 8'h3E;
        // reg_data[3]  = 8'h19;  // COM14: Manual scaling
        // reg_addr[4]  = 8'h72;
        // reg_data[4]  = 8'h11;  // SCALING_DCWC: Downsample by 4
        // reg_addr[5]  = 8'h73;
        // reg_data[5]  = 8'hF1;  // SCALING_PCLK_DIV: Divide by 4
        // reg_addr[6]  = 8'h12;
        // reg_data[6]  = 8'h14;  // COM7: RGB format
        // reg_addr[7]  = 8'h40;
        // reg_data[7]  = 8'hD0;  // COM15: RGB565, full range
        // reg_addr[8]  = 8'h4F;
        // reg_data[8]  = 8'h80;  // MTX1
        // reg_addr[9]  = 8'h50;
        // reg_data[9]  = 8'h80;  // MTX2
        // reg_addr[10] = 8'h51;
        // reg_data[10] = 8'h00;  // MTX3
        // reg_addr[11] = 8'h52;
        // reg_data[11] = 8'h22;  // MTX4
        // reg_addr[12] = 8'h53;
        // reg_data[12] = 8'h5E;  // MTX5
        // reg_addr[13] = 8'h54;
        // reg_data[13] = 8'h80;  // MTX6
        // reg_addr[14] = 8'h58;
        // reg_data[14] = 8'h9E;  // MTXS
        // reg_addr[15] = 8'h11;
        // reg_data[15] = 8'h80;  // CLKRC: Use external clock
        // reg_addr[16] = 8'h13;
        // reg_data[16] = 8'h84;  // COM8: AGC, AWB, AEC enable
        // reg_addr[17] = 8'h1E;
        // reg_data[17] = 8'h31;  // MVFP: Mirror/VFlip
        // reg_addr[18] = 8'h41;
        // reg_data[18] = 8'h08;  // COM16: Color matrix

        // // Fill remaining registers with NOP (No Operation)
        // for (int i = 19; i < 32; i++) begin
        //     reg_addr[i] = 8'h00;
        //     reg_data[i] = 8'h00;

        // end
    end

endmodule
