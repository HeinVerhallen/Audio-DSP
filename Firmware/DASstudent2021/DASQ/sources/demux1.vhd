LIBRARY ieee;                          
USE ieee.std_logic_1164.all;      
USE ieee.std_logic_arith.all;
ENTITY demux1 IS  
   PORT(              
      sbits    : IN     std_logic;
      chdesel_c : IN     std_logic_vector (7 DOWNTO 0);
      sorL    : OUT    std_logic;     
      sorR    : OUT    std_logic           
   );                                           
-- Declarations
END demux1 ;         
ARCHITECTURE demux1 OF demux1 IS            
BEGIN                             
    process(chdesel_c, sbits)   
    begin               
      case chdesel_c is
      when "00000001" => sorL <=sbits;     
      when "00000010"  => sorR <=sbits;
--      when "00000011" => spraakout(1) <=bits;
--      when "00000100" => spraakout(2) <=bits;
--      when "00000101" => spraakout(3) <=bits;
--      when "00000110" => spraakout(4) <=bits;
--      when "00000111" => spraakout(5) <=bits;
--      when "00001000" => spraakout(6) <=bits;
--      when "00001001" => spraakout(7) <=bits;
--      when "00001010" => spraakout(8) <=bits;
--      when "00001011" => spraakout(9) <=bits;
--      when "00001100" => spraakout(10) <=bits;
--      when "00001101" => spraakout(11) <=bits;
--      when "00001110" => spraakout(12) <=bits;
--      when "00001111" => spraakout(13) <=bits;
--      when "00010000" => spraakout(14) <=bits;
--      when "00010001" => spraakout(15) <=bits;
--      when "00010010" => spraakout(16) <=bits;
--      when "00010011" => spraakout(17) <=bits;
--      when "00010100" => spraakout(18) <=bits;
--      when "00010101" => spraakout(19) <=bits;
--      when "00010110" => spraakout(20) <=bits;
       when others   => null;
       end case;           
   end process;       
 END ARCHITECTURE demux1;
