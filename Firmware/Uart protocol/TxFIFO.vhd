LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TxFIFO IS
PORT(
	Data			: in	std_logic_vector(7 downto 0);
	Load			: in	std_logic;
	Ready			: in	std_logic;
	BufferFull	: out	std_logic;
	dataReady	: out	std_logic;
	Byte			: out	std_logic_vector(7 downto 0)
);
END TxFIFO;

ARCHITECTURE behaviour OF TxFIFO IS
BEGIN

END behaviour;