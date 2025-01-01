`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/01 17:16:55
// Design Name: 
// Module Name: Disparity_Map
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


module Disparity_Map (
    input  wire         clk,
    input  wire         reset,
    input  logic        wclk1,
    input  logic        we1,
    input  logic [14:0] wAddr1,
    input  logic [15:0] wData1,
    input  logic        wclk2,
    input  logic        we2,
    input  logic [14:0] wAddr2,
    input  logic [15:0] wData2,
    input  logic        rclk,
    input  logic        oe,
    input  logic [14:0] rAddr,
    output logic [ 7:0] rData
);

    logic [7:0] mem_L[0:160*120-1];
    logic [7:0] mem_R[0:160*120-1];
    logic [7:0] disparity_map[0:160*120-1];
    logic [3:0] state_reg, state_next;
    logic [15:0] pixel_index;

    // 상태 정의
    localparam INIT = 4'b0001,
               SAD_COMPUTE = 4'b0010,
               STORE_RESULT = 4'b0100,
               DONE = 4'b1000;

    always_ff @(posedge wclk1) begin
        if (we1) begin
            mem_L[wAddr1] <= (wData1[15:11]*299 + wData1[10:5]*587 + wData1[4:0]*114) / 1000;
        end
    end

    always_ff @(posedge wclk2) begin
        if (we2) begin
            mem_R[wAddr2] <= (wData2[15:11]*299 + wData2[10:5]*587 + wData2[4:0]*114) / 1000;
        end
    end

    always_ff @(posedge rclk) begin
        if (oe) begin
            rData <= disparity_map[rAddr];
        end else begin
            rData <= 0;
        end
    end

    // SAD 계산을 위한 파라미터
    reg [15:0] sad;  // 각 픽셀에 대한 SAD 값
    reg [15:0] min_sad;  // 최소 SAD 값
    reg [7:0] best_disparity;  // 가장 적합한 disparity
    reg [7:0] grayscale1, grayscale2;  // 각 이미지의 그레이스케일 값

    // 두 이미지의 disparity 계산
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= INIT;
            pixel_index <= 0;  // 픽셀 인덱스 초기화
            // 초기화
            for (integer i = 0; i < 160 * 120; i = i + 1) begin
                disparity_map[i] <= 0;
            end
        end else begin
            state_reg <= state_next;
        end
    end

    always_comb begin
        state_next = state_reg;
        case (state_reg)
            INIT: begin
                // 초기화 후 SAD_COMPUTE 상태로 전환
                state_next = SAD_COMPUTE;
            end
            SAD_COMPUTE: begin
                // 하나의 픽셀만 처리
                if (pixel_index < 160 * 120) begin
                    grayscale1 = mem_L[pixel_index];
                    grayscale2 = mem_R[pixel_index];

                    min_sad = 16'hFFFF; // 큰 값으로 초기화 (최소값을 찾기 위함)
                    best_disparity = 0;  // 초기 disparity 값

                    // 0부터 최대 disparity 차이까지 비교
                    for (integer k = 0; k < 16; k = k + 1) begin
                        sad = 0;  // SAD 초기화
                        // 두 이미지의 차이 계산
                        for (integer l = 0; l < 7; l = l + 1) begin
                            sad = sad + (grayscale1 > grayscale2 ? grayscale1 - grayscale2 : grayscale2 - grayscale1);
                        end

                        // 최소 SAD 값을 찾음
                        if (sad < min_sad) begin
                            min_sad = sad;
                            best_disparity = k;
                        end
                    end

                    // 결과 저장을 위해 STORE_RESULT 상태로 전환
                    state_next = STORE_RESULT;
                end else begin
                    state_next = DONE;  // 모든 픽셀을 처리한 후 DONE 상태로
                end
            end
            STORE_RESULT: begin
                // 계산된 disparity 값을 disparity_map에 저장
                disparity_map[pixel_index] <= best_disparity;

                // 다음 픽셀로 이동
                pixel_index <= pixel_index + 1;

                // 다시 SAD_COMPUTE 상태로 돌아가 계산을 계속
                state_next = SAD_COMPUTE;
            end
            DONE: begin
                // 모든 계산이 끝나면 종료
                state_next = INIT;  // 초기화 상태로 돌아감
            end
        endcase
    end
endmodule
