`timescale 1ns / 1ps

module VGA_OV7670_Test (
    input  logic       clk,
    input  logic       reset,
    input  logic       gray_sw,
    // ov7670 camera input signal
    output logic       ov7670_xclk,
    input  logic       ov7670_pclk,
    input  logic       ov7670_href,
    input  logic       ov7670_v_sync,
    input  logic [7:0] ov7670_data,
    // vga display port
    output logic       h_sync,
    output logic       v_sync,
    output logic [3:0] red_port,
    output logic [3:0] green_port,
    output logic [3:0] blue_port


);

    logic disp_enable;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic we;
    logic [16:0] wAddr, before_upscale_addr;
    logic [15:0] wData, buffer, before_upscale;
    logic qvga_en;
    logic [16:0] qvga_addr;
    logic vga_clk;

    // assign red_port   = (disp_enable) ? buffer[15:12] : 0;
    // assign green_port = (disp_enable) ? buffer[10:7] : 0;
    // assign blue_port  = (disp_enable) ? buffer[4:1] : 0;
    // assign red_port   = buffer[15:12];
    // assign green_port = buffer[10:7];
    // assign blue_port  = buffer[4:1];

    rbt2gray U_rbt2gray (
        .color_rgb  ({buffer[15:12], buffer[10:7], buffer[4:1]}),
        .gray_sw    (gray_sw),
        .disp_enable(disp_enable),
        .gray_rgb   ({red_port, green_port, blue_port})
    );

    clk_wiz_0 U_clk_wiz (
        .vga_clk   (vga_clk),
        .ov7670_clk(ov7670_xclk),
        .reset     (reset),
        .clk       (clk)
    );

    vga_controller U_VGA_Controller (
        .clk        (vga_clk),
        .reset      (reset),
        .h_sync     (h_sync),
        .v_sync     (v_sync),
        .x_pixel    (x_pixel),
        .y_pixel    (y_pixel),
        .disp_enable(disp_enable)
    );

    ISP U_ISP (
        .clk    (clk),
        .reset  (reset),
        .x      (x_pixel),
        .y      (y_pixel),
        .h_sync (h_sync),
        .v_sync (v_sync),
        .RGBdata(before_upscale),
        .addr   (before_upscale_addr),
        .rclk   (vga_clk),
        .oe     (gvga_en),
        .rData  (buffer)
    );

    qvga_addr_decoder U_QVGA_Decoder (
        .x        (x_pixel),
        .y        (y_pixel),
        .qvga_en  (qvga_en),
        .qvga_addr(qvga_addr)
    );

    frameBuffer U_FrameBuffer (
        // write side ov7670
        .wclk (ov7670_pclk),
        .we   (we),
        .wAddr(wAddr),
        .wData(wData),
        .rclk (clk),
        .oe   (1),
        .rAddr(before_upscale_addr),
        .rData(before_upscale)
    );

    ov7670_SetData U_OV7670_SetData (
        .pclk       (ov7670_pclk),
        .reset      (reset),
        .href       (ov7670_href),
        .v_sync     (ov7670_v_sync),
        .ov7670_data(ov7670_data),
        .we         (we),
        .wAddr      (wAddr),
        .wData      (wData)
    );

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

module qvga_addr_decoder (
    input  logic [ 9:0] x,
    input  logic [ 9:0] y,
    output logic        qvga_en,
    output logic [16:0] qvga_addr
);


    always_comb begin
        if (x < 640 && y < 480) begin
            // qvga_addr = y[9:2] * 160 + x[9:2];
            qvga_addr = y[9:1] * 320 + x[9:1];
            // qvga_addr = y * 640 + x;
            qvga_en   = 1'b1;
        end else begin
            qvga_addr = 0;
            qvga_en   = 1'b0;
        end
    end
endmodule


//module mux (
//    input  logic        sel,
//    input  logic [11:0] x0,
//    input  logic [11:0] x1,
//    output logic [11:0] y
//);
//    always_comb begin
//        case (sel)
//            1'b0: y = x0;
//            1'b1: y = x1;
//        endcase
//    end
//endmodule
