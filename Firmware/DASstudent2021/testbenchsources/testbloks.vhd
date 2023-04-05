--
-- VHDL Architecture DASLIB.testbloks.testblocks
--
-- Created:
--          by - 879291.UNKNOWN (PC143412)
--          at - 13:55:27 22-03-2018
--
-- using Mentor Graphics HDL Designer(TM) 2010.2a (Build 7)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY testbloks IS
   PORT( 
      encia  : OUT    std_logic_vector (23 DOWNTO 0);
      encib  : OUT    std_logic_vector (23 DOWNTO 0);
      nrst   : OUT    std_logic;
      clke   : INOUT  std_logic;
      push_B : OUT    std_logic;
      push_A : OUT    std_logic;
      simsel : OUT    std_logic
   );

-- Declarations

END testbloks ;

--
ARCHITECTURE testblocks OF testbloks IS
   constant clk_period : time := 20 ns;
 --     constant clk_period : time := 62.5 ns;
BEGIN
  
   nrst_process :process
   begin
        nrst <= '0';
        wait for 100 ns; 
        nrst <= '1';
        wait;
   end process; 
   clk_process :process
   begin
        clke <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clke <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;  
   process(clke)
     variable count:integer:=-1;
    variable pi_in,p1,p2 : std_logic_vector(23 downto 0);
    variable counter : integer:=16777216;
    variable counter1 : integer:=16777216;
    variable som1 : std_logic_vector (23 downto 0);
    procedure int2vec(inp: IN integer; outp: INOUT std_logic_vector) is
      variable tmp:integer;
      begin
              tmp:=inp;
              for i in outp'low to outp'high loop
                      if (tmp rem 2 ) = 1 then 
                              outp(i) := '1';
                      else
                              outp(i) := '0';
                      end if;
                      tmp:=tmp /2;
              end loop;
     end;

     begin
    if rising_edge(Clke) then
     simsel <= '1';
     Case count is 
     when -1 =>  encia<="111111111111111111111111"; encib<= "111111111111111111111111"; 
     when 17 =>  int2vec(counter, som1);p1:=som1;  counter:= counter-1;int2vec(counter1, som1);p2:= som1;
     when 65 =>  int2vec(counter, som1);p1:=som1;  counter:= counter-1;
     when 113 => int2vec(counter, som1);p1:=som1;  counter:= counter-1;
     when 161 => int2vec(counter, som1);p1:=som1;  counter:= counter-1;
     when others => null;
    end case;
         encia<= p2; encib<= p1;      
     if counter < 0 then counter := 16777216; counter1:=counter1-1; end if;
      count:=count+1;
      if (count > 191) then count:=0; end if;
  end if;
  end process;     
  
END ARCHITECTURE testblocks;

