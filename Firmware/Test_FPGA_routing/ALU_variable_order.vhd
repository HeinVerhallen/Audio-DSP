LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

--  Entity Declaration
ENTITY ALU_var IS
	PORT
	(
		input : IN STD_LOGIC_VECTOR(3 downto 0);
		position : IN STD_LOGIC_VECTOR(1 downto 0);
		func : IN STD_LOGIC_VECTOR(2 downto 0);
		enData : IN STD_LOGIC;
		nrst : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END ALU_var;


--  Architecture Body
ARCHITECTURE arch OF ALU_var IS
	--signal nextstate,presentstate : string(1 to 2);
	signal temp : STD_LOGIC_VECTOR(3 downto 0);
	signal res : STD_LOGIC_VECTOR(3 downto 0);
	
	type t_list is array (0 to 4) of string(1 to 2);
	signal list : t_list := (
		4 => "sr",
		3 => "st",
		2 => "sl",
		1 => "ad",
		0 => "ld");
	signal index : integer := 0;

BEGIN
	NSdec: process(index, input)
		variable n_s : string(1 to 2);
		
	begin
		case list(index) is
			when "ld" => temp <= input;
			when "ad" => temp <= res + "0010";
			when "sl" => temp <= res(2 downto 0) & '0';
			when "st" => temp <= res - "0010";
			when "sr" => temp <= '0' & res(3 downto 1);
			when others => temp <= input;
		end case;
	end process;
	
	Mem: process(nrst,clk)
	begin
		if nrst='0' then
			--presentstate <= "S0" after 1 ns;
			index <= 0 after 1 ns;
		elsif rising_edge(Clk) then
			--presentstate <= nextstate after 1 ns;
			if index + 1 > 4 then
				index <= 0 after 1 ns;
			else
				index <= index + 1 after 1 ns;
			end if;
			
			res <= temp after 1 ns;

			if enData = '1' then
				case func is 
					when "000" => list(to_integer(unsigned(position)) + 1) <= "wi"; --wire
					when "001" => list(to_integer(unsigned(position)) + 1) <= "ad"; --add
					when "010" => list(to_integer(unsigned(position)) + 1) <= "sl"; --shift left
					when "011" => list(to_integer(unsigned(position)) + 1) <= "st"; --subtract
					when "100" => list(to_integer(unsigned(position)) + 1) <= "sr"; --shift right
					when others => --Do nothing;
				end case;
			end if;
		end if;
	end process;
	
	OutDec: process(index)
	begin
		--if presentstate = "S0" then 
		if index = 0 then
			output <= res after 1 ns; 
		end if;
		
	end process;
END arch;