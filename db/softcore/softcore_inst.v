	softcore u0 (
		.clk_clk                          (<connected-to-clk_clk>),                          //                       clk.clk
		.leds_external_connections_export (<connected-to-leds_external_connections_export>), // leds_external_connections.export
		.reset_reset_n                    (<connected-to-reset_reset_n>),                    //                     reset.reset_n
		.sdram_ctrl_wire_addr             (<connected-to-sdram_ctrl_wire_addr>),             //           sdram_ctrl_wire.addr
		.sdram_ctrl_wire_ba               (<connected-to-sdram_ctrl_wire_ba>),               //                          .ba
		.sdram_ctrl_wire_cas_n            (<connected-to-sdram_ctrl_wire_cas_n>),            //                          .cas_n
		.sdram_ctrl_wire_cke              (<connected-to-sdram_ctrl_wire_cke>),              //                          .cke
		.sdram_ctrl_wire_cs_n             (<connected-to-sdram_ctrl_wire_cs_n>),             //                          .cs_n
		.sdram_ctrl_wire_dq               (<connected-to-sdram_ctrl_wire_dq>),               //                          .dq
		.sdram_ctrl_wire_dqm              (<connected-to-sdram_ctrl_wire_dqm>),              //                          .dqm
		.sdram_ctrl_wire_ras_n            (<connected-to-sdram_ctrl_wire_ras_n>),            //                          .ras_n
		.sdram_ctrl_wire_we_n             (<connected-to-sdram_ctrl_wire_we_n>),             //                          .we_n
		.sram_clk_clk                     (<connected-to-sram_clk_clk>)                      //                  sram_clk.clk
	);

