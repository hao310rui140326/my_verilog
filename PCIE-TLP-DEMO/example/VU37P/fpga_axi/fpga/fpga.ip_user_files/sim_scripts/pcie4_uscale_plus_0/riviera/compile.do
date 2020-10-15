vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/gtwizard_ultrascale_v1_7_6

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap gtwizard_ultrascale_v1_7_6 riviera/gtwizard_ultrascale_v1_7_6

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source" \
"D:/Xilinx/SDx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/SDx/Vivado/2019.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/SDx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/SDx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work gtwizard_ultrascale_v1_7_6  -v2k5 "+incdir+../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_bit_sync.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gte4_drp_arb.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_delay_powergood.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_delay_powergood.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe3_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gthe4_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtye4_cal_freqcnt.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_reset.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_rx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_tx.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_sync.v" \
"../../../ipstatic/hdl/gtwizard_ultrascale_v1_7_reset_inv_sync.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/gtwizard_ultrascale_v1_7_gtye4_channel.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/pcie4_uscale_plus_0_gt_gtye4_channel_wrapper.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/gtwizard_ultrascale_v1_7_gtye4_common.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/pcie4_uscale_plus_0_gt_gtye4_common_wrapper.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/pcie4_uscale_plus_0_gt_gtwizard_gtye4.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/pcie4_uscale_plus_0_gt_gtwizard_top.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/sim/pcie4_uscale_plus_0_gt.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gtwizard_top.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_phy_ff_chain.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_phy_pipeline.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_async_fifo.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_cc_intfc.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_cc_output_mux.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_cq_intfc.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_cq_output_mux.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_intfc_int.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_intfc.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_rc_intfc.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_rc_output_mux.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_rq_intfc.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_rq_output_mux.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_512b_sync_fifo.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_16k_int.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_16k.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_32k.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_4k_int.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_msix.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_rep_int.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_rep.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram_tph.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_bram.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_gt_channel.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_gt_common.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_phy_clk.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_phy_rst.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_phy_rxeq.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_phy_txeq.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_sync_cell.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_sync.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_cdr_ctrl_on_eidle.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_receiver_detect_rxterm.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_gt_phy_wrapper.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_init_ctrl.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_pl_eq.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_vf_decode.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_pipe.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_phy_top.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_seqnum_fifo.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_sys_clk_gen_ps.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/source/pcie4_uscale_plus_0_pcie4_uscale_core_top.v" \
"../../../../fpga.srcs/sources_1/ip/pcie4_uscale_plus_0/sim/pcie4_uscale_plus_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

