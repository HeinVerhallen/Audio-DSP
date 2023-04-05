--
-- Created:
--          by - tygtr (tekin Yilmaz global trade releation)
--          at - 13:08:31 08/18/2018
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

ENTITY piso IS
   PORT( 
      encrypteddatain     : IN     std_logic_vector (23 DOWNTO 0);
      serout              : OUT    std_logic;
      shift_c      : IN     std_logic;
      loadpiso_c : IN     std_logic;
      clk        : IN     std_logic
   );

-- Declarations

END piso ;

--
ARCHITECTURE piso OF piso IS
-----------------------------------------------------------------------  
-- 0->MSB->.....LSB (shifts from MSB to LSB)                         --    
-- the serial output is connected to LSB                             --
----------------------------------------------------------------------- 

BEGIN
   process(clk)
      variable reg : std_logic_vector (23 DOWNTO 0);
   begin
      if (rising_edge(clk)) then
         if (loadpiso_c='1') then
            reg := encrypteddatain(23 DOWNTO 0);
         end if;
			if (shift_c='1') then
            serout <= reg(0) after 5 ns;
            reg := ('0' & reg(23 DOWNTO 1));
         end if;
      end if;

   end process;
END ARCHITECTURE piso;

