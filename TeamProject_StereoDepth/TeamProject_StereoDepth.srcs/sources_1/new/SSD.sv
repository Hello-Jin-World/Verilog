`timescale 1ns / 1ps

module disparity_map_rgb565_to_grayscale(
    input wire clk,
    input wire rst,
        input wire [15:0] img1 [0:159][0:119], // 첫 번째 160x120 이미지 (RGB565)
    input wire [15:0] img2 [0:159][0:119], // 두 번째 160x120 이미지 (RGB565)
    output reg [7:0] disparity_map [0:159][0:119] // disparity 맵 출력
);

    // SAD 계산을 위한 파라미터
    integer i, j, k, l;
    reg [15:0] sad; // 각 픽셀에 대한 SAD 값
    reg [15:0] min_sad; // 최소 SAD 값
    reg [7:0] best_disparity; // 가장 적합한 disparity
    reg [7:0] grayscale1, grayscale2; // 각 이미지의 그레이스케일 값
    reg [4:0] r1, g1, b1, r2, g2, b2; // RGB565에서 추출된 R, G, B 값

    // RGB565에서 R, G, B 값을 추출하는 함수
    function [4:0] extract_r(input [15:0] rgb);
        begin
            extract_r = rgb[15:11]; // 상위 5비트
        end
    endfunction

    function [5:0] extract_g(input [15:0] rgb);
        begin
            extract_g = rgb[10:5]; // 중간 6비트
        end
    endfunction

    function [4:0] extract_b(input [15:0] rgb);
        begin
            extract_b = rgb[4:0]; // 하위 5비트
        end
    endfunction

    // RGB565에서 그레이스케일로 변환하는 함수
    function [7:0] rgb_to_grayscale(input [15:0] rgb);
        reg [7:0] grayscale;
        begin
            // RGB565에서 R, G, B 값 추출
            r1 = extract_r(rgb);
            g1 = extract_g(rgb);
            b1 = extract_b(rgb);

            // RGB를 그레이스케일로 변환 (R * 0.299 + G * 0.587 + B * 0.114)
            grayscale = (r1 * 299 + g1 * 587 + b1 * 114) / 1000;
            rgb_to_grayscale = grayscale;
        end
    endfunction

    // 두 이미지의 disparity 계산
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 초기화
            for (i = 0; i < 160; i = i + 1) begin
                for (j = 0; j < 120; j = j + 1) begin
                    disparity_map[i][j] <= 0;
                end
            end
        end else begin
            // 각 픽셀에 대해 disparity 계산
            for (i = 0; i < 160; i = i + 1) begin
                for (j = 0; j < 120; j = j + 1) begin
                    // 첫 번째 이미지의 그레이스케일 값 계산
                    grayscale1 = rgb_to_grayscale(img1[i][j]);
                    // 두 번째 이미지의 그레이스케일 값 계산
                    grayscale2 = rgb_to_grayscale(img2[i][j]);

                    min_sad = 16'hFFFF; // 큰 값으로 초기화 (최소값을 찾기 위함)
                    best_disparity = 0; // 초기 disparity 값

                    // 0부터 최대 disparity 차이까지 비교
                    for (k = 0; k < 16; k = k + 1) begin
                        if (i + k < 160) begin
                            sad = 0; // SAD 초기화

                            // 두 이미지의 차이 계산
                            for (l = 0; l < 7; l = l + 1) begin
                                sad = sad + abs(grayscale1 - grayscale2);
                            end

                            // 최소 SAD 값을 찾음
                            if (sad < min_sad) begin
                                min_sad = sad;
                                best_disparity = k;
                            end
                        end
                    end

                    // 최종 disparity 맵에 저장
                    disparity_map[i][j] <= best_disparity;
                end
            end
        end
    end

    // 절댓값 계산 함수
    function [15:0] abs(input [15:0] val);
        begin
            if (val[15] == 1) begin
                abs = -val;
            end else begin
                abs = val;
            end
        end
    endfunction

endmodule

// module image_read #(
//     parameter WIDTH = 160,  // Image width
//     HEIGHT = 120,  // Image height
//     START_UP_DELAY = 100,  // Delay during start up time
//     HSYNC_DELAY = 160  // Delay between HSYNC pulses	
// ) (
//     input               clk,       // clock					
//     input               reset,     // Reset (active low)
//     // write side_L
//     input  logic        wclk1,
//     input  logic        we1,
//     input  logic [14:0] wAddr1,
//     input  logic [15:0] wData1,
//     // write side_R
//     input  logic        wclk2,
//     input  logic        we2,
//     input  logic [14:0] wAddr2,
//     input  logic [15:0] wData2,
//     /////////////
//     output              VSYNC,     // Vertical synchronous pulse
//     // This signal is often a way to indicate that one entire image is transmitted.
//     // Just create and is not used, will be used once a video or many images are transmitted.
//     output reg          HSYNC,     // Horizontal synchronous pulse
//     // An HSYNC indicates that one line of the image is transmitted.
//     // Used to be a horizontal synchronous signals for writing bmp file.
//     output logic [ 7:0] DATA_0_L,  // 8 bit Red data (even)
//     output logic [ 7:0] DATA_1_L,  // 8 bit Green data (even)
//     // Process and transmit 2 pixels in parallel to make the process faster, you can modify to transmit 1 pixels or more if needed
//     output              ctrl_done  // Done flag
// );

//     logic        start;
//     logic [15:0] mem_L [0:160*120-1];
//     logic [15:0] mem_R [0:160*120-1];

//     always_ff @(posedge wclk1) begin
//         if (we1) begin
//             mem_L[wAddr1] <= wData1;
//         end
//         if (wAddr1 == 160 * 120 - 1) begin
//             start <= 1;
//         end else begin
//             start <= 0;
//         end
//     end
//     always_ff @(posedge wclk2) begin
//         if (we2) begin
//             mem_R[wAddr2] <= wData2;
//         end
//     end

//     //-------------------------------------------------
//     // Internal Signals
//     //-------------------------------------------------

//     // local parameters for FSM
//     localparam ST_IDLE = 2'b00,  // idle state
//     ST_VSYNC = 2'b01,  // state for creating vsync 
//     ST_HSYNC = 2'b10,  // state for creating hsync 
//     ST_DATA = 2'b11;  // state for data processing 
//     reg [1:0]
//         cstate,  // current state
//         nstate;  // next state			
//     reg HRESETn_d;  // delayed reset signal: use to create start signal
//     reg ctrl_vsync_run;  // control signal for vsync counter  
//     reg [8:0] ctrl_vsync_cnt;  // counter for vsync
//     reg ctrl_hsync_run;  // control signal for hsync counter
//     reg [8:0] ctrl_hsync_cnt;  // counter  for hsync
//     reg ctrl_data_run;  // control signal for data processing

//     reg [8:0] row;  // row index of the image
//     reg [8:0] col;  // column index of the Left image
//     integer window = 7;
//     integer x, y;  // column index of the Right image
//     reg [4:0] offset, best_offset, best_offset_1;
//     localparam [4:0] maxoffset = 10; // Maximum extent where to look for the same pixel
//     reg offsetfound;
//     reg offsetping;
//     reg compare, SSD_calc;
//     reg [20:0] ssd, ssd_1;  // sum of squared difference
//     reg [20:0] prev_ssd, prev_ssd_1;
//     reg [18:0] data_count;  // data counting for entire pixels of the image

//     //-----------------------------------------//
//     //--------- State Transition --------------//
//     //-----------------------------------------//
//     // IDLE . VSYNC . HSYNC . DATA
//     always @(*) begin
//         case (cstate)
//             ST_IDLE: begin
//                 if (start) nstate = ST_VSYNC;
//                 else nstate = ST_IDLE;
//             end
//             ST_VSYNC: begin
//                 if (ctrl_vsync_cnt == START_UP_DELAY) nstate = ST_HSYNC;
//                 else nstate = ST_VSYNC;
//             end
//             ST_HSYNC: begin
//                 if (ctrl_hsync_cnt == HSYNC_DELAY) nstate = ST_DATA;
//                 else nstate = ST_HSYNC;
//             end
//             ST_DATA: begin
//                 if (ctrl_done) nstate = ST_IDLE;
//                 else begin
//                     if (col == WIDTH - 2) nstate = ST_HSYNC;
//                     else nstate = ST_DATA;
//                 end
//             end
//         endcase
//     end
//     // ------------------------------------------------------------------- //
//     // --- counting for time period of vsync, hsync, data processing ----  //
//     // ------------------------------------------------------------------- //
//     always @(*) begin
//         ctrl_vsync_run = 0;
//         ctrl_hsync_run = 0;
//         ctrl_data_run  = 0;
//         case (cstate)
//             ST_VSYNC: begin
//                 ctrl_vsync_run = 1;
//             end  // trigger counting for vsync
//             ST_HSYNC: begin
//                 ctrl_hsync_run = 1;
//             end  // trigger counting for hsync
//             ST_DATA: begin
//                 ctrl_data_run = 1;
//             end  // trigger counting for data processing
//         endcase
//     end
//     // counters for vsync, hsync
//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             ctrl_vsync_cnt <= 0;
//             ctrl_hsync_cnt <= 0;
//         end else begin
//             if (ctrl_vsync_run)
//                 ctrl_vsync_cnt <= ctrl_vsync_cnt + 1;  // counting for vsync
//             else ctrl_vsync_cnt <= 0;

//             if (ctrl_hsync_run)
//                 ctrl_hsync_cnt <= ctrl_hsync_cnt + 1;  // counting for hsync		
//             else ctrl_hsync_cnt <= 0;
//         end
//     end
//     // counting column and row index  for reading memory 
//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             row <= 0;
//             col <= 0;
//             offset <= 4;
//             offsetping <= 0;
//             compare <= 0;

//         end else begin

//             if (ctrl_data_run) begin  //& offsetping==0 & compare==0
//                 if (offsetfound == 1) begin  //& offsetping==0
//                     if (col == WIDTH - 2) begin
//                         col <= 0;
//                         row <= row + 1;
//                         //data_count<=data_count+"1";
//                     end else begin
//                         col <= col + 2;
//                         //data_count <= data_count + 1;
//                     end
//                     offsetfound   <= 0;
//                     best_offset   <= 0;
//                     prev_ssd      <= 65535;
//                     best_offset_1 <= 0;
//                     prev_ssd_1    <= 65535;
//                     offset        <= 4;
//                 end else begin
//                     if (offset == maxoffset) begin
//                         offsetfound <= 1;
//                     end else begin
//                         offset <= offset + 1;
//                         //x<=0;
//                         //y<=0;
//                     end

//                     offsetping <= 1;
//                 end

//                 if (ssd < prev_ssd & SSD_calc==1) begin //& SSD_calc==1 & offsetping==1
//                     prev_ssd <= ssd;
//                     best_offset <= offset;
//                     //$display("ssd %d prev_ssd %d  offset %d x %d y %d ",ssd,prev_ssd,offset,x,y);
//                 end

//                 if (ssd_1 < prev_ssd_1  & SSD_calc==1) begin //& SSD_calc==1 & offsetping ==1
//                     prev_ssd_1 <= ssd_1;
//                     best_offset_1 <= offset;
//                 end
//                 if (SSD_calc == 1) begin
//                     offsetping <= 0;
//                 end
//             end
//         end
//     end

//     always @(posedge offsetfound) begin
//         DATA_0_L = best_offset * (255 / maxoffset);
//         DATA_1_L = best_offset_1 * (255 / maxoffset);
//         //DATA_0_L=(mem_L[WIDTH * row + col  ]+mem_R[WIDTH * row + col  ])/2 ;
//         //DATA_1_L =(mem_L[WIDTH * row + col+1  ]+mem_R[WIDTH * row + col+1  ])/2;
//     end
//     //-------------------------------------------------//
//     //----------------Data counting---------- ---------//
//     //-------------------------------------------------//
//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             data_count <= 0;
//         end else begin
//             if (ctrl_data_run) begin

//                 data_count <= data_count + 1;

//             end
//         end
//     end
//     assign VSYNC = ctrl_vsync_run;
//     assign ctrl_done = (data_count == 308487) ? 1'b1 : 1'b0;  // done flag308472
//     //-------------------------------------------------//
//     //-------------  Image processing   ---------------//
//     //-------------------------------------------------//
//     always @(*) begin

//         HSYNC = 1'b0;
//         DATA_0_L = 0;
//         DATA_1_L = 0;
//         // DATA_0_R = 0;
//         // DATA_1_R = 0;

//         if (ctrl_data_run) begin
//             if (offsetfound) HSYNC = 1'b1;
//             else HSYNC = 1'b0;

//         end
//     end


//     always @(posedge clk) begin
//         SSD_calc <= 0;
//         if (offsetping == 1) begin

//             for (x = -(window - 1) / 2; x < ((window - 1) / 2); x = x + 1) begin
//                 for (
//                     y = -(window - 1) / 2; y < ((window - 1) / 2); y = y + 1
//                 ) begin
//                     ssd  <=(mem_L[(row + x ) * WIDTH + col + y   ]-mem_R[(row + x ) * WIDTH + col + y -offset])*(mem_L[(row +  x ) * WIDTH + col + y   ]-mem_R[(row +  x ) * WIDTH + col + y - offset]);
//                     ssd_1<=(mem_L[(row + x ) * WIDTH + col + y  + 1 ]-mem_R[(row + x ) * WIDTH + col + y -offset + 1 ])*(mem_L[(row +  x ) * WIDTH + col + y  + 1 ]-mem_R[(row +  x ) * WIDTH + col + y - offset + 1 ]);
//                 end
//             end
//             SSD_calc <= 1;
//         end else begin
//             ssd   <= 0;
//             ssd_1 <= 0;
//         end
//     end
//     //end





// endmodule
