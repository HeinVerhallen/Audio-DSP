library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    port (
        Nrst    : in  std_logic;
        clk     : in  std_logic;
        input   : in std_logic;
        pulse  : out std_logic
    );
end entity test;

architecture rtl of test is
begin
    main: process(clk, Nrst, input)

    variable counter : integer := 0;
    variable state : std_logic := '1';
    
    begin
        if Nrst = '0' then
            pulse <= '0';
            counter := 0;
            state := '1';
        elsif rising_edge(clk) then
            if state = '0' then
                counter := counter + 1;
                if counter = 3000000 then
                    pulse <= '1';
                else
                    pulse <= '0';
                end if;
				else
					counter := 0;
            end if;
        end if;

        if state = not input then
            state := input;
        end if;
    end process main;
    
end architecture rtl;