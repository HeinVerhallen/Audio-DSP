LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RxFIFO IS
PORT(
	Byte			: in	std_logic_vector(7 downto 0);
	Ready			: in	std_logic;
	Datarequest	: in	std_logic;
	BufferEmpty	: out	std_logic;
	BufferFull	: out	std_logic;
	Dataready	: out	std_logic;
	Data			: out	std_logic_vector(7 downto 0)
);
END RxFIFO;

ARCHITECTURE behaviour OF RxFIFO IS
--FIFO buffer is 16 bytes(128 bits) (try 2D arrays)
TYPE memory IS ARRAY(15 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
SIGNAL FIFO 	: memory;

BEGIN
PROCESS ( Ready, Datarequest )
VARIABLE bufEmpty : std_logic := '1';
VARIABLE bufFull	: std_logic := '0';

VARIABLE head	: integer := 0;
VARIABLE tail	: integer := 0;

BEGIN

	IF Ready = '1' THEN
		Dataready <= '0';
		IF bufFull = '0' THEN
			FIFO(head) <= Byte;
			head := (head + 1) mod 16;
		END IF;
		
		IF bufEmpty = '1' THEN
			bufEmpty := '0';
			BufferEmpty <= '0';
		END IF;
		
		IF head = tail THEN
			bufFull := '1';
			BufferFull <= '1';
		ELSE
			bufFull := '0';
			BufferFull <= '0';
		END IF;
	END IF;
	
	IF Datarequest = '1' THEN
		Data <= FIFO(tail);
		FIFO(tail) <= "XXXXXXXX";
		Dataready <= '1';
		tail := (tail + 1) mod 16;
		
		IF bufFull = '1' THEN
			bufFull := '0';
			BufferFull <= '0';
		END IF;
		
		IF tail = head THEN
			bufEmpty := '1';
			BufferEmpty <= '1';
		ELSE
			bufEmpty := '0';
			BufferEmpty <= '0';
		END IF;
	END IF;

END PROCESS;
END behaviour;	