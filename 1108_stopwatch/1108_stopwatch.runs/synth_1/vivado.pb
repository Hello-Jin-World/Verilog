
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
create_project: 2

00:00:092

00:00:102

1997.8632
83.0042
45012
8259Z17-722h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental /home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/utils_1/imports/synth_1/counter_10000.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2i
g/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/utils_1/imports/synth_1/counter_10000.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
h
Command: %s
53*	vivadotcl27
5synth_design -top counter_10000 -part xc7a35tcpg236-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xc7a35tZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xc7a35tZ17-349h px� 
D
Loading part %s157*device2
xc7a35tcpg236-1Z21-403h px� 
Z
$Part: %s does not have CEAM library.966*device2
xc7a35tcpg236-1Z21-9227h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
4Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
N
#Helper process launched with PID %s4824*oasys2
63590Z8-7075h px� 
�
%s*synth2�
�Starting RTL Elaboration : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 2788.266 ; gain = 411.629 ; free physical = 3558 ; free virtual = 7087
h px� 
�
synthesizing module '%s'%s4497*oasys2
counter_100002
 2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
238@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
button_detector2
 2s
o/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/button_detector.v2
238@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
button_detector2
 2
02
12s
o/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/button_detector.v2
238@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
	clock_div2
 2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
978@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	clock_div2
 2
02
12q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
978@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
counter_tick2
 2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
1328@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
counter_tick2
 2
02
12q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
1328@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
control_unit2
 2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
2198@Z8-6157h px� 
�
-case statement is not full and has no default155*oasys2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
2428@Z8-155h px� 
�
-case statement is not full and has no default155*oasys2q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
2638@Z8-155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
control_unit2
 2
02
12q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
2198@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
fnd_controller2
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
228@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2	
clk_div2
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
908@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2	
clk_div2
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
908@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2	
counter2
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
758@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2	
counter2
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
758@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
decoder_2x42
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1528@Z8-6157h px� 
�
default block is never used226*oasys2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1588@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
decoder_2x42
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1528@Z8-6155h px� 
�
Pwidth (%s) of port connection '%s' does not match port width (%s) of module '%s'689*oasys2
42

switch_out2
52
decoder_2x42z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
488@Z8-689h px� 
�
synthesizing module '%s'%s4497*oasys2
digit_splitter2
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1178@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
digit_splitter2
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1178@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2	
mux_4x12
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1328@Z8-6157h px� 
�
default block is never used226*oasys2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1418@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2	
mux_4x12
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1328@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
BCDtoSEG_decoder2
 2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1698@Z8-6157h px� 
�
default block is never used226*oasys2z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1768@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
BCDtoSEG_decoder2
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
1698@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
fnd_controller2
 2
02
12z
v/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/imports/new/fnd_controller.v2
228@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
counter_100002
 2
02
12q
m/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/sources_1/imports/sources_1/new/counter_10000.v2
238@Z8-6155h px� 
�
%s*synth2�
�Finished RTL Elaboration : Time (s): cpu = 00:00:07 ; elapsed = 00:00:08 . Memory (MB): peak = 2868.082 ; gain = 491.445 ; free physical = 3239 ; free virtual = 6782
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:07 ; elapsed = 00:00:08 . Memory (MB): peak = 2883.094 ; gain = 506.457 ; free physical = 3223 ; free virtual = 6767
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:07 ; elapsed = 00:00:08 . Memory (MB): peak = 2883.094 ; gain = 506.457 ; free physical = 3223 ; free virtual = 6767
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.012
00:00:00.012

2883.7772
0.0552
32112
6762Z17-722h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
Parsing XDC File [%s]
179*designutils2s
o/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/constrs_1/imports/Downloads/MY_Basys-3-Master.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2s
o/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/constrs_1/imports/Downloads/MY_Basys-3-Master.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2q
o/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.srcs/constrs_1/imports/Downloads/MY_Basys-3-Master.xdc2!
.Xil/counter_10000_propImpl.xdcZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002
00:00:00.012

3031.1522
0.0002
29912
6658Z17-722h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
 Constraint Validation Runtime : 2
00:00:00.012
00:00:00.012

