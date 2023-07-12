library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity UIController is
generic(
	bufferSize 			: integer := 64;
	numberOfPages 		: integer := 28;
	numberOfChannels	: integer := 6;
	maxElements			: integer := 7;
	settingsData		: integer := 143;
	numberOfEffects		: integer := 5;
	effectRegisterSize	: integer := 32
);

port(
	Nrst		: in std_logic;
	Clk			: in std_logic;
	Dataready	: in std_logic;
	RXData		: in std_logic_vector(7 downto 0);
	TXDone		: in std_logic;
	leftInput	: in std_logic;
	rightInput	: in std_logic;
	pressInput	: in std_logic;
	loadbyte	: out std_logic;
	TXData		: out std_logic_vector(7 downto 0);
	param1		: out std_logic_vector(15 downto 0);
	button		: out std_logic_vector(3 downto 0);
	parameters	: OUT std_logic_vector(numberOfEffects*effectRegisterSize*numberOfChannels-1 downto 0) 	--ch1(159 downto 0). CH2(319 downto 160), CH3(479 downto 320), CH4(639 downto 480), CH5(799 downto 640), CH6(959 downto 800),
	--inputselect	: OUT std_logic_vector(17 downto 0)		--CH1(2 downto 0), CH2(5 downto 3), CH3(8 downto 6), CH4(11 downto 9), CH5(14 downto 12), CH16(17 downto 15), 
);

end entity UIController;

architecture RTL OF UIcontroller is

type t_SM_TX is (IDLE, LOAD, BUSY);
type t_SM_RX is (RECEIVING, StoP1, StoP2, StoP3, FULL);
type FifoBuffer 	is ARRAY(bufferSize-1 downto 0) 					OF std_logic_vector(7 downto 0);
type pageArray 		is ARRAY(0 to numberOfPages-1, 0 to maxElements-1)	OF integer RANGE 0 to 256;
type effectArray 	is ARRAY(0 to numberofChannels-1)					OF unsigned(31 downto 0);
type routingArray	is ARRAY (0 to numberOfChannels-1)					OF unsigned(15 downto 0);
type stepArray		is ARRAY (0 to 11)									OF unsigned(31 downto 0);

constant volumepos 	: integer := 0;
constant eqpos		: integer := 1;
constant gainpos	: integer := 2;
constant delaypos	: integer := 3;
constant reverbpos	: integer := 4;

constant homeScreen		: integer := 000;
constant signalRouting	: integer := 001;
constant inputSelect1	: integer := 002;
constant inputSelect2	: integer := 003;
constant outputrouting1	: integer := 004;
constant outputrouting2	: integer := 005;
constant outputrouting3	: integer := 006;
constant firstchannel1	: integer := 007;
constant firstchannel2	: integer := 008;
constant secondchannel1	: integer := 009;
constant secondchannel2 : integer := 010;
constant effects1		: integer := 011;
constant effects2		: integer := 012;
constant effectselect1	: integer := 013;
constant effectselect2	: integer := 014;
constant gain			: integer := 015;
constant jackgain		: integer := 016;
constant equalizer		: integer := 017;
constant delay			: integer := 018;
constant reverb			: integer := 019;
constant channelvolume	: integer := 020;

constant presets		: integer := 021;
constant loadpreset1	: integer := 022;
constant loadpreset2	: integer := 023;
constant loadconfirm	: integer := 024;
constant adjustpreset1	: integer := 025;
constant adjustpreset2	: integer := 026;
constant adjustconfirm	: integer := 027;


constant channel1		: integer := 94; 
constant channel2		: integer := 95; 
constant channel3		: integer := 96; 
constant channel4		: integer := 97; 
constant channel5		: integer := 98; 
constant channel6		: integer := 99;

constant RCA1			: integer := 100;
constant RCA2			: integer := 101;
constant TRS1			: integer := 102;
constant TRS2			: integer := 103;
constant XLR1			: integer := 104;
constant XLR2			: integer := 105;
constant USB			: integer := 106;
	
constant firstCH1		: integer := 107;
constant firstCH2		: integer := 108;
constant firstCH3		: integer := 109;
constant firstCH4		: integer := 110;
constant firstCH5		: integer := 111;
constant firstCH6		: integer := 112;
constant secondCH1		: integer := 113;
constant secondCH2		: integer := 114;
constant secondCH3		: integer := 115;
constant secondCH4		: integer := 116;
constant secondCH5		: integer := 117;
	
