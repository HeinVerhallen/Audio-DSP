--
-- VHDL Architecture das1_lib.ADCDRVR.ADCDRVR
--
-- Created:
--          by - 879291.UNKNOWN (PC513871)
--          at - 13:42:06 04/12/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY PASSTHRUS IS
   PORT( 
      SL24    : IN     std_logic_vector (23 DOWNTO 0);
      SR24    : IN     std_logic_vector (23 DOWNTO 0);
      SLS24   : IN     std_logic_vector (23 DOWNTO 0);
      SRS24   : IN     std_logic_vector (23 DOWNTO 0);
      simsel  : IN     std_logic;
      encia   : OUT    std_logic_vector (23 DOWNTO 0);
      encib   : OUT    std_logic_vector (23 DOWNTO 0)

   );

-- Declarations

END PASSTHRUS ;

--
ARCHITECTURE PASSTHRUS OF PASSTHRUS IS

begin
    process(sl24, sr24, sls24, srs24, simsel )
    begin

     if simsel = '1' then
       encia<= SLS24; encib<= SRS24;
     else 
      encia<=SL24;
      encib<=SR24;
     end if;        
  end process;
  
END ARCHITECTURE PASSTHRUS;

