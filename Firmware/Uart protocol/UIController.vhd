LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY UIController IS
PORT(
	Nrst			: IN STD_LOGIC;
	Clk			: IN STD_LOGIC;
	Dataready	: IN STD_LOGIC;
	RXData		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	TXDone		: IN STD_LOGIC;
	leftInput	: IN STD_LOGIC;
	rightInput	: IN STD_LOGIC;
	pressInput	: IN STD_LOGIC;
	loadbyte		: OUT STD_LOGIC;
	TXData		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	page1			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	page2			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	button		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);

END ENTITY UIController;

ARCHITECTURE RTL OF UIcontroller IS

--FUNCTION convertToPercentage (maxValue		: INTEGER;
--										minValue 	: INTEGER;
--										currentVal	: INTEGER) RETURN INTEGER IS
--BEGIN
--	
--
--END FUNCTION;
--
--FUNCTION convertFromPercentage (	maxValue		: INTEGER;
--											minValue 	: INTEGER;
--											percentage	: INTEGER) RETURN INTEGER IS
--BEGIN
--	
--
--END FUNCTION;

TYPE t_SM_TX IS (IDLE, LOAD, BUSY);
TYPE t_SM_RX IS (RECEIVING, STOP1, STOP2, STOP3, FULL);

CONSTANT bufferSize 			: INTEGER := 64;
CONSTANT numberOfPages 		: INTEGER := 28;
CONSTANT numberOfChannels	: INTEGER := 6;
CONSTANT maxElements			: INTEGER := 7;
CONSTANT settingsData		: INTEGER := 143;

TYPE FIFOBuffer IS ARRAY(bufferSize-1 DOWNTO 0) OF STD_LOGIC_VECTOR(7 downto 0);

SIGNAL SM_TX 			: t_SM_TX := IDLE;
SIGNAL SM_RX 			: t_SM_RX := RECEIVING;
SIGNAL inputBuffer 	: FIFOBuffer;
SIGNAL outputBuffer	: FIFOBuffer;
SIGNAL emptyBuffer	: FIFOBuffer := (OTHERS => "XXXXXXXX");
SIGNAL updatepage		: INTEGER	:= 0;

