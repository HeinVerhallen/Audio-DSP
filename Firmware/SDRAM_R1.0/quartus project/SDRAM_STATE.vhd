library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SDRAM_STATE is

port (
-------------inputs---------------
CLK:									:in	  std_logic_vector;
NRST:									:in	  std_logic_vector;
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