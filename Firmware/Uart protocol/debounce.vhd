LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decoder IS
	PORT(
		Clk     		: IN 	std_logic;
		A 				: IN 	std_logic;
		B 				: IN 	std_logic;
		LeftOut 		: OUT std_logic;
		RightOut 	: OUT std_logic
	);
END Decoder;


ARCHITECTURE RTL OF Decoder IS

TYPE SM_LR IS (IDLE, S1, S2, S3, S4);
SIgNAL SM_right 	: SM_LR := IDLE;
SIgNAL right_next : SM_LR := IDLE;
SIgNAL SM_left 	: SM_LR := IDLE;
SIgNAL left_next 	: SM_LR := IDLE;

BEGIN

PROCESS(A, B, clk)
BEGIN

	IF rising_edge(clk) THEN
		SM_right <= right_next;
		SM_left <= left_next;

		CASE SM_right IS
			WHEN IDLE=> rightOut <= '0';
			WHEN S1	=> rightOut <= '0';
			WHEN S2	=> rightOut <= '0';
			WHEN S3	=> rightOut <= '0';
			WHEN S4	=> rightOut <= '1';
		END CASE;
		
		CASE SM_left IS
			WHEN IDLE=> leftOut <= '0';
			WHEN S1	=> leftOut <= '0';
			WHEN S2	=> leftOut <= '0';
			WHEN S3	=> leftOut <= '0';
			WHEN S4	=> leftOut <= '1';
		END CASE;
	ELSIF NOT falling_edge(clk) OR SM_right = s4 OR SM_left = s4 THEN
		CASE SM_right IS
			WHEN IDLE 	=> IF A = '0' THEN right_next <= s1; ELSE right_next <= IDLE; END IF;
			WHEN S1 		=> IF B = '0' THEN right_next <= s2; ELSE right_next <= IDLE; END IF;
			WHEN S2 		=> IF A = '1' THEN right_next <= s3; ELSE right_next <= IDLE; END IF;
			WHEN S3 		=> IF B = '1' THEN right_next <= s4; ELSE right_next <= IDLE; END IF;
			WHEN S4		=> IF A = '0' THEN right_next <= s1; ELSE right_next <= IDLE; END IF;
			WHEN OTHERS => right_next <= IDLE;
		END CASE;

		CASE SM_left IS
			WHEN IDLE 	=> IF B = '0' THEN left_next <= s1; ELSE left_next <= IDLE; END IF;
			WHEN S1 		=> IF A = '0' THEN left_next <= s2; ELSE left_next <= IDLE; END IF;
			WHEN S2 		=> IF B = '1' THEN left_next <= s3; ELSE left_next <= IDLE; END IF;
			WHEN S3 		=> IF A = '1' THEN left_next <= s4; ELSE left_next <= IDLE; END IF;
			WHEN S4		=> IF B = '0' THEN left_next <= s1; ELSE left_next <= IDLE; END IF;
			WHEN OTHERS => left_next <= IDLE;
		END CASE;
	END IF;
END PROCESS;

--PROCESS( clk )
--BEGIN
--	SM_right <= right_next;
--	SM_left <= left_next;
--
--	CASE SM_right IS
--		WHEN IDLE=> rightOut <= '0';
--		WHEN S1	=> rightOut <= '0';	
--		WHEN S2	=> rightOut <= '0';
--		WHEN S3	=> rightOut <= '0';
--		WHEN S4	=> rightOut <= '1'; SM_right <= IDLE; right_next <= IDLE;
--	END CASE;
--	
--	CASE SM_left IS
--		WHEN IDLE=> leftOut <= '0';
--		WHEN S1	=> leftOut <= '0';
--		WHEN S2	=> leftOut <= '0';
--		WHEN S3	=> leftOut <= '0';
--		WHEN S4	=> leftOut <= '1'; SM_left <= IDLE; left_next <= IDLE;
--	END CASE;
--	 
--END PROCESS;                  
                                                                                
END ARCHITECTURE RTL;