BEGIN
	PROCESS( Clk, Nrst )
	CONSTANT homeScreen			: INTEGER := 000;
	CONSTANT signalRouting		: INTEGER := 001;
	CONSTANT inputSelect1		: INTEGER := 002;
	CONSTANT inputSelect2		: INTEGER := 003;
	CONSTANT channel121			: INTEGER := 004;
	CONSTANT channel122			: INTEGER := 005;
	CONSTANT channel34			: INTEGER := 006;
	CONSTANT channel5				: INTEGER := 007;
	CONSTANT firstchannel1		: INTEGER := 008;
	CONSTANT firstchannel2		: INTEGER := 009;
	CONSTANT secondchannel1		: INTEGER := 010;
	CONSTANT secondchannel2 	: INTEGER := 011;
	CONSTANT effects1				: INTEGER := 012;
	CONSTANT effects2				: INTEGER := 013;
	CONSTANT effectselect1		: INTEGER := 014;
	CONSTANT effectselect2		: INTEGER := 015;
	CONSTANT gain					: INTEGER := 016;
	CONSTANT jackgain				: INTEGER := 017;
	CONSTANT equalizer			: INTEGER := 018;
	CONSTANT delay					: INTEGER := 019;
	CONSTANT reverb				: INTEGER := 020;
	CONSTANT presets				: INTEGER := 021;
	CONSTANT loadpreset1			: INTEGER := 022;
	CONSTANT loadpreset2			: INTEGER := 023;
	CONSTANT loadconfirm			: INTEGER := 024;
	CONSTANT adjustpreset1		: INTEGER := 025;
	CONSTANT adjustpreset2		: INTEGER := 026;
	CONSTANT adjustconfirm		: INTEGER := 027;
	
	CONSTANT RCA1					: INTEGER := 100;
	CONSTANT RCA2					: INTEGER := 101;
	CONSTANT TRS1					: INTEGER := 102;
	CONSTANT TRS2					: INTEGER := 103;
	CONSTANT XLR1					: INTEGER := 104;
	CONSTANT XLR2					: INTEGER := 105;
	CONSTANT USB					: INTEGER := 106;
	
	CONSTANT firstCH1				: INTEGER := 107;
	CONSTANT firstCH2				: INTEGER := 108;
	CONSTANT firstCH3				: INTEGER := 109;
	CONSTANT firstCH4				: INTEGER := 110;
	CONSTANT firstCH5				: INTEGER := 111;
	CONSTANT firstCH6				: INTEGER := 112;
	CONSTANT secondCH1			: INTEGER := 113;
	CONSTANT secondCH2			: INTEGER := 114;
	CONSTANT secondCH3			: INTEGER := 115;
	CONSTANT secondCH4			: INTEGER := 116;
	CONSTANT secondCH5			: INTEGER := 117;
	
	CONSTANT CH1					: INTEGER := 118;
	CONSTANT CH2					: INTEGER := 119;
	CONSTANT CH3					: INTEGER := 120;
	CONSTANT CH4					: INTEGER := 121;
	CONSTANT CH5					: INTEGER := 122;
	CONSTANT CH6					: INTEGER := 123;
	CONSTANT volume				: INTEGER := 124;
	CONSTANT channelgain			: INTEGER := 125;
	CONSTANT inputgain			: INTEGER := 126;
	CONSTANT f0						: INTEGER := 127;
	CONSTANT f1						: INTEGER := 128;
	CONSTANT f2						: INTEGER := 129;
	CONSTANT f3						: INTEGER := 130;
	CONSTANT f4						: INTEGER := 131;
	CONSTANT dtime					: INTEGER := 132;
	CONSTANT feedback				: INTEGER := 133;
	CONSTANT mix					: INTEGER := 134;
	CONSTANT rlength				: INTEGER := 135;
	CONSTANT rsize					: INTEGER := 136;
	
	CONSTANT preset1				: INTEGER := 137;
	CONSTANT preset2				: INTEGER := 138;
	CONSTANT preset3				: INTEGER := 139;
	CONSTANT preset4				: INTEGER := 140;
	CONSTANT preset5				: INTEGER := 141;
	CONSTANT preset6				: INTEGER := 142;
	CONSTANT changepreset1		: INTEGER := 143;
	CONSTANT changepreset2		: INTEGER := 144;
	CONSTANT changepreset3		: INTEGER := 145;
	CONSTANT changepreset4		: INTEGER := 146;
	CONSTANT changepreset5		: INTEGER := 147;
	CONSTANT changepreset6		: INTEGER := 148;
	CONSTANT confirmload			: INTEGER := 149;
	CONSTANT confirmadjust		: INTEGER := 150;
	
	VARIABLE pressedFunction 	: INTEGER := 0;
	VARIABLE highlighted 		: INTEGER := 0;
	VARIABLE currentPage 		: INTEGER := 0;
	VARIABLE activeChannel		: INTEGER := 0;
	
	VARIABLE outputhead			: INTEGER RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputtail			: INTEGER RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputhead			: INTEGER RANGE 0 TO bufferSize 	:= 0;
	VARIABLE inputBufferLevel 	: INTEGER RANGE 0 TO bufferSize 	:= 0;
	VARIABLE outputBufferLevel	: INTEGER RANGE 0 TO bufferSize 	:= 0;
	
	
	TYPE pageArray 	IS ARRAY	(0 TO numberOfPages-1, 0 TO maxElements-1)	OF INTEGER RANGE 0 TO 256;
	TYPE effectArray 	IS ARRAY	(0 TO numberofChannels-1)							OF UNSIGNED(31 DOWNTO 0);
	TYPE routingArray	IS ARRAY (0 TO numberOfChannels-1)							OF UNSIGNED(15 DOWNTO 0);
	
	CONSTANT functions : pageArray := (
	(signalRouting	,effects1		,presets			,0					,0					,0					,3),--0  homeScreen
	(inputSelect1	,firstChannel1	,homeScreen		,0					,0					,0					,3),--1  signalRouting
	(channel121		,channel121		,channel34		,inputSelect2	,0					,0					,4),--2  inputSelect1
	(channel34		,channel5		,inputSelect1	,signalRouting	,0					,0					,4),--3  inputSelect2
	(RCA1				,RCA2				,TRS1				,channel122		,0					,0					,4),--4  channel121
	(TRS2				,channel121		,inputSelect1	,0					,0					,0					,3),--5  channel122
	(XLR1				,XLR2				,inputSelect1	,0					,0					,0					,3),--6  channel34
	(USB				,inputSelect1	,0					,0					,0					,0					,2),--7  channel5
	(firstCH1		,firstCH2		,firstCH3		,firstchannel2	,0					,0					,4),--8  firstchannel1
	(firstCH4		,firstCH5		,firstCH6		,firstchannel1	,signalRouting	,0					,5),--9  firstchannel2
	(secondCH1		,secondCH2		,secondCH3		,secondchannel2,0					,0					,4),--10 secondchannel1 A
	(secondCH4		,secondCH5		,secondchannel1,firstchannel1	,0					,0					,4),--11 secondchannel2 B
	(CH1				,CH2				,CH3				,effects2		,0					,0					,4),--12 effects1			C
	(CH4				,CH5				,CH6				,effects1		,homescreen		,0					,5),--13 effects2			D
	(equalizer		,volume			,delay			,effectselect2	,0					,0					,4),--14 effectselect1	E
	(reverb			,effectselect1	,effects1		,0					,0					,0					,3),--15 effectselect2	F
	(channelgain	,effectselect1	,0					,0					,0					,0					,2),--16 gain
	(inputgain		,channelgain	,effectselect1	,0					,0					,0					,3),--17 jackgain
	(f0				,f1				,f2				,f3				,f4				,effectselect1	,6),--18 equalizer
	(dtime			,feedback		,mix				,effectselect1	,0					,0					,4),--19 Delay
	(rLength			,rSize			,effectselect1	,0					,0					,0					,3),--20 Reverb
	(loadpreset1	,adjustpreset1	,homescreen		,0					,0					,0					,3),--21 presets
	(preset1			,preset2			,preset3			,loadpreset2	,0					,0					,4),--22 loadpreset1
	(preset4			,preset5			,preset6			,loadpreset1	,presets			,0					,5),--23 loadpreset2
	(confirmLoad	,loadpreset1	,0					,0					,0					,0					,2),--24 loadconfirm
	(changepreset1	,changepreset2	,changepreset3	,adjustpreset2	,0					,0					,4),--25 adjustpreset1
	(changepreset4	,changepreset5	,changepreset6	,adjustpreset1	,presets			,0					,5),--26 adjustpreset2
	(confirmAdjust	,adjustpreset1	,0					,0					,0					,0					,2) --27 adjustconfirm
	);
	
