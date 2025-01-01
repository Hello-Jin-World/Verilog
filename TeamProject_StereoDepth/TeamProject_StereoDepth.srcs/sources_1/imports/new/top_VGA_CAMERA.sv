`timescale 1ns / 1ps

module top_VGA_CAMERA (
    input  logic       clk,
    input  logic       reset,
    input  logic       gray_sw,
    // output logic [7:0] DATA_0_L,
    // inout  wire        SDA,
    // output logic       SCL,
    input  logic       start,
    output wire        SCL_L,
    output wire        SDA_L,
    output wire        SCL_R,
    output wire        SDA_R,
    // ov7670 camera input signal
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

    // vga display port
    output logic       Hsync,
    output logic       Vsync,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

    logic disp_enable;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic we1, we2;
    logic [14:0] wAddr1, wAddr2, Dis_rAddr;
    logic [15:0] wData1, wData2, buffer1, buffer2, buffer, ssd_data;
    logic qvga_en1, qvga_en2, qvga_en3;
    logic [14:0] qvga_addr1, qvga_addr2, qvga_addr3;
    logic vga_clk;
    logic sccb_L_clk;
    logic sccb_R_clk;
    logic [7:0] buffer3;

    // SCCB U_SCCB (
    //     .clk  (clk),
    //     .reset(reset),
    //     .SDA  (SDA),
    //     .SCL  (SCL)
    // );

    // image_read U_image_read (
    //     .clk      (clk),
    //     .reset    (reset),
    //     .wclk1    (ov7670_pclk1),
    //     .we1      (we1),
    //     .wAddr1   (wAddr1),
    //     .wData1   (wData1),
    //     .wclk2    (ov7670_pclk2),
    //     .we2      (we2),
    //     .wAddr2   (wAddr2),
    //     .wData2   (wData2),
    //     .VSYNC    (),
    //     .HSYNC    (),
    //     .DATA_0_L (DATA_0_L),
    //     .DATA_1_L (),
    //     .ctrl_done()
    // );

    camera_configure U_SCCB_Config_Left (
        .clk  (sccb_L_clk),
        .start(start),
        .sioc (SCL_L),
        .siod (SDA_L),
        .done ()
    );

    camera_configure U_SCCB_Config_Right (
        .clk  (sccb_R_clk),
        .start(start),
        .sioc (SCL_R),
        .siod (SDA_R),
        .done ()
    );

    clk_wiz_0 U_clk_wiz_0 (
        .vga_clk    (vga_clk),
        .ov7670_clk1(ov7670_xclk1),
        .ov7670_clk2(ov7670_xclk2),
        .sccb_L_clk (sccb_L_clk),    // output sccb_L_clk
        .sccb_R_clk (sccb_R_clk),    // output sccb_R_clk
        .reset      (reset),
        .clk        (clk)
    );


    rbt2gray U_rbt2gray (
        .color_rgb  ({buffer[15:12], buffer[10:7], buffer[4:1]}),
        .gray_sw    (gray_sw),
        .disp_enable(disp_enable),
        .gray_rgb   ({vgaRed, vgaGreen, vgaBlue})
    );

    display_mux_2x1 U_display_mux_2x1 (
        .Left_Data (buffer1),
        .Right_Data(buffer2),
        .Gray_Data ({buffer3[7:3], buffer3[7:2], buffer3[7:3]}),
        .x         (x_pixel),
        .y         (y_pixel),
        .Out_Data  (buffer)
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

    Disparity_Map U_Disparity_Map (
        .clk   (clk),
        .reset (reset),
        .wclk1 (ov7670_pclk1),
        .we1   (we1),
        .wAddr1(wAddr1),
        .wData1(wData1),
        .wclk2 (ov7670_pclk2),
        .we2   (we2),
        .wAddr2(wAddr2),
        .wData2(wData2),
        .rclk  (vga_clk),
        .oe    (qvga_en3),
        .rAddr (qvga_addr3),
        .rData (buffer3)
    );

    // frameBuffer U_FrameBufferLeft (
    //     // write side ov7670
    //     .wclk (ov7670_pclk1),
    //     .we   (we1),
    //     .wAddr(wAddr1),
    //     .wData(wData1),
    //     .rclk (vga_clk),
    //     .oe   (qvga_en1),
    //     .rAddr(qvga_addr1),
    //     .rData(buffer1)
    //     // .rData_for_SAD(rData_for_SAD1)
    // );

    // frameBuffer U_FrameBufferRight (
    //     // write side ov7670
    //     .wclk (ov7670_pclk2),
    //     .we   (we2),
    //     .wAddr(wAddr2),
    //     .wData(wData2),
    //     .rclk (vga_clk),
    //     .oe   (qvga_en2),
    //     .rAddr(qvga_addr2),
    //     .rData(buffer2)
    //     // .rData_for_SAD(rData_for_SAD2)
    // );

    // Disparity U_Disparity (
    //     .clk        (clk),
    //     .reset      (reset),
    //     .rAddr      (Dis_rAddr),
    //     .data1      (wData1),
    //     .data2      (wData2),
    //     .displayData(ssd_data)
    // );

    // frameBuffer U_FrameBufferDisparity (
    //     // write side ov7670
    //     .wclk (clk),
    //     .we   (1),
    //     .wAddr(Dis_rAddr),
    //     .wData(ssd_data),
    //     .rclk (vga_clk),
    //     .oe   (qvga_en3),
    //     .rAddr(qvga_addr3),
    //     .rData(buffer3)
    // );

    // window_sad_processor U_window_sad_processor (
    //     .clk        (clk),
    //     .reset      (reset),
    //     .left_pixel (gray_for_SAD1),
    //     .right_pixel(gray_for_SAD2),
    //     .rclk       (vga_clk),
    //     .oe         (qvga_en3),
    //     .rAddr      (qvga_addr3),
    //     .rData      (buffer3)
    // );

    qvga_addr_decoder U_qvga_addr_decoder (
        .x         (x_pixel),
        .y         (y_pixel),
        .qvga_en1  (qvga_en1),
        .qvga_addr1(qvga_addr1),
        .qvga_en2  (qvga_en2),
        .qvga_addr2(qvga_addr2),
        .qvga_en3  (qvga_en3),
        .qvga_addr3(qvga_addr3)
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
endmodule

// module line_buffer (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic        we_left,
//     input  logic [14:0] wAddr_left,
//     input  logic [15:0] wData_left,
//     input  logic        we_right,
//     input  logic [14:0] wAddr_right,
//     input  logic [15:0] wData_right,
//     input  logic        rclk,
//     input  logic        oe,
//     input  logic [14:0] rAddr,
//     output logic [15:0] rData
// );

//     logic [15:0] mem[0:160*120-1];

//     always_ff @(posedge wclk) begin
//         if (we) begin
//             mem[wAddr] <= wData;
//         end
//     end

//     localparam RW = 8'h4c, GW = 8'h96, BW = 8'h1e;


//     assign gray_left = wData_left[15:11]*RW + wData_left[10:5]*GW + wData_left[4:0]*BW;
//     assign gray_right = wData_right[15:11]*RW + wData_right[10:5]*GW + wData_right[4:0]*BW;

//     assign gray_rgb = {gray[15:12], gray[15:12], gray[15:12]};
// endmodule


module qvga_addr_decoder (
    input  logic [ 9:0] x,
    input  logic [ 9:0] y,
    output logic        qvga_en1,
    output logic [14:0] qvga_addr1,
    output logic        qvga_en2,
    output logic [14:0] qvga_addr2,
    output logic        qvga_en3,
    output logic [14:0] qvga_addr3
);

    always_comb begin
        qvga_addr1 = 0;
        qvga_en1   = 1'b0;
        qvga_addr2 = 0;
        qvga_en2   = 1'b0;
        qvga_addr3 = 0;
        qvga_en3   = 1'b0;
        if (y < 240) begin
            if (x < 320) begin
                qvga_addr1 = y[9:1] * 160 + x[9:1];
                qvga_en1   = 1'b1;
                qvga_addr2 = 0;
                qvga_en2   = 1'b0;
                qvga_addr3 = 0;
                qvga_en3   = 1'b0;
            end else begin
                qvga_addr1 = 0;
                qvga_en1   = 1'b0;
                qvga_addr2 = y[9:1] * 160 + x[9:1];
                qvga_en2   = 1'b1;
                qvga_addr3 = 0;
                qvga_en3   = 1'b0;
            end
        end else begin
            // if (x < 320) begin
            //     qvga_addr1 = 0;
            //     qvga_en1   = 1'b0;
            //     qvga_addr2 = 0;
            //     qvga_en2   = 1'b0;
            //     qvga_addr3 = y[9:1] * 160 + x[9:1];
            //     qvga_en3   = 1'b1;
            // end else begin
            qvga_addr1 = 0;
            qvga_en1   = 1'b0;
            qvga_addr2 = 0;
            qvga_en2   = 1'b0;
            qvga_addr3 = 0;
            qvga_en3   = 1'b0;
        end
    end
    // end
endmodule

module display_mux_2x1 (
    input  logic [15:0] Left_Data,
    input  logic [15:0] Right_Data,
    input  logic [15:0] Gray_Data,
    input  logic [ 9:0] x,
    input  logic [ 9:0] y,
    output logic [15:0] Out_Data
);

    always_comb begin
        if (x < 320 && y < 240) begin
            // Out_Data = {Left_Data[15:11], Left_Data[10:7], Left_Data[4:1]};
            Out_Data = Left_Data;
            // Out_Data = Gray_Data;
        end else if (x >= 320 && y < 240) begin
            // Out_Data = {Right_Data[15:11], Right_Data[10:7], Right_Data[4:1]};
            Out_Data = Right_Data;
        end else if (x < 320 && y >= 240) begin
            // Out_Data = {Right_Data[15:11], Right_Data[10:7], Right_Data[4:1]};
            Out_Data = Gray_Data;
            // Out_Data = Left_Data;
        end else begin
            Out_Data = 15'd0;
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


