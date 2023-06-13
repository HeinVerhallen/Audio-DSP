library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_signed.all;   

entity clock_counter is
    Port ( 
        nrst        : in  std_logic;
        mclk        : in  std_logic;
        pll_clk     : in  std_logic;
        bin0        : out std_logic_vector(3 downto 0);
        bin1        : out std_logic_vector(3 downto 0);
        bin2        : out std_logic_vector(3 downto 0)
        );                    
end clock_counter;

architecture Behavioral of clock_counter is
    constant mclk_limit : integer := 50;
    signal mclk_count   : integer := 0;
    signal pll_count    : std_logic_vector(11 downto 0) := (others=>'0');
    signal finished    : std_logic := '0';
begin
    process(mclk, nrst)
    begin
        if nrst = '0' then
            mclk_count <= 0;
        elsif rising_edge(mclk) and finished = '0' then
            if mclk_count < mclk_limit then
                mclk_count <= mclk_count + 1;
            else
                finished <= '1';
                bin0 <= pll_count(3 downto 0);
                bin1 <= pll_count(7 downto 4);
                bin2 <= pll_count(11 downto 8);
            end if;
        end if;
    end process;

    process(pll_clk, nrst)
    begin
        if nrst = '0' then
            pll_count <= (others => '0');
        elsif rising_edge(pll_clk) and finished = '0' then
            pll_count <= pll_count + '1';
        end if;
    end process;
end Behavioral;