CONSTANT routingmask 		: UNSIGNED(settingsData-1 DOWNTO 0) := "111_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT sourceselectmask	: UNSIGNED(settingsData-1 DOWNTO 0) := "000_1_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT inputlevelmask		: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_11111111_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT linkchannelmask	: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_111_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT gainlevelmask		: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_11111111111111111111111111111111_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT delaytimemask		: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_111111111111_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT delayfeedbackmask	: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_1111111111_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT delaymixmask		: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_1111111111_0000000000000000_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT reverblengthmask	: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_1111111111111111_0000000000000000_000000_000000_000000_000000_000000_00";
CONSTANT reverbsizemask		: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_1111111111111111_000000_000000_000000_000000_000000_00";
CONSTANT gainf0mask			: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_111111_000000_000000_000000_000000_00";
CONSTANT gainf1mask			: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_111111_000000_000000_000000_00";
CONSTANT gainf2mask			: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_111111_000000_000000_00";
CONSTANT gainf3mask			: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_111111_000000_00";
CONSTANT gainf4mask			: UNSIGNED(settingsData-1 DOWNTO 0) := "000_0_00000000_000_00000000000000000000000000000000_000000000000_0000000000_0000000000_0000000000000000_0000000000000000_000000_000000_000000_000000_111111_00";

VARIABLE Equalizer : effectArray := (
	"00100000100000100000100000100000", --channel 1(0dB, 0dB, 0dB, 0dB, 0dB)
	"00100000100000100000100000100000", --channel 2(0dB, 0dB, 0dB, 0dB, 0dB) 
	"00100000100000100000100000100000", --channel 3(0dB, 0dB, 0dB, 0dB, 0dB)
	"00100000100000100000100000100000", --channel 4(0dB, 0dB, 0dB, 0dB, 0dB)
	"00100000100000100000100000100000", --channel 5(0dB, 0dB, 0dB, 0dB, 0dB)
	"00100000100000100000100000100000"  --channel 6(0dB, 0dB, 0dB, 0dB, 0dB)
);

VARIABLE Gain : effectArray := (
	"00000000000000000000000000000000", -- channel 1
	"00000000000000000000000000000000", -- channel 2
	"00000000000000000000000000000000", -- channel 3
	"00000000000000000000000000000000", -- channel 4
	"00000000000000000000000000000000", -- channel 5
	"00000000000000000000000000000000"  -- channel 6
);

VARIABLE Delay	: effectArray := (
	"00000000000000000000000000000000", -- channel 1 (0,01x, 0ms, 1ms)
	"00000000000000000000000000000000", -- channel 2 (0,01x, 0ms, 1ms)
	"00000000000000000000000000000000", -- channel 3 (0,01x, 0ms, 1ms)
	"00000000000000000000000000000000", -- channel 4 (0,01x, 0ms, 1ms)
	"00000000000000000000000000000000", -- channel 5 (0,01x, 0ms, 1ms)
	"00000000000000000000000000000000"  -- channel 6 (0,01x, 0ms, 1ms)
);

