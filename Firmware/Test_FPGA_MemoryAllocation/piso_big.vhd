LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

ENTITY piso IS
   generic (
      constant N : integer := 1000;
      constant sampleSize : integer := 24
   );
   PORT( 
      clk                  : IN     std_logic;
      encrypteddatain      : IN     std_logic_vector((N*sampleSize)-1 DOWNTO 0);
      shift                : IN     std_logic;
      loadpiso             : IN     std_logic;
      serout               : OUT    std_logic_vector(sampleSize-1 DOWNTO 0)
   );
END piso;

ARCHITECTURE arch OF piso IS
BEGIN
   process(clk)
      variable reg : std_logic_vector((N*sampleSize)-1 DOWNTO 0);
   begin
      if (rising_edge(clk)) then
         if (loadpiso='1') then
            reg := encrypteddatain((N*sampleSize)-1 DOWNTO 0);
         end if;

         if (shift='1') then
            serout <= reg((N*sampleSize)-1 DOWNTO (N*sampleSize)-sampleSize);
            reg := (reg((N*sampleSize)-sampleSize-1 DOWNTO 0) & "000000000000000000000000");
         end if;
      end if;
   end process;
END ARCHITECTURE arch;

