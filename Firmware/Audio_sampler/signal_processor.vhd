library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_processor is
    GENERIC(
        d_width : integer := 24);                           --data width
    Port ( 
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        nrst    : in  std_logic;                            --active-low reset
        sys_clk : in  std_logic;                            --system clock
        ready   : in  std_logic;                            --input data valid check
        d_out   : out std_logic_vector(d_width-1 downto 0); --output data
        valid   : out std_logic                             --output data valid check
        ); 
end signal_processor;

architecture Behavioral of signal_processor is

begin
    process(sys_clk, nrst)
    begin
        if nrst = '0' then 
            
        elsif rising_edge(sys_clk) then
            
        end if;
    end process;
end Behavioral;