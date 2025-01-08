-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Wed Jan  8 16:32:25 2025
-- Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/GitHub/verilog/Verilog/StereoDepth_final/StereoDepth_final.gen/sources_1/ip/ila_1/ila_1_stub.vhdl
-- Design      : ila_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_1 is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 35 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe17 : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end ila_1;

architecture stub of ila_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[9:0],probe1[9:0],probe2[13:0],probe3[13:0],probe4[5:0],probe5[35:0],probe6[35:0],probe7[35:0],probe8[35:0],probe9[35:0],probe10[35:0],probe11[35:0],probe12[35:0],probe13[35:0],probe14[35:0],probe15[7:0],probe16[0:0],probe17[3:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2020.2";
begin
end;
