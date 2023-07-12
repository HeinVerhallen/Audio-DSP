library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Delay_effect is

port(
---------------------- To SDRAM controller ------------------------------
Data_write							: out		std_logic_vector(23 downto 0);			-- Input data bus
Data_address						: out		std_logic_vector(24 downto 0);			-- Address where u want to write or read data
read_enable							: out		STD_lOGIC;								 		-- read data enable
write_enable						: out 	STD_lOGIC;								 		-- write data enable
---------------------- Inputs -------------------------------------------
Reset_N								: in STD_LOGIC;
Enable								: in STD_LOGIC;
CLK									: in STD_LOGIC;							
DATA_IN								: in 	STD_LOGIC_VECTOR (23 downto 0);
---------------------- Outputs ------------------------------------------
DATA_OUT								: out 	STD_LOGIC_VECTOR (23 downto 0);
);
end entity Delay_effect;

architecture main of Delay_effect is 

SIGNAL Data_Delay: unsigned (47 downto 0);
BEGIN

PROCESS (CLK, Reset_N)
BEGIN

	if Reset_N = '0' then
		Data_write		<= (others := '0');
		Data_address	<= (others := '0');
		read_enable		<= '0';
		write_enable	<= '0';
		DATA_OUT			<= (others := '0');
	elsif rising_edge(CLK) then
	
	end if;
end PROCESS;
end main;