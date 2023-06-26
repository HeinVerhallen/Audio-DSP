LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

ENTITY piso2 IS
   generic (
      constant N : integer := 1000;
      constant sampleSize : integer := 24
   );
   PORT( 
      clk                  : IN     std_logic;
      count                : IN     integer;
      encrypteddatain      : IN     std_logic_vector((2*N*sampleSize)-1 DOWNTO 0);
      shift                : IN     std_logic;
      loadpiso             : IN     std_logic;
      serout               : OUT    std_logic_vector(sampleSize-1 DOWNTO 0)
   );
END piso2;

ARCHITECTURE arch OF piso2 IS
BEGIN
   process(clk)
      --variable reg : std_logic_vector((N*sampleSize)-1 DOWNTO 0);
      variable countOffs : integer := 0;
      variable counter  : integer := 0;
      variable index    : integer;
   begin
      if (rising_edge(clk)) then
         if (loadpiso='1') then
            --reg := encrypteddatain((N*sampleSize)-1 DOWNTO 0);
            countOffs := count;
            counter := 0;
         end if;

         if (shift='1') then
            index := countOffs + counter;

            if (index > N-1) then
               index := index - N;
            end if;

            serout <= encrypteddatain(sampleSize*index+sampleSize-1 downto sampleSize*index);
            
            counter := counter + 1;
            if (counter > 2*N-1) then
               counter := 0;
            end if;
            --serout <= reg((N*sampleSize)-1 DOWNTO (N*sampleSize)-sampleSize);
            --reg := (reg((N*sampleSize)-sampleSize-1 DOWNTO 0) & "000000000000000000000000");
         end if;
      end if;
   end process;
END ARCHITECTURE arch;