constant CH1			: integer := 118;
constant CH2			: integer := 119;
constant CH3			: integer := 120;
constant CH4			: integer := 121;
constant CH5			: integer := 122;
constant CH6			: integer := 123;
constant gainselect		: integer := 124;
constant channelgain	: integer := 125;
constant inputgain		: integer := 126;
constant f0				: integer := 127;
constant f1				: integer := 128;
constant f2				: integer := 129;
constant f3				: integer := 130;
constant f4				: integer := 131;
constant dtime			: integer := 132;
constant feedback		: integer := 133;
constant mix			: integer := 134;
constant chvolume		: integer := 135;
constant rlength		: integer := 136;
constant rsize			: integer := 137;
	
constant preset1		: integer := 138;
constant preset2		: integer := 139;
constant preset3		: integer := 140;
constant preset4		: integer := 141;
constant preset5		: integer := 142;
constant preset6		: integer := 143;
constant changepreset1	: integer := 144;
constant changepreset2	: integer := 145;
constant changepreset3	: integer := 146;
constant changepreset4	: integer := 147;
constant changepreset5	: integer := 148;
constant changepreset6	: integer := 149;
constant confirmload	: integer := 150;
constant confirmadjust	: integer := 151;
constant functions : pageArray := (
	(signalRouting	,effects1		,presets		,0				,0				,0				,3),--0  homeScreen
	(inputSelect1	,firstChannel1	,homeScreen		,0				,0				,0				,3),--1  signalRouting
	(channel1		,channel2		,channel3		,inputSelect2	,signalRouting	,0				,5),--2  inputSelect1
	(channel4		,channel5		,channel6		,inputSelect1	,signalRouting	,0				,4),--3  inputSelect2
	(RCA1			,RCA2			,TRS1			,outputrouting2	,inputSelect1	,0				,5),--4  outputrouting1
	(TRS2			,XLR1			,XLR2			,outputrouting3	,inputSelect1	,0				,5),--5  outputrouting2
	(USB			,outputrouting3	,inputSelect1	,0				,0				,0				,3),--6  outputrouting3
	(firstCH1		,firstCH2		,firstCH3		,firstchannel2	,signalRouting	,0				,5),--7  firstchannel1
	(firstCH4		,firstCH5		,firstCH6		,firstchannel1	,signalRouting	,0				,5),--8  firstchannel2
	(secondCH1		,secondCH2		,secondCH3		,secondchannel2	,firstchannel1	,0				,5),--9  secondchannel1
	(secondCH4		,secondCH5		,secondchannel1	,firstchannel1	,0				,0				,4),--10 secondchannel2
	(CH1			,CH2			,CH3			,effects2		,homescreen		,0				,5),--11 effects1
	(CH4			,CH5			,CH6			,effects1		,homescreen		,0				,5),--12 effects2
	(equalizer		,gainselect		,delay			,effectselect2	,effects1		,0				,5),--13 effectselect1
	(reverb			,channelvolume	,effectselect1	,effects1		,0				,0				,4),--14 effectselect2
	(channelgain	,effectselect1	,0				,0				,0				,0				,2),--15 gain
	(inputgain		,channelgain	,effectselect1	,0				,0				,0				,3),--16 jackgain
	(f0				,f1				,f2				,f3				,f4				,effectselect1	,6),--17 equalizer
	(dtime			,feedback		,mix			,effectselect1	,0				,0				,4),--18 Delay
	(rLength		,rSize			,effectselect1	,0				,0				,0				,3),--19 Reverb
	(chvolume		,effectselect1	,0				,0				,0				,0				,2),--20 channelvolume
	(loadpreset1	,adjustpreset1	,homescreen		,0				,0				,0				,3),--21 presets
	(preset1		,preset2		,preset3		,loadpreset2	,presets		,0				,4),--22 loadpreset1
	(preset4		,preset5		,preset6		,loadpreset1	,presets		,0				,5),--23 loadpreset2
	(confirmLoad	,loadpreset1	,0				,0				,0				,0				,2),--24 loadconfirm
	(changepreset1	,changepreset2	,changepreset3	,adjustpreset2	,presets		,0				,4),--25 adjustpreset1
	(changepreset4	,changepreset5	,changepreset6	,adjustpreset1	,presets		,0				,5),--26 adjustpreset2
	(confirmAdjust	,adjustpreset1	,0				,0				,0				,0				,2) --27 adjustconfirm
	);

