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
-- CREATED		"Thu Jun 29 23:19:32 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY UartBlock IS 
	PORT
	(
		LoadByte :  IN  STD_LOGIC;
		Clk :  IN  STD_LOGIC;
		RX :  IN  STD_LOGIC;
		Nrst :  IN  STD_LOGIC;
		TXData :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		TX :  OUT  STD_LOGIC;
		Dataready :  OUT  STD_LOGIC;
		TXActive :  OUT  STD_LOGIC;
		TXDone :  OUT  STD_LOGIC;
		RXData :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END UartBlock;

ARCHITECTURE bdf_type OF UartBlock IS 

COMPONENT uart_rx
GENERIC (CLKS_PER_BIT : INTEGER
			);
	PORT(Nrst : IN STD_LOGIC;
		 Clk : IN STD_LOGIC;
		 RX_Serial : IN STD_LOGIC;
		 RX_DV : OUT STD_LOGIC;
		 RX_Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT uart_tx
GENERIC (CLKS_PER_BIT : INTEGER
			);
	PORT(Nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 TX_DV : IN STD_LOGIC;
		 TX_Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 TX_Active : OUT STD_LOGIC;
		 TX_Serial : OUT STD_LOGIC;
		 TX_Done : OUT STD_LOGIC
	);
END COMPONENT;



BEGIN 



b2v_inst : uart_rx
GENERIC MAP(CLKS_PER_BIT => 5208
			)
PORT MAP(Nrst => Nrst,
		 Clk => Clk,
		 RX_Serial => RX,
		 RX_DV => Dataready,
		 RX_Byte => RXData);


b2v_inst5 : uart_tx
GENERIC MAP(CLKS_PER_BIT => 5208
			)
PORT MAP(Nrst => Nrst,
		 clk => Clk,
		 TX_DV => LoadByte,
		 TX_Byte => TXData,
		 TX_Active => TXActive,
		 TX_Serial => TX,
		 TX_Done => TXDone);


END bdf_type;