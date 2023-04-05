LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY fourbitsE IS
   PORT( 
	   mino    : IN     std_logic;
      pluso   : IN     std_logic;
    	min          : IN     std_logic_vector (3 DOWNTO 0);
      plus         : IN     std_logic_vector (3 DOWNTO 0);
    	mins          : OUT    std_logic_vector (3 DOWNTO 0);
      pluss         : OUT     std_logic_vector (3 DOWNTO 0)

   );

-- Declarations

END fourbitsE ;

--
ARCHITECTURE fourbitsE OF fourbitsE IS
BEGIN
  process(mino, pluso, min, plus)
  begin
      pluss <= pluso&plus(3 downto 1);
      mins <= mino&min(3 downto 1);		
  end process;
END ARCHITECTURE fourbitsE;

