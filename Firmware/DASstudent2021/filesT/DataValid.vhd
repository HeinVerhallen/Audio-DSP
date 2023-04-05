--
-- VHDL Architecture das1_lib.pisoL.pisoL
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 09:39:56 05/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DataValid IS
   PORT( 
	   clk, valid : in std_logic;
      din      : IN     std_logic_vector (23 DOWNTO 0);
      dout      : OUT     std_logic_vector (23 DOWNTO 0)
   );

-- Declarations

END DataValid ;

--
ARCHITECTURE DataValid OF DataValid IS
BEGIN
  process(clk) 
  -- variable pi_in : std_logic_vector(11 downto 0);
  begin 
  if clk'event and clk='1' then
    if valid = '1' then 
           dout<=din;
    end if;
 end if;
 end process;
END ARCHITECTURE DataValid;

