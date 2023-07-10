	component SDRAM is
		port (
			clk_clk                       : in    std_logic                     := 'X';             -- clk
			clk143_clk                    : out   std_logic;                                        -- clk
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
	end component SDRAM;

	u0 : component SDRAM
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --             clk.clk
			clk143_clk                    => CONNECTED_TO_clk143_clk,                    --          clk143.clk
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --           reset.reset_n
			sdramcontroller_address       => CONNECTED_TO_sdramcontroller_address,       -- sdramcontroller.address
			sdramcontroller_byteenable_n  => CONNECTED_TO_sdramcontroller_byteenable_n,  --                .byteenable_n
			sdramcontroller_chipselect    => CONNECTED_TO_sdramcontroller_chipselect,    --                .chipselect
			sdramcontroller_writedata     => CONNECTED_TO_sdramcontroller_writedata,     --                .writedata
			sdramcontroller_read_n        => CONNECTED_TO_sdramcontroller_read_n,        --                .read_n
			sdramcontroller_write_n       => CONNECTED_TO_sdramcontroller_write_n,       --                .write_n
			sdramcontroller_readdata      => CONNECTED_TO_sdramcontroller_readdata,      --                .readdata
			sdramcontroller_readdatavalid => CONNECTED_TO_sdramcontroller_readdatavalid, --                .readdatavalid
			sdramcontroller_waitrequest   => CONNECTED_TO_sdramcontroller_waitrequest,   --                .waitrequest
			wire_addr                     => CONNECTED_TO_wire_addr,                     --            wire.addr
			wire_ba                       => CONNECTED_TO_wire_ba,                       --                .ba
			wire_cas_n                    => CONNECTED_TO_wire_cas_n,                    --                .cas_n
			wire_cke                      => CONNECTED_TO_wire_cke,                      --                .cke
			wire_cs_n                     => CONNECTED_TO_wire_cs_n,                     --                .cs_n
			wire_dq                       => CONNECTED_TO_wire_dq,                       --                .dq
			wire_dqm                      => CONNECTED_TO_wire_dqm,                      --                .dqm
			wire_ras_n                    => CONNECTED_TO_wire_ras_n,                    --                .ras_n
			wire_we_n                     => CONNECTED_TO_wire_we_n                      --                .we_n
		);

