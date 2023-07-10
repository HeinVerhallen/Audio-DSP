
module SDRAM (
	clk_clk,
	clk143_clk,
	reset_reset_n,
	sdramcontroller_address,
	sdramcontroller_byteenable_n,
	sdramcontroller_chipselect,
	sdramcontroller_writedata,
	sdramcontroller_read_n,
	sdramcontroller_write_n,
	sdramcontroller_readdata,
	sdramcontroller_readdatavalid,
	sdramcontroller_waitrequest,
	wire_addr,
	wire_ba,
	wire_cas_n,
	wire_cke,
	wire_cs_n,
	wire_dq,
	wire_dqm,
	wire_ras_n,
	wire_we_n);	

	input		clk_clk;
	output		clk143_clk;
	input		reset_reset_n;
	input	[24:0]	sdramcontroller_address;
	input	[1:0]	sdramcontroller_byteenable_n;
	input		sdramcontroller_chipselect;
	input	[15:0]	sdramcontroller_writedata;
	input		sdramcontroller_read_n;
	input		sdramcontroller_write_n;
	output	[15:0]	sdramcontroller_readdata;
	output		sdramcontroller_readdatavalid;
	output		sdramcontroller_waitrequest;
	output	[12:0]	wire_addr;
	output	[1:0]	wire_ba;
	output		wire_cas_n;
	output		wire_cke;
	output		wire_cs_n;
	inout	[15:0]	wire_dq;
	output	[1:0]	wire_dqm;
	output		wire_ras_n;
	output		wire_we_n;
endmodule
