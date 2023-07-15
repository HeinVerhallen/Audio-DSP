library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity doubledebounce is
	port (
		Nrst	: in  std_logic;
		clk		: in  std_logic;
		input	: in  std_logic;
		output	: out std_logic
	);
end entity doubledebounce;

architecture rtl of doubledebounce is
begin
debounce: process(clk, Nrst, input)
	 variable counter : integer := 0;
    variable state : std_logic := '1';
	 variable changed : integer range 0 to 1 := 0; 
begin
    if Nrst = '0' then
        output <= '0';
        changed := 0;
        state := '1';
		  counter := 0;
    elsif rising_edge(clk) then
		if state = not input then
			state := input;
			changed := 1;
		end if;
	 
		if changed = 1 then
			counter := counter + 1;
			if counter = 50000 then
				output <= '1';
				counter := 0;
				changed := 0;
			else
				output <= '0';
			end if;
		else
			output <= '0';
		end if;
	end if;
end process debounce;	
end architecture rtl;