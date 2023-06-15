library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SampleShiftReg is
    generic (
        constant samples : integer := 3;
        constant resolution : integer := 24
    );
    Port ( 
        clk     : in  std_logic;
        nrst    : in  std_logic;
        inp     : in  std_logic_vector(resolution - 1 downto 0);
        output  : out std_logic_vector(resolution - 1 downto 0)
        );                    
end SampleShiftReg;

architecture Behavioral of SampleShiftReg is
    type t_reg is array (0 to samples - 1) of std_logic_vector(resolution - 1 downto 0);
    signal reg : t_reg := (others => (others => '0'));
begin
    process (clk, nrst)
    begin
        if (nrst = '0') then
            reg <= (others => (others => '0'));
            output <= (others => '0');
        elsif (rising_edge(clk)) then
            output <= reg(samples - 1);
            
            reg(1 to samples - 1) <= reg(0 to samples - 2);
            reg(0) <= inp;
        end if;
    end process;
end Behavioral;