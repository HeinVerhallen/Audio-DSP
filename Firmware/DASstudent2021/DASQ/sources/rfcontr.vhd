LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;    
ENTITY rfcontr IS                     
   PORT(                                   
      clk          : IN     std_logic;          
      nrst         : IN     std_logic;               
      syncdetected_c : IN     std_logic;                    
      chdesel_c      : OUT    std_logic_vector (7 DOWNTO 0);
      siL_c          : OUT    std_logic;
      SiR_c          : OUT    std_logic;     
      writeadc     : OUT    std_logic                
   );                                                     
-- Declarations
END rfcontr ;       
ARCHITECTURE rfcontr OF rfcontr IS
BEGIN                                       
PROCESS (nrst,Clk)                               
  Variable count : Integer:=0;                        
  variable startcount : integer:=0;                        
BEGIN
if nrst = '0' then count:=1;startcount := 0;
 elsif rising_edge(Clk) then     
  Case count is                       
   when 1   =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000"; -- sync detect
   when 4   =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000"; -- sync detect
   --when 9   =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000"; -- sync detect
         -- select speech channel 
   when 8      =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000011";
         -- select speech channel 
   when 16     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000100";
         -- select speech channel 
   when 24     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000101";
         -- select audio left 
   when 33     =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 57     =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 81     =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00000110" ;
   when 82     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000110" ;
         -- select speech channel 
   when 89     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000111";
         -- select speech channel 
   when 97     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001000";
         -- select speech channel 
   when 105    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001001";
         -- select audio left 
   when 113    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 137    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 161    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00001010" ;
   when 162    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001010" ;
         -- select speech channel 
   when 169    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001011";
         -- select speech channel 
   when 177    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001100";
         -- select speech channel 
   when 185    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001101";
         -- select audio left 
   when 193    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 217    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 241    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00001110" ;
   when 242    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001110" ;
         -- select speech channel 
   when 249    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001111";
         -- select speech channel 
   when 257    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010000";
         -- select speech channel 
   when 265    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010001";
         -- select audio left 
   when 273    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 297    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 321    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00010010" ;
   when 322    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010010" ;
         -- select speech channel 
   when 323    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010011";
         -- select speech channel 
   when 337    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010100";
         -- select speech channel 
   when 345    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010101";
         -- select audio left 
   when 353    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 377    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
   when 401    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000";
           when others => null;
     End  Case;                
  if syncdetected_c = '1' then startcount:=1;count:= 4;  end if;
  if startcount = 1 then count := count+1; end if;
  if (count > 401) then count:= 4; startcount := 0; end if;
  end if;
 END PROCESS; 
END ARCHITECTURE rfcontr;
