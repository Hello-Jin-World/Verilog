`timescale 1ns / 1ps

module DepthAlgorithm (
    input  logic        clk,
    input  logic        reset,
    input  logic        Hsync,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic [13:0] in_L,
    input  logic [13:0] in_R,
    output logic [ 5:0] rData
);
    localparam IDLE = 0, COMP = 1;

    logic [13:0] mem_L[0:159];
    logic [13:0] mem_R[0:159];

    logic [1:0] state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [13:0] temp1, temp2, temp3, temp4, temp5, temp_min;
    logic [5:0] temp_mem[0:160-1];
    logic [6:0] i_reg, i_next;

    // logic [6:0]  min_temp, min_index, i, temp;

    assign rData = temp_mem[x_pixel[9:2]];

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 1;
            i_reg       <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            i_reg       <= i_next;
            if (read_en_reg == 1'b1) begin
                mem_L[x_pixel[9:2]] <= in_L;
                mem_R[x_pixel[9:2]] <= in_R;
            end
        end
    end

    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        i_next       = i_reg;
        case (state_reg)
            IDLE: begin
                if (x_pixel >= 159) begin
                    state_next   = COMP;
                    read_en_next = 0;
                end
            end
            COMP: begin
                for (int j = 0; j < 160; j++) begin
                    temp1 = (mem_L[j] > mem_R[j])     ? (mem_L[j] - mem_R[j])     : (mem_R[j]     - mem_L[j]);
                    temp2 = (mem_L[j] > mem_R[j + 1]) ? (mem_L[j] - mem_R[j + 1]) : (mem_R[j + 1] - mem_L[j]);
                    temp3 = (mem_L[j] > mem_R[j + 2]) ? (mem_L[j] - mem_R[j + 2]) : (mem_R[j + 2] - mem_L[j]);
                    temp4 = (mem_L[j] > mem_R[j + 3]) ? (mem_L[j] - mem_R[j + 3]) : (mem_R[j + 3] - mem_L[j]);
                    temp5 = (mem_L[j] > mem_R[j + 4]) ? (mem_L[j] - mem_R[j + 4]) : (mem_R[j + 4] - mem_L[j]);

                    temp_mem[j] =
                        get_min_temp(temp1, temp2, temp3, temp4, temp5);
                end
                state_next   = IDLE;
                read_en_next = 1;
            end
        endcase
    end

    function logic [5:0] get_min_temp(logic [5:0] temp1, temp2, temp3, temp4,
                                      temp5);
        if (temp1 <= temp2 && temp1 <= temp3 && temp1 <= temp4 && temp1 <= temp5)
            return 0;
        if (temp2 <= temp3 && temp2 <= temp4 && temp2 <= temp5) return 10;
        if (temp3 <= temp4 && temp3 <= temp5) return 25;
        if (temp4 <= temp5) return 40;
        return 63;
    endfunction

endmodule

module DepthAlgorithm_window_3x3 (
    input  logic        clk,
    input  logic        reset,
    input  logic        Hsync,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic [13:0] in_L,
    input  logic [13:0] in_R,
    output logic [ 5:0] rData
);



    localparam IDLE = 0, COMP = 1;

    logic [13:0] mem_L[0:2][0:159];
    logic [13:0] mem_R[0:2][0:159];
    logic state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [35:0] window_cost[9:0];
    logic [5:0] temp_mem[0:160-1];
    logic [7:0] j, j_next;

    // Pipeline registers
    logic [13:0] window_L[0:2][0:2];
    logic [13:0] window_R[0:2][0:2];
    logic [5:0] depth_reg;
    logic [13:0] temp_R[0:2][0:2]; // Temporary packed array for passing to calc_window_cost


    assign rData = temp_mem[x_pixel[9:1]];

    logic [35:0] cost_sq;
    logic [ 3:0] min_idx;
    logic stop;

    function logic [35:0] calc_window_cost(input logic [13:0] L[0:2][0:2],
                                           input logic [13:0] R[0:2][0:2]);
        logic [17:0] cost;
        for (int i = 0; i < 3; i++)
            for (int w = 0; w < 3; w++)
                cost += (L[i][w] > R[i][w]) ? (L[i][w] - R[i][w]) : (R[i][w] - L[i][w]);
        cost_sq = cost * cost;
        return cost_sq;
    endfunction

    function logic [3:0] get_depth(logic [35:0] costs[9:0]);
        // for (int i = 0; i < 10; i++) if (costs[i] < costs[min_idx]) min_idx = i;

        if (costs[0] < costs[1]) begin
            min_idx = 0;
        end else begin
            if (costs[1] < costs[2]) begin
                min_idx = 1;
            end else begin
                if (costs[2] < costs[3]) begin
                    min_idx = 2;
                end else begin
                    if (costs[3] < costs[4]) begin
                        min_idx = 3;
                    end else begin
                        if (costs[4] < costs[5]) begin
                            min_idx = 4;
                        end else begin
                            if (costs[5] < costs[6]) begin
                                min_idx = 5;
                            end else begin
                                if (costs[6] < costs[7]) begin
                                    min_idx = 6;
                                end else begin
                                    if (costs[7] < costs[8]) begin
                                        min_idx = 7;
                                    end else begin
                                        if (costs[8] < costs[9]) begin
                                            min_idx = 8;
                                        end else begin
                                            min_idx = 9;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end



        case (min_idx)
            0: return 15;
            1: return 13;
            2: return 12;
            3: return 11;
            4: return 9;
            5: return 7;
            6: return 5;
            7: return 3;
            8: return 1;
            default: return 0;
            // 0: return 120 * 0.5 / 1;
            // 1: return 120 * 0.5 / 2;
            // 2: return 120 * 0.5 / 3;
            // 3: return 120 * 0.5 / 4;
            // default: return 120 * 0.5 / 5;
        endcase
    endfunction

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 1;
            j           <= 0;
            cost_sq     <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            j           <= j_next;

            // Pipeline Stage 1: Load window data
            if (read_en_reg == 1'b1) begin
                mem_L[y_pixel[9:1]%3][x_pixel[9:1]] <= in_L;
                mem_R[y_pixel[9:1]%3][x_pixel[9:1]] <= in_R;
            end

            // Pipeline Stage 2: Setup window data
            for (int i = 0; i < 3; i++) begin
                for (int k = 0; k < 3; k++) begin
                    window_L[i][k] <= mem_L[i][j+k];
                    window_R[i][k] <= mem_R[i][j+k];
                end
            end

            // Pipeline Stage 3: Calculate costs (Unrolled loop)
            // Prepare packed array for each disparity value and calculate costs
            // Disparity 0
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k];
            window_cost[0] <= calc_window_cost(window_L, temp_R);

            // Disparity 1
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+1];
            window_cost[1] <= calc_window_cost(window_L, temp_R);

            // Disparity 2
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+2];
            window_cost[2] <= calc_window_cost(window_L, temp_R);

            // Disparity 3
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+3];
            window_cost[3] <= calc_window_cost(window_L, temp_R);

            // Disparity 4
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+4];
            window_cost[4] <= calc_window_cost(window_L, temp_R);

            // Disparity 5
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+5];
            window_cost[5] <= calc_window_cost(window_L, temp_R);

            // Disparity 6
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+6];
            window_cost[6] <= calc_window_cost(window_L, temp_R);

            // Disparity 7
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+7];
            window_cost[7] <= calc_window_cost(window_L, temp_R);

            // Disparity 8
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+8];
            window_cost[8] <= calc_window_cost(window_L, temp_R);

            // Disparity 9
            for (int i = 0; i < 3; i++)
                for (int k = 0; k < 3; k++) temp_R[i][k] = window_R[i][k+9];
            window_cost[9] <= calc_window_cost(window_L, temp_R);

            // Pipeline Stage 4: Determine depth
            depth_reg <= {get_depth(window_cost), 2'b11};

            // Pipeline Stage 5: Store result
            temp_mem[j] <= depth_reg;
        end
    end

    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        j_next       = j;

        case (state_reg)
            IDLE: begin
                if (x_pixel[9:1] == 159) begin
                    state_next   = COMP;
                    read_en_next = 0;
                end
            end
            COMP: begin
                if (j == 159) begin
                    j_next       = 0;
                    state_next   = IDLE;
                    read_en_next = 1;
                end else begin
                    j_next     = j + 1;
                    state_next = COMP;
                end
            end
        endcase
    end

    // ila_1 your_instance_name (
    //     .clk(clk),  // input wire clk


    //     .probe0(x_pixel),  // input wire [9:0]  probe0  
    //     .probe1(y_pixel),  // input wire [9:0]  probe1 
    //     .probe2(in_L),  // input wire [13:0]  probe2 
    //     .probe3(in_R),  // input wire [13:0]  probe3 
    //     .probe4(rData),  // input wire [5:0]  probe4 
    //     .probe5(window_cost[0]),  // input wire [35:0]  probe5 
    //     .probe6(window_cost[1]),  // input wire [35:0]  probe6 
    //     .probe7(window_cost[2]),  // input wire [35:0]  probe7 
    //     .probe8(window_cost[3]),  // input wire [35:0]  probe8 
    //     .probe9(window_cost[4]),  // input wire [35:0]  probe9 
    //     .probe10(window_cost[5]),  // input wire [35:0]  probe10 
    //     .probe11(window_cost[6]),  // input wire [35:0]  probe11 
    //     .probe12(window_cost[7]),  // input wire [35:0]  probe12 
    //     .probe13(window_cost[8]),  // input wire [35:0]  probe13 
    //     .probe14(window_cost[9]),  // input wire [35:0]  probe14 
    //     .probe15(j),  // input wire [7:0]  probe15 
    //     .probe16(state_reg),  // input wire [0:0]  probe16
    //     .probe17(min_idx)  // input wire [3:0]  probe17
    // );
endmodule

module DepthAlgorithm_window_5x5 (
    input  logic        clk,
    input  logic        reset,
    input  logic        Hsync,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic [13:0] in_L,
    input  logic [13:0] in_R,
    output logic [ 5:0] rData
);

    localparam IDLE = 0, COMP = 1;
    logic [13:0] mem_L[0:4][0:159];
    logic [13:0] mem_R[0:4][0:159];
    logic state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [18:0] window_cost[4:0];
    logic [5:0] temp_mem[0:160-1];
    logic [7:0] j, j_next;

    // Pipeline registers
    logic [13:0] window_L[0:4][0:4];
    logic [13:0] window_R[0:4][0:4];
    logic [11:0] cost_reg[0:24];
    logic [5:0] depth_reg;
    logic [13:0] temp_R[0:4][0:4]; // Temporary packed array for passing to calc_window_cost

    assign rData = temp_mem[x_pixel[9:2]];

    function logic [18:0] calc_window_cost(input logic [13:0] L[0:4][0:4],
                                           input logic [13:0] R[0:4][0:4]);
        logic [18:0] cost = 0;
        for (int i = 0; i < 5; i++)
            for (int w = 0; w < 5; w++)
                cost += (L[i][w] > R[i][w]) ? (L[i][w] - R[i][w]) : (R[i][w] - L[i][w]);
        return cost;
    endfunction

    function logic [3:0] get_depth(logic [18:0] costs[5]);
        logic [2:0] min_idx = 0;
        for (int i = 0; i < 5; i++) if (costs[i] < costs[min_idx]) min_idx = i;

        case (min_idx)
            0: return 15;
            1: return 12;
            2: return 8;
            3: return 3;
            default: return 0;
            // 0: return 120 * 0.5 / 1;
            // 1: return 120 * 0.5 / 2;
            // 2: return 120 * 0.5 / 3;
            // 3: return 120 * 0.5 / 4;
            // default: return 120 * 0.5 / 5;
        endcase
    endfunction

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 1;
            j           <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            j           <= j_next;

            // Pipeline Stage 1: Load window data
            if (read_en_reg == 1'b1) begin
                mem_L[y_pixel[9:2]%3][x_pixel[9:2]] <= in_L;
                mem_R[y_pixel[9:2]%3][x_pixel[9:2]] <= in_R;
            end

            // Pipeline Stage 2: Setup window data
            for (int i = 0; i < 5; i++) begin
                for (int k = 0; k < 5; k++) begin
                    window_L[i][k] <= mem_L[i][j+k];
                    window_R[i][k] <= mem_R[i][j+k];
                end
            end

            // Pipeline Stage 3: Calculate costs (Unrolled loop)
            // Prepare packed array for each disparity value and calculate costs
            // Disparity 0
            for (int i = 0; i < 5; i++)
                for (int k = 0; k < 5; k++) temp_R[i][k] = window_R[i][k];
            window_cost[0] <= calc_window_cost(window_L, temp_R);

            // Disparity 1
            for (int i = 0; i < 5; i++)
                for (int k = 0; k < 5; k++) temp_R[i][k] = window_R[i][k+1];
            window_cost[1] <= calc_window_cost(window_L, temp_R);

            // Disparity 2
            for (int i = 0; i < 5; i++)
                for (int k = 0; k < 5; k++) temp_R[i][k] = window_R[i][k+2];
            window_cost[2] <= calc_window_cost(window_L, temp_R);

            // Disparity 3
            for (int i = 0; i < 5; i++)
                for (int k = 0; k < 5; k++) temp_R[i][k] = window_R[i][k+3];
            window_cost[3] <= calc_window_cost(window_L, temp_R);

            // Disparity 4
            for (int i = 0; i < 5; i++)
                for (int k = 0; k < 5; k++) temp_R[i][k] = window_R[i][k+4];
            window_cost[4] <= calc_window_cost(window_L, temp_R);


            // Pipeline Stage 4: Determine depth
            temp_mem[j] <= {get_depth(window_cost), 2'b11};

            // Pipeline Stage 5: Store result
            // temp_mem[j] <= depth_reg;
        end
    end

    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        j_next       = j;

        case (state_reg)
            IDLE: begin
                if (x_pixel[9:1] == 159) begin
                    state_next   = COMP;
                    read_en_next = 0;
                end
            end
            COMP: begin
                if (j == 159) begin
                    j_next       = 0;
                    state_next   = IDLE;
                    read_en_next = 1;
                end else begin
                    j_next     = j + 1;
                    state_next = COMP;
                end
            end
        endcase
    end



endmodule
/*
module DepthAlgorithm_window (
    input  logic        clk,
    input  logic        reset,
    input  logic        Hsync,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic [15:0] in_L,
    input  logic [15:0] in_R,
    output logic [15:0] rData
);
    localparam IDLE = 0, COMP = 1;

    logic [5:0] mem_L[0:2][0:159];
    logic [5:0] mem_R[0:2][0:159];

    logic [1:0] state_reg, state_next;
    logic read_en_reg, read_en_next;
    logic [11:0] window[4:0];
    logic [5:0] window1;
    logic [5:0] window2;
    logic [5:0] window3;
    logic [5:0] window4;
    logic [5:0] window5;
    logic [5:0] window6;
    logic [5:0] window7;
    logic [5:0] window8;
    logic [5:0] window9;
    logic [5:0] min_temp;
    logic [5:0] temp_mem[0:160-1];

    logic [7:0] j, j_next;
    logic [5:0] result;

    assign rData = temp_mem[x_pixel[9:2]];

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg   <= 0;
            read_en_reg <= 1;
            j           <= 0;
        end else begin
            state_reg   <= state_next;
            read_en_reg <= read_en_next;
            j           <= j_next;
            if (read_en_reg == 1'b1) begin
                mem_L[y_pixel[9:2]%3][x_pixel[9:2]] <= in_L[15:10];
                mem_R[y_pixel[9:2]%3][x_pixel[9:2]] <= in_R[15:10];
            end
            temp_mem[j] <= result;
        end
    end

    always_comb begin
        state_next   = state_reg;
        read_en_next = read_en_reg;
        j_next       = j;
        case (state_reg)
            IDLE: begin
                if (x_pixel >= 159) begin
                    state_next   = COMP;
                    read_en_next = 0;
                end
            end
            COMP: begin
                // i ===== y                j ======= x
                for (int i = 0; i < 5; i++) begin
                    window1 = (mem_L[0][j-1] > mem_R[0][j-1+i]) ? (mem_L[0][j-1] - mem_R[0][j-1+i]) : (mem_R[0][j-1+i] - mem_L[0][j-1]);
                    window2 = (mem_L[0][j]   > mem_R[0][j+i])   ? (mem_L[0][j]   - mem_R[0][j+i])   : (mem_R[0][j+i]   - mem_L[0][j]);
                    window3 = (mem_L[0][j+1] > mem_R[0][j+1+i]) ? (mem_L[0][j+1] - mem_R[0][j+1+i]) : (mem_R[0][j+1+i] - mem_L[0][j+1]);

                    window4 = (mem_L[1][j-1] > mem_R[1][j-1+i]) ? (mem_L[1][j-1] - mem_R[1][j-1+i]) : (mem_R[1][j-1+i] - mem_L[1][j-1]);
                    window5 = (mem_L[1][j]   > mem_R[1][j+i])   ? (mem_L[1][j]   - mem_R[1][j+i])   : (mem_R[1][j+i]   - mem_L[1][j]);
                    window6 = (mem_L[1][j+1] > mem_R[1][j+1+i]) ? (mem_L[1][j+1] - mem_R[1][j+1+i]) : (mem_R[1][j+1+i] - mem_L[1][j+1]);

                    window7 = (mem_L[2][j-1] > mem_R[2][j-1+i]) ? (mem_L[2][j-1] - mem_R[2][j-1+i]) : (mem_R[2][j-1+i] - mem_L[2][j-1]);
                    window8 = (mem_L[2][j]   > mem_R[2][j+i])   ? (mem_L[2][j]   - mem_R[2][j+i])   : (mem_R[2][j+i]   - mem_L[2][j]);
                    window9 = (mem_L[2][j+1] > mem_R[2][j+1+i]) ? (mem_L[2][j+1] - mem_R[2][j+1+i]) : (mem_R[2][j+1+i] - mem_L[2][j+1]);
                    window[i] = window1 + window2 + window3 + window4 + window5 + window6 + window7 + window8 + window9;
                end

                if (window[0] < window[1]) begin
                    if (window[0] < window[2]) begin
                        if (window[0] < window[3]) begin
                            if (window[0] < window[4]) begin
                                result = 63;
                            end else begin
                                result = 0;
                            end
                        end else begin
                            if (window[3] < window[4]) begin
                                result = 14;
                            end else begin
                                result = 0;
                            end
                        end
                    end else begin
                        if (window[2] < window[3]) begin
                            if (window[2] < window[4]) begin
                                result = 43;
                            end else begin
                                result = 0;
                            end
                        end else begin
                            if (window[3] < window[4]) begin
                                result = 14;
                            end else begin
                                result = 0;
                            end
                        end
                    end
                end else begin
                    if (window[1] < window[2]) begin
                        if (window[1] < window[3]) begin
                            if (window[1] < window[4]) begin
                                result = 27;
                            end else begin
                                result = 0;
                            end
                        end else begin
                            if (window[3] < window[4]) begin
                                result = 14;
                            end else begin
                                result = 0;
                            end
                        end
                    end else begin
                        if (window[2] < window[3]) begin
                            if (window[2] < window[4]) begin
                                result = 43;
                            end else begin
                                result = 0;
                            end
                        end else begin
                            if (window[3] < window[4]) begin
                                result = 14;
                            end else begin
                                result = 0;
                            end
                        end
                    end
                end
                if (j == 119) begin
                    j_next       = 0;
                    state_next   = IDLE;
                    read_en_next = 1;
                end else begin
                    j_next     = j + 1;
                    state_next = COMP;
                end
            end
        endcase
    end
endmodule
*/