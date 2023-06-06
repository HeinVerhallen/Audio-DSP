LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY BaudSetting IS
PORT(
	Baudrate	: in	std_logic_vector(3 downto 0);
	sysClk	: in	std_logic;
	Uartclk	: out	std_logic
);
END BaudSetting;

ARCHITECTURE behaviour OF BaudSetting IS
BEGIN

END behaviour;