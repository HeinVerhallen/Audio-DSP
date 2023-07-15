library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
        Nrst    : in    std_logic;
        clk     : in    std_logic;
        up      : in    std_logic;
        down    : in    std_logic;
        count   : inout   std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of counter is
    
begin
    
    main: process(clk, Nrst)
    begin
        if Nrst = '0' then
            count <= (OTHERS => '0');
        elsif rising_edge(clk) then
             if up = '1' and count < "11111111" then
                count <= std_logic_vector(unsigned(count) + 1);
            elsif down = '1' and count > "00000000" then
                count <= std_logic_vector(unsigned(count) - 1);
             end if;
        end if;
    end process main;
    
end architecture rtl;