constant stepsize : stepArray := ("00000000000000000000000011111111", "00000000000000000000000000111111", "00000000000000000000000000111111", "00000000000000000000000000111111", "00000000000000000000000000111111", "00000000000000000000000000111111", "00000000000000000000111111111111", "00000000000000000000001111111111", "00000000000000000000001111111111", "00000000000000001111111111111111", "00000000000000001111111111111111", "11111111111111111111111111111111");

SIGNAL SM_TX 		: t_SM_TX := IDLE;
SIGNAL SM_RX 		: t_SM_RX := RECEIVING;

procedure updateregister(
	effect 											: inout effectArray;
	size, offset, pressedfunction, activechannel	: in 	integer;
	count											: in	unsigned(31 downto 0)
) is

	--give x a good descriptive name
	constant x : integer := 126;
	variable maxcount : unsigned(31 downto 0);

begin
	maxcount := stepsize(pressedfunction-126);
 	if effect(activechannel)(offset+size-1 downto offset) > maxcount  then
		effect(activechannel)(offset+size-1 downto offset) := maxcount(size-1 downto 0);
	elsif effect(activechannel)(offset+size-1 downto offset) = maxcount and to_integer(count) = 1 then
		effect(activechannel)(offset+size-1 downto offset) := maxcount(size-1 downto 0);
	elsif effect(activechannel)(offset+size-1 downto offset) < "0" then
		effect(activechannel)(offset+size-1 downto offset) := (OTHERS => '0');
	elsif effect(activechannel)(offset+size-1 downto offset) = "0" and to_integer(count) = 65535  then
		effect(activechannel)(offset+size-1 downto offset) := (OTHERS => '0');
	else
		effect(activechannel)(offset+size-1 downto offset) := effect(activechannel)(offset+size-1 downto offset) + count(size-1 downto 0);
 	end if;
end procedure updateregister;

PROCEDURE gotopage (
	page : IN integer RANGE 0 to numberOfPages;
	outputhead, outputBufferLevel : INOUT integer;
	outputBuffer : INOUT FifOBuffer) is
begin
	REPORT "Page: " & integer'image(page);
	outputBuffer(outputhead) := "01110000"; --p
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "01100001"; --a
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "01100111"; --g
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "01100101"; --e
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "00100000"; --SPACE
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	if page >= 10 then
		--ecode page number(tens)
		outputBuffer(outputhead) := "0011" & std_logic_vector(to_unsigned(page / 10, 4)) ; --0
		outputhead := (outputhead + 1) mod bufferSize;
		outputBufferLevel := (outputBufferLevel + 1);
	end if;

	--decode page number (ones)
	outputBuffer(outputhead) := "0011" & std_logic_vector(to_unsigned(page mod 10, 4)); --0
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);

	outputBuffer(outputhead) := "11111111"; --0xFF
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "11111111"; --0xFF
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
	outputBuffer(outputhead) := "11111111"; --0xFF
	outputhead := (outputhead + 1) mod bufferSize;
	outputBufferLevel := (outputBufferLevel + 1);
end PROCEDURE gotopage;

