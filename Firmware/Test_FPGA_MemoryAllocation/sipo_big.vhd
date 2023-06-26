LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY sipo IS
   generic (
      constant N : integer := 1000;
      constant sampleSize : integer := 24
   );
   PORT( 
      clk    : IN  std_logic;
      shift  : IN  std_logic;
      sinput : IN  std_logic_vector(sampleSize - 1 downto 0);
      parout : OUT std_logic_vector((N*sampleSize)-1 DOWNTO 0)
   );
END sipo ;

ARCHITECTURE arch OF sipo IS
BEGIN
   process(clk)
        variable reg : std_logic_vector((N*sampleSize)-1 downto 0);
   begin
      if (rising_edge(clk)) then
         if (shift = '1') then
            reg := (reg((N*sampleSize)-sampleSize-1 downto 0) & sinput);
            parout <= reg;
         end if;
      end if;
   end process;
END ARCHITECTURE arch;

