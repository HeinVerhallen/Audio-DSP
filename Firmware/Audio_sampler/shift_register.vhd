library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_reg is
    GENERIC(
        d_width : integer := 24);                           --data width
    Port ( 
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        nrst    : in  std_logic;                            --active-low reset
        sys_clk : in  std_logic;                            --system clock
        ena     : in  std_logic;                            --enable
        d_out   : out std_logic_vector(d_width-1 downto 0)  --output data
        ); 
end shift_reg;

architecture Behavioral of shift_reg is

begin
    process(sys_clk, nrst)
    begin
        if nrst = '0' then 
            d_out <= (others => '0');
        elsif rising_edge(sys_clk) then
            if ena = '1' then
                d_out <= d_in;
            end if;
        end if;
    end process;
end Behavioral;