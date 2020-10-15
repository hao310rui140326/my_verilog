
verimode:
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  dma_client_port.v    -f verilog-batch-auto
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  pcie_dma_c2h_top.v   -f verilog-batch-auto
	#emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  gen_frame_sim.v      -f verilog-batch-auto
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  tb_top.v             -f verilog-batch-auto
	emacs  --batch  --no-site-file -l ~/.emacs.d/verilog-mode.el  ../tb/test_dma_c2h_tb.v 	-f verilog-batch-auto

verilator:
	verilator --cc -Wno-WIDTH -Wno-SELRANGE -Wno-PINMISSING --top-module pcie_dma_c2h_top -y . pcie_dma_c2h_top.v

iverilog:
	iverilog -o tb_top.vvp -f filelist.f
	vvp  tb_top.vvp -lxt2 

verdi:
	verdi -ssy -ssv -f ./filelist.f -top tb_top &

new:
	iverilog -o tb_top_new.vvp -D NEW_REG_WR -f filelist.f
	vvp  tb_top_new.vvp -lxt2 
