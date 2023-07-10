library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdram_controller is

port(

-----------------Inputs-------------------------
SW_read:					IN STD_lOGIC;
SW_write:				IN STD_LOGIC;
Reset_N:					IN STD_LOGIC;
CLK:						IN STD_LOGIC;
--sdramcontroller_readdata      : in   std_logic_vector(15 downto 0);                    -- readdata
--sdramcontroller_readdatavalid : in   std_logic;                                        -- readdatavalid
--sdramcontroller_waitrequest   : in   std_logic;                                        -- waitrequest

-----------------Outputs-----------------------
sdramcontroller_address       : out    std_logic_vector(24 downto 0) := (others => '0'); -- address
sdramcontroller_byteenable_n  : out    std_logic_vector(1 downto 0)  := (others => '0'); -- byteenable_n
sdramcontroller_chipselect    : out    std_logic                     := 'X';             -- chipselect
sdramcontroller_writedata     : out    std_logic_vector(15 downto 0) := (others => '0'); -- writedata
sdramcontroller_read_n        : out    std_logic                     := 'X';             -- read_n
sdramcontroller_write_n       : out    std_logic                     := 'X'              -- write_n



);
end entity sdram_controller;

architecture main of sdram_controller is 


TYPE STAGES IS (State_read , State_write, State_idle);
SIGNAL Current_state: STAGES:=State_idle;
SIGNAL Next_state: STAGES := State_idle;
SIGNAL Getal : unsigned (15 downto 0) := (others => '0');

BEGIN
PROCESS (SW_read, SW_write)
BEGIN

case Current_state is
	when State_read => ----------read state----------
--		sdramcontroller_chipselect 	<= '1';
--		sdramcontroller_read_n 			<= '0';
--		sdramcontroller_write_n 		<= '1';
		
		IF SW_read = '1' THEN
			Next_state <= State_idle;
		END IF;
		
	when State_write => ----------write state-----------
--		sdramcontroller_chipselect 	<= '1';
--		sdramcontroller_read_n 			<= '1';
--		sdramcontroller_write_n 		<= '0';
		
		IF SW_write = '1' THEN
			Next_state <= State_idle;
			
		Getal <= Getal + 1;
		if Getal > 6000 then
			Getal <= (others => '0');
		end if;
		END IF;
		
	when State_idle => ---------- idle state------------
--		sdramcontroller_chipselect		<= '0';
--		sdramcontroller_read_n 			<= '1';
--		sdramcontroller_write_n 		<= '1';

		------set reading or writing state---------
		if (SW_read = '0') then
			Next_state <= State_read;
		elsif (SW_write = '0') then
			Next_state <= State_write;
		end if;
end case;


end PROCESS;

PROCESS (CLK, Reset_N)
BEGIN
	if Reset_N = '0' then
		--sdramcontroller_chipselect <= '0';
		--sdramcontroller_read_n <= '1';
		--sdramcontroller_write_n <= '1';
		--sdramcontroller_writedata <= (others => '0');
		--Current_state <= State_idle;
	elsif rising_edge(CLK) then
		Current_state <= Next_state;
		
		case Current_state is
			when State_read => 
				sdramcontroller_writedata 	<= "0000000000000000";
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '0';
				sdramcontroller_write_n 		<= '1';
			when State_write => 
				sdramcontroller_writedata 	<= std_logic_vector(Getal);
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '1';
				sdramcontroller_write_n 		<= '0';
			when State_idle => 
				sdramcontroller_writedata 	<= "0000000000000000";
				sdramcontroller_chipselect 	<= '0';
				sdramcontroller_read_n 			<= '1';
				sdramcontroller_write_n 		<= '1';
			
		end case;
	end if;
end PROCESS;
end main;