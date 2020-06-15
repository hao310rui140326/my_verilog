verdiDockWidgetDisplay -dock widgetDock_WelcomePage
verdiDockWidgetHide -dock widgetDock_WelcomePage
debImport "/home/hao/wrk/my_verilog/sort-master/order_1_3.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_1_4.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_1_4_tb.sv" \
          "/home/hao/wrk/my_verilog/sort-master/order_25D_comodel.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_25D_model_0.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_25D_model_1.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_25D_switch.v" \
          "/home/hao/wrk/my_verilog/sort-master/order_25D_switch_tb.sv" -path \
          {/home/hao/wrk/my_verilog/sort-master}
srcHBSelect "order_1_4_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_1_4_tb" -delim "."
srcHBSelect "order_1_4_tb.INITIAL_CLOCK" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_1_4_tb.INITIAL_CLOCK" -delim "."
srcHBSelect "order_1_4_tb.clk_c0" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_1_4_tb.clk_c0" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -inst "clk_c0" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb.bit" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.bit" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 35 1 2 -win $_nTrace1 -name "randc" -ctrlKey off
srcHBSelect "order_25D_switch_tb.clk_c0" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.clk_c0" -delim "."
srcHBSelect "order_25D_switch_tb.INITIAL_CLOCK" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.INITIAL_CLOCK" -delim "."
srcDeselectAll -win $_nTrace1
srcHBSelect "order_25D_switch_tb.order_25D_switch" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.order_25D_switch" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb.bit" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.bit" -delim "."
srcHBSelect "order_25D_switch_tb.clk_c0" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.clk_c0" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb" -delim "."
srcHBSelect "order_25D_switch_tb.bit" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.bit" -delim "."
srcHBSelect "order_25D_switch_tb.clk_c0" -win $_nTrace1
srcSetScope -win $_nTrace1 "order_25D_switch_tb.clk_c0" -delim "."
