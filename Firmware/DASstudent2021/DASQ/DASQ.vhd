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
-- CREATED		"Sun Jul 24 15:26:46 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY DASQ IS 
	PORT
	(
		nrst :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		minoi :  IN  STD_LOGIC;
		nuloi :  IN  STD_LOGIC;
		plusoi :  IN  STD_LOGIC;
		SL24 :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		SR24 :  IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
		writeadc :  OUT  STD_LOGIC;
		mino :  OUT  STD_LOGIC;
		nulo :  OUT  STD_LOGIC;
		pluso :  OUT  STD_LOGIC;
		loadpiso_c :  OUT  STD_LOGIC;
		decoa :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0);
		decob :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END DASQ;

ARCHITECTURE bdf_type OF DASQ IS 

COMPONENT mux1
	PORT(soLo : IN STD_LOGIC;
		 soRo : IN STD_LOGIC;
		 chsel_c : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 so : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT sfcontr
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 readadc : OUT STD_LOGIC;
		 shL_c : OUT STD_LOGIC;
		 shR_c : OUT STD_LOGIC;
		 syncadd_c : OUT STD_LOGIC;
		 loadpiso_c : OUT STD_LOGIC;
		 chsel_c : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT syncdet
	PORT(mins : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 pluss : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 syncdetectedo : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT sipo
	PORT(clk : IN STD_LOGIC;
		 shift : IN STD_LOGIC;
		 sinput : IN STD_LOGIC;
		 parout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT demux1
	PORT(sbits : IN STD_LOGIC;
		 chdesel_c : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sorL : OUT STD_LOGIC;
		 sorR : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT decryptionblock
	PORT(encrypteddatain : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 decrypteddataout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT encryptionblock
	PORT(datain : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 encrypeddataout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rfcontr
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 syncdetected_c : IN STD_LOGIC;
		 siL_c : OUT STD_LOGIC;
		 SiR_c : OUT STD_LOGIC;
		 writeadc : OUT STD_LOGIC;
		 chdesel_c : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT piso
	PORT(shift_c : IN STD_LOGIC;
		 loadpiso_c : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 encrypteddatain : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 serout : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT hdb3dec
	PORT(nrst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 mino : IN STD_LOGIC;
		 nulo : IN STD_LOGIC;
		 pluso : IN STD_LOGIC;
		 sbits : OUT STD_LOGIC;
		 mins : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 pluss : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hdb3enc
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 so : IN STD_LOGIC;
		 syncadd_c : IN STD_LOGIC;
		 LWout : OUT STD_LOGIC;
		 hmin : OUT STD_LOGIC;
		 hnul : OUT STD_LOGIC;
		 hplus : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT addsync
	PORT(Lwino : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 hmino : IN STD_LOGIC;
		 hnulo : IN STD_LOGIC;
		 hpluso : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 syncaddo : IN STD_LOGIC;
		 mino : OUT STD_LOGIC;
		 nulo : OUT STD_LOGIC;
		 pluso : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	encrL :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	encrR :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	hmin :  STD_LOGIC;
SIGNAL	hnul :  STD_LOGIC;
SIGNAL	hplus :  STD_LOGIC;
SIGNAL	LWout :  STD_LOGIC;
SIGNAL	muxOut :  STD_LOGIC;
SIGNAL	seroutL :  STD_LOGIC;
SIGNAL	seroutR :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC;


BEGIN 
mino <= SYNTHESIZED_WIRE_12;
nulo <= SYNTHESIZED_WIRE_13;
pluso <= SYNTHESIZED_WIRE_14;
loadpiso_c <= SYNTHESIZED_WIRE_21;



b2v_inst : mux1
PORT MAP(soLo => seroutL,
		 soRo => seroutR,
		 chsel_c => SYNTHESIZED_WIRE_0,
		 so => muxOut);


b2v_inst1 : sfcontr
PORT MAP(clk => clk,
		 nrst => nrst,
		 shL_c => SYNTHESIZED_WIRE_10,
		 shR_c => SYNTHESIZED_WIRE_15,
		 syncadd_c => SYNTHESIZED_WIRE_22,
		 loadpiso_c => SYNTHESIZED_WIRE_21,
		 chsel_c => SYNTHESIZED_WIRE_0);


b2v_inst10 : syncdet
PORT MAP(mins => SYNTHESIZED_WIRE_1,
		 pluss => SYNTHESIZED_WIRE_2,
		 syncdetectedo => SYNTHESIZED_WIRE_9);


b2v_inst11 : sipo
PORT MAP(clk => clk,
		 shift => SYNTHESIZED_WIRE_3,
		 sinput => SYNTHESIZED_WIRE_4,
		 parout => SYNTHESIZED_WIRE_8);


b2v_inst12 : demux1
PORT MAP(sbits => SYNTHESIZED_WIRE_5,
		 chdesel_c => SYNTHESIZED_WIRE_6,
		 sorL => SYNTHESIZED_WIRE_18,
		 sorR => SYNTHESIZED_WIRE_4);


b2v_inst13 : decryptionblock
PORT MAP(encrypteddatain => SYNTHESIZED_WIRE_7,
		 decrypteddataout => decoa);


b2v_inst14 : decryptionblock
PORT MAP(encrypteddatain => SYNTHESIZED_WIRE_8,
		 decrypteddataout => decob);


b2v_inst15 : encryptionblock
PORT MAP(datain => SL24,
		 encrypeddataout => encrL);


b2v_inst16 : encryptionblock
PORT MAP(datain => SR24,
		 encrypeddataout => encrR);


b2v_inst18 : rfcontr
PORT MAP(clk => clk,
		 nrst => nrst,
		 syncdetected_c => SYNTHESIZED_WIRE_9,
		 siL_c => SYNTHESIZED_WIRE_17,
		 SiR_c => SYNTHESIZED_WIRE_3,
		 writeadc => writeadc,
		 chdesel_c => SYNTHESIZED_WIRE_6);


b2v_inst19 : piso
PORT MAP(shift_c => SYNTHESIZED_WIRE_10,
		 loadpiso_c => SYNTHESIZED_WIRE_21,
		 clk => clk,
		 encrypteddatain => encrL,
		 serout => seroutL);


b2v_inst2 : hdb3dec
PORT MAP(nrst => nrst,
		 clk => clk,
		 mino => SYNTHESIZED_WIRE_12,
		 nulo => SYNTHESIZED_WIRE_13,
		 pluso => SYNTHESIZED_WIRE_14,
		 sbits => SYNTHESIZED_WIRE_5,
		 mins => SYNTHESIZED_WIRE_1,
		 pluss => SYNTHESIZED_WIRE_2);


b2v_inst20 : piso
PORT MAP(shift_c => SYNTHESIZED_WIRE_15,
		 loadpiso_c => SYNTHESIZED_WIRE_21,
		 clk => clk,
		 encrypteddatain => encrR,
		 serout => seroutR);


b2v_inst5 : sipo
PORT MAP(clk => clk,
		 shift => SYNTHESIZED_WIRE_17,
		 sinput => SYNTHESIZED_WIRE_18,
		 parout => SYNTHESIZED_WIRE_7);


b2v_inst8 : hdb3enc
PORT MAP(clk => clk,
		 nrst => nrst,
		 so => muxOut,
		 syncadd_c => SYNTHESIZED_WIRE_22,
		 LWout => LWout,
		 hmin => hmin,
		 hnul => hnul,
		 hplus => hplus);


b2v_inst9 : addsync
PORT MAP(Lwino => LWout,
		 clk => clk,
		 hmino => hmin,
		 hnulo => hnul,
		 hpluso => hplus,
		 nrst => nrst,
		 syncaddo => SYNTHESIZED_WIRE_22,
		 mino => SYNTHESIZED_WIRE_12,
		 nulo => SYNTHESIZED_WIRE_13,
		 pluso => SYNTHESIZED_WIRE_14);


END bdf_type;