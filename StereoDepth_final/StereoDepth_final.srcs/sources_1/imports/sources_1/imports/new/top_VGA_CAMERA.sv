`timescale 1ns / 1ps



module top_VGA_CAMERA (
    input  logic       clk,
    input  logic       reset,
    input  logic       gray_sw,
    // input  logic       start,
    // output wire        SCL_L,
    // output wire        SDA_L,
    // output wire        SCL_R,
    // output wire        SDA_R,
    output logic       SCL_L,
    inout  wire        SDA_L,
    output logic       SCL_R,
    inout  wire        SDA_R,
    // ov7670 camera input signals
    output logic       ov7670_xclk1,
    input  logic       ov7670_pclk1,
    input  logic       ov7670_href1,
    input  logic       ov7670_v_sync1,
    input  logic [7:0] ov7670_data1,

    output logic       ov7670_xclk2,
    input  logic       ov7670_pclk2,
    input  logic       ov7670_href2,
    input  logic       ov7670_v_sync2,
    input  logic [7:0] ov7670_data2,

    // VGA display output
    output logic       Hsync,
    output logic       Vsync,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

    // Internal signals
    logic disp_enable;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic we1, we2;
    logic [14:0] wAddr1, wAddr2;
    logic [15:0] wData1, wData2, buffer1, buffer2, buffer;
    logic qvga_en1, qvga_en2, qvga_en3;
    logic [14:0] qvga_addr1, qvga_addr2, qvga_addr3;
    logic vga_clk, clk_200;
    logic [5:0] buffer3;

    // logic [15:0] rData_for_SAD1;
    // logic [15:0] rData_for_SAD2;
    // logic [11:0] gray_for_SAD1;
    // logic [11:0] gray_for_SAD2;
    logic [15:0] gray_rgb_L, gray_rgb_R;

    // Disparity signal
    logic [15:0] depth_out;
    // assign vgaRed   = (disp_enable) ? depth_out[15:12] : 0;
    // assign vgaGreen = (disp_enable) ? depth_out[10:7] : 0;
    // assign vgaBlue  = (disp_enable) ? depth_out[4:1] : 0;

    clk_wiz_0 U_clk_gene (
        // Clock out ports
        .vga_clk(vga_clk),     // output vga_clk
        .ov7670_xclk1(ov7670_xclk1),     // output ov7670_xclk1
        .ov7670_xclk2(ov7670_xclk2),     // output ov7670_xclk2
        // Status and control signals
        .reset(reset), // input reset
        // Clock in ports
        .clk_in1(clk)
    );  // input clk_in1

    rbt2gray U_rbt2gray (
        .color_rgb  ({depth_out[15:12], depth_out[10:7], depth_out[4:1]}),
        .gray_sw    (gray_sw),
        .disp_enable(disp_enable),
        .gray_rgb   ({vgaRed, vgaGreen, vgaBlue})
    );

    top_SCCB U_top_SCCB_L (
        .clk  (clk),
        .reset(reset),
        .sda  (SDA_L),
        .scl  (SCL_L)
    );
    top_SCCB U_top_SCCB_R (
        .clk  (clk),
        .reset(reset),
        .sda  (SDA_R),
        .scl  (SCL_R)
    );

    // SCCB_final U_SCCB_final_L (
    //     .clk  (clk),
    //     .reset(reset),
    //     .scl  (SCL_L),
    //     .sda  (SDA_L)
    // );
    // SCCB_final U_SCCB_final_R (
    //     .clk  (clk),
    //     .reset(reset),
    //     .scl  (SCL_R),
    //     .sda  (SDA_R)
    // );

    // camera_configure U_SCCB_Config_Left (
    //     .clk  (sccb_L_clk),
    //     .start(start),
    //     .sioc (SCL_L),
    //     .siod (SDA_L),
    //     .done ()
    // );

    // camera_configure U_SCCB_Config_Right (
    //     .clk  (sccb_R_clk),
    //     .start(start),
    //     .sioc (SCL_R),
    //     .siod (SDA_R),
    //     .done ()
    // );

    display_mux_2x1 U_display_mux_2x1 (
        .Left_Data(buffer1),
        .Right_Data(buffer2),
        .Disparity_Data({buffer3[5:1], buffer3, buffer3[5:1]}),
        .x(x_pixel),
        .y(y_pixel),
        .Out_Data(depth_out)
    );

    ov7670_SetData U_OV7670_SetDataLeft (
        .pclk       (ov7670_pclk1),
        .reset      (reset),
        .href       (ov7670_href1),
        .v_sync     (ov7670_v_sync1),
        .ov7670_data(ov7670_data1),
        .we         (we1),
        .wAddr      (wAddr1),
        .wData      (wData1)
    );

    ov7670_SetData U_OV7670_SetDataRight (
        .pclk       (ov7670_pclk2),
        .reset      (reset),
        .href       (ov7670_href2),
        .v_sync     (ov7670_v_sync2),
        .ov7670_data(ov7670_data2),
        .we         (we2),
        .wAddr      (wAddr2),
        .wData      (wData2)
    );


    frameBuffer U_FrameBufferLeft (
        // write side ov7670
        .wclk (ov7670_pclk1),
        .we   (we1),
        .wAddr(wAddr1),
        .wData(wData1),
        .rclk (vga_clk),
        .oe   (qvga_en1),
        .rAddr(qvga_addr1),
        .rData(buffer1)
    );

    frameBuffer U_FrameBufferRight (
        // write side ov7670
        .wclk (ov7670_pclk2),
        .we   (we2),
        .wAddr(wAddr2),
        .wData(wData2),
        .rclk (vga_clk),
        .oe   (qvga_en2),
        .rAddr(qvga_addr2),
        .rData(buffer2)
    );

    qvga_addr_decoder U_qvga_addr_decoder (
        .x         (x_pixel),
        .y         (y_pixel),
        .qvga_en1  (qvga_en1),
        .qvga_addr1(qvga_addr1),
        .qvga_en2  (qvga_en2),
        .qvga_addr2(qvga_addr2)
        // .qvga_en3  (qvga_en3),
        // .qvga_addr3(qvga_addr3)
    );

    vga_controller U_vga_controller (
        .clk        (vga_clk),
        .reset      (reset),
        .h_sync     (Hsync),
        .v_sync     (Vsync),
        .x_pixel    (x_pixel),
        .y_pixel    (y_pixel),
        .disp_enable(disp_enable)
    );

    rgb2gray U_rgb2gray_L (
        .color_rgb(buffer1),
        .gray_rgb (gray_rgb_L)
    );
    rgb2gray U_rgb2gray_R (
        .color_rgb(buffer2),
        .gray_rgb (gray_rgb_R)
    );

    // disparity_pipeline U_disparity_pipeline (
    //     .clk    (clk),
    //     .reset  (reset),
    //     .Hsync  (Hsync),
    //     .in_L   (gray_rgb_L),
    //     .in_R   (gray_rgb_R),
    //     .x_pixel(x_pixel),
    //     .rData  (buffer3)
    // );

    DepthAlgorithm_window U_DepthAlgorithm_window (
        //DepthAlgorithm U_DepthAlgorithm (
        // disparity_generator_1x1 U_disparity_generator (
        // disparity_generator U_disparity_generator (
        .clk    (clk),
        .reset  (reset),
        .Hsync  (Hsync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .in_L   (gray_rgb_R),
        .in_R   (gray_rgb_L),
        .rData  (buffer3)
    );
    // disparity_generator U_disparity_generator_hahahah (
    //     .clk   (clk),
    //     .reset (reset),
    //     .wclk1 (ov7670_pclk1),
    //     .we1   (we1),
    //     .wAddr1(wAddr1),
    //     .wData1(wData1),
    //     .wclk2 (ov7670_pclk2),
    //     .we2   (we2),
    //     .wAddr2(wAddr2),
    //     .wData2(wData2),
    //     .rclk (vga_clk),
    //     .oe   (qvga_en3),
    //     .rAddr(qvga_addr3),
    //     .rData(buffer3)
    // );


endmodule

module qvga_addr_decoder (
    input  logic [ 9:0] x,
    input  logic [ 9:0] y,
    output logic        qvga_en1,
    output logic [14:0] qvga_addr1,
    output logic        qvga_en2,
    output logic [14:0] qvga_addr2
    // output logic        qvga_en3,
    // output logic [14:0] qvga_addr3
);


    //     qvga_addr1 = 0;
    //     qvga_en1   = 1'b0;
    //     qvga_addr2 = 0;
    //     qvga_en2   = 1'b0;
    //     qvga_addr3 = 0;
    //     qvga_en3   = 1'b0;
    //     if (x < 640 && y < 480) begin
    //         qvga_addr1 = 0;
    //         qvga_en1   = 1'b0;
    //         qvga_addr2 = 0;
    //         qvga_en2   = 1'b0;
    //         qvga_addr3 = y[9:2] * 160 + x[9:2];
    //         qvga_en3   = 1'b1;
    //     end else begin
    //         qvga_addr1 = 0;
    //         qvga_en1   = 1'b0;
    //         qvga_addr2 = 0;
    //         qvga_en2   = 1'b0;
    //         qvga_addr3 = 0;
    //         qvga_en3   = 1'b0;
    //     end
    always_comb begin
        if (y < 240) begin
            if (x >= 320) begin
                qvga_addr1 = y[9:1] * 160 + x[9:1];
                qvga_en1   = 1'b1;
                // qvga_addr2 = y[9:1] * 160 + x[9:1];
                // qvga_en2   = 1'b1;
                // qvga_addr1 = y[9:1] * 160 + x[9:1];
                // qvga_en1   = 1'b1;
                qvga_addr2 = 0;
                qvga_en2   = 1'b0;
                // qvga_addr3 = 0;
                // qvga_en3   = 1'b0;
            end else begin
                // qvga_addr1 = y[9:1] * 160 + x[9:1];
                // qvga_en1   = 1'b1;
                qvga_addr2 = y[9:1] * 160 + x[9:1];
                qvga_en2   = 1'b1;
                qvga_addr1 = 0;
                qvga_en1   = 1'b0;
                // qvga_addr2 = y[9:1] * 160 + x[9:1];
                // qvga_en2   = 1'b1;
                // qvga_addr3 = 0;
                // qvga_en3   = 1'b0;
            end
        end else begin
            if (x < 320) begin
                // qvga_addr1 = x[9:1];
                // qvga_en1   = 1'b1;
                // qvga_addr2 = x[9:1];
                // qvga_en2   = 1'b1;
                qvga_addr1 = (y[9:1] - 120) * 160 + x[9:1];
                qvga_en1   = 1'b1;
                qvga_addr2 = (y[9:1] - 120) * 160 + x[9:1];
                qvga_en2   = 1'b1;
                // qvga_addr1 = 0;
                // qvga_en1   = 1'b0;
                // qvga_addr2 = 0;
                // qvga_en2   = 1'b0;
                // qvga_addr3 = x[9:1];
                // qvga_addr3 = y[9:1] * 160 + x[9:1];
                // qvga_en3   = 1'b1;
                // qvga_addr1 = 0;
                // qvga_en1   = 1'b0;
                // qvga_addr2 = 0;
                // qvga_en2   = 1'b0;
            end else begin
                qvga_addr1 = 0;
                qvga_en1   = 1'b0;
                qvga_addr2 = 0;
                qvga_en2   = 1'b0;
                // qvga_addr3 = 0;
                // qvga_en3   = 1'b0;
            end
        end
    end
endmodule



module display_mux_2x1 (
    input logic [15:0] Left_Data,
    input logic [15:0] Right_Data,
    input logic [15:0] Disparity_Data,  // Added for disparity output
    input logic [9:0] x,
    input logic [9:0] y,
    input logic qvga_en3,  // Added input for enabling disparity region
    output logic [15:0] Out_Data
);

    // always_comb begin
    //     if (x < 640 && y < 480) begin
    //         Out_Data = Disparity_Data;
    //     end else begin
    //         Out_Data = 16'd0;
    //     end
    // end

    always_comb begin
        if (x < 320 && y < 240) begin
            Out_Data = Right_Data;
        end else if (x >= 320 && y < 240) begin
            Out_Data = Left_Data;
        end else if (x < 320 && y >= 240) begin
            Out_Data = Disparity_Data;
        end else begin
            Out_Data = 16'd0;
        end
    end

endmodule


module rbt2gray (
    input  logic [11:0] color_rgb,
    input  logic        gray_sw,
    input  logic        disp_enable,
    output logic [11:0] gray_rgb
);

    localparam RW = 8'h4c, GW = 8'h96, BW = 8'h1e;

    logic [11:0] gray;

    assign gray = color_rgb[11:8]*RW + color_rgb[7:4]*GW + color_rgb[3:0]*BW;
    // assign gray = (76*color_rgb[11:8] + 150*color_rgb[7:4] + 30*color_rgb[3:0]) / 256;

    assign gray_rgb = (disp_enable) ? ((gray_sw) ? {gray[11:8], gray[11:8], gray[11:8]} : color_rgb) : 12'd0;
endmodule

module rgb2gray (
    input  logic [15:0] color_rgb,
    output logic [15:0] gray_rgb
);

    localparam RW = 8'h4c, GW = 8'h96, BW = 8'h1e;

    logic [14:0] gray;

    assign gray = color_rgb[15:11]*RW + color_rgb[10:5]*GW + color_rgb[4:0]*BW;

    assign gray_rgb = {gray[14:10], gray[14:9], gray[14:10]};
endmodule




