// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Jan  9 15:15:25 2025
// Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_wiz_0 -prefix
//               clk_wiz_0_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(vga_clk, ov7670_xclk1, ov7670_xclk2, reset, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="vga_clk,ov7670_xclk1,ov7670_xclk2,reset,clk_in1" */;
  output vga_clk;
  output ov7670_xclk1;
  output ov7670_xclk2;
  input reset;
  input clk_in1;
endmodule