begin
process( Clk, Nrst )
	VARIABLE EqualizerA : effectArray := (
		"00100000100000100000100000100000", --channel 1(0dB, 0dB, 0dB, 0dB, 0dB)
		"00100000100000100000100000100000", --channel 2(0dB, 0dB, 0dB, 0dB, 0dB) 
		"00100000100000100000100000100000", --channel 3(0dB, 0dB, 0dB, 0dB, 0dB)
		"00100000100000100000100000100000", --channel 4(0dB, 0dB, 0dB, 0dB, 0dB)
		"00100000100000100000100000100000", --channel 5(0dB, 0dB, 0dB, 0dB, 0dB)
		"00100000100000100000100000100000"  --channel 6(0dB, 0dB, 0dB, 0dB, 0dB)
	);

	VARIABLE GainA : effectArray := (
		"00000000000000000000000000000000", -- channel 1 (gain, level)
		"00000000000000000000000000000000", -- channel 2 (gain, level)
		"00000000000000000000000000000000", -- channel 3 (gain, level)
		"00000000000000000000000000000000", -- channel 4 (gain, level)
		"00000000000000000000000000000000", -- channel 5 (gain, level)
		"00000000000000000000000000000000"  -- channel 6 (gain, level)
	);

	VARIABLE DelayA	: effectArray := (
		"00000000000000000000000000000000", -- channel 1 (0,01x, 0ms, 1ms)
		"00000000000000000000000000000000", -- channel 2 (0,01x, 0ms, 1ms)
		"00000000000000000000000000000000", -- channel 3 (0,01x, 0ms, 1ms)
		"00000000000000000000000000000000", -- channel 4 (0,01x, 0ms, 1ms)
		"00000000000000000000000000000000", -- channel 5 (0,01x, 0ms, 1ms)
		"00000000000000000000000000000000"  -- channel 6 (0,01x, 0ms, 1ms)
	);

	VARIABLE ReverbA	: effectArray := (
		"00000000000000000000000000000000", -- channel 1 (0ms, 1ms)
		"00000000000000000000000000000000", -- channel 2 (0ms, 1ms)
		"00000000000000000000000000000000", -- channel 3 (0ms, 1ms)
		"00000000000000000000000000000000", -- channel 4 (0ms, 1ms)
		"00000000000000000000000000000000", -- channel 5 (0ms, 1ms)
		"00000000000000000000000000000000"  -- channel 6 (0ms, 1ms)
	);

	VARIABLE VolumeA	: effectArray := (
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000",
		"00000000000000000000000000000000"
	);

	VARIABLE outputrouting : routingArray := (
		"0010011000101000",	--channel 1 (input 3, RCA, +3dB, no link)
		"0010011000101000",	--channel 2 (input 3, RCA, +3dB, no link)
		"0010011000101000",	--channel 3 (input 3, RCA, +3dB, no link)
		"0011011000101000",	--channel 4 (input 4, RCA, +3dB, no link)
		"0011011000101000",	--channel 5 (input 4, RCA, +3dB, no link)
		"0011011000101000"	--channel 6 (input 4, RCA, +3dB, no link)
	);

	VARIABLE pressedFunction 	: integer := 0;
	VARIABLE highlighted 		: integer := 0;
	VARIABLE currentPage 		: integer := 0;
	VARIABLE activeChannel		: integer := 0;
	VARIABLE navMenu			: integer RANGE 0 to 1 := 1;
	VARIABLE updateparameter	: integer RANGE 0 to 1 := 0;
	VARIABLE parameterchanged	: integer RANGE 0 to 1 := 0;
	
	VARIABLE outputhead			: integer RANGE 0 to bufferSize 	:= 0;
	VARIABLE outputtail			: integer RANGE 0 to bufferSize 	:= 0;
	VARIABLE inputhead			: integer RANGE 0 to bufferSize 	:= 0;
	VARIABLE inputBufferLevel 	: integer RANGE 0 to bufferSize 	:= 0;
	VARIABLE outputBufferLevel	: integer RANGE 0 to bufferSize 	:= 0;
	VARIABLE pressState 		: std_logic := '1';
	VARIABLE leftState 			: std_logic := '1';
	VARIABLE rightState 		: std_logic := '1';
	
	VARIABLE touchPage			: integer 	:= 0;
	VARIABLE touchelement		: integer 	:= 0;
	VARIABLE count				: unsigned(31 downto 0) := (others => '0');

	VARIABLE inputBuffer 	: FifOBuffer;
	VARIABLE outputBuffer	: FifOBuffer;
	VARIABLE emptyBuffer	: FifOBuffer := (others => "XXXXXXXX");
	VARIABLE updatepage		: integer	:= 0;
	
	begin
		button <= std_logic_vector(to_unsigned(highlighted, 4));
		if Nrst = '0' THEN
			--reset outputs
			button 		<= "0000";
			TXData 		<= "00000000";
			param1		<= "0000000000000000";
			
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
			navMenu := 1;
			
		elsif RisING_EDGE(clk) THEN
			--buffer the incoming data
			if Dataready = '1' AND inputBufferLevel < bufferSize THEN
				inputBuffer(inputhead) := RXData;
				inputhead := (inputhead + 1) mod bufferSize;
				inputBufferLevel := inputBufferLevel + 1;
			end if;
			
			--process the incoming data
			if inputhead >=3 THEN
				if inputBuffer(inputhead-1) = "11111111" AND inputBuffer(inputhead-2) = "11111111" AND inputBuffer(inputhead-3) = "11111111" THEN
					if inputBufferLevel >= 7 THEN
						touchPage 	:= to_integer(unsigned(inputBuffer(inputhead-6)));
						if touchPage = outputrouting2 OR touchPage = inputselect2 THEN
							touchElement := to_integer(unsigned(inputBuffer(inputhead-5))) - 5;
						else
							touchElement := to_integer(unsigned(inputBuffer(inputhead-5))) - 2;
						end if;
						pressedFunction := functions(touchPage, touchElement);
						updatepage := 1;
					end if;
					inputBuffer := emptyBuffer;
					inputhead 			:= 0;
					--inputtail 			:= 0;
					inputBufferLevel 	:= 0;
				end if;
			end if;
			
			--process button inputs
			if pressInput = '1' and outputBufferLevel < bufferSize-10 THEN
				pressedFunction := functions(currentPage, highlighted);
				updatepage := 1;
			end if;
			
			if rightInput = '1' THEN
				--REPORT "navMenu: " & integer'IMAGE(navMenu);
				if navMenu = 1 THEN
					highlighted := (highlighted + 1) mod functions(currentPage, maxElements-1);
				else
					count := count + "0000000000000001";
					updateparameter := 1;
				end if;
			end if;
			
			if leftInput = '1' then
				--REPORT "navMenu: " & integer'IMAGE(navMenu);
				if navMenu = 1 THEN
					if highlighted >= 1 THEN
						highlighted := highlighted - 1;
					else
						highlighted := functions(currentpage, maxElements-1) - 1;
					end if;
				else
					count := count - "0000000000000001";
					updateparameter := 1;
				end if;
			end if;
			
			if updatePage = 1 THEN
				updatepage := 0;
				highlighted := 0;
				case pressedFunction is
						when homescreen to adjustconfirm => 
							pressedFunction := pressedFunction;

						when channel1 to channel6 => 
							activechannel := pressedfunction - channel1 + 1;
							pressedFunction := outputrouting1;
							
						when RCA1 to USB => 
							outputrouting(activechannel)(14 downto 11) := to_unsigned(pressedFunction - RCA1, 4);
							pressedFunction := signalRouting;

						when CH1 to CH6 => 	
							activeChannel := pressedFunction - 117;
							pressedFunction := effectselect1;

						when gainselect	=> 	
							if activeChannel = 3 OR activeChannel = 4 THEN
								pressedFunction := jackgain;
							else
								pressedFunction := gain;
							end if;		

						when firstCH1 to firstCH6 => 	
							activeChannel := pressedFunction - firstCH1;
							pressedFunction := secondChannel1;
																		
						when secondCH1 to secondCH5	=> 	
							outputrouting(activeChannel)(2 downto 0) := to_unsigned(pressedfunction - secondCH1, 3); 
							pressedFunction := signalRouting;

						when inputgain to chvolume	=>
							navMenu := (navMenu + 1) mod 2;

						when preset1 to preset6	=> 	
							pressedFunction := loadconfirm;

						when changepreset1 to changepreset6	=> 	
							pressedFunction := adjustconfirm;

						when confirmLoad to confirmAdjust	=> 	
							pressedFunction := homescreen;

						when others							=> 	
							pressedFunction := homescreen;

					end case;
				
				if pressedFunction < numberOfPages then
					gotopage(pressedfunction, outputhead, outputBufferLevel, outputBuffer);
					currentPage := pressedfunction;	
				end if;
			end if;
			
			if updateparameter = 1 THEN
				updateparameter := 0;

				case pressedfunction is
					--when inputgain =>
						--updateregister(outputrouting, 8, 0, pressedfunction, activechannel, count);
