LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Debounce IS
	PORT(
		Clk     	: IN std_logic;
		input 	: IN std_logic;
		output 	: OUT std_logic
	);
END Debounce;

ARCHITECTURE RTL OF Debounce IS

CONSTANT DELAY 		: integer 	:= 50; 
SIGNAL	lastState 	: std_logic	:= '1';

BEGIN
PROCESS(clk)

VARIABLE	count 		: integer 	:= 0;
VARIABLE	state		 	: std_logic	:= '1';

BEGIN
	IF rising_edge(clk) THEN
	output <= '1'; --standard output
		IF input = (NOT lastState) THEN
			count := 0;
		END IF;
		
		IF count = DELAY THEN
			IF input = NOT state THEN
				state := input;
				output <= state;
			END IF;
		ELSE
			count := count + 1;
		END IF;
	lastState <= input;
	END IF;
END PROCESS;                  
                                                                                
END ARCHITECTURE RTL;