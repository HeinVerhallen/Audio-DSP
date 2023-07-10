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
-- CREATED		"Mon Jul 10 10:59:12 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Audio_sampler_testbench IS 
	PORT
	(
		clk_50 :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		ADC_DAT :  IN  STD_LOGIC;
		BCLK :  IN  STD_LOGIC;
		DAC_LRCK :  IN  STD_LOGIC;
		ADC_LRCK :  IN  STD_LOGIC;
		SDA :  INOUT  STD_LOGIC;
		SCL :  INOUT  STD_LOGIC;
		freq :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		parameter :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		ack_err :  OUT  STD_LOGIC;
		DAC_DAT :  OUT  STD_LOGIC;
		MCLK :  OUT  STD_LOGIC;
		data_read :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Audio_sampler_testbench;

ARCHITECTURE bdf_type OF Audio_sampler_testbench IS 

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

COMPONENT sinewave_generator
GENERIC (d_width : INTEGER;
			mclk_freq : INTEGER;
			sample_freq : INTEGER
			);
	PORT(mclk : IN STD_LOGIC;
		 desired_freq : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_avail : OUT STD_LOGIC;
		 sinewave : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
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
SIGNAL	encoded_sine :  STD_LOGIC;
SIGNAL	i_avail_l :  STD_LOGIC;
SIGNAL	i_avail_r :  STD_LOGIC;
SIGNAL	o_avail_l :  STD_LOGIC;
SIGNAL	o_avail_r :  STD_LOGIC;
SIGNAL	rw :  STD_LOGIC;
SIGNAL	sinewave_l :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	sinewave_r :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;


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
		 sd => encoded_sine,
		 o_avail_left => i_avail_l,
		 o_avail_right => i_avail_r,
		 data_left => d_in_l,
		 data_right => d_in_r);


b2v_inst10 : bpf_filter_v3
GENERIC MAP(d_width => 24,
			freq_res => 1000,
			freq_sample => 192000
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 i_avail => i_avail_r,
		 d_in => d_in_r,
		 param => SYNTHESIZED_WIRE_3,
		 o_avail => o_avail_r,
		 d_out => d_out_r);


b2v_inst11 : clk_div
GENERIC MAP(div => 4
			)
PORT MAP(clk_in => clk_50,
		 nrst => nrst,
		 clk_out => MCLK);


SYNTHESIZED_WIRE_2 <= NOT(ADC_LRCK);



b2v_inst13 : bpf_filter_v3
GENERIC MAP(d_width => 24,
			freq_res => 1000,
			freq_sample => 192000
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 i_avail => i_avail_l,
		 d_in => d_in_l,
		 param => SYNTHESIZED_WIRE_3,
		 o_avail => o_avail_l,
		 d_out => d_out_l);


b2v_inst2 : controller_eff
PORT MAP(mclk => clk_50,
		 param_in => parameter,
		 param_out => SYNTHESIZED_WIRE_3);


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


b2v_inst7 : sinewave_generator
GENERIC MAP(d_width => 24,
			mclk_freq => 50000000,
			sample_freq => 192000
			)
PORT MAP(mclk => clk_50,
		 desired_freq => freq,
		 sinewave => sinewave_l);


b2v_inst8 : i2s_encoder
GENERIC MAP(d_width => 24
			)
PORT MAP(mclk => clk_50,
		 nrst => nrst,
		 sck => BCLK,
		 ws => ADC_LRCK,
		 i_avail_left => ADC_LRCK,
		 i_avail_right => SYNTHESIZED_WIRE_2,
		 data_left => sinewave_l,
		 data_right => sinewave_r,
		 sd => encoded_sine);


b2v_inst9 : sinewave_generator
GENERIC MAP(d_width => 24,
			mclk_freq => 50000000,
			sample_freq => 192000
			)
PORT MAP(mclk => clk_50,
		 desired_freq => freq,
		 sinewave => sinewave_r);


END bdf_type;