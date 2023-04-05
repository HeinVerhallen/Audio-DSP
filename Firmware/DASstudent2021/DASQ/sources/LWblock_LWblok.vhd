--
-- VHDL Architecture das1_lib.LWblock.LWblok
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 08:31:03 06/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY LWblock IS
   PORT( 
      LWout : IN     std_logic;
      LWin  : OUT    std_logic;
      clk   : IN     std_logic
   );

-- Declarations

END LWblock ;

--
ARCHITECTURE LWblok OF LWblock IS
BEGIN
  process(clk) 
 begin
  if clk'event and clk='1' then
      LWin<= LWout ;
  end if;
end process;
END ARCHITECTURE LWblok;

