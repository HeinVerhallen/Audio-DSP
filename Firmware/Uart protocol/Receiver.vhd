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

PROCESS ( Uartclk )
VARIABLE buf 			: std_logic_vector(7 DOWNTO 0);
VARIABLE receiving 	: BOOLEAN;
variable counter		: INTEGER := 0;
BEGIN
	IF RISING_EDGE(Uartclk) THEN
		IF counter = 0 THEN
			buf := "00000000";
			ready <= '0';
			IF RX = '0' THEN
				counter := 9;
			END IF;
		ELSIF counter = 1 THEN
			Byte <= buf;
			ready <= '1';
			counter := counter - 1;
		ELSIF counter >= 1 THEN
			buf := RX & buf(7 downto 1);
			counter := counter - 1;
		END IF;
	END IF;

END PROCESS;

END behaviour;