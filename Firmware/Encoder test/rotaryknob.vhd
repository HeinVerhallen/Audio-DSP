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
-- CREATED		"Wed Jul 12 09:33:56 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY rotaryknob IS 
	PORT
	(
		switch :  IN  STD_LOGIC;
		Ain :  IN  STD_LOGIC;
		Bin :  IN  STD_LOGIC;
		Nrst :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		press :  OUT  STD_LOGIC;
		right :  OUT  STD_LOGIC;
		a :  OUT  STD_LOGIC;
		b :  OUT  STD_LOGIC;
		left_left :  OUT  STD_LOGIC
	);
END rotaryknob;

ARCHITECTURE bdf_type OF rotaryknob IS 

COMPONENT doubledebounce
	PORT(Nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 input : IN STD_LOGIC;
		 output : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT debounce
	PORT(Nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 input : IN STD_LOGIC;
		 output : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT decoder
	PORT(Nrst : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 A : IN STD_LOGIC;
		 B : IN STD_LOGIC;
		 LeftOut : OUT STD_LOGIC;
		 RightOut : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;


BEGIN 
a <= SYNTHESIZED_WIRE_0;
b <= SYNTHESIZED_WIRE_1;



b2v_inst : doubledebounce
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 input => Ain,
		 output => SYNTHESIZED_WIRE_0);


b2v_inst1 : doubledebounce
PORT MAP(Nrst => Nrst,
		 clk => clk,
		 input => Bin,
		 output => SYNTHESIZED_WIRE_1);


b2v_inst2 : debounce
PORT MAP(Nrst => Bin,
		 clk => clk,
		 input => switch,
		 output => press);


b2v_inst4 : decoder
PORT MAP(Nrst => Nrst,
		 Clk => clk,
		 A => SYNTHESIZED_WIRE_0,
		 B => SYNTHESIZED_WIRE_1,
		 LeftOut => left_left,
		 RightOut => right);


END bdf_type;