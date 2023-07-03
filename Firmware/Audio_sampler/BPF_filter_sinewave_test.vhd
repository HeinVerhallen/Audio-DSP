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
-- CREATED		"Mon Jul 03 20:12:11 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY BPF_filter_sinewave_test IS 
	PORT
	(
		mclk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		freq :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		param :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		d_out :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END BPF_filter_sinewave_test;

ARCHITECTURE bdf_type OF BPF_filter_sinewave_test IS 

COMPONENT bpf_filter_v2
GENERIC (d_width : INTEGER;
			freq_res : INTEGER;
			freq_sample : INTEGER
			);
	PORT(nrst : IN STD_LOGIC;
		 i_avail : IN STD_LOGIC;
		 d_in : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 param : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 o_avail : OUT STD_LOGIC;
		 d_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sinewave_generator
GENERIC (d_width : INTEGER;
			mclk_freq : INTEGER;
			sample_freq : INTEGER
			);
	PORT(mclk : IN STD_LOGIC;
		 desired_freq : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 valid : OUT STD_LOGIC;
		 sinewave : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	sinewave :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	valid :  STD_LOGIC;


BEGIN 



b2v_inst : bpf_filter_v2
GENERIC MAP(d_width => 24,
			freq_res => 400,
			freq_sample => 192000
			)
PORT MAP(nrst => nrst,
		 i_avail => valid,
		 d_in => sinewave,
		 param => param,
		 d_out => d_out);


b2v_inst2 : sinewave_generator
GENERIC MAP(d_width => 24,
			mclk_freq => 50000000,
			sample_freq => 192000
			)
PORT MAP(mclk => mclk,
		 desired_freq => freq,
		 valid => valid,
		 sinewave => sinewave);


END bdf_type;