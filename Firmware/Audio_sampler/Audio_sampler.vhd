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
-- CREATED		"Thu Apr 13 18:12:50 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Audio_sampler IS 
	PORT
	(
		clk_50 :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		SDA :  INOUT  STD_LOGIC;
		SCL :  INOUT  STD_LOGIC;
		ack_err :  OUT  STD_LOGIC;
		data_read :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Audio_sampler;

ARCHITECTURE bdf_type OF Audio_sampler IS 

COMPONENT i2c_master
GENERIC (bus_clk : INTEGER;
			input_clk : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 ena : IN STD_LOGIC;
		 rw : IN STD_LOGIC;
		 sda : INOUT STD_LOGIC;
		 scl : INOUT STD_LOGIC;
		 addr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 data_wr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 busy : OUT STD_LOGIC;
		 ack_error : OUT STD_LOGIC;
		 data_rd : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT initializer
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 busy : IN STD_LOGIC;
		 ena : OUT STD_LOGIC;
		 rw : OUT STD_LOGIC;
		 addr : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	addr :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	busy :  STD_LOGIC;
SIGNAL	data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ena :  STD_LOGIC;
SIGNAL	rw :  STD_LOGIC;


BEGIN 



b2v_inst : i2c_master
GENERIC MAP(bus_clk => 400000,
			input_clk => 50000000
			)
PORT MAP(clk => clk_50,
		 reset_n => nrst,
		 ena => ena,
		 rw => rw,
		 sda => SDA,
		 scl => SCL,
		 addr => addr,
		 data_wr => data,
		 busy => busy,
		 ack_error => ack_err,
		 data_rd => data_read);


b2v_inst3 : initializer
PORT MAP(clk => clk_50,
		 nrst => nrst,
		 busy => busy,
		 ena => ena,
		 rw => rw,
		 addr => addr,
		 data => data);


END bdf_type;