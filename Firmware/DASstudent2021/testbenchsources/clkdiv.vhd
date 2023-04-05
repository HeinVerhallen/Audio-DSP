--
-- VHDL Architecture das1_lib.clkdiv.clkdiv
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 14:16:31 06/18/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY clkdiv IS
   PORT( 
      clke   : IN     std_logic;
      push_B : IN     std_logic;
      push_A : IN     std_logic;
      clk    : OUT    std_logic
   );

-- Declarations

END clkdiv ;

--
ARCHITECTURE clkdiv OF clkdiv IS

BEGIN
  io_nstate : PROCESS(clke)
    variable count: integer:=0;
    variable t:integer range 0 to 2  :=0;
    variable k:integer range 0 to 2  :=0; 
    variable beginvalue: integer range 0 to 50 :=25; -- channel capacity: 3 voor 4 Mhz    
  BEGIN
     IF rising_edge(clke) THEN
      if (Push_B = '1' and  Push_A = '0' )  and t = 0  then if beginvalue <15 then beginvalue := beginvalue+1; end if; t:=1;end if;
      if Push_B = '0' then  t:=0; end if;
      if (Push_A = '1' and  Push_B = '0' )  and k = 0  then if beginvalue > 0 then beginvalue := beginvalue-1;end if; k:=1;end if;
      if Push_A = '0' then  k:=0; end if;
  
      count:=count+1;
      if count > (beginvalue)/2 then  clk <= '1'; else clk <= '0'; end if;
      if count >= beginvalue then count := 0; end if;
      end if;
END PROCESS;
END ARCHITECTURE clkdiv;

