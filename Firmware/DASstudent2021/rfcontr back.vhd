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
   when 9   =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000"; -- sync detect
         -- select speech channel 
   when 8      =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000011";
         -- select speech channel 
   when 16     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000100";
         -- select speech channel 
   when 24     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000101";
         -- select audio left 
   when 32     =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 56     =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 80     =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00000110" ;
   when 81     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000110" ;
         -- select speech channel 
   when 88     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00000111";
         -- select speech channel 
   when 96     =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001000";
         -- select speech channel 
   when 104    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001001";
         -- select audio left 
   when 112    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 136    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 160    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00001010" ;
   when 161    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001010" ;
         -- select speech channel 
   when 168    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001011";
         -- select speech channel 
   when 176    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001100";
         -- select speech channel 
   when 184    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001101";
         -- select audio left 
   when 192    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 216    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 240    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00001110" ;
   when 241    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001110" ;
         -- select speech channel 
   when 248    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00001111";
         -- select speech channel 
   when 256    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010000";
         -- select speech channel 
   when 264    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010001";
         -- select audio left 
   when 272    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 296    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
         -- select speech channel 
   when 320    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00010010" ;
   when 321    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010010" ;
         -- select speech channel 
   when 328    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010011";
         -- select speech channel 
   when 336    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010100";
         -- select speech channel 
   when 344    =>  writeadc <= '0';siL_c<='0';SiR_c<='0';chdesel_c <= "00010101";
         -- select audio left 
   when 352    =>  writeadc <= '0';siL_c<='1';SiR_c<='0';chdesel_c <= "00000001";--
         -- select audio right 
   when 376    =>  writeadc <= '0';siL_c<='0';SiR_c<='1';chdesel_c <= "00000010";--
   when 400    =>  writeadc <= '1';siL_c<='0';SiR_c<='0';chdesel_c <= "00000000";
           when others => null;
     End  Case;                
  if syncdetected_c = '1' then startcount:=1;count:= 4;  end if;
  if startcount = 1 then count := count+1; end if;
  if (count > 400) then count:= 4; startcount := 0; end if;
  end if;
 END PROCESS; 
END ARCHITECTURE rfcontr;