--						if outputrouting(activechannel)(7 downto 0) > stepsize(pressedFunction - inputgain) THEN
--							outputrouting(activechannel)(7 downto 0) := stepsize(pressedFunction - inputgain)(7 downto 0);
--						elsif outputrouting(activechannel)(7 downto 0) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							outputrouting(activechannel)(7 downto 0) := stepsize(pressedFunction - inputgain)(7 downto 0);
--						elsif outputrouting(activechannel)(7 downto 0) < "00000000" THEN
--							outputrouting(activechannel)(7 downto 0) := "00000000";
--						elsif outputrouting(activechannel)(7 downto 0) = "00000000" AND to_integer(count) = 65535 THEN
--							outputrouting(activechannel)(7 downto 0) := "00000000";
--						else
--							parameterchanged := 1;
--							outputrouting(activechannel)(7 downto 0) := outputrouting(activechannel)(7 downto 0) + count(7 downto 0);
--						end if;
				when f0	 =>
					updateregister(EqualizerA, 6, 0, pressedfunction, activechannel, count);
--						if EqualizerA(activechannel)(5 downto 0) > stepsize(pressedFunction - inputgain) THEN
--							EqualizerA(activechannel)(5 downto 0) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(5 downto 0) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							EqualizerA(activechannel)(5 downto 0) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(5 downto 0) < "000000" THEN
--							EqualizerA(activechannel)(5 downto 0) := "000000";
--						elsif EqualizerA(activechannel)(5 downto 0) = "000000" AND to_integer(count) = 65535 THEN
--							EqualizerA(activechannel)(5 downto 0) := "000000";
--						else
--							parameterchanged := 1;
--							EqualizerA(activechannel)(5 downto 0) := EqualizerA(activechannel)(5 downto 0) + count(5 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-eqpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*eqpos)) <= std_logic_vector(EqualizerA(activechannel));
					when f1	 => 
						updateregister(EqualizerA, 6, 6, pressedfunction, activechannel, count);
