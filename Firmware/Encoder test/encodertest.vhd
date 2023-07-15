-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 22.1std.1 Build 917 02/14/2023 SC Lite Edition"
-- CREATED		"Wed Jul 12 10:28:24 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY encodertest IS 
	PORT
	(
		A :  IN  STD_LOGIC;
		B :  IN  STD_LOGIC;
		Nrst :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		switch :  IN  STD_LOGIC;
		leda :  OUT  STD_LOGIC;
		ledb :  OUT  STD_LOGIC;
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END encodertest;

ARCHITECTURE bdf_type OF encodertest IS 

COMPONENT rotaryknob
	PORT(Nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 Ain : IN STD_LOGIC;
		 Bin : IN STD_LOGIC;
		 switch : IN STD_LOGIC;
		 left_left : OUT STD_LOGIC;
		 right : OUT STD_LOGIC;
		 a : OUT STD_LOGIC;
		 b : OUT STD_LOGIC;
		 press : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT pulsecounter
	PORT(Nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 pulse : IN STD_LOGIC;
		 count : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT tohex
	PORT(bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;


BEGIN 
leda <= A;
ledb <= B;



b2v_inst : rotaryknob
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 Ain => A,
		 Bin => B,
		 switch => switch,
		 left_left => SYNTHESIZED_WIRE_7,
		 right => SYNTHESIZED_WIRE_5,
		 a => SYNTHESIZED_WIRE_0,
		 b => SYNTHESIZED_WIRE_9,
		 press => SYNTHESIZED_WIRE_8);


b2v_inst10 : pulsecounter
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 pulse => SYNTHESIZED_WIRE_0,
		 count => SYNTHESIZED_WIRE_2);


b2v_inst11 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_1,
		 seg => HEX3);


b2v_inst12 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_2,
		 seg => HEX4);


b2v_inst3 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_3,
		 seg => HEX0);


b2v_inst4 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_4,
		 seg => HEX1);


b2v_inst5 : pulsecounter
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 pulse => SYNTHESIZED_WIRE_5,
		 count => SYNTHESIZED_WIRE_4);


b2v_inst6 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_6,
		 seg => HEX2);


b2v_inst7 : pulsecounter
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 pulse => SYNTHESIZED_WIRE_7,
		 count => SYNTHESIZED_WIRE_3);


b2v_inst8 : pulsecounter
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 pulse => SYNTHESIZED_WIRE_8,
		 count => SYNTHESIZED_WIRE_6);


b2v_inst9 : pulsecounter
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 pulse => SYNTHESIZED_WIRE_9,
		 count => SYNTHESIZED_WIRE_1);


END bdf_type;