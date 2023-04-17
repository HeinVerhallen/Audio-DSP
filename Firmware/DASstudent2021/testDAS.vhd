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
-- CREATED		"Mon Apr 17 10:59:02 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY testDAS IS 
	PORT
	(
		OnOffKey0 :  IN  STD_LOGIC;
		VolUKey1 :  IN  STD_LOGIC;
		VolDKey2 :  IN  STD_LOGIC;
		CLOCK_50 :  IN  STD_LOGIC;
		ResetKey3 :  IN  STD_LOGIC;
		AUD_ADCDAT :  IN  STD_LOGIC;
		FPGA_I2C_SDAT :  INOUT  STD_LOGIC;
		AUD_DACLRCK :  INOUT  STD_LOGIC;
		AUD_BCLK :  INOUT  STD_LOGIC;
		AUD_ADCLRCK :  INOUT  STD_LOGIC;
		AUD_XCK :  OUT  STD_LOGIC;
		AUD_DACDAT :  OUT  STD_LOGIC;
		FPGA_I2C_SCLK :  OUT  STD_LOGIC;
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END testDAS;

ARCHITECTURE bdf_type OF testDAS IS 

COMPONENT audio_codec24
	PORT(OnOffKey0 : IN STD_LOGIC;
		 VolUKey1 : IN STD_LOGIC;
		 VolDKey2 : IN STD_LOGIC;
		 CLOCK_50 : IN STD_LOGIC;
		 ResetKey3 : IN STD_LOGIC;
		 AUD_ADCDAT : IN STD_LOGIC;
		 FPGA_I2C_SDAT : INOUT STD_LOGIC;
		 AUD_DACLRCK : INOUT STD_LOGIC;
		 AUD_BCLK : INOUT STD_LOGIC;
		 AUD_ADCLRCK : INOUT STD_LOGIC;
		 AUD_ADC_PATH : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_DAC_PATH : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_DATA_FORMAT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_LINE_IN_LC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_LINE_IN_RC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_POWER : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_SAMPLE_CTRL : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_SET_ACTIVE : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DataL_DAC24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 DataR_DAC24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 AUD_XCK : OUT STD_LOGIC;
		 AUD_DACDAT : OUT STD_LOGIC;
		 FPGA_I2C_SCLK : OUT STD_LOGIC;
		 valid_L : OUT STD_LOGIC;
		 valid_R : OUT STD_LOGIC;
		 readyL : OUT STD_LOGIC;
		 readyR : OUT STD_LOGIC;
		 DataL_ADC24 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 DataR_ADC24 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT initialize
	PORT(		 AUD_ADC_PATH : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_DAC_PATH : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_DATA_FORMAT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_LINE_IN_LC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_LINE_IN_RC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_POWER : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_SAMPLE_CTRL : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 AUD_SET_ACTIVE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT datavalid
	PORT(clk : IN STD_LOGIC;
		 valid : IN STD_LOGIC;
		 din : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 dout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT delay
	PORT(clk : IN STD_LOGIC;
		 load : IN STD_LOGIC;
		 dinL : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 dinR : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 doutL : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		 doutR : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
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

COMPONENT clk2mhz
	PORT(CLOCK : IN STD_LOGIC;
		 CLKBCLK : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(23 DOWNTO 0);


BEGIN 



b2v_inst : audio_codec24
PORT MAP(OnOffKey0 => OnOffKey0,
		 VolUKey1 => VolUKey1,
		 VolDKey2 => VolDKey2,
		 CLOCK_50 => CLOCK_50,
		 ResetKey3 => ResetKey3,
		 AUD_ADCDAT => AUD_ADCDAT,
		 AUD_DACLRCK => AUD_DACLRCK,
		 AUD_BCLK => AUD_BCLK,
		 AUD_ADCLRCK => AUD_ADCLRCK,
		 AUD_ADC_PATH => SYNTHESIZED_WIRE_0,
		 AUD_DAC_PATH => SYNTHESIZED_WIRE_1,
		 AUD_DATA_FORMAT => SYNTHESIZED_WIRE_2,
		 AUD_LINE_IN_LC => SYNTHESIZED_WIRE_3,
		 AUD_LINE_IN_RC => SYNTHESIZED_WIRE_4,
		 AUD_POWER => SYNTHESIZED_WIRE_5,
		 AUD_SAMPLE_CTRL => SYNTHESIZED_WIRE_6,
		 AUD_SET_ACTIVE => SYNTHESIZED_WIRE_7,
		 DataL_DAC24 => SYNTHESIZED_WIRE_8,
		 DataR_DAC24 => SYNTHESIZED_WIRE_9,
		 AUD_XCK => AUD_XCK,
		 AUD_DACDAT => AUD_DACDAT,
		 valid_L => SYNTHESIZED_WIRE_27,
		 valid_R => SYNTHESIZED_WIRE_24,
		 DataL_ADC24 => SYNTHESIZED_WIRE_28,
		 DataR_ADC24 => SYNTHESIZED_WIRE_25,
		 LEDR => LEDR);


b2v_inst1 : initialize
PORT MAP(		 AUD_ADC_PATH => SYNTHESIZED_WIRE_0,
		 AUD_DAC_PATH => SYNTHESIZED_WIRE_1,
		 AUD_DATA_FORMAT => SYNTHESIZED_WIRE_2,
		 AUD_LINE_IN_LC => SYNTHESIZED_WIRE_3,
		 AUD_LINE_IN_RC => SYNTHESIZED_WIRE_4,
		 AUD_POWER => SYNTHESIZED_WIRE_5,
		 AUD_SAMPLE_CTRL => SYNTHESIZED_WIRE_6,
		 AUD_SET_ACTIVE => SYNTHESIZED_WIRE_7);


b2v_inst10 : datavalid
PORT MAP(clk => CLOCK_50,
		 valid => SYNTHESIZED_WIRE_29,
		 din => SYNTHESIZED_WIRE_11,
		 dout => SYNTHESIZED_WIRE_8);


b2v_inst11 : datavalid
PORT MAP(clk => CLOCK_50,
		 valid => SYNTHESIZED_WIRE_29,
		 din => SYNTHESIZED_WIRE_13,
		 dout => SYNTHESIZED_WIRE_9);


b2v_inst2 : delay
PORT MAP(clk => SYNTHESIZED_WIRE_14,
		 dinL => SYNTHESIZED_WIRE_15,
		 dinR => SYNTHESIZED_WIRE_16,
		 doutL => SYNTHESIZED_WIRE_11,
		 doutR => SYNTHESIZED_WIRE_13);


b2v_inst3 : initializer
PORT MAP(clk => CLOCK_50,
		 nrst => ResetKey3,
		 busy => SYNTHESIZED_WIRE_17,
		 ena => SYNTHESIZED_WIRE_18,
		 rw => SYNTHESIZED_WIRE_19,
		 addr => SYNTHESIZED_WIRE_20,
		 data => SYNTHESIZED_WIRE_21);


b2v_inst4 : i2c_master
GENERIC MAP(bus_clk => 400000,
			input_clk => 50000000
			)
PORT MAP(clk => CLOCK_50,
		 reset_n => ResetKey3,
		 ena => SYNTHESIZED_WIRE_18,
		 rw => SYNTHESIZED_WIRE_19,
		 sda => FPGA_I2C_SDAT,
		 scl => FPGA_I2C_SCLK,
		 addr => SYNTHESIZED_WIRE_20,
		 data_wr => SYNTHESIZED_WIRE_21,
		 busy => SYNTHESIZED_WIRE_17);


b2v_inst6 : clk2mhz
PORT MAP(CLOCK => CLOCK_50,
		 CLKBCLK => SYNTHESIZED_WIRE_29);


b2v_inst7 : clk2mhz
PORT MAP(CLOCK => SYNTHESIZED_WIRE_29,
		 CLKBCLK => SYNTHESIZED_WIRE_14);


b2v_inst8 : datavalid
PORT MAP(clk => SYNTHESIZED_WIRE_29,
		 valid => SYNTHESIZED_WIRE_24,
		 din => SYNTHESIZED_WIRE_25,
		 dout => SYNTHESIZED_WIRE_16);


b2v_inst9 : datavalid
PORT MAP(clk => SYNTHESIZED_WIRE_29,
		 valid => SYNTHESIZED_WIRE_27,
		 din => SYNTHESIZED_WIRE_28,
		 dout => SYNTHESIZED_WIRE_15);


END bdf_type;