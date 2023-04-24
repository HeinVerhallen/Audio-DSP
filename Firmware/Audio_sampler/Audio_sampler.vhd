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
-- CREATED		"Thu Apr 20 19:58:59 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Audio_sampler IS 
	PORT
	(
		clk_50 :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		ADC_DAT :  IN  STD_LOGIC;
		ADC_LRCK :  IN  STD_LOGIC;
		BCLK :  IN  STD_LOGIC;
		DAC_LRCK :  IN  STD_LOGIC;
		SDA :  INOUT  STD_LOGIC;
		SCL :  INOUT  STD_LOGIC;
		ack_err :  OUT  STD_LOGIC;
		DAC_DAT :  OUT  STD_LOGIC;
		MCLK :  OUT  STD_LOGIC;
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

COMPONENT i2s_decoder
	PORT(nrst : IN STD_LOGIC;
		 sck : IN STD_LOGIC;
		 ws : IN STD_LOGIC;
		 sd : IN STD_LOGIC;
		 data_left : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 data_right : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT i2s_encoder
	PORT(nrst : IN STD_LOGIC;
		 sck : IN STD_LOGIC;
		 ws : IN STD_LOGIC;
		 data_left : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 data_right : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 sd : OUT STD_LOGIC
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

COMPONENT clk_div
GENERIC (div : INTEGER
			);
	PORT(clk_in : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 clk_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT pll_mlck
	PORT(refclk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 outclk_0 : OUT STD_LOGIC;
		 locked : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	addr :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	busy :  STD_LOGIC;
SIGNAL	data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	data_left :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	data_right :  STD_LOGIC_VECTOR(23 DOWNTO 0);
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


b2v_inst1 : i2s_decoder
PORT MAP(nrst => nrst,
		 sck => BCLK,
		 ws => ADC_LRCK,
		 sd => ADC_DAT,
		 data_left => data_left,
		 data_right => data_right);


b2v_inst2 : i2s_encoder
PORT MAP(nrst => nrst,
		 sck => BCLK,
		 ws => DAC_LRCK,
		 data_left => data_left,
		 data_right => data_right,
		 sd => DAC_DAT);


b2v_inst3 : initializer
PORT MAP(clk => clk_50,
		 nrst => nrst,
		 busy => busy,
		 ena => ena,
		 rw => rw,
		 addr => addr,
		 data => data);


b2v_inst4 : clk_div
GENERIC MAP(div => 8
			)
PORT MAP(clk_in => clk_50,
		 nrst => nrst,
		 clk_out => MCLK);


b2v_inst5 : pll_mlck
PORT MAP(refclk => clk_50,
		 rst => nrst);


END bdf_type;