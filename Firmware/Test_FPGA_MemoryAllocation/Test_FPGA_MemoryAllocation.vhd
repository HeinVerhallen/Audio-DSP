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
-- CREATED		"Fri Jun 02 11:48:38 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Test_FPGA_MemoryAllocation IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		shift_sipo :  IN  STD_LOGIC;
		shift_piso :  IN  STD_LOGIC;
		load_piso :  IN  STD_LOGIC;
		input :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		output :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END Test_FPGA_MemoryAllocation;

ARCHITECTURE bdf_type OF Test_FPGA_MemoryAllocation IS 

COMPONENT piso2
GENERIC (N : INTEGER;
			sampleSize : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 shift : IN STD_LOGIC;
		 loadpiso : IN STD_LOGIC;
		 count : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 encrypteddatain : IN STD_LOGIC_VECTOR(383 DOWNTO 0);
		 serout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sipo2
GENERIC (N : INTEGER;
			sampleSize : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 shift : IN STD_LOGIC;
		 sinput : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 parout : OUT STD_LOGIC_VECTOR(383 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(383 DOWNTO 0);


BEGIN 



b2v_inst : piso2
GENERIC MAP(N => 8,
			sampleSize => 24
			)
PORT MAP(clk => clk,
		 shift => shift_piso,
		 loadpiso => load_piso,
		 count => SYNTHESIZED_WIRE_0,
		 encrypteddatain => SYNTHESIZED_WIRE_1,
		 serout => output);


b2v_inst6 : sipo2
GENERIC MAP(N => 8,
			sampleSize => 24
			)
PORT MAP(clk => clk,
		 shift => shift_sipo,
		 sinput => input,
		 count => SYNTHESIZED_WIRE_0,
		 parout => SYNTHESIZED_WIRE_1);


END bdf_type;