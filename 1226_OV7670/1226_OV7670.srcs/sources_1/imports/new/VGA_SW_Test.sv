`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 15:03:39
// Design Name: 
// Module Name: VGA_SW_Test
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


module VGA_SW_Test (
    input  logic       clk,
    input  logic       reset,
    // ov7670 signal
    output logic       ov7670_xclk,
    input  logic       ov7670_pclk,
    input  logic       ov7670_href,
    input  logic       ov7670_v_sync,
    input  logic [7:0] ov7670_data,
    // vag display port
    output logic       Hsync,
    output logic       Vsync,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
    // input  logic       RGB_sel,
    // input  logic       gray_sel,
    // input  logic [3:0] bright_dark,
    // input  logic [2:0] vga_out_sel,
    // input  logic [3:0] sw_red,
    // input  logic [3:0] sw_green,
    // input  logic [3:0] sw_blue,
);

    logic        display_enable;
    logic [ 9:0] x_pixel;
    logic [ 9:0] y_pixel;
    logic        vga_clk;
    logic [16:0] wAddr;
    logic [15:0] wData;
    logic        we;
    logic [16:0] rAddr;
    logic [15:0] rData;
    logic        qvga_en;
    logic [15:0] buffer;

    // assign vgaRed   = buffer[15:12];
    // assign vgaGreen = buffer[10:7];
    // assign vgaBlue  = buffer[4:1];

    clk_wiz_0 U_clk_wiz_0 (
        .vga_clk   (vga_clk),      // output vga_clk
        .ov7670_clk(ov7670_xclk),  // output ov7670_clk
        .reset     (reset),        // input reset
        .clk_in1   (clk)
    );

    ov7670_SetData U_ov7670_SetData (
        .pclk       (ov7670_pclk),
        .reset      (reset),
        .href       (ov7670_href),
        .v_sync     (ov7670_v_sync),
        .ov7670_data(ov7670_data),
        .we         (we),
        .wAddr      (wAddr),
        .wData      (wData)
    );

    FrameBuffer U_FrameBuffer_320x240 (
        // write side ov7670
        .wclk (ov7670_pclk),
        .we   (we),
        .wAddr(wAddr),
        .wData(wData),
        // read side vga
        .rclk (vga_clk),
        .oe   (qvga_en),
        .rAddr(rAddr),
        .rData(buffer)
    );

    RGB_Conv U_RGB_Conv (
        .RGB_16bit     (buffer),
        .display_enable(display_enable),
        .vgaRed        (vgaRed),
        .vgaGreen      (vgaGreen),
        .vgaBlue       (vgaBlue)
    );

    vga_controller U_vga_controller (
        .clk           (vga_clk),
        .reset         (reset),
        .h_sync        (Hsync),
        .v_sync        (Vsync),
        .x_pixel       (x_pixel),
        .y_pixel       (y_pixel),
        .display_enable(display_enable)
    );

    qvga_addr_decoder U_qvga_addr_decoder (
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .addr   (rAddr),
        .we     (qvga_en)
    );
    // logic [ 3:0] colorbar_vgaRed;
    // logic [ 3:0] colorbar_vgaGreen;
    // logic [ 3:0] colorbar_vgaBlue;
    // logic [ 3:0] sw_vgaRed;
    // logic [ 3:0] sw_vgaGreen;
    // logic [ 3:0] sw_vgaBlue;
    // logic [ 3:0] photo_vgaRed;
    // logic [ 3:0] photo_vgaGreen;
    // logic [ 3:0] photo_vgaBlue;
    // logic [ 3:0] pre_photo_vgaRed;
    // logic [ 3:0] pre_photo_vgaGreen;
    // logic [ 3:0] pre_photo_vgaBlue;
    // logic        sw;
    // logic [16:0] addr;
    // logic [15:0] lenna_data;
    // logic [ 3:0] gray_vgaRed;
    // logic [ 3:0] gray_vgaGreen;
    // logic [ 3:0] gray_vgaBlue;
    // logic [11:0] red_rgb;
    // logic [11:0] green_rgb;
    // logic [11:0] blue_rgb;
    // logic [11:0] bright_rgb;
    // logic [11:0] dark_rgb;

    // mux_final U_mux_final (
    //     .colorbar    ({colorbar_vgaRed, colorbar_vgaGreen, colorbar_vgaBlue}),
    //     .color_image ({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .gray_image  (gray_rgb),
    //     .red_image   (red_rgb),
    //     .green_image (green_rgb),
    //     .blue_image  (blue_rgb),
    //     .bright_image(bright_rgb),
    //     .dark_image  (dark_rgb),
    //     .vga_out_sel (vga_out_sel),
    //     .vgaRGB      ({vgaRed, vgaGreen, vgaBlue})
    // );

    // rbt2gray U_rbt2gray (
    //     .color_rgb({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .gray_rgb (gray_rgb)
    // );

    // image_red U_image_red (
    //     .color_rgb({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .red_rgb  (red_rgb)
    // );

    // image_green U_image_green (
    //     .color_rgb({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .green_rgb(green_rgb)
    // );

    // image_blue U_image_blue (
    //     .color_rgb({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .blue_rgb (blue_rgb)
    // );

    // image_bright U_image_bright (
    //     .color_rgb ({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .bright_W  (bright_dark),
    //     .bright_rgb(bright_rgb)
    // );

    // image_dark U_image_dark (
    //     .color_rgb({photo_vgaRed, photo_vgaGreen, photo_vgaBlue}),
    //     .dark_W   (bright_dark),
    //     .dark_rgb (dark_rgb)
    // );

    // mux_6x3 U_RGB_out_mux (
    //     .in0_vgaRed  (4'b0000),
    //     .in0_vgaGreen(4'b0000),
    //     .in0_vgaBlue (4'b0000),
    //     .in1_vgaRed  (pre_photo_vgaRed),
    //     .in1_vgaGreen(pre_photo_vgaGreen),
    //     .in1_vgaBlue (pre_photo_vgaBlue),
    //     .RGB_sel     (sw),
    //     .o_vgaRed    (photo_vgaRed),
    //     .o_vgaGreen  (photo_vgaGreen),
    //     .o_vgaBlue   (photo_vgaBlue)
    // );

    // VGA_Color_load_display U_VGA_Color_load_display (
    //     .x_pixel       (x_pixel),
    //     .y_pixel       (y_pixel),
    //     .display_enable(display_enable),
    //     .vgaRed        (colorbar_vgaRed),
    //     .vgaGreen      (colorbar_vgaGreen),
    //     .vgaBlue       (colorbar_vgaBlue)
    // );

    // vga_sw_data U_vga_sw_data (
    //     .sw_red        (sw_red),
    //     .sw_green      (sw_green),
    //     .sw_blue       (sw_blue),
    //     .display_enable(display_enable),
    //     .red_port      (sw_vgaRed),
    //     .green_port    (sw_vgaGreen),
    //     .blue_port     (sw_vgaBlue)
    // );

    // qvga_addr_decoder U_addr_comparator (
    //     .x_pixel(x_pixel),
    //     .y_pixel(y_pixel),
    //     .addr   (addr),
    //     .sw     (sw)
    // );

    // rom_lenna U_rom_lenna (
    //     .addr(addr),
    //     .data(lenna_data)
    // );

    // RGB_Conv U_RGB_Conv (
    //     .RGB_16bit     (lenna_data),
    //     .display_enable(display_enable),
    //     .vgaRed        (pre_photo_vgaRed),
    //     .vgaGreen      (pre_photo_vgaGreen),
    //     .vgaBlue       (pre_photo_vgaBlue)
    // );
endmodule

module mux_final (
    input  logic [11:0] colorbar,
    input  logic [11:0] color_image,
    input  logic [11:0] gray_image,
    input  logic [11:0] red_image,
    input  logic [11:0] green_image,
    input  logic [11:0] blue_image,
    input  logic [11:0] bright_image,
    input  logic [11:0] dark_image,
    input  logic [ 2:0] vga_out_sel,
    output logic [11:0] vgaRGB
);

    always_comb begin
        case (vga_out_sel)
            0: begin
                vgaRGB = colorbar;
            end
            1: begin
                vgaRGB = color_image;
            end
            2: begin
                vgaRGB = gray_image;
            end
            3: begin
                vgaRGB = red_image;
            end
            4: begin
                vgaRGB = green_image;
            end
            5: begin
                vgaRGB = blue_image;
            end
            6: begin
                vgaRGB = bright_image;
            end
            7: begin
                vgaRGB = dark_image;
            end
        endcase
    end

endmodule

module image_red (
    input  logic [11:0] color_rgb,
    output logic [11:0] red_rgb
);


    assign red_rgb = {color_rgb[11:8], color_rgb[11:8], color_rgb[11:8]};
endmodule

module image_green (
    input  logic [11:0] color_rgb,
    output logic [11:0] green_rgb
);


    assign green_rgb = {color_rgb[7:4], color_rgb[7:4], color_rgb[7:4]};
endmodule

module image_blue (
    input  logic [11:0] color_rgb,
    output logic [11:0] blue_rgb
);


    assign blue_rgb = {blue_rgb[3:0], color_rgb[3:0], color_rgb[3:0]};
endmodule

module image_bright (
    input  logic [11:0] color_rgb,
    input  logic [ 3:0] bright_W,
    output logic [11:0] bright_rgb
);


    assign bright_rgb = {
        color_rgb[11:8] + bright_W,
        color_rgb[7:4] + bright_W,
        color_rgb[3:0] + bright_W
    };
endmodule

module image_dark (
    input  logic [11:0] color_rgb,
    input  logic [ 3:0] dark_W,
    output logic [11:0] dark_rgb
);


    assign dark_rgb = {
        color_rgb[11:8] - dark_W,
        color_rgb[7:4] - dark_W,
        color_rgb[3:0] - dark_W
    };
endmodule

module rbt2gray (
    input  logic [11:0] color_rgb,
    output logic [11:0] gray_rgb
);

    localparam RW = 8'h47, GW = 8'h96, BW = 8'h1d;

    logic [11:0] gray;

    assign gray = color_rgb[11:8]*RW + color_rgb[7:4]*GW + color_rgb[3:0]*BW;

    assign gray_rgb = {gray[11:8], gray[11:8], gray[11:8]};
endmodule

module qvga_addr_decoder (
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    output logic [16:0] addr,
    output logic        we
);
    always_comb begin
        if (x_pixel < 320 && y_pixel < 240) begin
            addr = (y_pixel * 320) + x_pixel;
            we   = 1;
            // end else if (x_pixel >= 320 && y_pixel < 240) begin
            //     addr = (y_pixel * 320) + x_pixel;
            //     we   = 1;
        end else begin
            addr = 17'bx;
            we   = 0;
        end
    end
endmodule

// module rom_lenna (
//     input  logic [16:0] addr,
//     output logic [15:0] data
// );
//     logic [15:0] rom[0:76800 - 1];

//     initial begin
//         $readmemh("phaka.mem", rom);
//     end

//     assign data = rom[addr];
// endmodule

module RGB_Conv (
    input  logic [15:0] RGB_16bit,
    input  logic        display_enable,
    output logic [ 3:0] vgaRed,
    output logic [ 3:0] vgaGreen,
    output logic [ 3:0] vgaBlue
);

    assign vgaRed   = (display_enable) ? RGB_16bit[15:12] : 4'b0000;
    assign vgaGreen = (display_enable) ? RGB_16bit[10:7] : 4'b0000;
    assign vgaBlue  = (display_enable) ? RGB_16bit[4:1] : 4'b0000;
endmodule

module mux_6x3 (
    input  logic [3:0] in0_vgaRed,
    input  logic [3:0] in0_vgaGreen,
    input  logic [3:0] in0_vgaBlue,
    input  logic [3:0] in1_vgaRed,
    input  logic [3:0] in1_vgaGreen,
    input  logic [3:0] in1_vgaBlue,
    input  logic       RGB_sel,
    output logic [3:0] o_vgaRed,
    output logic [3:0] o_vgaGreen,
    output logic [3:0] o_vgaBlue
);

    assign o_vgaRed   = (RGB_sel) ? in1_vgaRed : in0_vgaRed;
    assign o_vgaGreen = (RGB_sel) ? in1_vgaGreen : in0_vgaGreen;
    assign o_vgaBlue  = (RGB_sel) ? in1_vgaBlue : in0_vgaBlue;
endmodule
