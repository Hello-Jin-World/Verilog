// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Jan  1 12:23:59 2025
// Host        : DESKTOP-PFRE25G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(vga_clk, ov7670_clk1, ov7670_clk2, sccb_clk, 
  reset, clk)
/* synthesis syn_black_box black_box_pad_pin="vga_clk,ov7670_clk1,ov7670_clk2,sccb_clk,reset,clk" */;
  output vga_clk;
  output ov7670_clk1;
  output ov7670_clk2;
  output sccb_clk;
  input reset;
  input clk;
endmodule
