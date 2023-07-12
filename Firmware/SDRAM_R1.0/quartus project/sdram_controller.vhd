library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdram_controller is

port(

-----------------Inputs-------------------------
read_enable							: in		STD_lOGIC;								 -- read data enable
write_enable						: in 		STD_LOGIC;								 -- write data enable
Reset_N								: in 		STD_LOGIC;								 -- reset
CLK									: in		STD_LOGIC;								 --clock
Data_write							: in 		std_logic_vector(23 downto 0);			 -- Input data bus
Data_address						: in 		std_logic_vector(24 downto 0);			 -- Address where u want to write or read data
--sdramcontroller_readdata      : in   std_logic_vector(15 downto 0);                    -- readdata
--sdramcontroller_readdatavalid : in   std_logic;                                        -- readdatavalid
--sdramcontroller_waitrequest   : in   std_logic;                                        -- waitrequest
-----------------Outputs------------------------
Data_read							: out 	std_logic_vector(23 downto 0) := (others => 'X'); -- Output data bus
-----------------To SDRAM-----------------------
sdramcontroller_address       : out    std_logic_vector(24 downto 0) := (others => '0'); -- address
sdramcontroller_byteenable_n  : out    std_logic_vector(1 downto 0)  := (others => '0'); -- byteenable_n
sdramcontroller_chipselect    : out    std_logic                     := 'X';             -- chipselect
sdramcontroller_writedata     : out    std_logic_vector(15 downto 0) := (others => '0'); -- writedata
sdramcontroller_read_n        : out    std_logic                     := 'X';             -- read_n
sdramcontroller_write_n       : out    std_logic                     := 'X'              -- write_n

);
end entity sdram_controller;

architecture main of sdram_controller is 

SIGNAL Data_packet_1 : unsigned (15 downto 0) := (others => '0');
SIGNAL Data_packet_2 : unsigned (15 downto 0) := (others => '0');
SIGNAL Data_addres_next: unsigned (15 downto 0) := (others => '0');

TYPE STAGES IS (State_read_1, State_read_2, State_write_1, State_write_2, State_idle);
SIGNAL Current_state: STAGES:=State_idle;
SIGNAL Next_state: STAGES := State_idle;
SIGNAL Getal : unsigned (15 downto 0) := (others => '0');
BEGIN
-- convert 24 bit data to 2 times 16 bit
Data_packet_1 <= unsigned(Data_write (15 downto 0));
Data_packet_2(7 downto 0) <= unsigned(Data_write (23 downto 16));


PROCESS (read_enable, write_enable)
BEGIN

case Current_state is
	when State_read_1 => ----------read state----------
		
			Next_state <= State_read_2;
		
	when State_read_2 => ----------read state----------
		
		IF read_enable = '0' THEN
			Next_state <= State_idle;
		END IF;
		
	when State_write_1 => ----------write state-----------
		
			Next_state <= State_write_2;

		
	when State_write_2 => ----------write state-----------
		
		IF write_enable = '0' THEN
			Next_state <= State_idle;
		END IF;
		
	when State_idle => ---------- idle state------------

		------set reading or writing state---------
		if (read_enable = '1') then
			Next_state <= State_read_1;
		elsif (write_enable = '1') then
			Next_state <= State_write_1;
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
			when State_read_1 => 
				sdramcontroller_writedata 	<= (others => 'X');
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '0';
				sdramcontroller_write_n 		<= '1';
				sdramcontroller_address <= Data_address;
			when State_write_1 => 
				sdramcontroller_writedata 	<= std_logic_vector(Data_packet_1);
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '1';
				sdramcontroller_write_n 		<= '0';
				sdramcontroller_address <= Data_address;
			when State_read_2 => 
				sdramcontroller_writedata 	<= (others => 'X');
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '0';
				sdramcontroller_write_n 		<= '1';
				Data_addres_next					<= unsigned(Data_address);
				sdramcontroller_address 		<= std_logic_vector(Data_addres_next + 1);
			when State_write_2 => 
				sdramcontroller_writedata 	<= std_logic_vector(Data_packet_2);
				sdramcontroller_chipselect 	<= '1';
				sdramcontroller_read_n 			<= '1';
				sdramcontroller_write_n 		<= '0';
				Data_addres_next					<= unsigned(Data_address);
				sdramcontroller_address 		<= std_logic_vector(Data_addres_next + 1);
			when State_idle => 
				sdramcontroller_writedata 	<= (others => 'X');
				sdramcontroller_chipselect 	<= '0';
				sdramcontroller_read_n 			<= '1';
				sdramcontroller_write_n 		<= '1';
			
		end case;
	end if;
end PROCESS;
end main;