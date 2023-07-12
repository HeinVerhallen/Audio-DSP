library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	port(
		Nrst		: in  std_logic;
		Clk     	: in  std_logic;
		A 			: in  std_logic;
		B 			: in  std_logic;
		LeftOut 	: out std_logic;
		RightOut 	: out std_logic
	);
end Decoder;


architecture RTL of Decoder is

type SM_LR is (IDLE, r1, r2, r3, r4, l1, l2, l3, l4);
signal SM 		: SM_LR := IDLE;
signal SM_next 	: SM_LR := IDLE;

begin

decoder : process(A, B, Nrst, clk)
begin
	if Nrst = '0' then
		SM_next 	<= IDLE;
	elsif a = '1' or b = '1' or SM = r4 or SM = l4 then
		case SM is
			when IDLE 	=> if A = '1' THEN SM_next <= r1; elsif B = '1' then SM_next <= l1; else SM_next <= IDLE; end if;
			when r1 	=> if B = '1' THEN SM_next <= r2; else SM_next <= IDLE; end if;
			when r2 	=> if A = '1' THEN SM_next <= r3; else SM_next <= IDLE; end if;
			when r3 	=> if B = '1' THEN SM_next <= r4; else SM_next <= IDLE; end if;
			--when r4		=> SM_next <= IDLE;
			when l1 	=> if A = '1' THEN SM_next <= l2; else SM_next <= IDLE; end if;
			when l2 	=> if B = '1' THEN SM_next <= l3; else SM_next <= IDLE; end if;
			when l3 	=> if A = '1' THEN SM_next <= l4; else SM_next <= IDLE; end if;
			--when l4		=> SM_next <= IDLE;
			when OTHERS => SM_next <= IDLE;
		end case;
	end if;
end process decoder;

process( clk, Nrst )
	--variable counter : integer := 0;
begin
	if Nrst = '0' then
		SM <= IDLE;
		leftout 	<= '0';
		rightout <= '0';
	elsif rising_edge(clk) THEN
		SM <= SM_next;

		case SM is
			when IDLE=> rightOut <= '0';
			when r1	=> rightOut <= '0';
			when r2	=> rightOut <= '0';
			when r3	=> rightOut <= '0';
			when r4	=> rightOut <= '1';
			when l1	=> leftOut <= '0';
			when l2	=> leftOut <= '0';
			when l3	=> leftOut <= '0';
			when l4	=> leftOut <= '1';
		end case;
	end if;
end process;                                                                   
end architecture RTL;