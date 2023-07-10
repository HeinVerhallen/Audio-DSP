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
-- CREATED		"Thu Jun 29 12:57:02 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY test IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		RX :  IN  STD_LOGIC;
		Left :  IN  STD_LOGIC;
		Right :  IN  STD_LOGIC;
		Press :  IN  STD_LOGIC;
		TXActive :  OUT  STD_LOGIC;
		TX :  OUT  STD_LOGIC;
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END test;

ARCHITECTURE bdf_type OF test IS 

COMPONENT uartblock
	PORT(Clk : IN STD_LOGIC;
		 RX : IN STD_LOGIC;
		 LoadByte : IN STD_LOGIC;
		 TXData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Dataready : OUT STD_LOGIC;
		 TXActive : OUT STD_LOGIC;
		 TX : OUT STD_LOGIC;
		 TXDone : OUT STD_LOGIC;
		 RXData : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT tohex
	PORT(bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT uicontroller
	PORT(Clk : IN STD_LOGIC;
		 Dataready : IN STD_LOGIC;
		 TXDone : IN STD_LOGIC;
		 leftInput : IN STD_LOGIC;
		 rightInput : IN STD_LOGIC;
		 pressInput : IN STD_LOGIC;
		 RXData : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 loadbyte : OUT STD_LOGIC;
		 button : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 page : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 TXData : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Dataready :  STD_LOGIC;
SIGNAL	LoadByte :  STD_LOGIC;
SIGNAL	RXData :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	TXData :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	TXDone :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : uartblock
PORT MAP(Clk => Clk,
		 RX => RX,
		 LoadByte => LoadByte,
		 TXData => TXData,
		 Dataready => Dataready,
		 TXActive => TXActive,
		 TX => TX,
		 TXDone => TXDone,
		 RXData => RXData);


b2v_inst1 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_0,
		 seg => HEX0);


b2v_inst2 : uicontroller
PORT MAP(Clk => Clk,
		 Dataready => Dataready,
		 TXDone => TXDone,
		 leftInput => Left,
		 rightInput => Right,
		 pressInput => Press,
		 RXData => RXData,
		 loadbyte => LoadByte,
		 button => SYNTHESIZED_WIRE_1,
		 page => SYNTHESIZED_WIRE_0,
		 TXData => TXData);


b2v_inst3 : tohex
PORT MAP(bin => SYNTHESIZED_WIRE_1,
		 seg => HEX1);


END bdf_type;