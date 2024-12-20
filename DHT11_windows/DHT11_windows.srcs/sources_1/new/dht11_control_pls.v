`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 19:09:20
// Design Name: 
// Module Name: dht11_control_pls
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


module dht11_control_pls (
//     input        clk,
//     input        reset,
//     inout        ioport,
//     output       wr_en,
//     output [7:0] hum_int,
//     output [7:0] hum_dec,
//     output [7:0] tem_int,
//     output [7:0] tem_dec
// );

//     wire io_mode;
//     wire signal;
//     reg  receive_dht11_data;
//     wire tick;
//     wire start_dht11;
//     wire start_receive_data;
//     wire finish_receive_data;


//     clock_divider U_clock_divider (
//         .clk      (clk),
//         .reset    (reset),
//         .tick_1Mhz(tick)
//     );

//     count_5sec U_count_5sec (
//         .clk        (clk),
//         .reset      (reset),
//         .tick       (tick),
//         .start_dht11(start_dht11)
//     );


//     start_signal U_start_signal (
//         .clk                (clk),
//         .reset              (reset),
//         .tick               (tick),
//         .start_dht11        (start_dht11),
//         .wr_en              (wr_en),
//         .finish_receive_data(finish_receive_data),
//         .start_receive_data (start_receive_data),
//         .signal             (signal),
//         .mode               (io_mode)
//     );

//     receive_data U_receive_data (
//         .clk                (clk),
//         .reset              (reset),
//         .tick               (tick),
//         .dht11_data         (receive_dht11_data),
//         .start_receive_data (start_receive_data),
//         .finish_receive_data(finish_receive_data),
//         .hum_int            (hum_int),
//         .hum_dec            (hum_dec),
//         .tem_int            (tem_int),
//         .tem_dec            (tem_dec)
//     );

//     assign ioport = io_mode ? signal : 1'bz;  // If you want to send(out) "HIGH"
//     // //    assign xxxx   = mode ? 1'bz : ioport;  // If you want to read(in) INPUT data

//     always @(*) begin  // Read Data (INPUT MODE)
//         if (!io_mode) begin
//             receive_dht11_data <= ioport;
//         end
//     end
// endmodule

// module count_5sec (
//     input  clk,
//     input  reset,
//     input  tick,
//     output start_dht11
// );

//     reg [$clog2(1_000_000) - 1:0] counter_reg, counter_next;
//     reg start_dht11_reg, start_dht11_next;

//     assign start_dht11 = start_dht11_reg;

//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             counter_reg     <= 0;
//             start_dht11_reg <= 0;
//         end else begin
//             counter_reg     <= counter_next;
//             start_dht11_reg <= start_dht11_next;
//         end
//     end

//     always @(*) begin
//         counter_next     = counter_reg;
//         start_dht11_next = start_dht11_next;
//         if (tick) begin
//             if (counter_reg == 1_000_000 - 1) begin
//                 counter_next     = 0;
//                 start_dht11_next = 1;
//             end else begin
//                 start_dht11_next = 0;
//                 counter_next     = counter_reg + 1;
//             end
//         end
//     end

// endmodule

// module clock_divider (
//     input  clk,
//     input  reset,
//     output tick_1Mhz
// );

//     reg [$clog2(100)-1 : 0] r_counter;
//     reg r_tick;

//     assign tick_1Mhz = r_tick;

//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             r_counter <= 0;
//             r_tick    <= 1'b0;
//         end else begin
//             if (r_counter == 100 - 1) begin
//                 r_counter <= 0;
//                 r_tick    <= 1'b1;
//             end else begin
//                 r_counter <= r_counter + 1;
//                 r_tick    <= 1'b0;
//             end
//         end
//     end

// endmodule

// module start_signal (
//     input  clk,
//     input  reset,
//     input  tick,
//     input  start_dht11,
//     input  wr_en,
//     input  finish_receive_data,
//     output start_receive_data,
//     output signal,
//     output mode
// );

//     reg signal_reg, signal_next;
//     reg [$clog2(18_000) - 1:0] counter_reg, counter_next;
//     reg mode_reg, mode_next;
//     reg start_receive_data_reg, start_receive_data_next;
//     reg [1:0] state_reg, state_next;

//     localparam IDLE = 2'b00, START_L = 2'b01, START_H = 2'b10, RECEIVE_DATA = 2'b11;

//     //    localparam START = 1'b0, WAIT_RESPONSE = 1'b1;

//     assign signal             = signal_reg;
//     assign mode               = mode_reg;
//     assign start_receive_data = start_receive_data_reg;

//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             signal_reg             <= 1'b1;
//             counter_reg            <= 0;
//             mode_reg               <= 1'b1;
//             start_receive_data_reg <= 0;
//             state_reg              <= IDLE;
//         end else begin
//             signal_reg             <= signal_next;
//             counter_reg            <= counter_next;
//             mode_reg               <= mode_next;
//             start_receive_data_reg <= start_receive_data_next;
//             state_reg              <= state_next;
//         end
//     end

//     always @(*) begin
//         counter_next            = counter_reg;
//         signal_next             = signal_reg;
//         mode_next               = mode_reg;
//         start_receive_data_next = start_receive_data_reg;
//         state_next              = state_reg;

//         if (tick) begin
//             counter_next = counter_reg + 1;
//         end

//         case (state_reg)
//             IDLE: begin
//                 if (start_dht11) begin
//                     state_next   = START_L;
//                     counter_next = 0;
//                 end else begin
//                     signal_next = 1'b1;
//                     mode_next   = 1'b1;
//                 end
//             end
//             START_L: begin
//                 if (counter_reg == 18000 - 1) begin
//                     state_next   = START_H;
//                     counter_next = 0;
//                 end else begin
//                     signal_next = 1'b0;
//                 end
//             end
//             START_H: begin
//                 if (counter_reg == 40 - 1) begin
//                     state_next = RECEIVE_DATA;
//                     start_receive_data_next = 1'b1;
//                 end else begin
//                     signal_next = 1'b1;
//                 end
//             end
//             RECEIVE_DATA: begin
//                 if (finish_receive_data == 1'b1) begin
//                     state_next = IDLE;
//                     start_receive_data_next = 1'b0;
//                 end else begin
//                     mode_next = 1'b0;
//                     start_receive_data_next = 1'b1;
//                 end
//             end
//         endcase
//     end

// endmodule

// module receive_data (
//     input            clk,
//     input            reset,
//     input            tick,
//     input            dht11_data,
//     input            start_receive_data,
//     output           finish_receive_data,
//     output reg [7:0] hum_int,
//     output reg [7:0] hum_dec,
//     output reg [7:0] tem_int,
//     output reg [7:0] tem_dec
// );

//     ila_0 U_ila_0 (
//         .clk(clk),
//         .probe0(tick),
//         .probe1(finish_receive_data),
//         .probe2(dht11_data),
//         .probe3(state_reg),
//         .probe4(i_reg),
//         .probe5(counter_reg),
//         .probe6(hum_int),
//         .probe7(hum_dec)
//     );

//     localparam IDLE = 3'b000, WAIT_0 = 3'b001, WAIT_1 = 3'b010, READ_LOW = 3'b011, READ_HIGH = 3'b100, DATA_DIST = 3'b101, WAIT = 3'b110;


//     reg [2:0] state_reg, state_next;
//     reg [$clog2(80) - 1 : 0] counter_reg, counter_next;
//     reg [39:0] tem_hum_data_reg, tem_hum_data_next;
//     reg [$clog2(40) - 1 : 0] i_reg, i_next;
//     reg finish_receive_data_reg, finish_receive_data_next;



//     assign finish_receive_data = finish_receive_data_reg;

//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             state_reg               <= 0;
//             counter_reg             <= 0;
//             tem_hum_data_reg        <= 0;
//             i_reg                   <= 0;
//             finish_receive_data_reg <= 0;
//         end else begin
//             state_reg               <= state_next;
//             counter_reg             <= counter_next;
//             tem_hum_data_reg        <= tem_hum_data_next;
//             i_reg                   <= i_next;
//             finish_receive_data_reg <= finish_receive_data_next;
//         end
//     end

//     always @(*) begin
//         state_next               = state_reg;
//         tem_hum_data_next        = tem_hum_data_reg;
//         counter_next             = counter_reg;
//         i_next                   = i_reg;
//         finish_receive_data_next = finish_receive_data_reg;


//         case (state_reg)
//             IDLE: begin
//                 if (start_receive_data) begin
//                     state_next = WAIT;
//                 end
//                 finish_receive_data_next = 0;
//             end
//             WAIT: begin
//                 if (!dht11_data) begin
//                     state_next = WAIT_0;
//                 end
//             end
//             WAIT_0: begin
//                 if (dht11_data) begin
//                     state_next = WAIT_1;
//                 end
//             end
//             WAIT_1: begin
//                 if (!dht11_data) begin
//                     state_next = READ_LOW;
//                     i_next = 0;
//                 end
//             end
//             READ_LOW: begin
//                 if (dht11_data) begin
//                     state_next   = READ_HIGH;
//                     counter_next = 0;
//                 end
//             end
//             READ_HIGH: begin
//                 if (tick) begin
//                     counter_next = counter_reg + 1;
//                 end
//                 if (!dht11_data) begin
//                     if (counter_reg < 40) begin
//                         tem_hum_data_next = {tem_hum_data_reg[38:0], 1'b0};
//                         i_next            = i_reg + 1;
//                         state_next        = READ_LOW;
//                         if (i_next == 40) begin
//                             state_next = DATA_DIST;
//                         end
//                     end else begin
//                         tem_hum_data_next = {tem_hum_data_reg[38:0], 1'b1};
//                         i_next            = i_reg + 1;
//                         state_next        = READ_LOW;
//                         if (i_next == 40) begin
//                             state_next = DATA_DIST;
//                         end
//                     end
//                 end
//             end
//             DATA_DIST: begin
//                 hum_int                  = tem_hum_data_reg[7:0];
//                 hum_dec                  = tem_hum_data_reg[15:8];
//                 tem_int                  = tem_hum_data_reg[23:16];
//                 tem_dec                  = tem_hum_data_reg[31:24];
//                 finish_receive_data_next = 1;
//                 counter_next             = 0;
//                 i_next                   = 0;
//                 state_next               = IDLE;
//             end
//         endcase

//     end
// endmodule
