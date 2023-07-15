library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debounce is
	port (
		Nrst	: in  std_logic;
		clk		: in  std_logic;
		input	: in  std_logic;
		output	: out std_logic
	);
end entity debounce;

architecture rtl of debounce is
begin
debounce: process(clk, Nrst, input)
    variable counter : integer := 0;
    variable state : std_logic := '1'; 
begin
    if Nrst = '0' then
        output <= '0';
        counter := 0;
        state := '1';
    elsif rising_edge(clk) then
		if state = '0' then
			counter := counter + 1;
			if counter = 300000 then
				output <= '1';
			else
				output <= '0';
			end if;
		else
			counter := 0;
		end if;
		if state = not input then
			state := input;
		end if;
	end if;
end process debounce;	
end architecture rtl;