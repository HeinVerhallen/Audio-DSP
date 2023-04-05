--
-- VHDL Architecture das1_lib.minreg.minreg
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 22:53:12 05/10/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY minreg IS
   PORT( 
      clk  : IN     std_logic;
      mino : IN     std_logic;
      mins : OUT  std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END minreg ;

--
ARCHITECTURE minreg OF minreg IS
-----------------------------------------------------------------------  
-- mino->LSB->.....MSB (shifts from LSB to MSB)                      --    
----------------------------------------------------------------------- 
BEGIN
  process(clk) 
  variable reg : std_logic_vector(3 downto 0);
 begin
  if clk'event and clk='1' then
    reg := reg(2 downto 0) & mino;
    mins <= reg; 
  end if;
 end process; 
END ARCHITECTURE minreg;

