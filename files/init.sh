restart -f

force -freeze sim:/dma_lcd_ctrl/reset_n_i 0 0
force -freeze sim:/dma_lcd_ctrl/clk_i 1 0, 0 {25 ps} -r 50
force -freeze sim:/dma_lcd_ctrl/master_waitrequest_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_rd_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 000 0
force -freeze sim:/dma_lcd_ctrl/master_readdata_i 0000000000000000 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000000 0
run
run
run
force -freeze sim:/dma_lcd_ctrl/reset_n_i 1 0
run
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 000 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000011 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
run

force -freeze sim:/dma_lcd_ctrl/avalon_address_i 000 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000011 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 1 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 1 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 001 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000001111 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
run

force -freeze sim:/dma_lcd_ctrl/avalon_address_i 001 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000001111 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 1 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 1 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 011 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000001111 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 1 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 1 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 010 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000001111 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 1 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 1 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 100 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000001 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 100 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000001 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 1 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 1 0
run
run
run
force -freeze sim:/dma_lcd_ctrl/avalon_address_i 100 0
force -freeze sim:/dma_lcd_ctrl/avalon_write_data_i 00000000000000000000000000000001 0
force -freeze sim:/dma_lcd_ctrl/avalon_wr_i 0 0
force -freeze sim:/dma_lcd_ctrl/avalon_cs_i 0 0
run
run
run
run
force -freeze sim:/dma_lcd_ctrl/master_readdata_i 0000000000000110 0
run
run
run
run
run
force -freeze sim:/dma_lcd_ctrl/master_readdata_i 0000000011000000 0
run
run
run