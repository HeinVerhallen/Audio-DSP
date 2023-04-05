--------------------------------------------------------------------------------
--
-- File Type:    VHDL 
-- Tool Version: verilog2vhdl 19.01a
-- Input file was: clock_500.v.vpp
-- Command line was: D:\SynaptiCAD\bin\win32\verilog2vhdl.exe clock_500.v clock_500.vhdl
-- Date Created: Sun Oct 01 09:22:44 2017
--
--------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;



ENTITY CLK2MHZ IS	
    PORT (
         CLOCK: IN std_logic;	

         CLKBCLK : OUT std_logic	

		  
		  );	
END CLK2MHZ;



ARCHITECTURE CLK2MHZ OF CLK2MHZ IS
begin
    PROCESS (CLOCK)
	 variable cnt: integer:=0;

    BEGIN
		  if (rising_edge(CLOCK)) then
			   cnt:=cnt+1;
			  if cnt < 13 then
			    CLKBCLK <= '0';
			  else 
			    CLKBCLK <= '1';
			  end if;
			  if cnt > 23 then
			  cnt:=0;
			  end if;
		  end if;
    END PROCESS;

	
END CLK2MHZ;
