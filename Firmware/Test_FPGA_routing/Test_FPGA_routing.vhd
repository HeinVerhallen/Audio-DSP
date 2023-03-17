-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
-- CREATED		"Fri Mar 17 11:32:48 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Test_FPGA_routing IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		en :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		input :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		out1 :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		out2 :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END Test_FPGA_routing;

ARCHITECTURE bdf_type OF Test_FPGA_routing IS 

COMPONENT alu3
GENERIC (addr : STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
	PORT(nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 en : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 input : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : alu3
GENERIC MAP(addr => "010"
			)
PORT MAP(nrst => nrst,
		 clk => clk,
		 en => en,
		 input => input,
		 output => out1);


b2v_inst5 : alu3
GENERIC MAP(addr => "001"
			)
PORT MAP(nrst => nrst,
		 clk => clk,
		 en => en,
		 input => input,
		 output => out2);


END bdf_type;