--						if EqualizerA(activechannel)(11 downto 6) > stepsize(pressedFunction - inputgain) THEN
--							EqualizerA(activechannel)(11 downto 6) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(11 downto 6) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							EqualizerA(activechannel)(11 downto 6) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(11 downto 6) < "000000" THEN
--							EqualizerA(activechannel)(11 downto 6) := "000000";
--						elsif EqualizerA(activechannel)(11 downto 6) = "000000" AND to_integer(count) = 65535 THEN
--							EqualizerA(activechannel)(11 downto 6) := "000000";
--						else
--							parameterchanged := 1;
--							EqualizerA(activechannel)(11 downto 6) := EqualizerA(activechannel)(11 downto 6) + count(5 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-eqpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*eqpos)) <= std_logic_vector(EqualizerA(activechannel));
					when f2	 => 
						updateregister(EqualizerA, 6, 12, pressedfunction, activechannel, count);
--						if EqualizerA(activechannel)(17 downto 12) > stepsize(pressedFunction - inputgain) THEN
--							EqualizerA(activechannel)(17 downto 12) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(17 downto 12) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							EqualizerA(activechannel)(17 downto 12) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(17 downto 12) < "000000" THEN
--							EqualizerA(activechannel)(17 downto 12) := "000000";
--						elsif EqualizerA(activechannel)(17 downto 12) = "000000" AND to_integer(count) = 65535 THEN
--							EqualizerA(activechannel)(17 downto 12) := "000000";
--						else
--							parameterchanged := 1;
--							EqualizerA(activechannel)(17 downto 12) := EqualizerA(activechannel)(17 downto 12) + count(5 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-eqpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*eqpos)) <= std_logic_vector(EqualizerA(activechannel));
					when f3	 =>  
						updateregister(EqualizerA, 6, 18, pressedfunction, activechannel, count);
--						if EqualizerA(activechannel)(23 downto 18) > stepsize(pressedFunction - inputgain) THEN
--							EqualizerA(activechannel)(23 downto 18) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(23 downto 18) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							EqualizerA(activechannel)(23 downto 18) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(23 downto 18) < "000000" THEN
--							EqualizerA(activechannel)(23 downto 18) := "000000";
--						elsif EqualizerA(activechannel)(23 downto 18) = "000000" AND to_integer(count) = 65535 THEN
--							EqualizerA(activechannel)(23 downto 18) := "000000";
--						else
--							parameterchanged := 1;
--							EqualizerA(activechannel)(23 downto 18) := EqualizerA(activechannel)(23 downto 18) + count(5 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-eqpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*eqpos)) <= std_logic_vector(EqualizerA(activechannel));
					when f4	 =>  
						updateregister(EqualizerA, 6, 0, pressedfunction, activechannel, count);
