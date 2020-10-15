
verimode:
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  pcie_us_dma_axis.v    -f verilog-batch-auto
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  pcie_us_dma_sub_top.v -f verilog-batch-auto

verilator:
	verilator --cc -Wno-WIDTH -Wno-SELRANGE -Wno-PINMISSING --top-module pcie_us_dma_sub_top -y . pcie_us_dma_sub_top.v
