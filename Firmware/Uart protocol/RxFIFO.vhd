LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RxFIFO IS
PORT(
	Byte			: in	std_logic_vector(7 downto 0);
	Ready			: in	std_logic;
	BufferEmpty	: out	std_logic;
	BufferFull	: out	std_logic;
	Data			: out	std_logic_vector(7 downto 0)
);
END RxFIFO;

ARCHITECTURE behaviour OF RxFIFO IS
BEGIN

END behaviour;