verdiDockWidgetDisplay -dock widgetDock_WelcomePage
verdiDockWidgetHide -dock widgetDock_WelcomePage
debImport "/home/hao/wrk/my_nic/verilog-pcie-demo/tb/test_dma_c2h_tb.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/arbiter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/axis_arb_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_sink.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_source.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_psdpram.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_axi_dma_desc_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_tag_manager.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axil_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_cq_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_rc_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_cfg.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_axis.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_sub_top.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_msi.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/priority_encoder.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pulse_merge.v" -path \
          {/home/hao/wrk/my_nic/verilog-pcie-demo/tb}
verdiWindowResize -win $_Verdi_1 "738" "348" "902" "701"
verdiWindowResize -win $_Verdi_1 "738" "348" "909" "704"
verdiWindowResize -win $_Verdi_1 "738" "348" "987" "729"
verdiWindowResize -win $_Verdi_1 "738" "348" "1137" "755"
verdiWindowResize -win $_Verdi_1 "738" "348" "1387" "811"
verdiWindowResize -win $_Verdi_1 "738" "348" "1493" "843"
verdiWindowResize -win $_Verdi_1 "738" "348" "1531" "853"
verdiWindowResize -win $_Verdi_1 "738" "348" "1537" "858"
verdiWindowResize -win $_Verdi_1 "738" "348" "1560" "874"
verdiWindowResize -win $_Verdi_1 "738" "348" "1572" "886"
verdiWindowResize -win $_Verdi_1 "738" "348" "1581" "907"
verdiWindowResize -win $_Verdi_1 "738" "348" "1582" "916"
verdiWindowResize -win $_Verdi_1 "738" "348" "1581" "926"
verdiWindowResize -win $_Verdi_1 "738" "348" "1579" "928"
verdiWindowResize -win $_Verdi_1 "738" "348" "1578" "929"
verdiWindowResize -win $_Verdi_1 "738" "348" "1577" "929"
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.fifo_read_monitor_inst" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.genblk1\[3\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.genblk1\[3\]" -delim "."
srcHBSelect "test_dma_c2h_tb.genblk1\[3\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.genblk1\[3\]" -delim "."
srcHBSelect "test_dma_c2h_tb.genblk1\[0\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.genblk1\[0\]" -delim "."
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcDeselectAll -win $_nTrace1
srcAction -pos 304 0 11 -win $_nTrace1 -name "pcie_dma_c2h_top" -ctrlKey off
nsMsgSwitchTab -tab general
debImport "/home/hao/wrk/my_nic/verilog-pcie-demo/tb/test_dma_c2h_tb.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/arbiter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/axis_arb_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_sink.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_source.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_psdpram.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_axi_dma_desc_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_tag_manager.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axil_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_cq_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_rc_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_cfg.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_axis.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_sub_top.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_msi.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/priority_encoder.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pulse_merge.v" -path \
          {/home/hao/wrk/my_nic/verilog-pcie-demo/tb}
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.fifo_read_monitor_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.fifo_read_monitor_inst" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
nsMsgSwitchTab -tab general
debImport "/home/hao/wrk/my_nic/verilog-pcie-demo/tb/test_dma_c2h_tb.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/arbiter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/axis_arb_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_sink.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_client_axis_source.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_mux_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_if_pcie_us_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/dma_psdpram.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_axi_dma_desc_mux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_tag_manager.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_dma_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_rd.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axi_master_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axil_master.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_cq_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_axis_rc_demux.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_cfg.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_axis.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_dma_sub_top.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pcie_us_msi.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/priority_encoder.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/rtl/pulse_merge.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/arbiter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/axis_adapter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/axis_fifo.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/axis_fifo_adapter.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/dma_client_port.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/dma_if_pcie_reg_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/dma_if_pcie_us_wr.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/dma_psdpram.v" "-f" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/filelist.f" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/gen_frame_sim.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/pcie_dma_c2h_top.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/priority_encoder.v" \
          "/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma/tb_top.v" -path \
          {/home/hao/wrk/my_nic/verilog-pcie-demo/c2h_dma}
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.fifo_read_monitor_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.fifo_read_monitor_inst" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "tb_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top" -delim "."
srcHBSelect "tb_top.pcie_dma_c2h_top_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.pcie_dma_c2h_top_inst" -delim "."
srcHBSelect "tb_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top" -delim "."
srcDeselectAll -win $_nTrace1
srcAction -pos 282 2 8 -win $_nTrace1 -name "gen_frame_sim" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -inst "gen_frame_sim_i" -win $_nTrace1
srcAction -pos 291 2 9 -win $_nTrace1 -name "gen_frame_sim_i" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcAction -pos 282 2 7 -win $_nTrace1 -name "gen_frame_sim" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_top.genblk1\[0\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\]" -delim "."
srcHBSelect "tb_top.genblk1\[0\].gen_frame_sim_i" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\].gen_frame_sim_i" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -word -line 4 -pos 2 -win $_nTrace1
srcAction -pos 4 2 8 -win $_nTrace1 -name "gen_frame_sim" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_top.genblk1\[0\].gen_frame_sim_i" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\].gen_frame_sim_i" -delim "."
srcHBSelect "tb_top.genblk1\[0\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\]" -delim "."
srcHBSelect "tb_top.genblk1\[0\].gen_frame_sim_i" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\].gen_frame_sim_i" -delim "."
srcHBSelect "tb_top.genblk1\[0\].gen_frame_sim_i" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.genblk1\[0\].gen_frame_sim_i" -delim "."
srcHBSelect "tb_top.genblk1\[0\].gen_frame_sim_i.get_frame_len_cycle" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "tb_top.genblk1\[0\].gen_frame_sim_i.get_frame_len_cycle" -delim \
           "."
