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
-- CREATED		"Wed May 31 10:01:19 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Test_FPGA_MemoryAllocation IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		D_in :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		D_out :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END Test_FPGA_MemoryAllocation;

ARCHITECTURE bdf_type OF Test_FPGA_MemoryAllocation IS 

COMPONENT sampleshiftreg
GENERIC (resolution : INTEGER;
			samples : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 inp : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : sampleshiftreg
GENERIC MAP(resolution => 24,
			samples => 16
			)
PORT MAP(clk => clk,
		 nrst => nrst,
		 inp => D_in,
		 output => D_out);


END bdf_type;