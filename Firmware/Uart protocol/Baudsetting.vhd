LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BaudSetting IS
PORT(
	sysClk	: in		std_logic;
	Uartclk	: out	std_logic := '0'
);
END BaudSetting;

ARCHITECTURE behaviour OF BaudSetting IS
SIGNAL uartfrq :integer := 50000000/9600;
SIGNAL counter : integer := 0;
SIGNAL state : std_logic := '0';
BEGIN
PROCESS ( sysClk )
BEGIN
	counter <= counter + 1;
	
	IF counter = uartfrq THEN
		counter <= 0;
		Uartclk <= state;
		state <= not state;
	END IF;
END PROCESS;

END behaviour;