srcHBSelect "tb_top.genblk1\[0\]" -win $_nTrace1
srcHBSelect "tb_top" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT.dma_client_port_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT.dma_client_port_inst" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT.dma_if_pcie_us_wr_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT.dma_if_pcie_us_wr_inst" -delim \
           "."
srcHBSelect "test_dma_c2h_tb.DUT.dma_psdpram_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT.dma_psdpram_inst" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {68 80 1 8 26 2}
srcDeselectAll -win $_nTrace1
srcSelect -signal "m_axis_rq_tkeep" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "s_axis_rq_seq_num_0" -win $_nTrace1
srcAction -pos 100 10 12 -win $_nTrace1 -name "s_axis_rq_seq_num_0" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "s_axis_rq_seq_num_valid_0" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {361 361 7 7 1 18}
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {156 156 1 1 30 47}
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {86 86 6 6 1 18}
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {85 85 6 6 1 18}
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {84 84 11 11 1 18}
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {83 83 11 11 1 18}
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {364 364 7 7 1 18}
srcHBSelect "tb_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top" -delim "."
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcSearchString "s_axis_rq_seq_num" -win $_nTrace1 -next -case
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_len\[PORTS*LEN_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_ready\[PORTS-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tag\[PORTS*TAG_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tdata\[PORTS*FRAME_DATA_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id\[15:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id_enable" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id\[15:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tdata\[PORTS*FRAME_DATA_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_ready\[PORTS-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_len\[PORTS*LEN_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_ready\[PORTS-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tag\[PORTS*TAG_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tag\[PORTS*TAG_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id\[15:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tdata\[PORTS*FRAME_DATA_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_ready\[PORTS-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tag\[PORTS*TAG_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_frame_tdata\[PORTS*FRAME_DATA_WIDTH-1:0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id\[15:0\]" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.fifo_read_monitor_inst" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {68 80 1 8 25 21}
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {83 100 1 10 18 2}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {85 99 10 6 8 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {101 110 8 1 1 1}
verdiWindowResize -win $_Verdi_1 "738" "347" "1577" "930"
verdiWindowResize -win $_Verdi_1 "738" "327" "1577" "950"
verdiWindowResize -win $_Verdi_1 "738" "314" "1577" "963"
verdiWindowResize -win $_Verdi_1 "738" "282" "1577" "995"
verdiWindowResize -win $_Verdi_1 "738" "252" "1577" "1025"
verdiWindowResize -win $_Verdi_1 "738" "241" "1577" "1036"
verdiWindowResize -win $_Verdi_1 "738" "227" "1577" "1050"
verdiWindowResize -win $_Verdi_1 "738" "220" "1577" "1057"
verdiWindowResize -win $_Verdi_1 "738" "219" "1577" "1058"
verdiWindowResize -win $_Verdi_1 "738" "185" "1577" "1092"
verdiWindowResize -win $_Verdi_1 "738" "146" "1577" "1131"
verdiWindowResize -win $_Verdi_1 "738" "104" "1577" "1173"
verdiWindowResize -win $_Verdi_1 "738" "102" "1577" "1175"
srcDeselectAll -win $_nTrace1
srcSelect -signal "requester_id" -win $_nTrace1
srcAction -pos 97 9 9 -win $_nTrace1 -name "requester_id" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_dma_c2h_tb.DUT" -delim "."
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -next -case
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {15 15 2 2 15 18}
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {14 14 5 5 15 18}
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {14 14 2 2 15 18}
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {13 13 8 8 15 18}
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {10 10 5 5 15 18}
srcSearchString "num" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {10 10 2 2 15 18}
srcDeselectAll -win $_nTrace1
srcSelect -signal "m_axis_rq_seq_num_0" -win $_nTrace1
srcAction -pos 9 4 10 -win $_nTrace1 -name "m_axis_rq_seq_num_0" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT.dma_if_pcie_us_wr_inst" -win $_nTrace1
srcHBSelect "test_dma_c2h_tb.DUT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "test_dma_c2h_tb" -win $_nTrace1
