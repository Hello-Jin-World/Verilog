vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -sv "+incdir+../../../../TeamProject_StereoDepth.gen/sources_1/ip/ila_0/hdl/verilog" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../TeamProject_StereoDepth.gen/sources_1/ip/ila_0/hdl/verilog" \
"../../../../TeamProject_StereoDepth.gen/sources_1/ip/ila_0/sim/ila_0.v" \


vlog -work xil_defaultlib \
"glbl.v"