--						if EqualizerA(activechannel)(29 downto 24) > stepsize(pressedFunction - inputgain) THEN
--							EqualizerA(activechannel)(29 downto 24) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(29 downto 24) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							EqualizerA(activechannel)(29 downto 24) := stepsize(pressedFunction - inputgain)(5 downto 0);
--						elsif EqualizerA(activechannel)(29 downto 24) < "000000" THEN
--							EqualizerA(activechannel)(29 downto 24) := "000000";
--						elsif EqualizerA(activechannel)(29 downto 24) = "000000" AND to_integer(count) = 65535 THEN
--							EqualizerA(activechannel)(29 downto 24) := "000000";
--						else
--							parameterchanged := 1;
--							EqualizerA(activechannel)(29 downto 24) := EqualizerA(activechannel)(29 downto 24) + count(5 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-eqpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*eqpos)) <= std_logic_vector(EqualizerA(activechannel));
					when dtime =>   
						updateregister(DelayA, 12, 0, pressedfunction, activechannel, count);
--						if DelayA(activechannel)(11 downto 0) > stepsize(pressedFunction - inputgain) THEN
--							DelayA(activechannel)(11 downto 0) := stepsize(pressedFunction - inputgain)(11 downto 0);
--						elsif DelayA(activechannel)(11 downto 0) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							DelayA(activechannel)(11 downto 0) := stepsize(pressedFunction - inputgain)(11 downto 0);
--						elsif DelayA(activechannel)(11 downto 0) < "000000000000" THEN
--							DelayA(activechannel)(11 downto 0) := "000000000000";
--						elsif DelayA(activechannel)(11 downto 0) = "000000000000" AND to_integer(count) = 65535 THEN
--							DelayA(activechannel)(11 downto 0) := "000000000000";
--						else
--							parameterchanged := 1;
--							DelayA(activechannel)(11 downto 0) := DelayA(activechannel)(11 downto 0) + count(11 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-delaypos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*delaypos)) <= std_logic_vector(DelayA(activechannel));
					when feedback =>   
						updateregister(DelayA, 12, 12, pressedfunction, activechannel, count);
--						if DelayA(activechannel)(21 downto 12) > stepsize(pressedFunction - inputgain) THEN
--							DelayA(activechannel)(21 downto 12) := stepsize(pressedFunction - inputgain)(9 downto 0);
--						elsif DelayA(activechannel)(21 downto 12) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							DelayA(activechannel)(21 downto 12) := stepsize(pressedFunction - inputgain)(9 downto 0);
--						elsif DelayA(activechannel)(21 downto 12) < "0000000000" THEN
--							DelayA(activechannel)(21 downto 12) := "0000000000";
--						elsif DelayA(activechannel)(21 downto 12) = "0000000000" AND to_integer(count) = 65535 THEN
--							DelayA(activechannel)(21 downto 12) := "0000000000";
--						else
--							parameterchanged := 1;
--							DelayA(activechannel)(21 downto 12) := DelayA(activechannel)(21 downto 12) + count(9 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-delaypos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*delaypos)) <= std_logic_vector(DelayA(activechannel));
					when mix =>   
						updateregister(DelayA, 10, 22, pressedfunction, activechannel, count);
--						if DelayA(activechannel)(31 downto 22) > stepsize(pressedFunction - inputgain) THEN
--							DelayA(activechannel)(31 downto 22) := stepsize(pressedFunction - inputgain)(9 downto 0);
--						elsif DelayA(activechannel)(31 downto 22) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							DelayA(activechannel)(31 downto 22) := stepsize(pressedFunction - inputgain)(9 downto 0);
--						elsif DelayA(activechannel)(31 downto 22) < "0000000000" THEN
--							DelayA(activechannel)(31 downto 22) := "0000000000";
--						elsif DelayA(activechannel)(31 downto 22) = "0000000000" AND to_integer(count) = 65535 THEN
--							DelayA(activechannel)(31 downto 22) := "0000000000";
--						else
--							parameterchanged := 1;
--							DelayA(activechannel)(31 downto 22) := DelayA(activechannel)(31 downto 22) + count(9 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-delaypos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*delaypos)) <= std_logic_vector(DelayA(activechannel));
					when rlength =>   
						updateregister(ReverbA, 16, 0, pressedfunction, activechannel, count);
