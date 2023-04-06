LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY delay IS
   PORT( 
      clk  : IN   std_logic;
      dinL : IN   std_logic_vector(23 downto 0);
      dinR : IN   std_logic_vector(23 downto 0);
      doutL : OUT std_logic_vector(23 downto 0);
      doutR : OUT std_logic_vector(23 downto 0)
   );
END delay ;

ARCHITECTURE arch OF delay IS
  constant delayTime : integer := 50e-3; --ms
  constant f_clock   : integer := 2e6; 

  constant audioBits : integer := 24;
  constant memCapacity : integer := delayTime / f_clock;

  signal memL : std_logic_vector((audioBits * memCapacity - 1) downto 0);
  signal memR : std_logic_vector((audioBits * memCapacity - 1) downto 0);

BEGIN
  process(clk) 
  begin
    if rising_edge(clk) then
      memL <= memL(memL'high - audioBits downto 0) & dinL(23 downto 0);
      memR <= memR(memR'high - audioBits downto 0) & dinR(23 downto 0);

      doutL <= memL(memL'high downto memL'high - audioBits + 1);
      doutR <= memR(memR'high downto memR'high - audioBits + 1);
    end if;
  end process; 
END ARCHITECTURE arch;

