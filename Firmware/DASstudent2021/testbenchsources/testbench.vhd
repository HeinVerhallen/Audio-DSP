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
-- CREATED		"Mon Oct 12 19:41:06 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY testbench IS 
	PORT
	(
		SL24 :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		SR24 :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		OK :  OUT  STD_LOGIC
	);
END testbench;

ARCHITECTURE bdf_type OF testbench IS 

COMPONENT testbloks
	PORT(clke : INOUT STD_LOGIC;
		 nrst : OUT STD_LOGIC;
		 push_B : OUT STD_LOGIC;
		 push_A : OUT STD_LOGIC;
		 simsel : OUT STD_LOGIC;
		 encia : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encib : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT outtest
	PORT(clk : IN STD_LOGIC;
		 writeadc : IN STD_LOGIC;
		 loadpiso_c : IN STD_LOGIC;
		 decoa : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 decob : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encia : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encib : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 ok : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT dasq
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 minoi : IN STD_LOGIC;
		 nuloi : IN STD_LOGIC;
		 plusoi : IN STD_LOGIC;
		 SL24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 SR24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 writeadc : OUT STD_LOGIC;
		 loadpiso_c : OUT STD_LOGIC;
		 mino : OUT STD_LOGIC;
		 nulo : OUT STD_LOGIC;
		 pluso : OUT STD_LOGIC;
		 decoa : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 decob : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT passthrus
	PORT(simsel : IN STD_LOGIC;
		 SL24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 SLS24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 SR24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 SRS24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encia : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encib : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT clkdiv
	PORT(clke : IN STD_LOGIC;
		 push_B : IN STD_LOGIC;
		 push_A : IN STD_LOGIC;
		 clk : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;


BEGIN 



b2v_inst : testbloks
PORT MAP(clke => SYNTHESIZED_WIRE_17,
		 nrst => SYNTHESIZED_WIRE_8,
		 push_B => SYNTHESIZED_WIRE_18,
		 push_A => SYNTHESIZED_WIRE_19,
		 simsel => SYNTHESIZED_WIRE_14,
		 encia => SYNTHESIZED_WIRE_15,
		 encib => SYNTHESIZED_WIRE_16);


b2v_inst1 : outtest
PORT MAP(clk => SYNTHESIZED_WIRE_20,
		 writeadc => SYNTHESIZED_WIRE_1,
		 loadpiso_c => SYNTHESIZED_WIRE_2,
		 decoa => SYNTHESIZED_WIRE_3,
		 decob => SYNTHESIZED_WIRE_4,
		 encia => SYNTHESIZED_WIRE_21,
		 encib => SYNTHESIZED_WIRE_22,
		 ok => OK);


b2v_inst2 : dasq
PORT MAP(clk => SYNTHESIZED_WIRE_20,
		 nrst => SYNTHESIZED_WIRE_8,
		 minoi => SYNTHESIZED_WIRE_9,
		 nuloi => SYNTHESIZED_WIRE_10,
		 plusoi => SYNTHESIZED_WIRE_11,
		 SL24 => SYNTHESIZED_WIRE_21,
		 SR24 => SYNTHESIZED_WIRE_22,
		 writeadc => SYNTHESIZED_WIRE_1,
		 loadpiso_c => SYNTHESIZED_WIRE_2,
		 mino => SYNTHESIZED_WIRE_9,
		 nulo => SYNTHESIZED_WIRE_10,
		 pluso => SYNTHESIZED_WIRE_11,
		 decoa => SYNTHESIZED_WIRE_3,
		 decob => SYNTHESIZED_WIRE_4);


b2v_inst3 : passthrus
PORT MAP(simsel => SYNTHESIZED_WIRE_14,
		 SL24 => SL24,
		 SLS24 => SYNTHESIZED_WIRE_15,
		 SR24 => SR24,
		 SRS24 => SYNTHESIZED_WIRE_16,
		 encia => SYNTHESIZED_WIRE_21,
		 encib => SYNTHESIZED_WIRE_22);


b2v_inst4 : clkdiv
PORT MAP(clke => SYNTHESIZED_WIRE_17,
		 push_B => SYNTHESIZED_WIRE_18,
		 push_A => SYNTHESIZED_WIRE_19,
		 clk => SYNTHESIZED_WIRE_20);


END bdf_type;