VARIABLE Reverb	: effectArray := (
	"00000000000000000000000000000000", -- channel 1 (0ms, 1ms)
	"00000000000000000000000000000000", -- channel 2 (0ms, 1ms)
	"00000000000000000000000000000000", -- channel 3 (0ms, 1ms)
	"00000000000000000000000000000000", -- channel 4 (0ms, 1ms)
	"00000000000000000000000000000000", -- channel 5 (0ms, 1ms)
	"00000000000000000000000000000000"  -- channel 6 (0ms, 1ms)
);

VARIABLE outputrouting : routingArray := (
	"0010011000101000", --channel 1 (input 3, RCA, +3dB, no link)
	"0010011000101000", --channel 2 (input 3, RCA, +3dB, no link)
	"0010011000101000", --channel 3 (input 3, RCA, +3dB, no link)
	"0011011000101000", --channel 4 (input 4, RCA, +3dB, no link)
	"0011011000101000", --channel 5 (input 4, RCA, +3dB, no link)
	"0011011000101000", --channel 6 (input 4, RCA, +3dB, no link)
);
	
	VARIABLE pressState 	: STD_LOGIC := '1';
	VARIABLE leftState 	: STD_LOGIC := '1';
	VARIABLE rightState 	: STD_LOGIC := '1';
	
	VARIABLE touchPage	: INTEGER 	:= 0;
	VARIABLE touchelement: INTEGER 	:= 0;
	
	BEGIN
		button <= STD_LOGIC_VECTOR(TO_UNSIGNED(highlighted, 4));
		IF Nrst = '0' THEN
			--reset outputs
			page1 		<= "0000";
			page2			<= "0000";
			button 		<= "0000";
			TXData 		<= "00000000";
			
			--reset input variables
			pressState 			:= '1';
			leftState 			:= '1';
			rightState 			:= '1';
			pressedFunction 	:= 0;
			highlighted			:= 0;
			currentPage			:= 0;
			activeChannel		:= 0;
			outputhead			:= 0;
			outputtail			:= 0;
			inputhead			:= 0;
			--inputtail			:= 0;
			inputBufferLevel	:= 0;
			outputBufferLevel	:= 0;
			
		ELSIF RISING_EDGE(clk) THEN
			--buffer the incoming data
			IF Dataready = '1' AND inputBufferLevel < bufferSize THEN
				inputBuffer(inputhead) <= RXData;
				inputhead := (inputhead + 1) mod bufferSize;
				inputBufferLevel := inputBufferLevel + 1;
			END IF;
			
			--process the incoming data
			IF inputhead >=3 THEN
				IF inputBuffer(inputhead-1) = "11111111" AND inputBuffer(inputhead-2) = "11111111" AND inputBuffer(inputhead-3) = "11111111" THEN
					IF inputBufferLevel >= 7 THEN
						touchPage 	:= TO_INTEGER(UNSIGNED(inputBuffer(inputhead-6)));
						touchElement:= TO_INTEGER(UNSIGNED(inputBuffer(inputhead-5))) - 2;
						pressedFunction := functions(touchPage, touchElement);
						updatepage <= 1;
					END IF;
					inputBuffer <= emptyBuffer;
					inputhead 			:= 0;
					--inputtail 			:= 0;
					inputBufferLevel 	:= 0;
				END IF;
			END IF;
			
			--process button inputs
			IF pressInput = NOT pressState THEN
				pressState := pressInput;
				IF pressState = '0' AND outputBufferLevel < bufferSize-10 THEN
				REPORT "currentPage: " & INTEGER'IMAGE(currentPage);
					pressedFunction := functions(currentPage, highlighted);
					updatepage <= 1;
				END IF;
			END IF;
			
			IF rightState = NOT rightInput THEN
				rightState := rightInput;
				IF rightState = '0' THEN
					highlighted := (highlighted + 1) MOD functions(currentPage, maxElements-1);
				END IF;
			END IF;
			
			IF leftState = NOT leftInput THEN
				leftState := leftInput;
				IF leftState = '0' THEN
					IF highlighted >= 1 THEN
						highlighted := highlighted - 1;
					ELSE
						highlighted := functions(currentpage, maxElements-1) - 1;
					END IF;
				END IF;
			END IF;
			
			IF updatePage = 1 THEN
				updatepage <= 0;
				highlighted := 0;
				CASE pressedFunction IS
						WHEN homescreen TO adjustconfirm		=> pressedFunction := pressedFunction;
						WHEN RCA1 TO USB 							=> pressedFunction := signalRouting;
						
						WHEN CH1 TO CH6 							=> activeChannel := pressedFunction - 117;
																			pressedFunction := effectselect1;
																			
						WHEN volume									=> IF activeChannel = 3 OR activeChannel = 4 THEN
																				pressedFunction := jackgain;
																			ELSE
																				pressedFunction := gain;
																			END IF;
																			
						WHEN firstCH1 TO firstCH6				=> activeChannel := pressedFunction - firstCH1;
																			pressedFunction := secondChannel1;
																			
						WHEN secondCH1 TO secondCH5			=> outputroutng(activeChannel)(2 DOWNTO 0) := UNSIGNED(pressedfunction - secondCH1); 
																			pressedFunction := signalRouting;
						
						WHEN channelgain TO mix					=> pressedFunction := pressedFunction;
						
						WHEN preset1 TO preset6					=> pressedFunction := loadconfirm;
						
						WHEN changepreset1 TO changepreset6	=> pressedFunction := adjustconfirm;
						
						WHEN confirmLoad TO confirmAdjust	=> pressedFunction := homescreen;
						
						WHEN OTHERS									=> pressedFunction := homescreen;
					END CASE;
				
				--goto function update page
				outputBuffer(outputhead) <= "01110000"; --p
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "01100001"; --a
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "01100111"; --g
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "01100101"; --e
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "00100000"; --SPACE
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				
				CASE pressedFunction IS
					WHEN 0 to 9 =>	outputBuffer(outputhead) <= "0011" & STD_LOGIC_VECTOR(TO_UNSIGNED(pressedFunction, 4)); --page
										page1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(pressedFunction, 4));
										page2 <= "0000";
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										
					WHEN 10 		=> outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110000" ; --0
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0000";
										page2 <= "0001";
										
					WHEN 11 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0001";
										page2 <= "0001";
										
					WHEN 12		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0010";
										page2 <= "0001";
										
					WHEN 13 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110011" ; --3
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0011";
										page2 <= "0001";
										
					WHEN 14 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110100" ; --4
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0100";
										page2 <= "0001";
										
					WHEN 15 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110101" ; --5
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0101";
										page2 <= "0001";
										
					WHEN 16 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110110" ; --6
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0110";
										page2 <= "0001";
										
					WHEN 17 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110111" ; --7
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0111";
										page2 <= "0001";
										
					WHEN 18 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00111000" ; --8
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "1000";
										page2 <= "0001";
										
					WHEN 19 		=>	outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00111001" ; --9
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "1001";
										page2 <= "0001";
										
					WHEN 20 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110000" ; --0
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0000";
										page2 <= "0010";
										
					WHEN 21 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110001" ; --1
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0001";
										page2 <= "0010";
										
					WHEN 22		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0010";
										page2 <= "0010";
										
					WHEN 23 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110011" ; --3
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0011";
										page2 <= "0010";
										
					WHEN 24 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110100" ; --4
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0100";
										page2 <= "0010";
										
					WHEN 25 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110101" ; --5
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0101";
										page2 <= "0010";
										
					WHEN 26 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110110" ; --6
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0110";
										page2 <= "0010";
										
					WHEN 27 		=>	outputBuffer(outputhead) <= "00110010" ; --2
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										outputBuffer(outputhead) <= "00110111" ; --7
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0111";
										page2 <= "0010";
										
					WHEN OTHERS => outputBuffer(outputhead) <= "00110000" ; --0
										outputhead := (outputhead + 1) MOD bufferSize;
										outputBufferLevel := (outputBufferLevel + 1);
										page1 <= "0000";
										page2 <= "0000";
				END CASE;
				outputBuffer(outputhead) <= "11111111"; --0xFF
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "11111111"; --0xFF
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				outputBuffer(outputhead) <= "11111111"; --0xFF
				outputhead := (outputhead + 1) MOD bufferSize;
				outputBufferLevel := (outputBufferLevel + 1);
				currentPage := pressedFunction;
			END IF;
			
			--output the data from the outputBuffer
			CASE SM_TX IS
				WHEN IDLE => IF outputBufferLevel > 0 THEN SM_TX <= LOAD; ELSE SM_TX <= IDLE; END IF; --if head and tail have the same value there is no data available so then stay in IDLE
				WHEN LOAD => 
					TXData <= outputBuffer(outputtail);	--output the oldest byte in the buffer
					outputtail := (outputtail+1) MOD bufferSize;		--increment the tail value
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