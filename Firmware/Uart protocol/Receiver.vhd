LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Receiver IS
PORT(
	RX			: in	std_logic;
	Uartclk	: in	std_logic;
	Ready		: out std_logic;
	Byte		: out std_logic_vector(7 downto 0)
);
END Receiver;

ARCHITECTURE behaviour OF Receiver IS
BEGIN

END behaviour;