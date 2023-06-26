LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY sipo2 IS
   generic (
      constant N : integer := 1000;
      constant sampleSize : integer := 24
   );
   PORT( 
      clk    : IN  std_logic;
      shift  : IN  std_logic;
      sinput : IN  std_logic_vector(sampleSize - 1 downto 0);
      count  : OUT integer;
      parout : OUT std_logic_vector((2*N*sampleSize)-1 DOWNTO 0)
   );
END sipo2 ;

ARCHITECTURE arch OF sipo2 IS
BEGIN
   process(clk)
        --variable reg : std_logic_vector((N*sampleSize)-1 downto 0);
      variable counter : integer := 0;
   begin
      if (rising_edge(clk)) then
         if (shift = '1') then
            --reg := (reg((N*sampleSize)-sampleSize-1 downto 0) & sinput);
            parout(sampleSize*counter+sampleSize-1 downto sampleSize*counter) <= sinput;
            if (counter - (N/2)-1 < 0) then
               count <= N - ((N/2)-1 - counter);
            else
               count <= counter - (N/2)-1;
            end if;
            
            counter := counter + 1;
            if (counter > 2*N-1) then
               counter := 0;
            end if;
         end if;
      end if;
   end process;
END ARCHITECTURE arch;

