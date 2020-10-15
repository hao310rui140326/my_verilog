create_project -force -part xcvu9p-fsgd2104-2L-e fpga
add_files -fileset sources_1 defines.v
add_files -fileset sources_1 ../rtl/fpga.v
add_files -fileset sources_1 ../rtl/fpga_core.v
add_files -fileset sources_1 ../rtl/debounce_switch.v
add_files -fileset sources_1 ../rtl/sync_reset.v
add_files -fileset sources_1 ../rtl/sync_signal.v
add_files -fileset sources_1 ../rtl/axi_ram.v
add_files -fileset sources_1 ../rtl/axis_register.v
add_files -fileset sources_1 ../lib/pcie/rtl/axis_arb_mux.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axil_master.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_dma.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_dma_rd.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_dma_wr.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_tag_manager.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_master.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_master_rd.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axi_master_wr.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_axis_cq_demux.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_cfg.v
add_files -fileset sources_1 ../lib/pcie/rtl/pcie_us_msi.v
add_files -fileset sources_1 ../lib/pcie/rtl/arbiter.v
add_files -fileset sources_1 ../lib/pcie/rtl/priority_encoder.v
add_files -fileset sources_1 ../lib/pcie/rtl/pulse_merge.v
add_files -fileset constrs_1 ../fpga.xdc
import_ip ../ip/pcie4_uscale_plus_0.xci
exit
