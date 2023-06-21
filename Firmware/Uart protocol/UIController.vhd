LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY UIController IS
PORT(
	Clk			: IN std_logic;
	Dataready	: IN std_logic;
	RXData		: IN std_logic_vector(7 DOWNTO 0);
	TXDone		: IN std_logic;
	leftInput	: IN std_logic;
	rightInput	: IN std_logic;
	pressInput	: IN std_logic;
	loadbyte		: OUT std_logic;
	TXData		: OUT std_logic_vector(7 DOWNTO 0);
	page			: OUT std_logic_vector(3 DOWNTO 0);
	button		: OUT std_logic_vector(3 DOWNTO 0)
);

END ENTITY UIController;

ARCHITECTURE RTL OF UIcontroller IS

TYPE t_SM_TX IS (IDLE, LOAD, BUSY);
TYPE t_SM_RX IS (RECEIVING, STOP1, STOP2, STOP3, FULL);

CONSTANT bufferSize 		: integer := 10;
CONSTANT numberOfPages 	: integer := 12;
CONSTANT maxElements		: integer := 6;

TYPE FIFOBuffer IS ARRAY(bufferSize-1 DOWNTO 0) OF std_logic_vector(7 downto 0);

SIGNAL SM_TX : t_SM_TX := IDLE;
SIGNAL SM_RX : t_SM_RX := RECEIVING;
SIGNAL inputBuffer : FIFOBuffer;
SIGNAL outputBuffer : FIFOBuffer;

BEGIN

	PROCESS( Clk )
	
	CONSTANT RCA1	: integer := 100;
	CONSTANT RCA2	: integer := 101;
	CONSTANT TRS1	: integer := 102;
	CONSTANT TRS2	: integer := 103;
	CONSTANT XLR1	: integer := 104;
	CONSTANT XLR2	: integer := 105;
	CONSTANT USB	: integer := 106;
	
	CONSTANT CH1	: integer := 201;
	CONSTANT CH2	: integer := 202;
	CONSTANT CH3	: integer := 203;
	CONSTANT CH4	: integer := 204;
	CONSTANT CH5	: integer := 205;

	CONSTANT homeScreen		: integer := 0;
	CONSTANT signalRouting	: integer := 1;
	CONSTANT inputSelect1	: integer := 2;
	CONSTANT inputSelect2	: integer := 3;
	CONSTANT channel121		: integer := 4;
	CONSTANT channel122		: integer := 5;
	CONSTANT channel34		: integer := 6;
	CONSTANT channel5			: integer := 7;
	CONSTANT firstchannel1	: integer := 8;
	CONSTANT firstchannel2	: integer := 9;
	CONSTANT secondchannel1	: integer := 10;
	CONSTANT secondchannel2 : integer := 11;
	CONSTANT effects			: integer := 0;
	CONSTANT presets			: integer := 0;
	
	VARIABLE pressedFunction 	: integer := 0;
	VARIABLE highlighted 		: integer := 1;
	VARIABLE currentPage 		: integer := 0;
	
	VARIABLE outputhead			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputtail			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputhead			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputtail			: integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputBufferLevel : integer RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputBufferLevel: integer RANGE 0 TO bufferSize 	:= 0;
	
	
	TYPE pageArray IS ARRAY(0 TO numberOfPages-1, 0 TO maxElements-1) OF integer RANGE 0 TO 256;
	
	CONSTANT functions : pageArray := (
	(signalRouting	,effects			,presets			,0					,0					,3),--0  homeScreen
	(homeScreen		,inputSelect1	,firstChannel1	,0					,0					,3),--1  signalRouting
	(signalRouting	,channel121		,channel121		,channel34		,inputSelect2	,4),--2  inputSelect1
	(signalRouting	,channel34		,channel5		,inputSelect1	,0					,3),--3  inputSelect2
	(signalrouting	,RCA1				,RCA2				,TRS1				,channel122		,4),--4  channel121
	(signalRouting	,TRS2				,channel121		,0					,0					,3),--5  channel122
	(signalRouting	,XLR1				,XLR2				,0					,0					,3),--6  channel34
	(signalRouting	,USB				,0					,0					,0					,2),--7  channel5
	(signalRouting	,CH1				,CH2				,CH3				,firstchannel2	,4),--8  firstchannel1
	(signalRouting	,CH4				,CH5				,firstchannel2	,0					,3),--9  firstchannel2
	(firstchannel1	,CH1				,CH2				,CH3				,secondchannel2,4),--10 secondchannel1
	(firstchannel1	,CH4				,0					,0					,0					,2) --11 secondchannel2
	);
	
	VARIABLE pressState 	: std_logic := '1';
	VARIABLE leftState 	: std_logic := '1';
	VARIABLE rightState 	: std_logic := '1';
	
	BEGIN
		page <= std_logic_vector(to_unsigned(currentPage, 4));
		button <= std_logic_vector(to_unsigned(highlighted, 4));
		IF rising_edge(clk) THEN
		
			--buffer the incoming datax
			IF Dataready = '1' and inputBufferLevel < bufferSize THEN
				inputBuffer(inputhead) <= RXData;
				inputhead := (inputhead + 1) mod bufferSize;
				inputBufferLevel := inputBufferLevel + 1;
			END IF;
			
			--process the incoming data
			IF pressInput = NOT pressState THEN
				pressState := pressInput;
				IF pressState = '0' AND outputBufferLevel < bufferSize-9 THEN
					pressedFunction := functions(currentPage, highlighted);
					--goto function update page
					outputBuffer(outputhead) <= "01110000"; --p
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "01100001"; --a
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "01100111"; --g
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "01100101"; --e
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "00100000"; --SPACE
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "0011" & std_logic_vector(to_unsigned(pressedFunction, 4)); --page
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					outputBuffer(outputhead) <= "11111111"; --0xFF
					outputhead := (outputhead + 1) mod bufferSize;
					outputBufferLevel := (outputBufferLevel + 1);
					
					currentPage := pressedFunction;
					highlighted := 1;
				END IF;
			END IF;
			
			IF rightState = NOT rightInput THEN
				rightState := rightInput;
				IF rightState = '0' THEN
					highlighted := (highlighted + 1) mod functions(currentPage, maxElements-1);
				END IF;
			END IF;
			
			IF leftState = NOT leftInput THEN
				IF leftInput = '1' THEN
					IF highlighted >= 1 THEN
						highlighted := highlighted -1;
					ELSE
						highlighted := functions(currentPage, maxElements-1);
					END IF;
				END IF;
			END IF;
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