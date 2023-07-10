	SDRAM u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //             clk.clk
		.clk143_clk                    (<connected-to-clk143_clk>),                    //          clk143.clk
		.reset_reset_n                 (<connected-to-reset_reset_n>),                 //           reset.reset_n
		.sdramcontroller_address       (<connected-to-sdramcontroller_address>),       // sdramcontroller.address
		.sdramcontroller_byteenable_n  (<connected-to-sdramcontroller_byteenable_n>),  //                .byteenable_n
		.sdramcontroller_chipselect    (<connected-to-sdramcontroller_chipselect>),    //                .chipselect
		.sdramcontroller_writedata     (<connected-to-sdramcontroller_writedata>),     //                .writedata
		.sdramcontroller_read_n        (<connected-to-sdramcontroller_read_n>),        //                .read_n
		.sdramcontroller_write_n       (<connected-to-sdramcontroller_write_n>),       //                .write_n
		.sdramcontroller_readdata      (<connected-to-sdramcontroller_readdata>),      //                .readdata
		.sdramcontroller_readdatavalid (<connected-to-sdramcontroller_readdatavalid>), //                .readdatavalid
		.sdramcontroller_waitrequest   (<connected-to-sdramcontroller_waitrequest>),   //                .waitrequest
		.wire_addr                     (<connected-to-wire_addr>),                     //            wire.addr
		.wire_ba                       (<connected-to-wire_ba>),                       //                .ba
		.wire_cas_n                    (<connected-to-wire_cas_n>),                    //                .cas_n
		.wire_cke                      (<connected-to-wire_cke>),                      //                .cke
		.wire_cs_n                     (<connected-to-wire_cs_n>),                     //                .cs_n
		.wire_dq                       (<connected-to-wire_dq>),                       //                .dq
		.wire_dqm                      (<connected-to-wire_dqm>),                      //                .dqm
		.wire_ras_n                    (<connected-to-wire_ras_n>),                    //                .ras_n
		.wire_we_n                     (<connected-to-wire_we_n>)                      //                .we_n
	);