3031.2852
0.0782
29892
6658Z17-722h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:15 ; elapsed = 00:00:17 . Memory (MB): peak = 3032.516 ; gain = 655.879 ; free physical = 2874 ; free virtual = 6632
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Loading part: xc7a35tcpg236-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:15 ; elapsed = 00:00:17 . Memory (MB): peak = 3040.641 ; gain = 664.004 ; free physical = 2874 ; free virtual = 6632
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:15 ; elapsed = 00:00:17 . Memory (MB): peak = 3040.676 ; gain = 664.039 ; free physical = 2874 ; free virtual = 6632
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2
control_unitZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                    STOP |                              001 |                               00
h p
x
� 
y
%s
*synth2a
_                     RUN |                              010 |                               01
h p
x
� 
y
%s
*synth2a
_                   CLEAR |                              100 |                               10
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2	
one-hot2
control_unitZ8-3354h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:16 ; elapsed = 00:00:17 . Memory (MB): peak = 3041.965 ; gain = 665.328 ; free physical = 2872 ; free virtual = 6630
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   24 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   17 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit       Adders := 1     
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               24 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               17 Bit    Registers := 3     
h p
x
� 
H
%s
*synth20
.	               10 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                8 Bit    Registers := 2     
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                2 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 6     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   24 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input    4 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   3 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   3 Input    1 Bit        Muxes := 1     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
%s
*synth2X
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:22 ; elapsed = 00:00:23 . Memory (MB): peak = 3043.645 ; gain = 667.008 ; free physical = 2858 ; free virtual = 6619
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2940 ; free virtual = 6701
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:36 ; elapsed = 00:00:37 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2916 ; free virtual = 6677
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:36 ; elapsed = 00:00:38 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2915 ; free virtual = 6676
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|      |Cell   |Count |
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|1     |BUFG   |     1|
h px� 
2
%s*synth2
|2     |CARRY4 |    41|
h px� 
2
%s*synth2
|3     |LUT1   |    14|
h px� 
2
%s*synth2
|4     |LUT2   |    94|
h px� 
2
%s*synth2
|5     |LUT3   |    73|
h px� 
2
%s*synth2
|6     |LUT4   |    63|
h px� 
2
%s*synth2
|7     |LUT5   |    49|
h px� 
2
%s*synth2
|8     |LUT6   |    79|
h px� 
2
%s*synth2
|9     |FDCE   |   113|
h px� 
2
%s*synth2
|10    |FDPE   |     1|
h px� 
2
%s*synth2
|11    |FDRE   |     2|
h px� 
2
%s*synth2
|12    |IBUF   |     4|
h px� 
2
%s*synth2
|13    |OBUF   |    12|
h px� 
2
%s*synth2
+------+-------+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
`
%s
*synth2H
FSynthesis finished with 0 errors, 0 critical warnings and 1 warnings.
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:37 ; elapsed = 00:00:38 . Memory (MB): peak = 3090.141 ; gain = 564.859 ; free physical = 2907 ; free virtual = 6668
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:39 ; elapsed = 00:00:41 . Memory (MB): peak = 3090.141 ; gain = 713.504 ; free physical = 2907 ; free virtual = 6668
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.012
00:00:00.012

3090.1412
0.0002
29062
6670Z17-722h px� 
T
-Analyzing %s Unisim elements for replacement
17*netlist2
41Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

3090.1412
0.0002
33342
7100Z17-722h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

a86cc74cZ4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
~
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
532
22
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
synth_design: 2

00:00:562

00:00:502

3090.1412

1084.5512
33322
7098Z17-722h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2

Physical2
PSS2=
;(MB): overall = 2584.499; main = 1928.860; forked = 657.424Z17-2834h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2	
Virtual2
VSS2>
<(MB): overall = 5487.305; main = 3086.457; forked = 2400.848Z17-2834h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2
00:00:00.052
00:00:00.082

3105.6212
0.3442
33322
7098Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2Y
W/home/user/project/Verilog/1108_stopwatch/1108_stopwatch.runs/synth_1/counter_10000.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2e
creport_utilization -file counter_10000_utilization_synth.rpt -pb counter_10000_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Sun Nov 10 10:20:26 2024Z17-206h px� 


End Record