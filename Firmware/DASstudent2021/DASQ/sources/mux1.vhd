LIBRARY ieee;                          
USE ieee.std_logic_1164.all;      
USE ieee.std_logic_arith.all;
ENTITY mux1 IS          
   PORT(          
      chsel_c : IN     std_logic_vector (7 DOWNTO 0);
      soLo   : IN     std_logic;         
      soRo   : IN     std_logic;    
      so    : OUT    std_logic
   );
-- Declarations                                  
END mux1 ;                                   
ARCHITECTURE mux1 OF mux1 IS             
BEGIN                             
  process(chsel_c, soLo, soRo)   
    begin               
      case chsel_c is
      when "00000000" => so <='1';     
      when "00000001" => so <=soLo;     
      when "00000010"  => so <=soRo;
      when "00000011" => so <='0';
      when "00000100" => so <='0';
      when "00000101" => so <='0';
      when "00000110" => so <='0';
      when "00000111" => so <='0';
      when "00001000" => so <='0';
      when "00001001" => so <='0';
      when "00001010" => so <='0';
      when "00001011" => so <='0';
      when "00001100" => so <='0';
      when "00001101" => so <='0';
      when "00001110" => so <='0';
      when "00001111" => so <='0';
      when "00010000" => so <='0';
      when "00010001" => so <='0';
      when "00010010" => so <='0';
      when "00010011" => so <='0';
      when "00010100" => so <='0';
      when "00010101" => so <='0';
      when "00010110" => so <='1';
       when others   => so<='1';
       end case;           
   end process;       
 END ARCHITECTURE mux1;
