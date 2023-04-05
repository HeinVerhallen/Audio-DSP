--
-- VHDL Architecture das1_lib.nulreg.nulreg
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 08:29:02 06/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY nulreg IS
   PORT( 
      clk  : IN     std_logic;
      nuls : OUT  std_logic_vector (3 DOWNTO 0);
      nulo : IN     std_logic
   );

-- Declarations

END nulreg ;

--
ARCHITECTURE nulreg OF nulreg IS
----------------------------------------------------------------------- 
-- nulo->LSB->.....MSB (shifts from LSB to MSB)                      --    
----------------------------------------------------------------------- 
BEGIN
  process(clk) 
  variable reg : std_logic_vector(3 downto 0);
 begin
  if clk'event and clk='1' then
    reg := reg(2 downto 0) & nulo;
    nuls <= reg; 
  end if;
 end process; 
END ARCHITECTURE nulreg;

