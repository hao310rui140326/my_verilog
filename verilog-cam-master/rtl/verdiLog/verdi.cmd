verdiDockWidgetDisplay -dock widgetDock_WelcomePage
verdiDockWidgetHide -dock widgetDock_WelcomePage
debImport "/home/hao/wrk/my_verilog/verilog-cam-master/rtl/cam.v" \
          "/home/hao/wrk/my_verilog/verilog-cam-master/rtl/cam_bram.v" \
          "/home/hao/wrk/my_verilog/verilog-cam-master/rtl/cam_srl.v" \
          "/home/hao/wrk/my_verilog/verilog-cam-master/rtl/priority_encoder.v" \
          "/home/hao/wrk/my_verilog/verilog-cam-master/rtl/ram_dp.v" -path \
          {/home/hao/wrk/my_verilog/verilog-cam-master/rtl}
srcHBSelect "cam.genblk1" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1" -delim "."
srcHBSelect "cam.genblk1" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1" -delim "."
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compare_data_padded" -win $_nTrace1
srcSearchString "compare_data_padded" -win $_nTrace1 -next -case
srcSearchString "compare_data_padded" -win $_nTrace1 -next -case
srcSearchString "compare_data_padded" -win $_nTrace1 -next -case
srcSearchString "compare_data_padded" -win $_nTrace1 -next -case
srcSearchString "compare_data_padded" -win $_nTrace1 -next -case
srcSearchString "compare_data_padded" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {72 72 13 14 1 1}
srcSearchString "compare_data_padded" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {72 72 13 14 1 1}
srcSearchString "compare_data_padded" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {72 72 13 14 1 1}
srcDeselectAll -win $_nTrace1
srcSelect -signal "compare_data" -win $_nTrace1
srcSearchString "compare_data" -win $_nTrace1 -next -case
srcSearchString "compare_data" -win $_nTrace1 -next -case
srcSearchString "compare_data" -win $_nTrace1 -next -case
srcSearchString "compare_data" -win $_nTrace1 -next -case
srcSearchString "compare_data" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compare_data\[SLICE_WIDTH * slice_ind +: W\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_addr\[SLICE_WIDTH * slice_ind +: W\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {151 151 5 6 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {150 150 6 7 1 1}
srcSearchString "ram_data" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {134 134 12 13 1 1}
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data" -win $_nTrace1
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcSearchString "write_data" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcAction -pos 163 5 15 -win $_nTrace1 -name "write_data_padded_reg" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram_wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram_wr_en" -win $_nTrace1
srcAction -pos 162 4 6 -win $_nTrace1 -name "erase_ram_wr_en" -ctrlKey off
nsMsgAction -tab trace -index {1 1 1}
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcForwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcForwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcForwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcHBSelect "cam" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compare_data_padded" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr_reg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_delete_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_busy_reg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_busy" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match_raw_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match_many_raw" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match_many_raw" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst.slice\[0\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[0\]" -delim "."
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram\[i\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram\[i\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram_wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram_wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "erase_ram\[write_addr_next\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "W" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 130 -pos 7 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 129 -pos 18 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 130 -pos 21 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 130 -pos 7 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 130 -pos 7 -win $_nTrace1
srcAction -pos 130 7 5 -win $_nTrace1 -name "slice_ind" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "W" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 136 2 6 -win $_nTrace1 -name "DATA_WIDTH" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 137 2 3 -win $_nTrace1 -name "ADDR_WIDTH" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {136 154 1 1 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {135 153 1 1 1 1} -backward
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {136 153 1 1 5 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {136 153 1 1 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {135 151 1 2 1 1} -backward
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {136 153 1 1 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {136 154 1 1 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "slice_ind" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clear_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "slice_ind" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "set_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcAction -pos 149 5 4 -win $_nTrace1 -name "ram_data" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "clear_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clear_bit" -win $_nTrace1
srcAction -pos 149 10 3 -win $_nTrace1 -name "clear_bit" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
nsMsgSelect -range {4 1 1-1}
nsMsgAction -tab trace -index {4 1 1}
nsMsgSelect -range {4 1 1-1}
nsMsgSelect -range {4 1 2-2}
nsMsgAction -tab trace -index {4 1 2}
nsMsgSelect -range {4 1 2-2}
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "set_bit" -win $_nTrace1
srcAction -pos 149 15 4 -win $_nTrace1 -name "set_bit" -ctrlKey off
nsMsgSelect -range {5 1 1-1}
nsMsgAction -tab trace -index {5 1 1}
nsMsgSelect -range {5 1 1-1}
nsMsgSelect -range {5 1 2-2}
nsMsgAction -tab trace -index {5 1 2}
nsMsgSelect -range {5 1 2-2}
nsMsgSelect -range {5 1 1-1}
nsMsgAction -tab trace -index {5 1 1}
nsMsgSelect -range {5 1 1-1}
nsMsgSelect -range {5 1 2-2}
nsMsgAction -tab trace -index {5 1 2}
nsMsgSelect -range {5 1 2-2}
nsMsgSelect -range {5 1 1-1}
nsMsgAction -tab trace -index {5 1 1}
nsMsgSelect -range {5 1 1-1}
nsMsgSelect -range {5 1 0-0}
nsMsgAction -tab trace -index {5 1 0}
nsMsgSelect -range {5 1 0-0}
nsMsgSelect -range {5 1 1-1}
nsMsgAction -tab trace -index {5 1 1}
nsMsgSelect -range {5 1 1-1}
nsMsgSelect -range {5 1 2-2}
nsMsgAction -tab trace -index {5 1 2}
nsMsgSelect -range {5 1 2-2}
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "set_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "state_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_IDLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "set_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "set_bit" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcForwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcShowDefine -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ram_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clear_bit" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcAction -pos 147 4 3 -win $_nTrace1 -name "wr_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "state_reg" -win $_nTrace1
srcAction -pos 184 4 5 -win $_nTrace1 -name "state_reg" -ctrlKey off
nsMsgSelect -range {7 1 1-1}
nsMsgAction -tab trace -index {7 1 1}
nsMsgSelect -range {7 1 1-1}
srcDeselectAll -win $_nTrace1
srcSelect -signal "state_next" -win $_nTrace1
srcAction -pos 246 5 6 -win $_nTrace1 -name "state_next" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_IDLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_INIT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "count_reg" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "count_reg" -win $_nTrace1
srcAction -pos 192 4 5 -win $_nTrace1 -name "count_reg" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_INIT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_INIT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_IDLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_enable" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_DELETE_1" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_IDLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_enable" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "state_next" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_DELETE_1" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_enable" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_enable" -win $_nTrace1
srcAction -pos 205 4 6 -win $_nTrace1 -name "write_enable" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -word -line 31 -pos 2 -win $_nTrace1
srcAction -pos 31 2 5 -win $_nTrace1 -name "cam_bram" -ctrlKey off
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -inst "cam_inst" -win $_nTrace1
srcAction -pos 85 1 5 -win $_nTrace1 -name "cam_inst" -ctrlKey off
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -next -case
srcSearchString "write_enable" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {206 206 5 6 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_DELETE_1" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 205 4 7 -win $_nTrace1 -name "write_enable" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_DELETE_1" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "STATE_DELETE_2" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_addr" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "wr_en" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_delete_reg" -win $_nTrace1
srcAction -pos 220 4 12 -win $_nTrace1 -name "write_delete_reg" -ctrlKey off
nsMsgSelect -range {11 1 1-1}
nsMsgAction -tab trace -index {11 1 1}
nsMsgSelect -range {11 1 1-1}
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_next" -win $_nTrace1
srcAction -pos 252 5 2 -win $_nTrace1 -name "write_data_padded_next" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcAction -pos 181 5 11 -win $_nTrace1 -name "write_data_padded_reg" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_next" -win $_nTrace1
srcAction -pos 82 26 14 -win $_nTrace1 -name "write_data_padded_next" -ctrlKey \
          off
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcAction -pos 181 5 16 -win $_nTrace1 -name "write_data_padded_reg" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_next" -win $_nTrace1
srcAction -pos 82 26 17 -win $_nTrace1 -name "write_data_padded_next" -ctrlKey \
          off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded_reg" -win $_nTrace1
srcAction -pos 181 5 16 -win $_nTrace1 -name "write_data_padded_reg" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcForwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 56 0 47 -win $_nTrace1 -name \
          "// total number of slices \(enough to cover DATA_WIDTH with address inputs\)" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
srcAction -pos 56 0 67 -win $_nTrace1 -name \
          "// total number of slices \(enough to cover DATA_WIDTH with address inputs\)" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
srcAction -pos 56 0 62 -win $_nTrace1 -name \
          "// total number of slices \(enough to cover DATA_WIDTH with address inputs\)" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
srcAction -pos 56 0 8 -win $_nTrace1 -name \
          "// total number of slices \(enough to cover DATA_WIDTH with address inputs\)" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {57 58 1 1 1 1} -backward
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "RAM_DEPTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 71 20 5 -win $_nTrace1 -name "SLICE_WIDTH" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_COUNT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data_padded" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "compare_data" -win $_nTrace1
srcAction -pos 71 29 3 -win $_nTrace1 -name "compare_data" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "cam.genblk1" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data" -win $_nTrace1
srcAction -pos 72 29 4 -win $_nTrace1 -name "write_data" -ctrlKey off
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcHBSelect "cam.genblk1.cam_inst.slice\[0\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[0\]" -delim "."
srcHBSelect "cam.genblk1.cam_inst.slice\[15\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[15\]" -delim "."
srcHBSelect "cam.genblk1.cam_inst.slice\[15\].ram_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[15\].ram_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcHBSelect "cam" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CAM_STYLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CAM_STYLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CAM_STYLE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "SLICE_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "DATA_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match_addr" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "match" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "write_data" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst" -delim "."
srcHBSelect "cam.genblk1.cam_inst.slice\[2\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[2\]" -delim "."
srcHBSelect "cam.genblk1.cam_inst.slice\[2\].ram_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[2\].ram_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst.slice\[2\].ram_inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[2\].ram_inst" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 31 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDR_WIDTH" -win $_nTrace1
srcHBSelect "cam.genblk1.cam_inst.slice\[11\]" -win $_nTrace1
srcSetScope -win $_nTrace1 "cam.genblk1.cam_inst.slice\[11\]" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
