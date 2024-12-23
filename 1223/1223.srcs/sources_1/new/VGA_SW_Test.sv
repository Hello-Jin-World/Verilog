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
    // input  logic [3:0] sw_red,
    // input  logic [3:0] sw_green,
    // input  logic [3:0] sw_blue,
    output logic       Hsync,
    output logic       Vsync,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

    logic display_enable;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;

    VGA_Color_load_display U_VGA_Color_load_display (
        .x_pixel       (x_pixel),
        .y_pixel       (y_pixel),
        .display_enable(display_enable),
        .vgaRed        (vgaRed),
        .vgaGreen      (vgaGreen),
        .vgaBlue       (vgaBlue)
    );
    // vga_sw_data U_vga_sw_data (
    //     .sw_red        (sw_red),
    //     .sw_green      (sw_green),
    //     .sw_blue       (sw_blue),
    //     .display_enable(display_enable),
    //     .red_port      (vgaRed),
    //     .green_port    (vgaGreen),
    //     .blue_port     (vgaBlue)
    // );

    vga_controller U_vga_controller (
        .clk           (clk),
        .reset         (reset),
        .h_sync        (Hsync),
        .v_sync        (Vsync),
        .x_pixel       (x_pixel),
        .y_pixel       (y_pixel),
        .display_enable(display_enable)
    );
endmodule
