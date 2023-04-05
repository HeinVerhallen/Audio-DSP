--
-- Created:
--          by - tygtr (tekin Yilmaz global trade releation)
--          at - 13:08:31 08/18/2018
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY encryptionblock IS
   PORT( 
      datain          : IN     std_logic_vector (23 DOWNTO 0);
      encrypeddataout : OUT    std_logic_vector (23 DOWNTO 0)
   );

END encryptionblock ;

ARCHITECTURE encryptionblock OF encryptionblock IS
BEGIN
   process(datain)
      begin
      for i in 0 to 23 loop
         encrypeddataout(i) <= datain(23 - i);
      end loop;
   end process;
END ARCHITECTURE encryptionblock;

