
module softcore (
	clk_clk,
	gpio_external_export,
	gpio_lcd_external_export,
	lcd_ctl_external_wr_n,
	lcd_ctl_external_data_com_n,
	lcd_ctl_external_data_lcd,
	reset_reset_n,
	sdram_ctrl_wire_addr,
	sdram_ctrl_wire_ba,
	sdram_ctrl_wire_cas_n,
	sdram_ctrl_wire_cke,
	sdram_ctrl_wire_cs_n,
	sdram_ctrl_wire_dq,
	sdram_ctrl_wire_dqm,
	sdram_ctrl_wire_ras_n,
	sdram_ctrl_wire_we_n,
	sram_clk_clk);	

	input		clk_clk;
	inout	[31:0]	gpio_external_export;
	inout	[7:0]	gpio_lcd_external_export;
	output		lcd_ctl_external_wr_n;
	output		lcd_ctl_external_data_com_n;
	output	[15:0]	lcd_ctl_external_data_lcd;
	input		reset_reset_n;
	output	[11:0]	sdram_ctrl_wire_addr;
	output	[1:0]	sdram_ctrl_wire_ba;
	output		sdram_ctrl_wire_cas_n;
	output		sdram_ctrl_wire_cke;
	output		sdram_ctrl_wire_cs_n;
	inout	[15:0]	sdram_ctrl_wire_dq;
	output	[1:0]	sdram_ctrl_wire_dqm;
	output		sdram_ctrl_wire_ras_n;
	output		sdram_ctrl_wire_we_n;
	output		sram_clk_clk;
endmodule
