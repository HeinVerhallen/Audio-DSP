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
-- CREATED		"Thu Jul 21 19:52:02 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY hdb3enc IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		so :  IN  STD_LOGIC;
		syncadd_c :  IN  STD_LOGIC;
		LWout :  OUT  STD_LOGIC;
		hmin :  OUT  STD_LOGIC;
		hnul :  OUT  STD_LOGIC;
		hplus :  OUT  STD_LOGIC
	);
END hdb3enc;

ARCHITECTURE bdf_type OF hdb3enc IS 

COMPONENT hdb3reg_1
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 so : IN STD_LOGIC;
		 bits : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hdb3_1
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 syncadd_c : IN STD_LOGIC;
		 bits : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LWout : OUT STD_LOGIC;
		 hmin : OUT STD_LOGIC;
		 hnul : OUT STD_LOGIC;
		 hplus : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : hdb3reg_1
PORT MAP(clk => clk,
		 nrst => nrst,
		 so => so,
		 bits => SYNTHESIZED_WIRE_0);


b2v_inst2 : hdb3_1
PORT MAP(clk => clk,
		 nrst => nrst,
		 syncadd_c => syncadd_c,
		 bits => SYNTHESIZED_WIRE_0,
		 LWout => LWout,
		 hmin => hmin,
		 hnul => hnul,
		 hplus => hplus);


END bdf_type;