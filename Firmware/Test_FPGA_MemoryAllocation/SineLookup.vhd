library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SineLookup is
    Port ( 
        n       : in  std_logic_vector(13 downto 0);
        sineVal : out std_logic_vector(23 downto 0)
        );                    
end SineLookup;

architecture Behavioral of SineLookup is
begin
    process (n)
        type table is array (0 to 9599) of std_logic_vector(23 downto 0);
        variable sine : table := (others => (others => '0'));
        variable gen  : std_logic := '0';
    begin
        if gen = '0' then
            for i in 0 to sine'length - 1 loop
                sine(i) := std_logic_vector(to_unsigned(i, sine(0)'length));
            end loop;
            gen := '1';
        else
            gen := '1';
            sineVal <= sine(to_integer(unsigned(n)));
        end if;
    end process;

--    process (n)
--    begin
--        sineVal <= sine(to_integer(unsigned(n)));
--    end process;
end Behavioral;