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
-- CREATED		"Mon Jul 10 11:04:22 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Audio_sampler IS 
	PORT
	(
		clk_50 :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		ADC_DAT :  IN  STD_LOGIC;
		BCLK :  IN  STD_LOGIC;
		DAC_LRCK :  IN  STD_LOGIC;
		ADC_LRCK :  IN  STD_LOGIC;
		effect_nrst :  IN  STD_LOGIC;
		SDA :  INOUT  STD_LOGIC;
		SCL :  INOUT  STD_LOGIC;
		parameter :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
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
GENERIC (d_width : INTEGER
			);
	PORT(mclk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 sck : IN STD_LOGIC;
		 ws : IN STD_LOGIC;
		 sd : IN STD_LOGIC;
		 o_avail_left : OUT STD_LOGIC;
		 o_avail_right : OUT STD_LOGIC;
		 data_left : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 data_right : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
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

COMPONENT controller_eff
	PORT(mclk : IN STD_LOGIC;
		 param_in : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 param_out : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
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

COMPONENT i2s_encoder
GENERIC (d_width : INTEGER
			);
	PORT(mclk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 sck : IN STD_LOGIC;
		 ws : IN STD_LOGIC;
		 i_avail_left : IN STD_LOGIC;
		 i_avail_right : IN STD_LOGIC;
		 data_left : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 data_right : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 sd : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bpf_filter_v3
GENERIC (d_width : INTEGER;
			freq_res : INTEGER;
			freq_sample : INTEGER
			);
	PORT(mclk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 i_avail : IN STD_LOGIC;
		 d_in : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 param : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 o_avail : OUT STD_LOGIC;
		 d_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	addr :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	busy :  STD_LOGIC;
SIGNAL	d_in_l :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	d_in_r :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	d_out_l :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	d_out_r :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ena :  STD_LOGIC;
SIGNAL	i_avail_l :  STD_LOGIC;
SIGNAL	i_avail_r :  STD_LOGIC;
SIGNAL	o_avail_l :  STD_LOGIC;
SIGNAL	o_avail_r :  STD_LOGIC;
SIGNAL	rw :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(5 DOWNTO 0);


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
GENERIC MAP(d_width => 24
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 sck => BCLK,
		 ws => ADC_LRCK,
		 sd => ADC_DAT,
		 o_avail_left => i_avail_l,
		 o_avail_right => i_avail_r,
		 data_left => d_in_l,
		 data_right => d_in_r);


b2v_inst11 : clk_div
GENERIC MAP(div => 4
			)
PORT MAP(clk_in => clk_50,
		 nrst => nrst,
		 clk_out => MCLK);


b2v_inst2 : controller_eff
PORT MAP(mclk => clk_50,
		 param_in => parameter,
		 param_out => SYNTHESIZED_WIRE_2);


b2v_inst3 : initializer
PORT MAP(clk => clk_50,
		 nrst => nrst,
		 busy => busy,
		 ena => ena,
		 rw => rw,
		 addr => addr,
		 data => data);


b2v_inst4 : i2s_encoder
GENERIC MAP(d_width => 24
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 sck => BCLK,
		 ws => DAC_LRCK,
		 i_avail_left => o_avail_l,
		 i_avail_right => o_avail_r,
		 data_left => d_out_l,
		 data_right => d_out_r,
		 sd => DAC_DAT);


b2v_inst6 : bpf_filter_v3
GENERIC MAP(d_width => 24,
			freq_res => 1000,
			freq_sample => 48000
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 i_avail => i_avail_r,
		 d_in => d_in_r,
		 param => SYNTHESIZED_WIRE_2,
		 o_avail => o_avail_r,
		 d_out => d_out_r);


b2v_inst7 : bpf_filter_v3
GENERIC MAP(d_width => 24,
			freq_res => 1000,
			freq_sample => 48000
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 i_avail => i_avail_l,
		 d_in => d_in_l,
		 param => SYNTHESIZED_WIRE_2,
		 o_avail => o_avail_l,
		 d_out => d_out_l);


END bdf_type;