--
-- Created:
--          by - tygtr (tekin Yilmaz global trade releation)
--          at - 13:08:31 08/18/2018
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY sipo IS
   PORT( 
      clk    : IN     std_logic;
      shift  : IN     std_logic;
      sinput : IN     std_logic;
      parout : OUT    std_logic_vector (23 DOWNTO 0)
	
   );

-- Declarations

END sipo ;

--
ARCHITECTURE sipo OF sipo IS
-----------------------------------------------------------------------  
-- sinput->MSB->.....LSB (shifts from MSB to LSB)                      --    
----------------------------------------------------------------------- 
--signal reg : std_logic_vector(23 downto 0);
BEGIN
   process(clk)
		variable reg : std_logic_vector(23 downto 0);
   begin
      if (rising_edge(clk)) then
         if (shift = '1') then
            reg := (sinput & reg(23 downto 1));
            parout <= reg after 1 ns;
         end if;
      end if;
   end process;

END ARCHITECTURE sipo;

