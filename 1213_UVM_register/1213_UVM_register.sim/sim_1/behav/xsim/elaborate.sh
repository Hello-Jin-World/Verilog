#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Fri Dec 13 16:56:13 KST 2024
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 5ba04a6971bd4edb9704cd07eba91c4b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_uvm_register_behav xil_defaultlib.tb_uvm_register xil_defaultlib.glbl -log elaborate.log -L uvm"
xelab -wto 5ba04a6971bd4edb9704cd07eba91c4b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_uvm_register_behav xil_defaultlib.tb_uvm_register xil_defaultlib.glbl -log elaborate.log -L uvm

