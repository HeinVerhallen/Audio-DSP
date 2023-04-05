--
-- Created:
--          by - tygtr (tekin Yilmaz global trade releation)
--          at - 13:08:31 08/18/2018
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY hdbdecreg IS
   PORT( 
      clk  : IN     std_logic;
      serin : IN     std_logic;
      serout : INOUT  std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END hdbdecreg ;

--
ARCHITECTURE hdbdecreg OF hdbdecreg IS
-----------------------------------------------------------------------  
-- mino->LSB->.....MSB (shifts from LSB to MSB)                      --    
----------------------------------------------------------------------- 
BEGIN

END ARCHITECTURE hdbdecreg;

