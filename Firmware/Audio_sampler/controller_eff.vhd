library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller_eff is
    Port ( 
        mclk    : in std_logic;                             --master clock
        param_in    : in std_logic_vector(5 downto 0);
        param_out   : out  std_logic_vector(5 downto 0) := "100000"        --parameter
        ); 
end controller_eff;

architecture Behavioral of controller_eff is
    
begin
    process(mclk)
        
        
    begin
        if rising_edge(mclk) then
--            param_out <= "100000";
            param_out <= param_in;
        end if;
    end process;
end Behavioral;