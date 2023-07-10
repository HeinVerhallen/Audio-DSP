library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SDRAM_STATE is

port (
-------------inputs---------------
CLK										:in	  std_logic_vector;
NRST									:in	  std_logic_vector;
--------------outputs-------------
wire_addr                     : out   std_logic_vector(12 downto 0);                    --            wire.addr
wire_ba                       : out   std_logic_vector(1 downto 0);                     --                .ba
wire_cas_n                    : out   std_logic;                                        --                .cas_n
wire_cke                      : out   std_logic;                                        --                .cke
wire_cs_n                     : out   std_logic;                                        --                .cs_n
wire_dq                       : inout std_logic_vector(15 downto 0) := (others => '0'); --                .dq
wire_dqm                      : out   std_logic_vector(1 downto 0);                     --                .dqm
wire_ras_n                    : out   std_logic;                                        --                .ras_n
wire_we_n                     : out   std_logic                                         --                .we_n
	);
end entity SDRAM_STATE;

architecture main of SDRAM_STATE is 

TYPE STATE IS (State_NOP , State_Precharge, State_Idle, State_AutoRefresh, State_MRS, State_Active, State_Read, State_Write);
SIGNAl Current_state: STATE:= State_Idle;
SIGNAL Next_state: STATE:= State_Idle;

TYPE ORDER is (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9 , ST10, ST11, ST12, ST13, ST14, ST15, ST16, ST17, ST18);
SIGNAL Current_Order: ORDER:= ST0;
SIGNAL Next_Order: ORDER:= ST0;

BEGIN
PROCESS (CLK, NRST)
BEGIN
if (NRST = 0) then	
	Current_state <= State_Idle;
	Current_Order <= ST0;
elsif rising_edge(CLK) then	
	Current_state <= Next_state;
	Current_Order <= Next_Order;
end if;



end PROCESS;
PROCESS (Current_state)
BEGIN
	case Current_state is
		when State_Idle => 
			--wire_cs_n <= 	'0';
			--wire_ras_n <= 	'1';
			--wire_cas_n <= 	'1';
			--wire_we_n <= 	'1';

		when State_NOP => ---------- no operation state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'1';
			wire_cas_n <= 	'1';
			wire_we_n <= 	'1';

		when State_MRS => ---------- mode select state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'0';
			wire_cas_n <= 	'0';
			wire_we_n <= 	'0';

		when State_AutoRefresh => ---------- auto refresh state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'0';
			wire_cas_n <= 	'0';
			wire_we_n <= 	'1';

		when State_Precharge => ---------- precharge state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'0';
			wire_cas_n <= 	'1';
			wire_we_n <= 	'0';

		when State_Active => ---------- activate row state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'0';
			wire_cas_n <= 	'1';
			wire_we_n <= 	'1';

		when State_Read => -------------- read row state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'1';
			wire_cas_n <= 	'0';
			wire_we_n <= 	'1';

		when State_Write => -------------- write row state
			wire_cs_n <= 	'0';
			wire_ras_n <= 	'1';
			wire_cas_n <= 	'0';
			wire_we_n <= 	'0';

	end case;

end PROCESS;

PROCESS (Current_Order)
BEGIN
	case Current_Order is
		when ST0 => 
			Next_state <= State_NOP;
			Next_Order <= ST1; 
		when ST1 => 
			Next_state <= State_Precharge;
			Next_Order <= ST2; 
		when ST2 => 
			Next_state <= State_AutoRefresh;
			Next_Order <= ST3; 
		when ST3 => 
			Next_state <= State_NOP;
			Next_Order <= ST4; 
		when ST4 => 
			Next_state <= State_AutoRefresh;
			Next_Order <= ST5; 
		when ST5 => 
			Next_state <= State_NOP;
			Next_Order <= ST6; 
		when ST6 => 
			Next_state <= State_MRS;
			Next_Order <= ST7; 
		when ST7 => 
			Next_state <= State_NOP;
			Next_Order <= ST8; 
		when ST8 => 
			Next_state <= State_NOP;
			Next_Order <= ST9; 
		when ST9 => 
			Next_state <= State_Active;
			Next_Order <= ST10; 
		when ST10 => 
			Next_state <= State_NOP;
			Next_Order <= ST11; 
		when ST11 => 
			Next_state <= State_Write;
			Next_Order <= ST12; 
		when ST12 => 
			Next_state <= State_NOP;
			Next_Order <= ST13; 
		when ST13 => 
			Next_state <= State_Read;
			Next_Order <= ST14; 
		when ST14 => 
			Next_state <= State_NOP;
			Next_Order <= ST15; 
		when ST15 => 
			Next_state <= State_NOP;
			Next_Order <= ST16; 
		when ST16 => 
			Next_state <= State_NOP;
			Next_Order <= ST17; 
		when ST17 => 
			Next_state <= State_NOP;
			Next_Order <= ST18; 
		when ST18 => 
			Next_state <= State_Precharge;
			Next_Order <= ST0; 
	end case;

end PROCESS;
end main;