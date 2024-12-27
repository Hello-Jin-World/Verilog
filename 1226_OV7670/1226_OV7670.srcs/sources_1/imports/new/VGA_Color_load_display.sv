`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 16:10:47
// Design Name: 
// Module Name: VGA_Color_load_display
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


module VGA_Color_load_display (
    input  logic [9:0] x_pixel,
    input  logic [9:0] y_pixel,
    input  logic       display_enable,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);
    localparam H_Visible_area = 640;
    localparam H_Front_porch = 16;
    localparam H_Sync_pulse = 96;
    localparam H_Back_porch = 48;
    localparam H_Whole_line = 800;
    localparam V_Visible_area = 480;
    localparam V_Front_porch = 10;
    localparam V_Sync_pulse = 2;
    localparam V_Back_porch = 33;
    localparam V_Whole_frame = 525;

    always_comb begin
        if (display_enable) begin
            if (y_pixel >= 0 && y_pixel < V_Visible_area - 160) begin
                if (x_pixel > H_Visible_area - 91 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 15;
                end else if (x_pixel > H_Visible_area - 91 * 2 && x_pixel >= 0) begin
                    vgaRed   = 15;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 91 * 3 && x_pixel >= 0) begin
                    vgaRed   = 13;
                    vgaGreen = 5;
                    vgaBlue  = 12;
                end else if (x_pixel > H_Visible_area - 91 * 4 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 15;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 91 * 5 && x_pixel >= 0) begin
                    vgaRed   = 11;
                    vgaGreen = 15;
                    vgaBlue  = 14;
                end else if (x_pixel > H_Visible_area - 91 * 6 && x_pixel >= 0) begin
                    vgaRed   = 15;
                    vgaGreen = 14;
                    vgaBlue  = 3;
                end else if (x_pixel > H_Visible_area - 91 * 7 && x_pixel >= 0) begin
                    vgaRed   = 12;
                    vgaGreen = 12;
                    vgaBlue  = 12;
                end else begin
                    vgaRed   = 4'b0000;
                    vgaGreen = 4'b0000;
                    vgaBlue  = 4'b0000;
                end
            end else if (y_pixel >= 0 && y_pixel < V_Visible_area - 120) begin
                if (x_pixel > H_Visible_area - 91 && x_pixel >= 0) begin
                    vgaRed   = 11;
                    vgaGreen = 11;
                    vgaBlue  = 11;
                end else if (x_pixel > H_Visible_area - 91 * 2 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 91 * 3 && x_pixel >= 0) begin
                    vgaRed   = 11;
                    vgaGreen = 15;
                    vgaBlue  = 14;
                end else if (x_pixel > H_Visible_area - 91 * 4 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 91 * 5 && x_pixel >= 0) begin
                    vgaRed   = 13;
                    vgaGreen = 5;
                    vgaBlue  = 12;
                end else if (x_pixel > H_Visible_area - 91 * 6 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 91 * 7 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 15;
                end else begin
                    vgaRed   = 4'b0000;
                    vgaGreen = 4'b0000;
                    vgaBlue  = 4'b0000;
                end
            end else begin
                if (x_pixel > H_Visible_area - 107 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 107 * 2 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 107 * 3 && x_pixel >= 0) begin
                    vgaRed   = 0;
                    vgaGreen = 0;
                    vgaBlue  = 0;
                end else if (x_pixel > H_Visible_area - 107 * 4 && x_pixel >= 0) begin
                    vgaRed   = 4;
                    vgaGreen = 5;
                    vgaBlue  = 8;
                end else if (x_pixel > H_Visible_area - 107 * 5 && x_pixel >= 0) begin
                    vgaRed   = 15;
                    vgaGreen = 15;
                    vgaBlue  = 15;
                end else if (x_pixel > H_Visible_area - 107 * 5 && x_pixel >= 0) begin
                    vgaRed   = 1;
                    vgaGreen = 2;
                    vgaBlue  = 5;
                end else begin
                    vgaRed   = 4'b0000;
                    vgaGreen = 4'b0000;
                    vgaBlue  = 4'b0000;
                end
            end
        end else begin
            vgaRed   = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue  = 4'b0000;
        end
    end

endmodule
