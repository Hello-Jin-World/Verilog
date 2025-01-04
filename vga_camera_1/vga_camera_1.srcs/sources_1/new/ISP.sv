
// `timescale 1ns / 1ps

// // module ISP_line_buf (
// //     input  logic        clk,
// //     input  logic        reset,
// //     input  logic [ 9:0] x,
// //     input  logic [ 9:0] y,
// //     input  logic        h_sync,
// //     input  logic        v_sync,
// //     // Before upscale data
// //     input  logic [15:0] camera_data,
// //     output logic        we,
// //     output logic [16:0] wAddr,
// //     // VGA out port
// //     input  logic        rclk,
// //     input  logic        re,
// //     input  logic [16:0] rAddr,
// //     output logic [15:0] rData
// // );
// //     assign wAddr = i_reg[9:1];

// //     logic [15:0] upscale_mem[0:640-1];
// //     logic [15:0] temp_reg, temp_next;
// //     logic [2:0] state_reg, state_next;
// //     logic [9:0] i_reg, i_next;
// //     logic vga_out_en_reg, vga_out_en_next;

// //     always_ff @(posedge clk, posedge reset) begin
// //         if (reset) begin
// //             temp_reg       <= 0;
// //             i_reg          <= 0;
// //             state_reg      <= 0;
// //             vga_out_en_reg <= 0;
// //             we             <= 0;
// //         end else begin
// //             temp_reg       <= temp_next;
// //             i_reg          <= i_next;
// //             state_reg      <= state_next;
// //             vga_out_en_reg <= vga_out_en_next;
// //         end
// //     end

// //     always_comb begin
// //         state_next = state_reg;
// //         case (state_reg)
// //             0: begin
// //                 we = 1;
// //                 if (i_reg >= 640-1) begin
// //                     state_next = 2;
// //                 end else begin
// //                     temp_next = camera_data;
// //                     if (temp_reg != temp_next) begin
// //                         state_next = 1;
// //                     end
// //                 end
// //             end
// //             1: begin
// //                 we = 0;
// //                 upscale_mem[i_reg] = temp_reg;
// //                 if (i_reg > 1) begin
// //                     upscale_mem[i_reg-1] = (upscale_mem[i_reg-2] + temp_reg) / 2;
// //                 end
// //                 i_next = i_reg + 2;
// //                 state_next = 0;
// //             end
// //             2: begin
// //                 vga_out_en_next = 1;
// //                 state_next      = 0;
// //                 i_next          = 0;
// //                 temp_next       = 0;
// //             end
// //         endcase
// //     end

// //     always_ff @(posedge rclk) begin
// //         // if (vga_out_en_reg && re) begin
// //         if (re) begin
// //             rData <= upscale_mem[rAddr];
// //         end
// //         // if (rAddr >= 640) begin
// //         //     vga_out_en_next <= 0;
// //         // end
// //     end
// // endmodule

// module ISP (
//     input  logic        clk,
//     input  logic        reset,
//     input  logic [ 9:0] x,
//     input  logic [ 9:0] y,
//     input  logic        h_sync,
//     // Before upscale data
//     output logic [16:0] addr,
//     output logic        en,
//     input  logic [15:0] RGBdata,
//     // VGA out port
//     input  logic        rclk,
//     // input  logic        oe,
//     output logic [15:0] rData
// );

//     logic state_reg, state_next;
//     logic [11:0] video_mem[0:640-1];
//     logic [9:0] i_reg, i_next;
//     // logic [15:0] video_copy[0:640-1];
//     logic [15:0] video_reg, video_next;
//     logic [15:0] prv_video_reg, prv_video_next;
//     // logic [3:0] R_video_reg, R_video_next;
//     // logic [3:0] R_prv_video_reg, R_prv_video_next;
//     // logic [3:0] G_video_reg, G_video_next;
//     // logic [3:0] G_prv_video_reg, G_prv_video_next;
//     // logic [3:0] B_video_reg, B_video_next;
//     // logic [3:0] B_prv_video_reg, B_prv_video_next;
//     // logic [3:0] R_aver, G_aver, B_aver;

//     // logic [15:0] rData_reg, rData_next;

//     // always_ff @(posedge rclk) begin
//     //     // rData_reg <= rData_next;
//     //     if (oe) begin
//     //         // rData <= (y[0]) ? video_mem[x] : video_copy[x];
//     //         rData <= video_mem[x];
//     //     end else begin
//     //         rData <= 0;
//     //     end
//     // end
//     always_ff @(posedge rclk) begin
//         if (x < 640 && y < 480) begin
//             rData <= video_mem[x];
//         end else begin
//             rData <= 0;
//         end
//     end
//     always_comb begin
//         if (x < 640 && y < 480) begin
//             addr = x[9:1] + 320 * y[9:1];
//             en   = 1;
//         end else begin
//             addr = 0;
//             en   = 0;
//         end
//     end

