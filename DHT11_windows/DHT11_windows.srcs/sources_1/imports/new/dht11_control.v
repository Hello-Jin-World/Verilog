`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 02:20:16 PM
// Design Name: 
// Module Name: dht11_control
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


module dht11_control (
    input        clk,
    input        reset,
    inout        ioport,
    output       wr_en,
    output [7:0] int_hum,
    output [7:0] dec_hum,
    output [7:0] int_tem,
    output [7:0] dec_tem
);

    wire io_mode;
    wire signal;
    wire receive_dht11_data;
    wire tick;
    wire start_dht11;
    wire start_receive_data;

    select_io U_select_io (
        .mode    (io_mode),
        .ioport  (ioport),
        .out_data(signal),
        .in_data (receive_dht11_data)
    );

    clock_divider U_clock_divider (
        .clk      (clk),
        .reset    (reset),
        .tick_1Mhz(tick)
    );

    count_5sec U_count_5sec (
        .clk        (clk),
        .reset      (reset),
        .tick       (tick),
        .start_dht11(start_dht11)
    );

    start_signal U_start_signal (
        .clk               (clk),
        .reset             (reset),
        .tick              (tick),
        .start_dht11       (start_dht11),
        .wr_en             (wr_en),
        .start_receive_data(start_receive_data),
        .signal            (signal),
        .mode              (io_mode)
    );


    receive_data U_receive_data (
        .clk               (clk),
        .reset             (reset),
        .dht11_data        (receive_dht11_data),
        .tick              (tick),
        .start_receive_data(start_receive_data),
        .input_mode        (io_mode),
        .wr_en             (wr_en),
        .int_hum           (int_hum),
        .dec_hum           (dec_hum),
        .int_tem           (int_tem),
        .dec_tem           (dec_tem)
    );
endmodule

module count_5sec (
    input  clk,
    input  reset,
    input  tick,
    output start_dht11
);

    reg [$clog2(1_000_000) - 1:0] counter_reg, counter_next;
    reg start_dht11_reg, start_dht11_next;

    assign start_dht11 = start_dht11_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg     <= 0;
            start_dht11_reg <= 0;
        end else begin
            counter_reg     <= counter_next;
            start_dht11_reg <= start_dht11_next;
        end
    end

    always @(*) begin
        counter_next     = counter_reg;
        start_dht11_next = start_dht11_next;
        if (tick) begin
            if (counter_reg == 1_000_000 - 1) begin
                counter_next     = 0;
                start_dht11_next = 1;
            end else begin
                start_dht11_next = 0;
                counter_next     = counter_reg + 1;
            end
        end
    end

endmodule

module select_io (
    input      mode,
    inout      ioport,
    input      out_data,
    output reg in_data
);

    //    reg temp, outdata, in_data;

    assign ioport = mode ? out_data : 1'bz;  // If you want to send(out) "HIGH"
    //    assign xxxx   = mode ? 1'bz : ioport;  // If you want to read(in) INPUT data

    always @(*) begin  // Read Data (INPUT MODE)
        if (!mode) begin
            in_data <= ioport;
        end
    end

    // always @(*) begin
    //     if (!mode) begin
    //         if (in_data == 1'b1) begin
    //             temp = 8'h00;
    //         end else begin
    //             temp = 8'hff;
    //         end
    //     end
    // end

endmodule

module clock_divider (
    input  clk,
    input  reset,
    output tick_1Mhz
);

    reg [$clog2(100)-1 : 0] r_counter;
    reg r_tick;

    assign tick_1Mhz = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_tick    <= 1'b0;
        end else begin
            if (r_counter == 100 - 1) begin
                r_counter <= 0;
                r_tick    <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_tick    <= 1'b0;
            end
        end
    end

endmodule

module start_signal (
    input  clk,
    input  reset,
    input  tick,
    input  start_dht11,
    input  wr_en,
    output start_receive_data,
    output signal,
    output mode
);

    reg signal_reg, signal_next;
    reg [$clog2(18_000) - 1:0] counter_reg, counter_next;
    reg mode_reg, mode_next;
    reg lets_start_dht11_reg, lets_start_dht11_next;
    reg start_receive_data_reg, start_receive_data_next;


    //    localparam START = 1'b0, WAIT_RESPONSE = 1'b1;

    assign signal             = signal_reg;
    assign mode               = mode_reg;
    assign start_receive_data = start_receive_data_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            signal_reg             <= 1'b1;
            counter_reg            <= 0;
            mode_reg               <= 1'b1;
            lets_start_dht11_reg   <= 1'b0;
            start_receive_data_reg <= 0;
        end else begin
            signal_reg             <= signal_next;
            counter_reg            <= counter_next;
            mode_reg               <= mode_next;
            lets_start_dht11_reg   <= lets_start_dht11_next;
            start_receive_data_reg <= start_receive_data_next;
        end
    end

    always @(*) begin
        counter_next            = counter_reg;
        signal_next             = signal_reg;
        mode_next               = mode_reg;
        lets_start_dht11_next   = lets_start_dht11_reg;
        start_receive_data_next = start_receive_data_reg;
        if (tick) begin
            // if (counter_reg == 18000 - 1) begin
            //     counter_next = 0;
            // end else begin
            //     counter_next = counter_reg + 1;
            // end
            counter_next = counter_reg + 1;
        end

        // if (wr_en) begin
        //     mode_next = 1'b1;
        // end

        if (start_dht11) begin
            mode_next             = 1'b1;
            signal_next           = 1'b0;
            counter_next          = 0;
            lets_start_dht11_next = 1'b1;
            // start_receive_data_next = 1'b0;
        end

        if (lets_start_dht11_reg) begin
            if (!signal_reg) begin
                if (counter_reg == 18000 - 1) begin // count(maintain) start signal(LOW) for 18ms.
                    //if (counter_reg == 1800 - 1) begin // count(maintain) start signal(LOW) for 18ms.
                    counter_next = 0;
                    signal_next  = 1'b1;
                end
            end else begin
                if (counter_reg == 35 - 1) begin // count(maintain) DHT_wait_signal(HIGH) for 20~40us.
                    counter_next = 0;
                    mode_next             = 1'b0; // end start process, and io_port set input mode.
                    lets_start_dht11_next = 1'b0;
                    start_receive_data_next = 1'b1;
                end
            end
        end else begin
            start_receive_data_next = 1'b0;
        end
    end

endmodule

module receive_data (
    input            clk,
    input            reset,
    input            dht11_data,
    input            tick,
    input            start_receive_data,
    input            input_mode,
    output           wr_en,
    output reg [7:0] int_hum,
    output reg [7:0] dec_hum,
    output reg [7:0] int_tem,
    output reg [7:0] dec_tem

    // output            temp_out
);

    reg [2:0] state_reg, state_next;
    reg [$clog2(160) - 1:0] counter_reg, counter_next;
    reg [39:0] tem_hum_data_reg, tem_hum_data_next;
    reg wr_en_reg, wr_en_next;
    reg wait_more_reg, wait_more_next;

    // reg temp_reg, temp_next;
    // assign temp_out = temp_reg;

    assign wr_en = wr_en_reg;

    // assign int_hum = tem_hum_data_reg[7:0];
    // assign dec_hum = tem_hum_data_reg[15:8];
    // assign int_tem = tem_hum_data_reg[23:16];
    // assign dec_tem = tem_hum_data_reg[31:24];

    localparam NONE = 3'b000, WAIT_1 = 3'b001, WAIT_2 = 3'b010, WAIT_RECEIVE = 3'b011, RECEIVE = 3'b100, WAIT_0 = 3'b101;

    reg [5:0] i_reg, i_next;
    // reg [$clog2(40)-1:0] i;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg      <= 0;
            state_reg        <= 3'b000;
            tem_hum_data_reg <= 0;
            wr_en_reg        <= 0;
            // temp_reg         <= 0;
            i_reg            <= 39;
            wait_more_reg    <= 0;
        end else begin
            counter_reg      <= counter_next;
            state_reg        <= state_next;
            tem_hum_data_reg <= tem_hum_data_next;
            wr_en_reg        <= wr_en_next;
            // temp_reg         <= temp_next;
            i_reg            <= i_next;
            wait_more_reg    <= wait_more_next;
        end
    end

    always @(*) begin
        counter_next      = counter_reg;
        state_next        = state_reg;
        tem_hum_data_next = tem_hum_data_reg;
        wr_en_next        = wr_en_reg;
        wait_more_next    = wait_more_reg;
        // temp_next         = temp_reg;
        i_next            = i_reg;
        if (tick) begin
            counter_next = counter_reg + 1;
        end

        if (input_mode == 1'b0) begin
            case (state_reg)
                NONE: begin
                    if (start_receive_data) begin
                        state_next   = WAIT_0;
                        counter_next = 0;
                    end else begin
                        i_next = 39;
                        wr_en_next = 0;
                        // if (counter_next == 50) begin
                        // int_hum = tem_hum_data_reg[39:32];
                        // dec_hum    = tem_hum_data_reg[31:24];
                        // // dec_hum = 0;
                        // int_tem = tem_hum_data_reg[23:16];
                        // dec_tem    = tem_hum_data_reg[15:8];
                        // dec_tem = 0;
                    end  // else begin
                    // int_hum    = 8'b01010010; 
                    // dec_hum    = 0; 
                    // int_tem    = 8'b00011001;
                    // dec_tem    = 0;
                    // end
                    // tem_hum_data_next = 0;
                    //     i = 0;
                    //     state_next = NONE;
                    // end
                end
                WAIT_0: begin
                    if(dht11_data == 1'b0) begin
                        state_next = WAIT_1;
                    end
                end

                WAIT_1: begin
                    if (dht11_data == 1'b1) begin
                        state_next = WAIT_2;
                    // end else begin
                    //     state_next = WAIT_1;
                    end
                end
                WAIT_2: begin
                    if (dht11_data == 1'b0) begin
                        state_next = WAIT_RECEIVE;
                    // end else begin
                    //     state_next = WAIT_2;
                    end
                end
                WAIT_RECEIVE: begin
                    if (dht11_data == 1'b1) begin
                        i_next       = i_reg - 1;
                        state_next   = RECEIVE;
                        counter_next = 0;
                    end
                    //else begin
                    //     state_next = WAIT_RECEIVE;
                    //     // if (i == 8) begin
                    //     //     i = 0;
                    //     //     state_next = NONE;
                    //     //     wr_en_next = 1;
                    //     // end
                    // end
                    // if (i_reg == 7) begin
                    //     wr_en_next = 1;
                    //     i_next     = 0;
                    //     state_next = NONE;
                    // end
                end
                RECEIVE: begin
                    if (!dht11_data) begin
                        if (counter_reg < 35) begin
                            tem_hum_data_next[i_reg] = 1'b0;
                            if (i_reg == 0) begin
                                state_next = NONE;
                                wr_en_next = 1;
                                int_hum = tem_hum_data_reg[39:32];
                                dec_hum    = tem_hum_data_reg[31:24];
                                // dec_hum = 0;
                                int_tem = tem_hum_data_reg[23:16];
                                dec_tem    = tem_hum_data_reg[15:8];
                            end else begin
                                state_next = WAIT_RECEIVE;
                            end
                        end else begin
                            tem_hum_data_next[i_reg] = 1'b1;
                            if (i_reg == 0) begin
                                state_next = NONE;
                                wr_en_next = 1;
                                int_hum = tem_hum_data_reg[39:32];
                                dec_hum    = tem_hum_data_reg[31:24];
                                // dec_hum = 0;
                                int_tem = tem_hum_data_reg[23:16];
                                dec_tem    = tem_hum_data_reg[15:8];
                            end else begin
                                state_next = WAIT_RECEIVE;
                            end
                        end
                    end
                    // if (!dht11_data) begin
                    //     counter_next = 0;
                    //     i = i + 1;
                    //     state_next = WAIT_RECEIVE;
                    // end else begin
                    // if (counter_reg == 40 - 1) begin
                    //     if (dht11_data) begin
                    //         // temp_next = 1;
                    //         wait_more_next = 1;
                    //     end else begin
                    //         tem_hum_data_next[i_reg] = 1'b0;
                    //         // temp_next = 0;
                    //         i_next = i_reg - 1;
                    //         state_next = WAIT_RECEIVE;
                    //         if (i_reg == 0) begin
                    //             // if (tem_hum_data_reg[39:32] == tem_hum_data_reg[7:0]+tem_hum_data_reg[15:8]+tem_hum_data_reg[23:16]+tem_hum_data_reg[31:24]) begin
                    //             counter_next = 0;
                    //             wr_en_next   = 1;
                    //             i_next       = 0;
                    //             state_next   = NONE;
                    //             // end
                    //         end
                    //         // i = i + 1;
                    //     end
                    // end
                    // if (wait_more_reg) begin
                    //     if (!dht11_data) begin
                    //         tem_hum_data_next[i_reg] = 1'b1;
                    //         i_next = i_reg - 1;
                    //         wait_more_next = 0;
                    //         state_next = WAIT_RECEIVE;
                    //         // i = i + 1;
                    //         if (i_reg == 0) begin
                    //             // if (tem_hum_data_reg[39:32] == tem_hum_data_reg[7:0]+tem_hum_data_reg[15:8]+tem_hum_data_reg[23:16]+tem_hum_data_reg[31:24]) begin
                    //             counter_next = 0;
                    //             wr_en_next   = 1;
                    //             i_next       = 39;
                    //             state_next   = NONE;
                    //             // end
                    //         end
                    //     end
                    // end
                    // // end
                end
            endcase
        end
    end
endmodule
