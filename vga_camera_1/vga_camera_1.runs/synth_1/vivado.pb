
{
Command: %s
53*	vivadotcl2J
6synth_design -top top_VGA_CAMERA -part xc7a35tcpg236-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-349h px� 
V
Loading part %s157*device2#
xc7a35tcpg236-12default:defaultZ21-403h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
`
#Helper process launched with PID %s4824*oasys2
169082default:defaultZ8-7075h px� 
�
%s*synth2�
wStarting RTL Elaboration : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1110.781 ; gain = 6.430
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2"
top_VGA_CAMERA2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/top_VGA_CAMERA.sv2default:default2
32default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
rbt2gray2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/top_VGA_CAMERA.sv2default:default2
1402default:default8@Z8-6157h px� 
Q
%s
*synth29
%	Parameter RW bound to: 8'b01001100 
2default:defaulth p
x
� 
Q
%s
*synth29
%	Parameter GW bound to: 8'b10010110 
2default:defaulth p
x
� 
Q
%s
*synth29
%	Parameter BW bound to: 8'b00011110 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
rbt2gray2default:default2
 2default:default2
12default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/top_VGA_CAMERA.sv2default:default2
1402default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
	clk_wiz_02default:default2
 2default:default2�
sD:/Verilog/Verilog/vga_camera_1/vga_camera_1.runs/synth_1/.Xil/Vivado-568-DESKTOP-PFRE25G/realtime/clk_wiz_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	clk_wiz_02default:default2
 2default:default2
22default:default2
12default:default2�
sD:/Verilog/Verilog/vga_camera_1/vga_camera_1.runs/synth_1/.Xil/Vivado-568-DESKTOP-PFRE25G/realtime/clk_wiz_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2"
vga_controller2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
32default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2!
pixel_counter2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
622default:default8@Z8-6157h px� 
`
%s
*synth2H
4	Parameter H_PIX_MAX bound to: 800 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter V_LINE_MAX bound to: 525 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2!
pixel_counter2default:default2
 2default:default2
32default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
622default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
vga_decoder2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
342default:default8@Z8-6157h px� 
e
%s
*synth2M
9	Parameter H_Visible_area bound to: 640 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter H_Front_porch bound to: 16 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter H_Sync_pulse bound to: 96 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter H_Back_porch bound to: 48 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter H_Whole_line bound to: 800 - type: integer 
2default:defaulth p
x
� 
e
%s
*synth2M
9	Parameter V_Visible_area bound to: 480 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter V_Front_porch bound to: 10 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter V_Sync_pulse bound to: 2 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter V_Back_porch bound to: 33 - type: integer 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter V_Whole_frame bound to: 525 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
vga_decoder2default:default2
 2default:default2
42default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
342default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
vga_controller2default:default2
 2default:default2
52default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/vga_controller.sv2default:default2
32default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
ISP2default:default2
 2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
872default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ISP2default:default2
 2default:default2
62default:default2
12default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
872default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
frameBuffer2default:default2
 2default:default2d
ND:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/FrameBuffer.sv2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
frameBuffer2default:default2
 2default:default2
72default:default2
12default:default2d
ND:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/FrameBuffer.sv2default:default2
52default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2"
ov7670_SetData2default:default2
 2default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ov7670_SetData.sv2default:default2
32default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
ov7670_SetData2default:default2
 2default:default2
82default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ov7670_SetData.sv2default:default2
32default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
top_VGA_CAMERA2default:default2
 2default:default2
92default:default2
12default:default2g
QD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/top_VGA_CAMERA.sv2default:default2
32default:default8@Z8-6155h px� 
�
%s*synth2�
yFinished RTL Elaboration : Time (s): cpu = 00:00:09 ; elapsed = 00:00:09 . Memory (MB): peak = 1309.445 ; gain = 205.094
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:10 ; elapsed = 00:00:11 . Memory (MB): peak = 1309.445 ; gain = 205.094
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:10 ; elapsed = 00:00:11 . Memory (MB): peak = 1309.445 ; gain = 205.094
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:012default:default2 
00:00:00.2332default:default2
1309.4452default:default2
0.0002default:defaultZ17-268h px� 
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
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
jd:/Verilog/Verilog/vga_camera_1/vga_camera_1.gen/sources_1/ip/clk_wiz_0/clk_wiz_0/clk_wiz_0_in_context.xdc2default:default2
	U_CLK_WIZ	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
jd:/Verilog/Verilog/vga_camera_1/vga_camera_1.gen/sources_1/ip/clk_wiz_0/clk_wiz_0/clk_wiz_0_in_context.xdc2default:default2
	U_CLK_WIZ	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2w
aD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/constrs_1/imports/Desktop/MY_Basys-3-Master.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2w
aD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/constrs_1/imports/Desktop/MY_Basys-3-Master.xdc2default:default8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2u
aD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/constrs_1/imports/Desktop/MY_Basys-3-Master.xdc2default:default24
 .Xil/top_VGA_CAMERA_propImpl.xdc2default:defaultZ1-236h px� 
�
Parsing XDC File [%s]
179*designutils2^
HD:/Verilog/Verilog/vga_camera_1/vga_camera_1.runs/synth_1/dont_touch.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2^
HD:/Verilog/Verilog/vga_camera_1/vga_camera_1.runs/synth_1/dont_touch.xdc2default:default8Z20-178h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0022default:default2
1391.5472default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common24
 Constraint Validation Runtime : 2default:default2
00:00:002default:default2 
00:00:00.0272default:default2
1391.5472default:default2
0.0002default:defaultZ17-268h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:19 ; elapsed = 00:00:19 . Memory (MB): peak = 1391.547 ; gain = 287.195
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7a35tcpg236-1
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:19 ; elapsed = 00:00:19 . Memory (MB): peak = 1391.547 ; gain = 287.195
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:19 ; elapsed = 00:00:19 . Memory (MB): peak = 1391.547 ; gain = 287.195
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[0]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[1]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[2]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[3]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[4]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[5]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[6]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[7]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[8]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2$
video_mem_reg[9]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[10]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[11]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[12]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[13]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[14]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[15]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[16]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[17]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[18]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[19]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[20]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[21]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[22]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[23]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[24]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[25]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[26]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[27]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[28]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[29]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[30]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[31]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[32]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[33]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[34]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[35]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[36]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[37]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[38]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[39]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[40]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[41]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[42]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[43]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[44]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[45]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[46]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[47]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[48]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[49]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[50]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[51]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[52]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[53]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[54]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[55]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[56]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[57]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[58]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[59]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[60]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[61]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[62]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[63]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[64]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[65]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[66]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[67]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[68]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[69]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[70]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[71]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[72]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[73]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[74]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[75]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[76]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[77]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[78]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[79]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[80]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[81]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[82]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[83]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[84]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[85]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[86]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[87]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[88]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[89]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[90]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[91]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[92]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[93]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[94]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[95]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[96]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[97]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[98]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2%
video_mem_reg[99]2default:default2\
FD:/Verilog/Verilog/vga_camera_1/vga_camera_1.srcs/sources_1/new/ISP.sv2default:default2
1942default:default8@Z8-327h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2
Synth 8-3272default:default2
1002default:defaultZ17-14h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:47 ; elapsed = 00:00:52 . Memory (MB): peak = 1391.547 ; gain = 287.195
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   17 Bit       Adders := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   10 Bit       Adders := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit       Adders := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               16 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               10 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
l
%s
*synth2T
@	            1200K Bit	(76800 X 16 bit)          RAMs := 1     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   17 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   16 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   16 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   12 Bit        Muxes := 1282  
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   10 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 1936  
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    1 Bit        Muxes := 1     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2j
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:01:56 ; elapsed = 00:02:05 . Memory (MB): peak = 1456.023 ; gain = 351.672
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
d
%s*synth2L
8
Block RAM: Preliminary Mapping	Report (see note below)
2default:defaulth px� 
�
%s*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|Module Name    | RTL Object            | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth px� 
�
%s*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|top_VGA_CAMERA | U_FrameBuffer/mem_reg | 75 K x 16(NO_CHANGE)   | W |   | 75 K x 16(WRITE_FIRST) |   | R | Port A and B     | 0      | 48     | 
2default:defaulth px� 
�
%s*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
2default:defaulth px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:02:02 ; elapsed = 00:02:11 . Memory (MB): peak = 1456.023 ; gain = 351.672
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
}Finished Timing Optimization : Time (s): cpu = 00:02:09 ; elapsed = 00:02:18 . Memory (MB): peak = 1456.023 ; gain = 351.672
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!
Block RAM: Final Mapping	Report
2default:defaulth p
x
� 
�
%s
*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|Module Name    | RTL Object            | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|top_VGA_CAMERA | U_FrameBuffer/mem_reg | 75 K x 16(NO_CHANGE)   | W |   | 75 K x 16(WRITE_FIRST) |   | R | Port A and B     | 0      | 48     | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+---------------+-----------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_12default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_22default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_32default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_42default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_52default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_62default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_72default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_82default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2-
U_FrameBuffer/mem_reg_1_92default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_102default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_112default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_122default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_132default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_142default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2.
U_FrameBuffer/mem_reg_1_152default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_0__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_1__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_2__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_3__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_4__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_5__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_6__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_7__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_8__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys20
U_FrameBuffer/mem_reg_1_9__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_10__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_11__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_12__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_13__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_14__02default:default2
Block2default:defaultZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys21
U_FrameBuffer/mem_reg_1_15__02default:default2
Block2default:defaultZ8-7052h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Technology Mapping : Time (s): cpu = 00:02:14 ; elapsed = 00:02:23 . Memory (MB): peak = 1518.344 ; gain = 413.992
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
vFinished IO Insertion : Time (s): cpu = 00:02:19 ; elapsed = 00:02:28 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:02:19 ; elapsed = 00:02:28 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:02:20 ; elapsed = 00:02:29 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:02:20 ; elapsed = 00:02:29 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:02:21 ; elapsed = 00:02:30 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:02:21 ; elapsed = 00:02:30 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|      |BlackBox name |Instances |
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
O
%s
*synth27
#|1     |clk_wiz_0     |         1|
2default:defaulth p
x
� 
O
%s
*synth27
#+------+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|      |Cell     |Count |
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|1     |clk_wiz  |     1|
2default:defaulth px� 
F
%s*synth2.
|2     |BUFG     |     1|
2default:defaulth px� 
F
%s*synth2.
|3     |CARRY4   |    25|
2default:defaulth px� 
F
%s*synth2.
|4     |LUT1     |    36|
2default:defaulth px� 
F
%s*synth2.
|5     |LUT2     |   146|
2default:defaulth px� 
F
%s*synth2.
|6     |LUT3     |  3692|
2default:defaulth px� 
F
%s*synth2.
|7     |LUT4     |  1754|
2default:defaulth px� 
F
%s*synth2.
|8     |LUT5     |   225|
2default:defaulth px� 
F
%s*synth2.
|9     |LUT6     |  2713|
2default:defaulth px� 
F
%s*synth2.
|10    |MUXF7    |   672|
2default:defaulth px� 
F
%s*synth2.
|11    |MUXF8    |   336|
2default:defaulth px� 
F
%s*synth2.
|12    |RAMB36E1 |    48|
2default:defaulth px� 
F
%s*synth2.
|15    |FDCE     |   219|
2default:defaulth px� 
F
%s*synth2.
|16    |FDPE     |     1|
2default:defaulth px� 
F
%s*synth2.
|17    |FDRE     |    10|
2default:defaulth px� 
F
%s*synth2.
|18    |LD       |  5112|
2default:defaulth px� 
F
%s*synth2.
|19    |IBUF     |    13|
2default:defaulth px� 
F
%s*synth2.
|20    |OBUF     |    15|
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:02:21 ; elapsed = 00:02:30 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
t
%s
*synth2\
HSynthesis finished with 0 errors, 0 critical warnings and 640 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:02:06 ; elapsed = 00:02:26 . Memory (MB): peak = 1531.363 ; gain = 344.910
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:02:21 ; elapsed = 00:02:30 . Memory (MB): peak = 1531.363 ; gain = 427.012
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.1522default:default2
1547.7542default:default2
0.0002default:defaultZ17-268h px� 
h
-Analyzing %s Unisim elements for replacement
17*netlist2
61932default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
12default:defaultZ29-28h px� 
�
�Netlist '%s' is not ideal for floorplanning, since the cellview '%s' contains a large number of primitives.  Please consider enabling hierarchy in synthesis if you want to do floorplanning.
310*netlist2"
top_VGA_CAMERA2default:default2
ISP2default:defaultZ29-101h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
g
1Inserted %s IBUFs to IO ports without IO buffers.100*opt2
12default:defaultZ31-140h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0032default:default2
1547.7542default:default2
0.0002default:defaultZ17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2_
K  A total of 5112 instances were transformed.
  LD => LDCE: 5112 instances
2default:defaultZ1-111h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
672default:default2
1012default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:02:312default:default2
00:02:412default:default2
1547.7542default:default2
443.4022default:defaultZ17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2`
LD:/Verilog/Verilog/vga_camera_1/vga_camera_1.runs/synth_1/top_VGA_CAMERA.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
rExecuting : report_utilization -file top_VGA_CAMERA_utilization_synth.rpt -pb top_VGA_CAMERA_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Mon Dec 30 03:02:21 20242default:defaultZ17-206h px� 


End Record