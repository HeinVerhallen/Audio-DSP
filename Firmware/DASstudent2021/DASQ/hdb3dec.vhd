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
-- CREATED		"Thu Jul 21 21:58:15 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY hdb3dec IS 
	PORT
	(
		nulo :  IN  STD_LOGIC;
		pluso :  IN  STD_LOGIC;
		mino :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		sbits :  OUT  STD_LOGIC;
		mins :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		pluss :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END hdb3dec;

ARCHITECTURE bdf_type OF hdb3dec IS 

COMPONENT fourbitse
	PORT(mino : IN STD_LOGIC;
		 pluso : IN STD_LOGIC;
		 min : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 plus : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 mins : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 pluss : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT minreg
	PORT(clk : IN STD_LOGIC;
		 mino : IN STD_LOGIC;
		 mins : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT nulreg
	PORT(clk : IN STD_LOGIC;
		 nulo : IN STD_LOGIC;
		 nuls : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT plusreg
	PORT(clk : IN STD_LOGIC;
		 pluso : IN STD_LOGIC;
		 pluss : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hdb3decod
	PORT(nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 LWin : IN STD_LOGIC;
		 mins : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 nuls : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 pluss : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LWout : OUT STD_LOGIC;
		 sbits : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT lwblock
	PORT(LWout : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 LWin : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;


BEGIN 



b2v_inst : fourbitse
PORT MAP(mino => mino,
		 pluso => pluso,
		 min => SYNTHESIZED_WIRE_7,
		 plus => SYNTHESIZED_WIRE_8,
		 mins => mins,
		 pluss => pluss);


b2v_inst1 : minreg
PORT MAP(clk => clk,
		 mino => mino,
		 mins => SYNTHESIZED_WIRE_7);


b2v_inst2 : nulreg
PORT MAP(clk => clk,
		 nulo => nulo,
		 nuls => SYNTHESIZED_WIRE_4);


b2v_inst3 : plusreg
PORT MAP(clk => clk,
		 pluso => pluso,
		 pluss => SYNTHESIZED_WIRE_8);


b2v_inst4 : hdb3decod
PORT MAP(nrst => nrst,
		 clk => clk,
		 LWin => SYNTHESIZED_WIRE_2,
		 mins => SYNTHESIZED_WIRE_7,
		 nuls => SYNTHESIZED_WIRE_4,
		 pluss => SYNTHESIZED_WIRE_8,
		 LWout => SYNTHESIZED_WIRE_6,
		 sbits => sbits);


b2v_inst5 : lwblock
PORT MAP(LWout => SYNTHESIZED_WIRE_6,
		 clk => clk,
		 LWin => SYNTHESIZED_WIRE_2);


END bdf_type;