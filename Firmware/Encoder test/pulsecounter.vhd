library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulsecounter is
    port (
        Nrst    : in  std_logic;
        clk     : in  std_logic;
        pulse   : in  std_logic;
        count   : inout std_logic_vector(3 downto 0)
    );
end entity pulsecounter;

architecture rtl of pulsecounter is
    
begin   
    main: process(clk, Nrst)
    begin
        if Nrst = '0' then
            count <= (OTHERS => '0');
        elsif rising_edge(clk) then
            if pulse = '1' then
                count <= std_logic_vector(to_unsigned((to_integer(unsigned(count))+ 1) mod 16, 4));
            end if;
        end if;
    end process main;
end architecture rtl;