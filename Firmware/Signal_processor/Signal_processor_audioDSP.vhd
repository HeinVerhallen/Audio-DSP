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
-- CREATED		"Thu Mar 23 19:29:22 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Signal_processor_audioDSP IS 
	PORT
	(
		en :  IN  STD_LOGIC;
		rw :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		sample_clk :  IN  STD_LOGIC;
		sys_clk :  IN  STD_LOGIC;
		dat :  INOUT  STD_LOGIC_VECTOR(24 DOWNTO 0);
		inp :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		reg :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		outp :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END Signal_processor_audioDSP;

ARCHITECTURE bdf_type OF Signal_processor_audioDSP IS 

COMPONENT signal_proc
	PORT(sample_clk : IN STD_LOGIC;
		 sys_clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 enData : IN STD_LOGIC;
		 rw : IN STD_LOGIC;
		 data : INOUT STD_LOGIC_VECTOR(24 DOWNTO 0);
		 input : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 regSel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : signal_proc
PORT MAP(sample_clk => sample_clk,
		 sys_clk => sys_clk,
		 nrst => nrst,
		 enData => en,
		 rw => rw,
		 data => dat,
		 input => inp,
		 regSel => reg,
		 output => outp);


END bdf_type;