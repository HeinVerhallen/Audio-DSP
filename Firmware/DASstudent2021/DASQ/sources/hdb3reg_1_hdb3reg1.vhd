--
-- VHDL Architecture das1_lib.hdb3reg_1.hdb3reg1
--
-- Created:
--          by - 879291.UNKNOWN (PC513871)
--          at - 12:58:19 23-09-2013
--
-- using Mentor Graphics HDL Designer(TM) 2010.2a (Build 7)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY hdb3reg_1 IS
   PORT( 
      clk  : IN     std_logic;
      nrst : IN     std_logic;
      so   : IN     std_logic;
      bits : OUT    std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END hdb3reg_1 ;

--
ARCHITECTURE hdb3reg1 OF hdb3reg_1 IS
-----------------------------------------------------------------------  
-- so->LSB->.....MSB (shifts from LSB to MSB)                        --    
-----------------------------------------------------------------------  
BEGIN
    process(clk,nrst) 
  variable bits1: std_logic_vector(3 downto 0);
begin 
if nrst = '0' then bits1:="0000";
elsif clk'event and clk='1' then
  bits1 := bits1(2 downto 0) & so ; 
end if;
  bits <= bits1;
end process; 
END ARCHITECTURE hdb3reg1;

