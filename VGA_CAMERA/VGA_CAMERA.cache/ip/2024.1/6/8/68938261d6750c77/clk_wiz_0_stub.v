// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
// Date        : Sat Dec 28 13:25:42 2024
// Host        : 8ca0394867cd running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(vga_clk, ov7670_clk, reset, clk)
/* synthesis syn_black_box black_box_pad_pin="reset,clk" */
/* synthesis syn_force_seq_prim="vga_clk" */
/* synthesis syn_force_seq_prim="ov7670_clk" */;
  output vga_clk /* synthesis syn_isclock = 1 */;
  output ov7670_clk /* synthesis syn_isclock = 1 */;
  input reset;
  input clk;
endmodule
