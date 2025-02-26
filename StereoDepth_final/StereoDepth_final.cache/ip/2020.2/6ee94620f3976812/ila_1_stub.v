// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Jan  8 16:32:20 2025
// Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ila_1_stub.v
// Design      : ila_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2020.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[9:0],probe1[9:0],probe2[13:0],probe3[13:0],probe4[5:0],probe5[35:0],probe6[35:0],probe7[35:0],probe8[35:0],probe9[35:0],probe10[35:0],probe11[35:0],probe12[35:0],probe13[35:0],probe14[35:0],probe15[7:0],probe16[0:0],probe17[3:0]" */;
  input clk;
  input [9:0]probe0;
  input [9:0]probe1;
  input [13:0]probe2;
  input [13:0]probe3;
  input [5:0]probe4;
  input [35:0]probe5;
  input [35:0]probe6;
  input [35:0]probe7;
  input [35:0]probe8;
  input [35:0]probe9;
  input [35:0]probe10;
  input [35:0]probe11;
  input [35:0]probe12;
  input [35:0]probe13;
  input [35:0]probe14;
  input [7:0]probe15;
  input [0:0]probe16;
  input [3:0]probe17;
endmodule
