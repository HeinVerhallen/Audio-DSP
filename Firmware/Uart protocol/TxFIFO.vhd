LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TxFIFO IS
PORT(
	Data			: in	std_logic_vector(7 downto 0);
	Load			: in	std_logic;
	Ready			: in	std_logic;
	BufferFull	: out	std_logic := '0';
	dataReady	: out	std_logic;
	Byte			: out	std_logic_vector(7 downto 0)
);
END TxFIFO;

ARCHITECTURE behaviour OF TxFIFO IS 
--FIFO buffer is 16 bytes(128 bits) (try 2D arrays)
TYPE memory IS ARRAY(15 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
signal FIFO 	: memory;
BEGIN
PROCESS ( Load, Ready )
VARIABLE bufFull : std_logic := '0'; 

VARIABLE head	: integer := 0;
VARIABLE tail	: integer := 0;
BEGIN
	IF ready = '1' THEN
		Byte <= FIFO(tail);
		Dataready <= '1';
		tail := (tail + 1) mod 16;
		
		IF bufFull = '1' THEN
			bufFull := '0';
			BufferFull <= '0';
		END IF;
		
	ELSIF Load = '1' THEN
		Dataready <= '0';
		
		IF bufFull = '0' THEN
			--insert incoming byte
			FIFO(head) <= Data;
			
			--update head position
			head := (head + 1) mod 16;
			
			--full condition (if after byte is loaded the head = tail then the buffer must be full)
			IF head = tail THEN
				bufFull := '1';
				BufferFull <= '1';
			ELSE
				bufFull := '0';
				BufferFull <= '0';
			END IF;
		END IF;
	END IF;
END PROCESS;

END behaviour;