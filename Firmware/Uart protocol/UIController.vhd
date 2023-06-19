LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY UIController IS
PORT(
	Clk			: IN std_logic;
	Dataready	: IN std_logic;
	RXData		: IN std_logic_vector(7 DOWNTO 0);
	TXDone		: IN std_logic;
	loadbyte		: OUT std_logic;
	TXData		: OUT std_logic_vector(7 DOWNTO 0)
);

END ENTITY UIController;

ARCHITECTURE RTL OF UIcontroller IS

TYPE t_SM_TX IS (IDLE, LOAD, BUSY);
TYPE t_SM_RX IS (RECEIVING, STOP1, STOP2, STOP3, FULL);

CONSTANT bufferSize : integer := 10;

TYPE FIFOBuffer IS ARRAY(bufferSize-1 DOWNTO 0) OF std_logic_vector(7 downto 0);

SIGNAL SM_TX : t_SM_TX := IDLE;
SIGNAL SM_RX : t_SM_RX := RECEIVING;
SIGNAL inputBuffer : FIFOBuffer;
SIGNAL outputBuffer : FIFOBuffer;
SIGNAL counter				: integer RANGE 0 TO 50000000  	:= 49_995_000;
BEGIN

	PROCESS( Clk )
	VARIABLE page 					: std_logic_vector(7 downto 0):= "00110000";
	VARIABLE outputhead			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputtail			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputhead			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputtail			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputBufferLevel 	: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputBufferLevel	: integer RANGE 0 TO bufferSize 	:= 0;
	BEGIN
		IF rising_edge(clk) THEN
		
			--buffer the incoming datax
			IF Dataready = '1' and inputBufferLevel < bufferSize THEN
				inputBuffer(inputhead) <= RXData;
				inputhead := (inputhead + 1) mod bufferSize;
				inputBufferLevel := inputBufferLevel + 1;
			END IF;
			
			--process the incoming data
			
			--send commands
			IF counter >= 50_000_000 THEN
				IF outputBufferLevel < 2 THEN
					outputBuffer(outputhead) <= "01110000"; --p
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "01100001"; --a
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "01100111"; --g
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "01100101"; --e
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "00100000"; --SPACE
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= page; --page
					CASE page IS
						WHEN "00110000" 	=> page := "00110001";--1
						WHEN "00110001" 	=> page := "00110010";--2
						WHEN "00110010" 	=> page := "00110011";--3
						WHEN "00110011" 	=> page := "00110100";--4
						WHEN "00110100" 	=> page := "00110101";--5
						WHEN "00110101" 	=> page := "00110110";--6
						WHEN "00110110" 	=> page := "00110111";--7
						WHEN "00110111" 	=> page := "00111000";--8
						WHEN "00111000" 	=> page := "00111001";--9
						WHEN "00111001" 	=> page := "00110000";--0
						WHEN OTHERS 		=> page := "00000000";
					END CASE;
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputBufferLevel := outputBufferLevel + 1;
					outputhead := (outputhead + 1) mod bufferSize;
					counter <= 0;
				END IF;
			ELSE
				counter <= counter + 1;
			END IF;
			
			--IF inputBufferLevel > 0 THEN
			--	outputbuffer(outputhead) <= std_logic_vector(to_unsigned(to_integer(unsigned(inputBuffer(inputtail))) + 1, 8));
			--	inputtail	<= (inputtail 	+ 1) mod bufferSize;
			--	outputhead 	<= (outputhead + 1) mod bufferSize;
			--	inputBufferLevel 	<= inputBufferLevel 	- 1;
			--	outputBufferLevel <= outputBufferLevel + 1;
			--END IF;
			
			--output the data from the outputBuffer
			CASE SM_TX IS
				WHEN IDLE => IF outputBufferLevel > 0 THEN SM_TX <= LOAD; ELSE SM_TX <= IDLE; END IF; --if head and tail have the same value there is no data available so then stay in IDLE
				WHEN LOAD => 
					TXData <= outputBuffer(outputtail);	--output the oldest byte in the buffer
					outputtail := (outputtail+1) mod bufferSize;		--increment the tail value
					outputBufferLevel := outputBufferLevel - 1;
					loadByte <= '1';					--let the transmitter know the data is ready					
					SM_TX <= BUSY;
				WHEN BUSY =>
					loadByte <= '0';
					IF TXDone = '1' THEN SM_TX <= IDLE; ELSE SM_TX <= BUSY; END IF; --If TXDone is high the transmitter has finished transmitting the data so go back to IDLE
				WHEN OTHERS => SM_TX <= IDLE;
			END CASE;
		END IF;
	END PROCESS;

END RTL;