--						if ReverbA(activechannel)(15 downto 0) > stepsize(pressedFunction - inputgain) THEN
--							ReverbA(activechannel)(15 downto 0) := stepsize(pressedFunction - inputgain)(15 downto 0);
--						elsif ReverbA(activechannel)(15 downto 0) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							ReverbA(activechannel)(15 downto 0) := stepsize(pressedFunction - inputgain)(15 downto 0);
--						elsif ReverbA(activechannel)(15 downto 0) < "0000000000000000" THEN
--							ReverbA(activechannel)(15 downto 0) := "0000000000000000";
--						elsif ReverbA(activechannel)(15 downto 0) = "0000000000000000" AND to_integer(count) = 65535 THEN
--							ReverbA(activechannel)(15 downto 0) := "0000000000000000";
--						else
--							parameterchanged := 1;
--							ReverbA(activechannel)(15 downto 0) := ReverbA(activechannel)(15 downto 0) + count(15 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-reverbpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*reverbpos)) <= std_logic_vector(ReverbA(activechannel));
					when rsize =>   
						updateregister(ReverbA, 16, 16, pressedfunction, activechannel, count);
--						if ReverbA(activechannel)(31 downto 16) > stepsize(pressedFunction - inputgain) THEN
--							ReverbA(activechannel)(31 downto 16) := stepsize(pressedFunction - inputgain)(15 downto 0);
--						elsif ReverbA(activechannel)(31 downto 16) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							ReverbA(activechannel)(31 downto 16) := stepsize(pressedFunction - inputgain)(15 downto 0);
--						elsif ReverbA(activechannel)(31 downto 16) < "0000000000000000" THEN
--							ReverbA(activechannel)(31 downto 16) := "0000000000000000";
--						elsif ReverbA(activechannel)(31 downto 16) = "0000000000000000" AND to_integer(count) = 65535 THEN
--							ReverbA(activechannel)(31 downto 16) := "0000000000000000";
--						else
--							parameterchanged := 1;
--							ReverbA(activechannel)(31 downto 16) := ReverbA(activechannel)(31 downto 16) + count(15 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-reverbpos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*reverbpos)) <= std_logic_vector(ReverbA(activechannel));
					when channelvolume =>  
						updateregister(VolumeA, 32, 0, pressedfunction, activechannel, count);
--						if VolumeA(activechannel)(31 downto 0) > stepsize(pressedFunction - inputgain) THEN
--							VolumeA(activechannel)(31 downto 0) := stepsize(pressedFunction - inputgain)(31 downto 0);
--						elsif VolumeA(activechannel)(31 downto 0) > stepsize(pressedFunction - inputgain) AND to_integer(count) = 1 THEN
--							VolumeA(activechannel)(31 downto 0) := stepsize(pressedFunction - inputgain)(31 downto 0);
--						elsif VolumeA(activechannel)(31 downto 0) < "0000000000000000" THEN
--							VolumeA(activechannel)(31 downto 0) := "00000000000000000000000000000000";
--						elsif VolumeA(activechannel)(31 downto 0) = "0000000000000000" AND to_integer(count) = 65535 THEN
--							VolumeA(activechannel)(31 downto 0) := "00000000000000000000000000000000";
--						else
--							parameterchanged := 1;
--							VolumeA(activechannel)(31 downto 0) := ReverbA(activechannel)(31 downto 0) + count(31 downto 0);
--						end if;
--						parameters((numberOfEffects*effectRegisterSize+activechannel*numberOfEffects*effectRegisterSize) - (effectregistersize*(numberOfEffects-1-volumepos)) downto (activechannel*numberOfEffects*effectRegisterSize) + (effectRegisterSize*volumepos)) <= std_logic_vector(VolumeA(activechannel));
					when others =>
				end case;
				count := "00000000000000000000000000000000";
			end if;

			--output the data from the outputBuffer
			case SM_TX is
				when IDLE => if outputBufferLevel > 0 THEN SM_TX <= LOAD; else SM_TX <= IDLE; end if; --if head and tail have the same value there is no data available so then stay in IDLE
				when LOAD => 
					TXData <= outputBuffer(outputtail);	--output the oldest byte in the buffer
					outputtail := (outputtail+1) mod bufferSize;		--increment the tail value
					outputBufferLevel := outputBufferLevel - 1;
					loadByte <= '1';					--let the transmitter know the data is ready					
					SM_TX <= BUSY;
				when BUSY =>
					loadByte <= '0';
					if TXDone = '1' THEN SM_TX <= IDLE; else SM_TX <= BUSY; end if; --if TXDone is high the transmitter has finished transmitting the data so go back to IDLE
				when others => SM_TX <= IDLE;
			end case;
		end if;
	end process;
end RTL;