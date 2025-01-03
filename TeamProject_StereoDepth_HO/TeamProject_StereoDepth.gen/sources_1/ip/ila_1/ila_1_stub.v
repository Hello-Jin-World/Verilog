// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Jan  3 21:07:50 2025
// Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/GitHub/verilog/Verilog/TeamProject_StereoDepth_HO/TeamProject_StereoDepth.gen/sources_1/ip/ila_1/ila_1_stub.v
// Design      : ila_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2020.2" *)
module ila_1(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[9:0],probe2[15:0],probe3[15:0],probe4[5:0],probe5[15:0],probe6[15:0],probe7[1:0],probe8[0:0],probe9[5:0],probe10[5:0],probe11[5:0],probe12[5:0],probe13[5:0],probe14[5:0],probe15[5:0]" */;
  input clk;
  input [0:0]probe0;
  input [9:0]probe1;
  input [15:0]probe2;
  input [15:0]probe3;
  input [5:0]probe4;
  input [15:0]probe5;
  input [15:0]probe6;
  input [1:0]probe7;
  input [0:0]probe8;
  input [5:0]probe9;
  input [5:0]probe10;
  input [5:0]probe11;
  input [5:0]probe12;
  input [5:0]probe13;
  input [5:0]probe14;
  input [5:0]probe15;
endmodule
