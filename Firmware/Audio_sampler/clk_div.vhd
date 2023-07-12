library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_div is
    generic (
        constant div : integer := 4
    );
    Port ( 
            clk_in  : in  std_logic;
            nrst    : in  std_logic;
            clk_out : out std_logic 
        );                    
end clk_div;

architecture Behavioral of clk_div is
begin
    process(clk_in, nrst)
        variable cnt : integer := 0;
    begin
        if nrst = '0' then
            cnt := 0;
        elsif rising_edge(clk_in) then

            if cnt < (div / 2) then
                clk_out <= '0';
            else 
                clk_out <= '1';
            end if;
            
            cnt := cnt + 1;

            if cnt > div - 1 then
                cnt := 0;
            end if;
        end if;
    end process;
end Behavioral;