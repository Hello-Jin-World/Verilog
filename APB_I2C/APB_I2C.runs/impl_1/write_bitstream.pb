
c
Command: %s
53*	vivadotcl22
write_bitstream -force MCU.bit2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
YReport rule limit reached: REQP-1839 rule limit reached: 20 violations have been found.%s*DRC29
 !DRC|DRC System|Rule limit reached2default:default8ZCHECK-3h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "t
.U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[28]_0.U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[28]_02default:default2default:default2�
 "|
2U_RV32I_CORE/U_DataPath/U_EXE_Reg1/ready_reg_i_2/O2U_RV32I_CORE/U_DataPath/U_EXE_Reg1/ready_reg_i_2/O2default:default2default:default2�
 "x
0U_RV32I_CORE/U_DataPath/U_EXE_Reg1/ready_reg_i_2	0U_RV32I_CORE/U_DataPath/U_EXE_Reg1/ready_reg_i_22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRARDADDR[10]$U_DataMemory/mem_reg/ADDRARDADDR[10]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[5]U_DataMemory/dataAddr[5]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[7]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[7]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRARDADDR[11]$U_DataMemory/mem_reg/ADDRARDADDR[11]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[6]U_DataMemory/dataAddr[6]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[8]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[8]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRARDADDR[12]$U_DataMemory/mem_reg/ADDRARDADDR[12]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[7]U_DataMemory/dataAddr[7]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[9]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[9]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRARDADDR[13]$U_DataMemory/mem_reg/ADDRARDADDR[13]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[8]U_DataMemory/dataAddr[8]2default:default2default:default2�
 "p
,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[10]	,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[10]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRARDADDR[14]$U_DataMemory/mem_reg/ADDRARDADDR[14]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[9]U_DataMemory/dataAddr[9]2default:default2default:default2�
 "p
,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[11]	,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[11]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRARDADDR[5]#U_DataMemory/mem_reg/ADDRARDADDR[5]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[0]U_DataMemory/dataAddr[0]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[2]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[2]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRARDADDR[6]#U_DataMemory/mem_reg/ADDRARDADDR[6]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[1]U_DataMemory/dataAddr[1]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[3]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[3]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRARDADDR[7]#U_DataMemory/mem_reg/ADDRARDADDR[7]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[2]U_DataMemory/dataAddr[2]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[4]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[4]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRARDADDR[8]#U_DataMemory/mem_reg/ADDRARDADDR[8]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[3]U_DataMemory/dataAddr[3]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[5]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[5]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRARDADDR[9]#U_DataMemory/mem_reg/ADDRARDADDR[9]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[4]U_DataMemory/dataAddr[4]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[6]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[6]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRBWRADDR[10]$U_DataMemory/mem_reg/ADDRBWRADDR[10]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[5]U_DataMemory/dataAddr[5]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[7]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[7]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRBWRADDR[11]$U_DataMemory/mem_reg/ADDRBWRADDR[11]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[6]U_DataMemory/dataAddr[6]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[8]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[8]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRBWRADDR[12]$U_DataMemory/mem_reg/ADDRBWRADDR[12]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[7]U_DataMemory/dataAddr[7]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[9]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[9]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRBWRADDR[13]$U_DataMemory/mem_reg/ADDRBWRADDR[13]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[8]U_DataMemory/dataAddr[8]2default:default2default:default2�
 "p
,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[10]	,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[10]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2v
 "`
$U_DataMemory/mem_reg/ADDRBWRADDR[14]$U_DataMemory/mem_reg/ADDRBWRADDR[14]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[9]U_DataMemory/dataAddr[9]2default:default2default:default2�
 "p
,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[11]	,U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[11]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRBWRADDR[5]#U_DataMemory/mem_reg/ADDRBWRADDR[5]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[0]U_DataMemory/dataAddr[0]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[2]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[2]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRBWRADDR[6]#U_DataMemory/mem_reg/ADDRBWRADDR[6]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[1]U_DataMemory/dataAddr[1]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[3]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[3]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRBWRADDR[7]#U_DataMemory/mem_reg/ADDRBWRADDR[7]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[2]U_DataMemory/dataAddr[2]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[4]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[4]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRBWRADDR[8]#U_DataMemory/mem_reg/ADDRBWRADDR[8]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[3]U_DataMemory/dataAddr[3]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[5]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[5]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
�
�RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
U_DataMemory/mem_reg	U_DataMemory/mem_reg2default:default2default:default2t
 "^
#U_DataMemory/mem_reg/ADDRBWRADDR[9]#U_DataMemory/mem_reg/ADDRBWRADDR[9]2default:default2default:default2^
 "H
U_DataMemory/dataAddr[4]U_DataMemory/dataAddr[4]2default:default2default:default2�
 "n
+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[6]	+U_RV32I_CORE/U_DataPath/U_EXE_Reg1/q_reg[6]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px� 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 22 Warnings2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
Z
Writing bitstream %s...
11*	bitstream2
	./MCU.bit2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a WebPACK part without a full Vivado license. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.
120*projectZ1-120h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
122default:default2
222default:default2
02default:default2
02default:defaultZ4-41h px� 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:042default:default2
00:00:082default:default2
2307.7462default:default2
445.4532default:defaultZ17-268h px� 


End Record