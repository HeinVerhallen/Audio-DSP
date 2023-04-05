--
-- Created:
--          by - tygtr (tekin Yilmaz global trade releation)
--          at - 13:08:31 08/18/2018
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY decryptionblock IS
   PORT( 
      encrypteddatain   : IN     std_logic_vector (23 DOWNTO 0);
      decrypteddataout  : OUT    std_logic_vector (23 DOWNTO 0)
   );

END decryptionblock ;

ARCHITECTURE decryptionblock OF decryptionblock IS
BEGIN
   process(encrypteddatain)
      begin
      for i in 0 to 23 loop
         decrypteddataout(i) <= encrypteddatain(23 - i);
      end loop;
   end process;
END ARCHITECTURE decryptionblock;

