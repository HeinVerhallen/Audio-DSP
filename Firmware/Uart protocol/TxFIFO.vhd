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

ARCHITECTURE behaviour OF TxFIFO 
--FIFI buffer is 16 bytes(128 bits)
variable FIFO 	: std_logic_vector(127 downto 0);
variable head	: integer := 0;
variable tail	: integer := 0;
BEGIN
PROCESS ( Load, Ready )
	IF Load = '1' THEN
	--not sure if this works
		FIFO := FIFO(127 downto (127-16*head)) & Data & FIFO((16*head) downto 0);
	END IF;
END PROCESS;

END behaviour;