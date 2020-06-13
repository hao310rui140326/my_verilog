DUMP=NONE
MODE=NONE
MY_IP=SIM_SPEED_UP
LOG1=NONE
LOG2=PCIE
LOG3=NONE
LOG4=NONE
LOG5=NONE
LOG6=NONE
LOG7=NONE
LOG8=NONE
LOG9=NONE
LONG=LONG
CASE=NONE
OCHECK=NONE
UCHECK=NONE
OCHECK_50=NONE
NSAVE=NONE
OCHECK_10_HEAD=NONE
OCHECK_50_HEAD=NONE

#PCIE
##verdi_path = /opt/Verdi3_L-2016.06-1
##verdi_path = /opt/tools/verdi
verdi_path = /usr/synopsys/Verdi3_L-2016.06-1




default :
	echo "\`define  $(DUMP)       "  >   define.v
	echo "\`define  $(OCHECK)     "  >>   define.v
	echo "\`define  $(UCHECK)     "  >>   define.v	
	echo "\`define  $(OCHECK_50)  "  >>   define.v	
	echo "\`define  $(NSAVE)      "  >>   define.v	
	echo "\`define  $(MODE)       "  >>  define.v
	echo "\`define  $(MY_IP)      "  >>  define.v
	echo "\`define  $(LOG1)       "  >>  define.v
	echo "\`define  $(LOG2)       "  >>  define.v
	echo "\`define  $(LOG3)       "  >>  define.v
	echo "\`define  $(LOG4)       "  >>  define.v
	echo "\`define  $(LOG5)       "  >>  define.v
	echo "\`define  $(LOG6)       "  >>  define.v
	echo "\`define  $(LOG7)       "  >>  define.v		
	echo "\`define  $(LOG8)       "  >>  define.v		
	echo "\`define  $(LOG9)       "  >>  define.v					
	echo "\`define  $(LONG)       "  >>  define.v
	echo "\`define  $(CASE)       "  >>  define.v
	echo "\`define  $(OCHECK_10_HEAD)       "  >>  define.v
	echo "\`define  $(OCHECK_50_HEAD)       "  >>  define.v
	vcs -full64 -lca -timescale=1ns/1ps  -P  $(verdi_path)/share/PLI/VCS/LINUX64/novas.tab   $(verdi_path)/share/PLI/VCS/LINUX64/pli.a +vcs+lic+wait +vcd+vcdpluson  -sverilog +verilog2001ext+.v  +lint=TFIPC-L    -debug_all   -f tb.vc -top tb       -l vcs_com.log
	./simv -debug_all         -l vcs_sim.log 
##	urg -dir     cov_result/my_cov_info_$(MODE)    -metric line+cond+fsm+tgl -report cov_report/report_$(MODE)   -format both
##	mv fpga_output.txt  fpga_output_$(MODE).txt
	


cov :
	echo "\`define  $(DUMP)       "  >   define.v
	echo "\`define  $(OCHECK)     "  >>   define.v
	echo "\`define  $(UCHECK)     "  >>   define.v	
	echo "\`define  $(OCHECK_50)  "  >>   define.v	
	echo "\`define  $(NSAVE)      "  >>   define.v	
	echo "\`define  $(MODE)       "  >>  define.v
	echo "\`define  $(MY_IP)      "  >>  define.v
	echo "\`define  $(LOG1)       "  >>  define.v
	echo "\`define  $(LOG2)       "  >>  define.v
	echo "\`define  $(LOG3)       "  >>  define.v
	echo "\`define  $(LOG4)       "  >>  define.v
	echo "\`define  $(LOG5)       "  >>  define.v
	echo "\`define  $(LOG6)       "  >>  define.v
	echo "\`define  $(LOG7)       "  >>  define.v		
	echo "\`define  $(LOG8)       "  >>  define.v		
	echo "\`define  $(LOG9)       "  >>  define.v					
	echo "\`define  $(LONG)       "  >>  define.v
	echo "\`define  $(CASE)       "  >>  define.v
	/bin/cp ../../Code/include/step_fast_param.vh   ./
	/bin/cp ../../Code/include/step_fast_pkg.sv   ./
	/bin/cp ../../Code/pcie_pio_tlp_top/rtl/pcie_tlp_param.vh  ./
	/bin/cp ../tb/tb_top/step_sim_pkg.sv   ./
	vcs -full64 -lca -timescale=1ns/1ps  -P  $(verdi_path)/share/PLI/VCS/LINUX64/novas.tab   $(verdi_path)/share/PLI/VCS/LINUX64/pli.a +vcs+lic+wait +vcd+vcdpluson  -sverilog +verilog2001ext+.v  +lint=TFIPC-L    -debug_all   -f tb.vc -top tb    -cm line+cond+fsm+tgl -cm_dir cov_result/my_cov_info     -l vcs_com.log
	./simv -debug_all    -cm line+cond+fsm+tgl -cm_dir cov_result/my_cov_info      -l vcs_sim.log 
	urg -dir     cov_result/my_cov_info    -metric line+cond+fsm+tgl -report cov_report/report   -format both
##	mv fpga_output.txt  fpga_output_$(MODE).txt
	




clean:
	rm -rf simv*
	rm -rf csrc*  *.log  verdiLog  novas* 
	rm -rf cov_result*  *.fsdb  *.vpd


auto_emacs:
	cp ../rtl/com_pipline.v   ../rtl/com_inline.v   ./	
	emacs   --batch   tb.sv             -f verilog-auto     -f save-buffer 	
	rm com_pipline.v  com_inline.v





verdi:
	##source /home/haorui/.bashrc_2015
	verdi -sv -f tb.vc &



dve:
	dve -full64  &

wave:
	dve -full64 -vpd vcdplus.vpd &
	
