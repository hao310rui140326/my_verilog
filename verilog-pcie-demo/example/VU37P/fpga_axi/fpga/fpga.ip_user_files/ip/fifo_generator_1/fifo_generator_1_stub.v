// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Jun 15 17:33:56 2020
// Host        : guowei7lc10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/guow_test/verilog-pcie-demo/example/VU37P/fpga_axi/fpga/fpga.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_stub.v
// Design      : fifo_generator_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu37p-fsvh2892-2L-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1" *)
module fifo_generator_1(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[23:0],wr_en,rd_en,dout[23:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [23:0]din;
  input wr_en;
  input rd_en;
  output [23:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
