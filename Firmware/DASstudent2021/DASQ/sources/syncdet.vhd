--
-- VHDL Architecture das1_lib.syncdet.syncdet
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 22:51:35 05/10/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY syncdet IS
   PORT( 
    	mins          : IN     std_logic_vector (3 DOWNTO 0);
      pluss         : IN     std_logic_vector (3 DOWNTO 0);
      syncdetectedo : OUT    std_logic
   );

-- Declarations

END syncdet ;

--
ARCHITECTURE syncdet OF syncdet IS
BEGIN
  process(mins, pluss)
  begin
    if (mins = "0011" and pluss = "1100" ) or (mins = "1100" and pluss = "0011") then
          syncdetectedo <= '1'; 
    else  syncdetectedo <='0'; 
  end if; 
  end process;
END ARCHITECTURE syncdet;

