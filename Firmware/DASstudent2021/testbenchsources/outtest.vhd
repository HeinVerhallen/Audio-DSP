--
-- VHDL Architecture DASLIB.outtest.testout
--
-- Created:
--          by - 879291.UNKNOWN (PC513871)
--          at - 09:57:20  1-06-2016
--
-- using Mentor Graphics HDL Designer(TM) 2010.2a (Build 7)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY outtest IS
   PORT( 
      clk        : IN     std_logic;
		writeadc   : IN     std_logic;
		loadpiso_c : IN     std_logic;
      decoa      : IN     std_logic_vector (23 DOWNTO 0);
      decob      : IN     std_logic_vector (23 DOWNTO 0);
      encia      : IN     std_logic_vector (23 DOWNTO 0);
      encib      : IN     std_logic_vector (23 DOWNTO 0);

      ok         : OUT    std_logic
   );

-- Declarations

END outtest ;

--
ARCHITECTURE testout OF outtest IS
  signal prevl, prevadc : std_logic;
BEGIN
  
  process(clk)
  variable adcdataL, adcdataR, dacdataL, dacdataR : std_logic_vector(23 downto 0);
  begin
    if rising_edge (clk) then
      prevl <= writeadc;
      prevadc <= prevl;
    if loadpiso_c = '1' then adcdataL := encia; adcdataR := encib; end if;
    if prevadc='1' then  dacdataL := decoa; dacdataR := decob;  prevl<='0';
      if adcdataL = dacdataL  and adcdataR = dacdataR then ok <= '1'; else ok <= '0';   
         assert false
           report "Fail"
         severity error;
      end if;
    end if; 
  end if;     
 end process; 
END ARCHITECTURE testout;

