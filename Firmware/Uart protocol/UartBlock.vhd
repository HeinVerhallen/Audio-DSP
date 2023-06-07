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
-- CREATED		"Tue Jun  6 12:57:46 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY UartBlock IS 
	PORT
	(
		LoadByte :  IN  STD_LOGIC;
		Clk :  IN  STD_LOGIC;
		RX :  IN  STD_LOGIC;
		Datarequest :  IN  STD_LOGIC;
		TXData :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		TX :  OUT  STD_LOGIC;
		Dataready :  OUT  STD_LOGIC;
		RxBufEmpty :  OUT  STD_LOGIC;
		RxBufFull :  OUT  STD_LOGIC;
		TxBufFull :  OUT  STD_LOGIC;
		RXData :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END UartBlock;

ARCHITECTURE bdf_type OF UartBlock IS 

COMPONENT baudsetting
	PORT(sysClk : IN STD_LOGIC;
		 Uartclk : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT receiver
	PORT(RX : IN STD_LOGIC;
		 Uartclk : IN STD_LOGIC;
		 Ready : OUT STD_LOGIC;
		 Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rxfifo
	PORT(Ready : IN STD_LOGIC;
		 Datarequest : IN STD_LOGIC;
		 Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 BufferEmpty : OUT STD_LOGIC;
		 BufferFull : OUT STD_LOGIC;
		 Dataready : OUT STD_LOGIC;
		 Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT transmitter
	PORT(Dataready : IN STD_LOGIC;
		 Uartclk : IN STD_LOGIC;
		 Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Ready : OUT STD_LOGIC;
		 Tx : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT txfifo
	PORT(Load : IN STD_LOGIC;
		 Ready : IN STD_LOGIC;
		 Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 BufferFull : OUT STD_LOGIC;
		 dataReady : OUT STD_LOGIC;
		 Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	RXByte :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	Rxready :  STD_LOGIC;
SIGNAL	TxByte :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	TxDataReady :  STD_LOGIC;
SIGNAL	TxReady :  STD_LOGIC;
SIGNAL	UartClk :  STD_LOGIC;


BEGIN 



b2v_inst : baudsetting
PORT MAP(sysClk => Clk,
		 Uartclk => UartClk);


b2v_inst2 : receiver
PORT MAP(RX => RX,
		 Uartclk => UartClk,
		 Ready => Rxready,
		 Byte => RXByte);


b2v_inst3 : rxfifo
PORT MAP(Ready => Rxready,
		 Datarequest => Datarequest,
		 Byte => RXByte,
		 BufferEmpty => RxBufEmpty,
		 BufferFull => RxBufFull,
		 Dataready => Dataready,
		 Data => RXData);


b2v_inst4 : transmitter
PORT MAP(Dataready => TxDataReady,
		 Uartclk => UartClk,
		 Byte => TxByte,
		 Ready => TxReady,
		 Tx => TX);


b2v_inst5 : txfifo
PORT MAP(Load => LoadByte,
		 Ready => TxReady,
		 Data => TXData,
		 BufferFull => TxBufFull,
		 dataReady => TxDataReady,
		 Byte => TxByte);


END bdf_type;