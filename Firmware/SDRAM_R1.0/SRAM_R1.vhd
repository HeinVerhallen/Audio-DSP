library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity sdram_controller is

port(

CLOCK_50MHz:					IN STD_LOGIC;
SW:								IN STD_LOGIC_VECTOR(9 downto 0);
--------------SDRAM------------------------
DRAM_ADDR: 						OUT STD_LOGIC_VECTOR(12 downto 0);
DRAM_BA:							OUT STD_LOGIC_VECTOR(1 downto 0);
DRAM_CAS_N:						OUT STD_LOGIC;
DRAM_CKE:						OUT STD_LOGIC;
DRAM_CLK:						OUT STD_LOGIC;
DRAM_CS_N:						OUT STD_LOGIC;
DRAM_DQ:							INOUT STD_LOGIC_VECTOR (15 downto 0);
DRAM_RAS_N:						OUT STD_LOGIC;
DRAM_WE_N:						OUT STD_LOGIC;
DRAM_LDQM, DRAM_UDQM:		OUT STD_LOGIC
);


end sdram_controller;

architecture main of sdram_controller is 
---------------------clock----------------------
SIGNAL CLK143: STD_LOGIC;
---------------------sdram----------------------
SIGNAL SDRAM_ADDR:								STD_LOGIC_VECTOR(24 downto 0);
SIGNAL SDRAM_BE_N:								STD_LOGIC_VECTOR(1 downto 0);
SIGNAL SDRAM_CS:									STD_LOGIC;
SIGNAL SDRAM_RDVAL, SDRAM_WAIT:				STD_LOGIC;
SIGNAL SDRAM_RE_N, SDRAM_WE_N:				STD_LOGIC;
SIGNAL SDRAM_READDATA, SDRAM_WRITEDATA:	STD_LOGIC_VECTOR(15 downto 0);
SIGNAL DRAM_DQM: 									STD_LOGIC_VECTOR(1 downto 0);
-------------------------------------------------

    component SDRAM is
        port (
            clk_clk                       : in    std_logic                     := 'X';             -- clk
				clk143_clk							: out   std_logic;							  							 -- clk
            reset_reset_n                 : in    std_logic                     := 'X';             -- reset_n
            sdramcontroller_address       : in    std_logic_vector(24 downto 0) := (others => 'X'); -- address
            sdramcontroller_byteenable_n  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable_n
            sdramcontroller_chipselect    : in    std_logic                     := 'X';             -- chipselect
            sdramcontroller_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
            sdramcontroller_read_n        : in    std_logic                     := 'X';             -- read_n
            sdramcontroller_write_n       : in    std_logic                     := 'X';             -- write_n
            sdramcontroller_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
            sdramcontroller_readdatavalid : out   std_logic;                                        -- readdatavalid
            sdramcontroller_waitrequest   : out   std_logic;                                        -- waitrequest
            wire_addr                     : out   std_logic_vector(12 downto 0);                    -- addr
            wire_ba                       : out   std_logic_vector(1 downto 0);                     -- ba
            wire_cas_n                    : out   std_logic;                                        -- cas_n
            wire_cke                      : out   std_logic;                                        -- cke
            wire_cs_n                     : out   std_logic;                                        -- cs_n
            wire_dq                       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            wire_dqm                      : out   std_logic_vector(1 downto 0);                     -- dqm
            wire_ras_n                    : out   std_logic;                                        -- ras_n
            wire_we_n                     : out   std_logic                                         -- we_n
        );
    end component;
begin

    u1 : component SDRAM
        port map(
            clk_clk                       => CLOCK_50MHz,                   --                clk.clk
				clk143_clk							=> CLK143,								 --					 clk143.clk
            reset_reset_n                 => '1',                				 --                reset.reset_n
            sdramcontroller_address       => SDRAM_ADDR,      					 -- 					  sdramcontroller.address
            sdramcontroller_byteenable_n  => SDRAM_BE_N, 						 --                .byteenable_n
            sdramcontroller_chipselect    => SDRAM_CS,    						 --                .chipselect
            sdramcontroller_writedata     => SDRAM_WRITEDATA,     			 --                .writedata
            sdramcontroller_read_n        => SDRAM_RE_N,        				 --                .read_n
            sdramcontroller_write_n       => SDRAM_WE_N,       				 --                .write_n
            sdramcontroller_readdata      => SDRAM_READDATA,      			 --                .readdata
            sdramcontroller_readdatavalid => SDRAM_RDVAL, 						 --                .readdatavalid
            sdramcontroller_waitrequest   => SDRAM_WAIT,   						 --                .waitrequest
            wire_addr                     => DRAM_ADDR,                     --            	  wire.addr
            wire_ba                       => DRAM_BA,                       --                .ba
            wire_cas_n                    => DRAM_CAS_N,                    --                .cas_n
            wire_cke                      => DRAM_CKE,                      --                .cke
            wire_cs_n                     => DRAM_CS_N,                     --                .cs_n
            wire_dq                       => DRAM_DQ,                       --                .dq
            wire_dqm                      => DRAM_DQM,                      --                .dqm
            wire_ras_n                    => DRAM_RAS_N,                    --                .ras_n
            wire_we_n                     => DRAM_WE_N                      --                .we_n
        );
		  
PROCESS (CLK143)
begin
if rising_edge(CLK143) then

end if;
end PROCESS;
end main;