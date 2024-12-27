set_property SRC_FILE_INFO {cfile:d:/GitHub/verilog/Verilog/1226_OV7670/1226_OV7670.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../../../1226_OV7670.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:U_clk_wiz_0/inst} [current_design]
set_property SRC_FILE_INFO {cfile:D:/GitHub/verilog/Verilog/1226_OV7670/1226_OV7670.srcs/constrs_1/imports/Downloads/MY_Basys-3-Master.xdc rfile:../../../1226_OV7670.srcs/constrs_1/imports/Downloads/MY_Basys-3-Master.xdc id:2} [current_design]
current_instance U_clk_wiz_0/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
current_instance
set_property src_info {type:XDC file:2 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_34 ,Sch=CLK100MHZ
set_property src_info {type:XDC file:2 line:71 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L18N_T2_A11_D27_14 ,Sch=BTNC
set_property src_info {type:XDC file:2 line:92 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A14  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[0] }]; #IO_L6P_T0_16       ,Sch=JB1
set_property src_info {type:XDC file:2 line:93 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A16  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[2] }]; #IO_L12P_T1_MRCC_16 ,Sch=JB2
set_property src_info {type:XDC file:2 line:94 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B15  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[4] }]; #IO_L11N_T1_SRCC_16 ,Sch=JB3
set_property src_info {type:XDC file:2 line:95 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B16  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[6] }]; #IO_L13N_T2_MRCC_16 ,Sch=JB4
set_property src_info {type:XDC file:2 line:96 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A15  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[1] }]; #IO_L6N_T0_VREF_16  ,Sch=JB7
set_property src_info {type:XDC file:2 line:97 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A17  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[3] }]; #IO_L12N_T1_MRCC_16 ,Sch=JB8
set_property src_info {type:XDC file:2 line:98 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C15  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[5] }]; #IO_L11P_T1_SRCC_16 ,Sch=JB9
set_property src_info {type:XDC file:2 line:99 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C16  IOSTANDARD LVCMOS33 } [get_ports { ov7670_data[7] }]; #IO_L13P_T2_MRCC_16 ,Sch=JB10
set_property src_info {type:XDC file:2 line:104 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33 } [get_ports { ov7670_xclk }]; #IO_L12N_T1_MRCC_14 ,Sch=JC1
set_property src_info {type:XDC file:2 line:105 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33 } [get_ports { ov7670_href }]; #IO_L11P_T1_SRCC_14 ,Sch=JC2
set_property src_info {type:XDC file:2 line:108 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L17  IOSTANDARD LVCMOS33 } [get_ports { ov7670_pclk }]; #IO_L12P_T1_MRCC_14 ,Sch=JC7
set_property src_info {type:XDC file:2 line:109 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports { ov7670_v_sync }]; #IO_L11N_T1_SRCC_14 ,Sch=JC8
set_property src_info {type:XDC file:2 line:128 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G19  IOSTANDARD LVCMOS33 } [get_ports { vgaRed[0]   }]; #IO_L4N_T0_D05_14      ,Sch=VGA_R0
set_property src_info {type:XDC file:2 line:129 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H19  IOSTANDARD LVCMOS33 } [get_ports { vgaRed[1]   }]; #IO_L4P_T0_D04_14      ,Sch=VGA_R1
set_property src_info {type:XDC file:2 line:130 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J19  IOSTANDARD LVCMOS33 } [get_ports { vgaRed[2]   }]; #IO_L6N_T0_D08_VREF_14 ,Sch=VGA_R2
set_property src_info {type:XDC file:2 line:131 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N19  IOSTANDARD LVCMOS33 } [get_ports { vgaRed[3]   }]; #IO_L9N_T1_DQS_D13_14  ,Sch=VGA_R3
set_property src_info {type:XDC file:2 line:132 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N18  IOSTANDARD LVCMOS33 } [get_ports { vgaBlue[0]  }]; #IO_L9P_T1_DQS_14      ,Sch=VGA_B0
set_property src_info {type:XDC file:2 line:133 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33 } [get_ports { vgaBlue[1]  }]; #IO_L8P_T1_D11_14      ,Sch=VGA_B1
set_property src_info {type:XDC file:2 line:134 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K18  IOSTANDARD LVCMOS33 } [get_ports { vgaBlue[2]  }]; #IO_L8N_T1_D12_14      ,Sch=VGA_B2
set_property src_info {type:XDC file:2 line:135 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J18  IOSTANDARD LVCMOS33 } [get_ports { vgaBlue[3]  }]; #IO_L7N_T1_D10_14      ,Sch=VGA_B3
set_property src_info {type:XDC file:2 line:136 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33 } [get_ports { vgaGreen[0] }]; #IO_L7P_T1_D09_14      ,Sch=VGA_G0
set_property src_info {type:XDC file:2 line:137 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H17  IOSTANDARD LVCMOS33 } [get_ports { vgaGreen[1] }]; #IO_L5P_T0_D06_14      ,Sch=VGA_G1
set_property src_info {type:XDC file:2 line:138 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G17  IOSTANDARD LVCMOS33 } [get_ports { vgaGreen[2] }]; #IO_L5N_T0_D07_14      ,Sch=VGA_G2
set_property src_info {type:XDC file:2 line:139 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D17  IOSTANDARD LVCMOS33 } [get_ports { vgaGreen[3] }]; #IO_0_14               ,Sch=VGA_G3
set_property src_info {type:XDC file:2 line:140 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN P19  IOSTANDARD LVCMOS33 } [get_ports { Hsync       }]; #IO_L10P_T1_D14_14     ,Sch=VGA_HS
set_property src_info {type:XDC file:2 line:141 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R19  IOSTANDARD LVCMOS33 } [get_ports { Vsync       }]; #IO_L10N_T1_D15_14     ,Sch=VGA_VS
