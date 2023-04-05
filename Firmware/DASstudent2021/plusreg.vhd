--
-- VHDL Architecture das1_lib.plusreg.plusreg
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 22:57:27 05/10/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY plusreg IS
   PORT( 
      clk   : IN     std_logic;
      pluso : IN     std_logic;
      pluss : OUT  std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END plusreg ;

--
ARCHITECTURE plusreg OF plusreg IS
----------------------------------------------------------------------- 
-- pluso ->LSB->.....MSB (shifts from LSB to MSB)                    --    
----------------------------------------------------------------------- 
BEGIN
  process(clk) 
  variable reg : std_logic_vector(3 downto 0);
begin
 if clk'event and clk='1' then
    reg := reg(2 downto 0) & pluso;
    pluss <= reg; 
 end if;
end process; 
END ARCHITECTURE plusreg;

