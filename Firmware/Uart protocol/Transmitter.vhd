LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Transmitter IS
PORT(
	Dataready: IN	std_logic;
	Byte		: IN	std_logic_vector(7 DOWNTO 0);
	Uartclk	: IN	std_logic;
	Ready		: OUT std_logic;
	Tx			: OUT std_logic
);
END Transmitter;

ARCHITECTURE behaviour OF Transmitter IS
VARIABLE buf : std_logic_vector( 7 DOWNTO 0);
VARIABLE counter: integer := 0;
BEGIN
PROCESS( Uartclk )
BEGIN
	IF rising_edge(Uartclk) THEN
		IF counter = 0 AND Dataready = '1' THEN
			counter := 9;
			buf := Byte;
			--start condition
			Tx <= '0';
		ELSIF counter = 1 THEN
			TX <= '1';
			ready <= '1';
			counter:= counter - 1;
		ELSIF counter > 1 THEN
			--send data bits LSB first
			Tx <= buf(0);
			buf := '0' & buf(7 downto 1);
			counter := counter - 1;
		END IF;
	END IF;
END PROCESS;
END behaviour;