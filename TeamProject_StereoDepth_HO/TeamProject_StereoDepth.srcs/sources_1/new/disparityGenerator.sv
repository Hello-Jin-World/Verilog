`timescale 1ns / 1ps

// module disparity_pipeline (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic        Hsync,
//     input  logic [15:0] in_L,
//     input  logic [15:0] in_R,
//     input  logic [9:0]  x_pixel,
//     output logic [5:0]  rData
// );

//     logic [15:0] mem_L[0:160-1];
//     logic [15:0] mem_R[0:160-1];
//     logic [5:0] temp1_stage1, temp2_stage1, temp3_stage1, temp4_stage1, temp5_stage1;
//     logic [5:0] min_value_stage2;
//     logic [5:0] temp_mem[0:160-1];

//     // Stage 1: Difference Calculation
//     always_ff @(posedge clk or posedge reset) begin
//         if (reset) begin
//             temp1_stage1 <= 0;
//             temp2_stage1 <= 0;
//             temp3_stage1 <= 0;
//             temp4_stage1 <= 0;
//             temp5_stage1 <= 0;
//         end else begin
//             temp1_stage1 <= (mem_L[x_pixel] > mem_R[x_pixel])   ? (mem_L[x_pixel] - mem_R[x_pixel])     : (mem_R[x_pixel] - mem_L[x_pixel]);
//             temp2_stage1 <= (mem_L[x_pixel] > mem_R[x_pixel+1]) ? (mem_L[x_pixel] - mem_R[x_pixel+1])   : (mem_R[x_pixel+1] - mem_L[x_pixel]);
//             temp3_stage1 <= (mem_L[x_pixel] > mem_R[x_pixel+2]) ? (mem_L[x_pixel] - mem_R[x_pixel+2])   : (mem_R[x_pixel+2] - mem_L[x_pixel]);
//             temp4_stage1 <= (mem_L[x_pixel] > mem_R[x_pixel+3]) ? (mem_L[x_pixel] - mem_R[x_pixel+3])   : (mem_R[x_pixel+3] - mem_L[x_pixel]);
//             temp5_stage1 <= (mem_L[x_pixel] > mem_R[x_pixel+4]) ? (mem_L[x_pixel] - mem_R[x_pixel+4])   : (mem_R[x_pixel+4] - mem_L[x_pixel]);
//         end
//     end

//     // Stage 2: Minimum Value Calculation
//     always_ff @(posedge clk or posedge reset) begin
//         if (reset) begin
//             min_value_stage2 <= 0;
//         end else begin
//             min_value_stage2 <= temp1_stage1;
//             if (temp2_stage1 < min_value_stage2) min_value_stage2 <= temp2_stage1;
//             if (temp3_stage1 < min_value_stage2) min_value_stage2 <= temp3_stage1;
//             if (temp4_stage1 < min_value_stage2) min_value_stage2 <= temp4_stage1;
//             if (temp5_stage1 < min_value_stage2) min_value_stage2 <= temp5_stage1;
//         end
//     end

//     // Stage 3: Update temp_mem based on minimum value
//     always_ff @(posedge clk or posedge reset) begin
//         if (reset) begin
//             temp_mem[x_pixel] <= 0;
//         end else begin
//             case (min_value_stage2)
//                 temp1_stage1: temp_mem[x_pixel] <= 0;
//                 temp2_stage1: temp_mem[x_pixel] <= 10;
//                 temp3_stage1: temp_mem[x_pixel] <= 25;
//                 temp4_stage1: temp_mem[x_pixel] <= 40;
//                 temp5_stage1: temp_mem[x_pixel] <= 63;
//                 default:       temp_mem[x_pixel] <= 63;
//             endcase
//         end
//     end

//     // Output
//     assign rData = temp_mem[x_pixel];

// endmodule


module disparity_generator (
    input  logic        clk,
    input  logic        reset,
    input  logic        Hsync,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic [15:0] in_L,
    input  logic [15:0] in_R,
    output logic [ 5:0] rData
);
    localparam IDLE = 0, COMP = 1;

    logic [15:0] mem_L[0:160-1];
    logic [15:0] mem_R[0:160-1];

    logic state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [5:0] temp1;
    logic [5:0] temp2;
    logic [5:0] temp3;
    logic [5:0] temp4;
    logic [5:0] temp5;
    logic [5:0] min_value;
    logic [5:0] temp_mem  [0:160-1];

    assign rData = temp_mem[x_pixel[9:2]];

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 1;
            temp1       <= 0;
            temp2       <= 0;
            temp3       <= 0;
            temp4       <= 0;
            temp5       <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            if (read_en_reg == 1'b1) begin
                mem_L[x_pixel[9:2]] <= in_L[15:10];
                mem_R[x_pixel[9:2]] <= in_R[15:10];
            end
        end
    end

    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        case (state_reg)
            IDLE: begin
                if (x_pixel[9:1] > 158) begin
                    state_next   = COMP;
                    read_en_next = 0;
                end
            end
            COMP: begin
                for (int j = 0; j < 160; j++) begin
                    temp1 = (mem_L[j] > mem_R[j]) ? (mem_L[j] - mem_R[j]) : (mem_R[j] - mem_L[j]); // Right data' 1st data. 
                    temp2 = (mem_L[j] > mem_R[j+1]) ? (mem_L[j] - mem_R[j+1]) : (mem_R[j+1] - mem_L[j]);       // i
                    temp3 = (mem_L[j] > mem_R[j+2]) ? (mem_L[j] - mem_R[j+2]) : (mem_R[j+2] - mem_L[j]);       // i
                    temp4 = (mem_L[j] > mem_R[j+3]) ? (mem_L[j] - mem_R[j+3]) : (mem_R[j+3] - mem_L[j]);       // i
                    temp5 = (mem_L[j] > mem_R[j+4]) ? (mem_L[j] - mem_R[j+4]) : (mem_R[j+4] - mem_L[j]);       // i

                    if (temp1 < temp2) begin
                        if (temp1 < temp3) begin
                            if (temp1 < temp4) begin
                                if (temp1 < temp5) begin
                                    temp_mem[j] = 0;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 40;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end
                        end else begin
                            if (temp3 < temp4) begin
                                if (temp3 < temp5) begin
                                    temp_mem[j] = 25;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 40;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end
                        end
                    end else begin
                        if (temp2 < temp3) begin
                            if (temp2 < temp4) begin
                                if (temp2 < temp5) begin
                                    temp_mem[j] = 10;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 40;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end
                        end else begin
                            if (temp3 < temp4) begin
                                if (temp3 < temp5) begin
                                    temp_mem[j] = 25;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end else begin
                                if (temp4 < temp5) begin
                                    temp_mem[j] = 40;
                                end else begin
                                    temp_mem[j] = 63;
                                end
                            end
                        end
                    end
                end
                state_next   = IDLE;
                read_en_next = 1;
            end
        endcase
    end

    // ila_1 your_instance_name (
    //     .clk    (clk),                // input wire clk
    //     .probe0 (Hsync),              // input wire [0:0]  probe0  
    //     .probe1 (x_pixel),            // input wire [9:0]  probe1 
    //     .probe2 (in_L),               // input wire [15:0]  probe2 
    //     .probe3 (in_R),               // input wire [15:0]  probe3 
    //     .probe4 (rData),              // input wire [5:0]  probe4 
    //     .probe5 (mem_L[x_pixel]),     // input wire [15:0]  probe5 
    //     .probe6 (mem_R[x_pixel]),     // input wire [15:0]  probe6 
    //     .probe7 (state_reg),          // input wire [0:0]  probe7 
    //     .probe8 (read_en_reg),        // input wire [0:0]  probe8 
    //     .probe9 (temp1),              // input wire [5:0]  probe9 
    //     .probe10(temp2),              // input wire [5:0]  probe10 
    //     .probe11(temp3),              // input wire [5:0]  probe11 
    //     .probe12(temp4),              // input wire [5:0]  probe12 
    //     .probe13(temp5),              // input wire [5:0]  probe13 
    //     .probe14(temp_mem[x_pixel]),  // input wire [5:0]  probe14
    //     .probe15(min_value)
    // );

endmodule

// module disparity_generator (
//     input  logic        clk,
//     input  logic        reset,
//     // input  logic        Hsync,
//     // write side
//     input  logic        wclk1,
//     input  logic        we1,
//     input  logic [14:0] wAddr1,
//     input  logic [15:0] wData1,
//     // write side
//     input  logic        wclk2,
//     input  logic        we2,
//     input  logic [14:0] wAddr2,
//     input  logic [15:0] wData2,
//     // read side for VGA
//     input  logic        rclk,
//     input  logic        oe,
//     input  logic [14:0] rAddr,
//     output logic [ 5:0] rData
// );
//     logic [5:0] mem_L[0:160-1];
//     logic [5:0] mem_R[0:160-1];

//     logic [5:0] prv_mem_L[0:160-1];
//     logic [5:0] prv_mem_R[0:160-1];

//     logic state_reg, state_next;
//     logic read_en_reg, read_en_next;
//     logic [5:0] temp1;
//     logic [5:0] temp2;
//     logic [5:0] temp3;
//     logic [5:0] temp4;
//     logic [5:0] temp5;
//     logic [5:0] temp_mem[0:160-1];
//     // logic [6:0] j_reg, j_next;


//     localparam IDLE = 0, STATE0 = 1;

//     always_ff @(posedge rclk) begin
//         if (oe && read_en_reg) begin
//             rData <= temp_mem[rAddr];
//         end else begin
//             rData <= 0;
//         end
//     end

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             state_reg   <= 0;
//             read_en_reg <= 0;
//             temp1       <= 0;
//             temp2       <= 0;
//             temp3       <= 0;
//             temp4       <= 0;
//             temp5       <= 0;
//             // j_reg       <= 0;
//         end else begin
//             state_reg   <= state_next;
//             read_en_reg <= read_en_next;
//             // j_reg       <= j_next;
//         end
//     end

//     always_ff @(posedge wclk1) begin
//         if (we1) begin
//             mem_L[wAddr1%160] <= wData1[12:7];
//         end
//     end

//     always_ff @(posedge wclk2) begin
//         if (we2) begin
//             mem_R[wAddr2%160] <= wData2[12:7];
//         end
//     end

//     always_comb begin
//         state_next   = state_reg;
//         read_en_next = read_en_reg;
//         // j_next       = j_reg;
//         case (state_reg)
//             IDLE: begin

//                 if (wAddr1 % 159 == 0 && wAddr1 > 0 && wAddr2 % 159 == 0) begin
//                     state_next   = STATE0;
//                     read_en_next = 0;
//                 end
//                 // if (j_reg == 1)
//                 // focal length * baseline / disparity = z() (depth)
//             end
//             STATE0: begin
//                 for (int j = 0; j < 160; j++) begin
//                     temp1 = (mem_L[j] > prv_mem_R[j]) ? (mem_L[j] - mem_R[j]) : (mem_R[j] - mem_L[j]); // Right data' 1st data. 
//                     temp2 = (mem_L[j] > mem_R[j+1]) ? (mem_L[j] - mem_R[j+1]) : (mem_R[j+1] - mem_L[j]);       // i
//                     temp3 = (mem_L[j] > mem_R[j+2]) ? (mem_L[j] - mem_R[j+2]) : (mem_R[j+2] - mem_L[j]);       // i
//                     temp4 = (mem_L[j] > mem_R[j+3]) ? (mem_L[j] - mem_R[j+3]) : (mem_R[j+3] - mem_L[j]);       // i
//                     temp5 = (mem_L[j] > mem_R[j+4]) ? (mem_L[j] - mem_R[j+4]) : (mem_R[j+4] - mem_L[j]);       // i

//                     if (temp1 < temp2) begin
//                         if (temp1 < temp3) begin
//                             if (temp1 < temp4) begin
//                                 if (temp1 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 1;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end else begin
//                                 if (temp4 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 4;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end
//                         end else begin
//                             if (temp3 < temp4) begin
//                                 if (temp3 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 3;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end else begin
//                                 if (temp4 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 4;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end
//                         end
//                     end else begin
//                         if (temp2 < temp3) begin
//                             if (temp2 < temp4) begin
//                                 if (temp2 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 2;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end else begin
//                                 if (temp4 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 4;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end
//                         end else begin
//                             if (temp3 < temp4) begin
//                                 if (temp3 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 3;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end else begin
//                                 if (temp4 < temp5) begin
//                                     temp_mem[j] = 600 * 0.1 / 4;
//                                 end else begin
//                                     temp_mem[j] = 600 * 0.1 / 5;
//                                 end
//                             end
//                         end
//                     end
//                 end
//                 // j_next = j_reg + 1;
//                 // if (!Hsync) begin
//                     state_next   = IDLE;
//                     read_en_next = 1;
//                 // end
//             end
//         endcase
//     end
// endmodule

// module disparity_generator (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic        Hsync,
//     // write side
//     input  logic        wclk1,
//     input  logic        we1,
//     input  logic [14:0] wAddr1,
//     input  logic [15:0] wData1,
//     // write side
//     input  logic        wclk2,
//     input  logic        we2,
//     input  logic [14:0] wAddr2,
//     input  logic [15:0] wData2,
//     // read side for VGA
//     input  logic        rclk,
//     input  logic        oe,
//     input  logic [14:0] rAddr,
//     output logic [ 5:0] rData
// );
//     logic [5:0] mem_L[0:160-1];
//     logic [5:0] mem_R[0:160-1];

//     logic [5:0] prv_mem_L[0:160-1];
//     logic [5:0] prv_mem_R[0:160-1];

//     logic [1:0] state_reg, state_next;
//     // logic read_en_reg, read_en_next;
//     logic [5:0] temp1, temp1_next;
//     logic [5:0] temp2, temp2_next;
//     logic [5:0] temp3, temp3_next;
//     logic [5:0] temp4, temp4_next;
//     logic [5:0] temp5, temp5_next;
//     logic [5:0] result;
//     logic [5:0] temp_mem[0:160*120-1];
//     logic [7:0] j_reg, j_next;
//     logic [6:0] k_reg, k_next;

//     ila_0 U_ila_0 (
//         .clk    (clk),                        // input wire clk
//         .probe0 (wclk1),                      // input wire [0:0]  probe0  
//         .probe1 (wAddr1),                     // input wire [14:0]  probe1 
//         .probe2 (wData1),                     // input wire [15:0]  probe2 
//         .probe3 (wclk2),                      // input wire [0:0]  probe3 
//         .probe4 (wAddr2),                     // input wire [14:0]  probe4 
//         .probe5 (wData2),                     // input wire [15:0]  probe5 
//         .probe6 (rclk),                       // input wire [0:0]  probe6 
//         .probe7 (oe),                         // input wire [0:0]  probe7 
//         .probe8 (rAddr),                      // input wire [14:0]  probe8 
//         .probe9 (rData),                      // input wire [5:0]  probe9 
//         .probe10(mem_L[wAddr1%160]),          // input wire [5:0]  probe10 
//         .probe11(mem_R[wAddr2%160]),          // input wire [5:0]  probe11 
//         .probe12(prv_mem_L[wAddr1%160]),      // input wire [5:0]  probe12 
//         .probe13(prv_mem_R[wAddr2%160]),      // input wire [5:0]  probe13 
//         .probe14(state_reg),                  // input wire [1:0]  probe14 
//         .probe15(read_en_reg),                // input wire [0:0]  probe15
//         .probe16(temp_mem[j_reg+k_reg*160]),  // input wire [5:0]  probe16 
//         .probe17({8'd0, k_reg}),              // input wire [14:0]  probe17 
//         .probe18(j_reg)                       // input wire [7:0]  probe18
//     );


//     localparam IDLE0 = 0, IDLE1 = 1, STATE0 = 2, STATE1 = 3;


//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             state_reg <= 0;
//             temp1     <= 0;
//             temp2     <= 0;
//             temp3     <= 0;
//             temp4     <= 0;
//             temp5     <= 0;
//             result    <= 0;
//             j_reg     <= 0;
//             k_reg     <= 0;
//         end else begin
//             state_reg <= state_next;
//             j_reg     <= j_next;
//             k_reg     <= k_next;
//             temp1     <= temp1_next;
//             temp2     <= temp2_next;
//             temp3     <= temp3_next;
//             temp4     <= temp4_next;
//             temp5     <= temp5_next;
//         end
//     end


//     always_ff @(posedge wclk1) begin
//         if (we1) begin
//             mem_L[wAddr1%160] <= wData1[13:8];
//         end
//     end

//     always_ff @(posedge wclk2) begin
//         if (we2) begin
//             mem_R[wAddr2%160] <= wData2[13:8];
//         end
//     end

//     always_comb begin
//         state_next = state_reg;
//         j_next     = j_reg;
//         k_next     = k_reg;
//         temp1_next = temp1;
//         temp2_next = temp2;
//         temp3_next = temp3;
//         temp4_next = temp4;
//         temp5_next = temp5;
//         case (state_reg)
//             IDLE0: begin
//                 prv_mem_L = mem_L;
//                 prv_mem_R = mem_R;
//                 if (wAddr2 >= 4) begin
//                     state_next = STATE0;
//                 end else begin
//                     state_next = IDLE0;
//                 end
//             end
//             IDLE1: begin
//                 prv_mem_L = mem_L;
//                 prv_mem_R = mem_R;
//                 if (wAddr2 % (j_reg + 4 == 0)) begin
//                     state_next = STATE0;
//                 end else begin
//                     state_next = IDLE1;
//                 end
//                 // read_en_next = 0;
//             end
//             STATE0: begin
//                 temp1_next = (prv_mem_L[j_reg] > prv_mem_R[j_reg]) ? (prv_mem_L[j_reg] - prv_mem_R[j_reg]) : (prv_mem_R[j_reg] - prv_mem_L[j_reg]);             // Right data' 1st data. 
//                 temp2_next = (prv_mem_L[j_reg] > prv_mem_R[j_reg+1]) ? (prv_mem_L[j_reg] - prv_mem_R[j_reg+1]) : (prv_mem_R[j_reg+1] - prv_mem_L[j_reg]);       // i
//                 temp3_next = (prv_mem_L[j_reg] > prv_mem_R[j_reg+2]) ? (prv_mem_L[j_reg] - prv_mem_R[j_reg+2]) : (prv_mem_R[j_reg+2] - prv_mem_L[j_reg]);       // i
//                 temp4_next = (prv_mem_L[j_reg] > prv_mem_R[j_reg+3]) ? (prv_mem_L[j_reg] - prv_mem_R[j_reg+3]) : (prv_mem_R[j_reg+3] - prv_mem_L[j_reg]);       // i
//                 temp5_next = (prv_mem_L[j_reg] > prv_mem_R[j_reg+4]) ? (prv_mem_L[j_reg] - prv_mem_R[j_reg+4]) : (prv_mem_R[j_reg+4] - prv_mem_L[j_reg]);       // i
//                 state_next = STATE1;
//             end
//             STATE1: begin
//                 if (temp1 < temp2) begin
//                     if (temp1 < temp3) begin
//                         if (temp1 < temp4) begin
//                             if (temp1 < temp5) begin
//                                 result = 600 * 0.1 / 1;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end else begin
//                             if (temp4 < temp5) begin
//                                 result = 600 * 0.1 / 4;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end
//                     end else begin
//                         if (temp3 < temp4) begin
//                             if (temp3 < temp5) begin
//                                 result = 600 * 0.1 / 3;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end else begin
//                             if (temp4 < temp5) begin
//                                 result = 600 * 0.1 / 4;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end
//                     end
//                 end else begin
//                     if (temp2 < temp3) begin
//                         if (temp2 < temp4) begin
//                             if (temp2 < temp5) begin
//                                 result = 600 * 0.1 / 2;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end else begin
//                             if (temp4 < temp5) begin
//                                 result = 600 * 0.1 / 4;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end
//                     end else begin
//                         if (temp3 < temp4) begin
//                             if (temp3 < temp5) begin
//                                 result = 600 * 0.1 / 3;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end else begin
//                             if (temp4 < temp5) begin
//                                 result = 600 * 0.1 / 4;
//                             end else begin
//                                 result = 600 * 0.1 / 5;
//                             end
//                         end
//                     end
//                 end

//                 temp_mem[j_reg+k_reg*160] = result;

//                 if (j_reg >= 159) begin
//                     if (!Hsync) begin
//                         temp1_next = 0;
//                         temp2_next = 0;
//                         temp3_next = 0;
//                         temp4_next = 0;
//                         temp5_next = 0;
//                         j_next     = 0;
//                         state_next = IDLE0;
//                         if (k_reg == 119) begin
//                             k_next = 0;
//                         end else begin
//                             k_next = k_reg + 1;
//                         end
//                     end
//                 end else begin
//                     temp1_next = 0;
//                     temp2_next = 0;
//                     temp3_next = 0;
//                     temp4_next = 0;
//                     temp5_next = 0;
//                     j_next     = j_reg + 1;
//                     state_next = IDLE1;
//                 end
//             end
//         endcase
//     end

//     always_ff @(posedge rclk) begin
//         if (oe) begin
//             rData <= temp_mem[rAddr];
//         end else begin
//             rData <= 0;
//         end
//     end
// endmodule

// module disparity_generator (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic        Hsync,
//     // write side
//     input  logic        wclk1,
//     input  logic        we1,
//     input  logic [14:0] wAddr1,
//     input  logic [15:0] wData1,
//     // write side
//     input  logic        wclk2,
//     input  logic        we2,
//     input  logic [14:0] wAddr2,
//     input  logic [15:0] wData2,
//     // read side for VGA
//     input  logic        rclk,
//     input  logic        oe,
//     input  logic [14:0] rAddr,
//     output logic [ 5:0] rData
// );
//     logic [5:0] mem_L[0:160-1];
//     logic [5:0] mem_R[0:160-1];

//     logic [5:0] prv_mem_L[0:160-1];
//     logic [5:0] prv_mem_R[0:160-1];

//     logic state_reg, state_next;
//     logic read_en_reg, read_en_next;
//     logic [5:0] temp1;
//     logic [5:0] temp2;
//     logic [5:0] temp3;
//     logic [5:0] temp4;
//     logic [5:0] temp5;
//     logic [5:0] temp_mem[0:160-1];
//     logic [6:0] j_reg, j_next;

//     ila_0 U_ila_0 (
//         .clk    (clk),                    // input wire clk
//         .probe0 (wclk1),                  // input wire [0:0]  probe0  
//         .probe1 (wAddr1),                 // input wire [14:0]  probe1 
//         .probe2 (wData1),                 // input wire [15:0]  probe2 
//         .probe3 (wclk2),                  // input wire [0:0]  probe3 
//         .probe4 (wAddr2),                 // input wire [14:0]  probe4 
//         .probe5 (wData2),                 // input wire [15:0]  probe5 
//         .probe6 (rclk),                   // input wire [0:0]  probe6 
//         .probe7 (oe),                     // input wire [0:0]  probe7 
//         .probe8 (rAddr),                  // input wire [14:0]  probe8 
//         .probe9 (rData),                  // input wire [5:0]  probe9 
//         .probe10(mem_L[wAddr1%160]),      // input wire [5:0]  probe10 
//         .probe11(mem_R[wAddr2%160]),      // input wire [5:0]  probe11 
//         .probe12(prv_mem_L[wAddr1%160]),  // input wire [5:0]  probe12 
//         .probe13(prv_mem_R[wAddr2%160]),  // input wire [5:0]  probe13 
//         .probe14(state_reg),              // input wire [1:0]  probe14 
//         .probe15(read_en_reg),            // input wire [0:0]  probe15
//         .probe16(temp_mem[rAddr])        // input wire [5:0]  probe16 
//     );

//     localparam IDLE = 0, STATE0 = 1;

//     always_ff @(posedge rclk) begin
//         // if (y - 240 == j_reg) begin
//         if (oe && read_en_reg) begin
//             rData <= temp_mem[rAddr];
//         end else begin
//             rData <= 0;
//         end
//         // end
//     end

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             state_reg   <= 0;
//             read_en_reg <= 1;
//             temp1       <= 0;
//             temp2       <= 0;
//             temp3       <= 0;
//             temp4       <= 0;
//             temp5       <= 0;
//             j_reg       <= 0;
//             for (int i = 0; i < 160; i++) begin
//                 temp_mem[i]  <= 6'd0;
//                 mem_L[i]     <= 6'd0;
//                 mem_R[i]     <= 6'd0;
//                 prv_mem_L[i] <= 6'd0;
//                 prv_mem_R[i] <= 6'd0;
//             end
//         end else begin
//             state_reg   <= state_next;
//             read_en_reg <= read_en_next;
//             j_reg       <= j_next;
//         end
//     end

//     always_ff @(posedge wclk1) begin
//         if (we1 && read_en_reg) begin
//             mem_L[wAddr1%160] <= wData1[13:8];
//         end
//     end

//     always_ff @(posedge wclk2) begin
//         if (we2 && read_en_reg) begin
//             mem_R[wAddr2%160] <= wData2[13:8];
//         end
//     end

//     always_comb begin
//         state_next   = state_reg;
//         read_en_next = read_en_reg;
//         j_next       = j_reg;
//         case (state_reg)
//             IDLE: begin
//                 prv_mem_L = mem_L;
//                 prv_mem_R = mem_R;
//                 if (wAddr2 % 159 == 0 && wAddr2 > 0) begin
//                     state_next   = STATE0;
//                     read_en_next = 0;
//                 end
//                 // focal length * baseline / disparity = z() (depth)
//             end
//             STATE0: begin
//                 if (!Hsync) begin
//                     state_next   = IDLE;
//                     read_en_next = 1;
//                     if (j_reg == 119) begin
//                         j_next = 0;
//                     end else begin
//                         j_next = j_reg + 1;
//                     end
//                     for (int j = 0; j < 160; j++) begin
//                         temp1 = (prv_mem_L[j] > prv_mem_R[j]) ? (prv_mem_L[j] - prv_mem_R[j]) : (prv_mem_R[j] - prv_mem_L[j]); // Right data' 1st data. 
//                         temp2 = (prv_mem_L[j] > prv_mem_R[j+1]) ? (prv_mem_L[j] - prv_mem_R[j+1]) : (prv_mem_R[j+1] - prv_mem_L[j]);       // i
//                         temp3 = (prv_mem_L[j] > prv_mem_R[j+2]) ? (prv_mem_L[j] - prv_mem_R[j+2]) : (prv_mem_R[j+2] - prv_mem_L[j]);       // i
//                         temp4 = (prv_mem_L[j] > prv_mem_R[j+3]) ? (prv_mem_L[j] - prv_mem_R[j+3]) : (prv_mem_R[j+3] - prv_mem_L[j]);       // i
//                         temp5 = (prv_mem_L[j] > prv_mem_R[j+4]) ? (prv_mem_L[j] - prv_mem_R[j+4]) : (prv_mem_R[j+4] - prv_mem_L[j]);       // i

//                         if (temp1 < temp2) begin
//                             if (temp1 < temp3) begin
//                                 if (temp1 < temp4) begin
//                                     if (temp1 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 1;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end else begin
//                                     if (temp4 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 4;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end
//                             end else begin
//                                 if (temp3 < temp4) begin
//                                     if (temp3 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 3;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end else begin
//                                     if (temp4 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 4;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end
//                             end
//                         end else begin
//                             if (temp2 < temp3) begin
//                                 if (temp2 < temp4) begin
//                                     if (temp2 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 2;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end else begin
//                                     if (temp4 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 4;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end
//                             end else begin
//                                 if (temp3 < temp4) begin
//                                     if (temp3 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 3;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end else begin
//                                     if (temp4 < temp5) begin
//                                         temp_mem[j] = 600 * 0.1 / 4;
//                                     end else begin
//                                         temp_mem[j] = 600 * 0.1 / 5;
//                                     end
//                                 end
//                             end
//                         end
//                     end
//                 end
//             end
//         endcase
//     end
// endmodule