//     always_ff @(posedge clk, posedge reset) begin
//         if (reset) begin
//             i_reg         <= 0;
//             video_reg     <= 0;
//             prv_video_reg <= 0;
//             state_reg     <= 0;
//             // R_prv_video_reg <= 0;
//             // R_video_reg     <= 0;
//             // G_prv_video_reg <= 0;
//             // G_video_reg     <= 0;
//             // B_prv_video_reg <= 0;
//             // B_video_reg     <= 0;
//             // R_aver          <= 0;
//             // G_aver          <= 0;
//             // B_aver          <= 0;
//         end else begin
//             i_reg         <= i_next;
//             video_reg     <= video_next;
//             prv_video_reg <= prv_video_next;
//             state_reg     <= state_next;
//             // R_video_reg     <= R_video_next;
//             // R_prv_video_reg <= R_prv_video_next;
//             // G_video_reg     <= G_video_next;
//             // G_prv_video_reg <= G_prv_video_next;
//             // B_video_reg     <= B_video_next;
//             // B_prv_video_reg <= B_prv_video_next;
//         end
//     end
     
//     always_comb begin
//         i_next         = i_reg;
//         video_next     = video_reg;
//         prv_video_next = prv_video_reg;
//         state_next     = state_reg;
//         case (state_reg)
//             0: begin
//                 if (video_reg != video_next) begin
//                     state_next = 1;
//                 end else begin
//                 video_next     = RGBdata;
//                 prv_video_next = video_reg;
//                 end
//             end
//             1: begin
//                 if (i_reg >= 640 - 1) begin
//                     if (!h_sync) begin
//                         i_next = 0;
//                         state_next = 0;
//                     end
//                 end else begin
//                     video_mem[i_reg] = video_reg;
//                     i_next = i_reg + 2;
//                     if (i_reg > 1) begin
//                         video_mem[i_reg-1] = (video_reg + prv_video_reg) / 2;
//                     end
//                     state_next = 0;
//                 end
//             end
//         endcase
//     end

//     // always_comb begin
//     //     i_next           = i_reg;
//     //     R_video_next     = R_video_reg;
//     //     R_prv_video_next = R_prv_video_reg;
//     //     G_video_next     = G_video_reg;
//     //     G_prv_video_next = G_prv_video_reg;
//     //     B_video_next     = B_video_reg;
//     //     B_prv_video_next = B_prv_video_reg;
//     //     state_next       = state_reg;
//     //     case (state_reg)
//     //         0: begin
//     //             R_video_next     = RGBdata[15:12];
//     //             R_prv_video_next = R_video_reg;
//     //             G_video_next     = RGBdata[10:7];
//     //             G_prv_video_next = G_video_reg;
//     //             B_video_next     = RGBdata[4:1];
//     //             B_prv_video_next = B_video_reg;
//     //             if (R_video_reg != R_video_next && G_video_reg != G_video_next && B_video_reg != B_video_next
//     //                 ) begin
//     //                 state_next = 1;
//     //             end
//     //         end
//     //         1: begin
//     //             if (i_reg >= 640 - 1) begin
//     //                 if (!h_sync) begin
//     //                     i_next = 0;
//     //                     state_next = 0;
//     //                 end
//     //             end else begin
//     //                 video_mem[i_reg] = {R_video_reg, G_video_reg, B_video_reg};
//     //                 i_next = i_reg + 2;
//     //                 if (i_reg > 1) begin
//     //                     R_aver = (R_video_reg + R_prv_video_reg) / 2;
//     //                     G_aver = (G_video_reg + G_prv_video_reg) / 2;
//     //                     B_aver = (B_video_reg + B_prv_video_reg) / 2;
//     //                     video_mem[i_reg-1] = {R_aver, G_aver, B_aver};
//     //                 end
//     //                 state_next = 0;
//     //             end
//     //         end
//     //     endcase
//     // end

//     // always_comb begin
//     //     i_next = i_reg;
//     //     // if (!h_sync) begin
//     //     if (i_reg >= 640 - 1) begin
//     //         i_next     = 0;
//     //         // video_copy = video_mem;
//     //     end else begin
//     //         if (video_reg != RGBdata) begin
//     //             video_mem[i_reg] = video_reg;
//     //             i_next = i_reg + 2;
//     //             // video_mem[i_reg+1] = (video_reg + RGBdata) / 2;
//     //             video_mem[i_reg+1] = {
//     //                 (video_reg[15:12] + RGBdata[15:12]) / 2,
//     //                 (video_reg[10:7] + RGBdata[10:7]) / 2,
//     //                 (video_reg[4:1] + RGBdata[4:1]) / 2
//     //             };
//     //         end
//     //     end
//     // end

// endmodule
