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
-- CREATED		"Tue Apr 25 15:59:33 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Signal_processor_manager IS 
	PORT
	(
		nrst :  IN  STD_LOGIC;
		sys_clk :  IN  STD_LOGIC;
		valid_in :  IN  STD_LOGIC;
		d_in :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		valid_out :  OUT  STD_LOGIC;
		d_out :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END Signal_processor_manager;

ARCHITECTURE bdf_type OF Signal_processor_manager IS 

COMPONENT signal_processor
GENERIC (d_width : INTEGER
			);
	PORT(nrst : IN STD_LOGIC;
		 sys_clk : IN STD_LOGIC;
		 valid_in : IN STD_LOGIC;
		 d_in : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 valid_out : OUT STD_LOGIC;
		 d_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : signal_processor
GENERIC MAP(d_width => 24
			)
PORT MAP(nrst => nrst,
		 sys_clk => sys_clk,
		 valid_in => valid_in,
		 d_in => d_in,
		 valid_out => valid_out,
		 d_out => d_out);


END bdf_type;