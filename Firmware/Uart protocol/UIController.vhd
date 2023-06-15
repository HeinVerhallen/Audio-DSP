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

CONSTANT bufferSize : integer := 8;

TYPE FIFOBuffer IS ARRAY(bufferSize-1 DOWNTO 0) OF std_logic_vector(7 downto 0);

SIGNAL SM_TX : t_SM_TX := IDLE;
SIGNAL SM_RX : t_SM_RX := RECEIVING;
SIGNAL inputBuffer : FIFOBuffer;
SIGNAL outputBuffer : FIFOBuffer;
SIGNAL head : integer RANGE 0 TO bufferSize := 0;
SIGNAL tail : integer RANGE 0 TO bufferSize := 0;

SIGNAL outputhead			: integer RANGE 0 TO bufferSize := 0;
SIGNAL outputtail			: integer RANGE 0 TO bufferSize := 0;
SIGNAL inputhead			: integer RANGE 0 TO bufferSize := 0;
SIGNAL inputtail			: integer RANGE 0 TO bufferSize := 0;
SIGNAL inputBufferLevel : integer RANGE 0 TO bufferSize := 0;
SIGNAL outputBufferLevel: integer RANGE 0 TO bufferSize := 0;
SIGNAL counter				: integer RANGE 0 TO 1 			  := 0;
BEGIN

	PROCESS( Clk )
	BEGIN
		IF rising_edge(clk) THEN
		
			--buffer the incoming datax
			IF Dataready = '1' and inputBufferLevel < bufferSize THEN
				inputBuffer(inputhead) <= RXData;
				inputhead <= (inputhead + 1) mod bufferSize;
				inputBufferLevel <= inputBufferLevel + 1;
			END IF;
			
			--process the incoming data
			
			--send commands
			IF counter = 0 THEN
				outputBuffer(outputhead) <= "00000000";
				outputBufferLevel <= outputBufferLevel + 1;
				outputhead <= outputhead + 1;
				counter <= counter + 1;
			END IF;
			
			IF inputBufferLevel > 0 THEN
				outputbuffer(outputhead) <= std_logic_vector(to_unsigned(to_integer(unsigned(inputBuffer(inputtail))) + 1, 8));
				inputtail	<= (inputtail 	+ 1) mod bufferSize;
				outputhead 	<= (outputhead + 1) mod bufferSize;
				inputBufferLevel 	<= inputBufferLevel 	- 1;
				outputBufferLevel <= outputBufferLevel + 1;
			END IF;
			
			--output the data from the outputBuffer
			CASE SM_TX IS
				WHEN IDLE => IF outputBufferLevel > 0 THEN SM_TX <= LOAD; ELSE SM_TX <= IDLE; END IF; --if head and tail have the same value there is no data available so then stay in IDLE
				WHEN LOAD => 
					TXData <= outputBuffer(outputtail);	--output the oldest byte in the buffer
					outputBuffer(outputtail) <= "XXXXXXXX";
					outputtail <= (outputtail+1) mod bufferSize;		--increment the tail value
					outputBufferLevel <= outputBufferLevel - 1;
					loadByte <= '1';					--let the transmitter know the data is ready					
					SM_TX <= BUSY;
				WHEN BUSY =>
					loadByte <= '0';
					IF TXDone = '1' THEN SM_TX <= IDLE; ELSE SM_TX <= BUSY; END IF; --If TXDone is high the transmitter has finished transmitting the data so go back to IDLE
				WHEN OTHERS => SM_TX <= IDLE;
			END CASE;
		END IF;
		head <= outputhead;
		tail <= outputtail;
	END PROCESS;

END RTL;