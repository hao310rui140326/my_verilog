// Language: Verilog 2001

`timescale 1ns / 1ps

module pcie_dma_c2h_top (/*AUTOARG*/
   // Outputs
   s_axis_rq_tready, read_frame_enb, ram_rd_cmd_sel, m_axis_rq_tvalid,
   m_axis_rq_tuser, m_axis_rq_tlast, m_axis_rq_tkeep, m_axis_rq_tdata,
   m_axis_rq_seq_num_valid_1, m_axis_rq_seq_num_valid_0,
   m_axis_rq_seq_num_1, m_axis_rq_seq_num_0,
   // Inputs
   s_axis_rq_tvalid, s_axis_rq_tuser, s_axis_rq_tlast,
   s_axis_rq_tkeep, s_axis_rq_tdata, s_axis_rq_seq_num_valid_1,
   s_axis_rq_seq_num_valid_0, s_axis_rq_seq_num_1,
   s_axis_rq_seq_num_0, rst, requester_id_enable, requester_id,
   read_frame_tdata, read_frame_tag, read_frame_ready, read_frame_len,
   pcie_tx_fc_ph_av, pcie_tx_fc_pd_av, pcie_ram_base_addr,
   pcie_buf_size_kb, pcie_buf_cnt_max, max_payload_size,
   m_axis_rq_tready, enable_tlp_ram, enable_port, clk
   );

// Width of PCIe AXI stream interfaces in bits
parameter AXIS_PCIE_DATA_WIDTH = 512;
// PCIe AXI stream tkeep signal width (words per cycle)
parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32);
// PCIe AXI stream RQ tuser signal width
parameter AXIS_PCIE_RQ_USER_WIDTH = AXIS_PCIE_DATA_WIDTH < 512 ? 60 : 137;
// RQ sequence number width
parameter RQ_SEQ_NUM_WIDTH = AXIS_PCIE_RQ_USER_WIDTH == 60 ? 4 : 6;
// RQ sequence number tracking enable
parameter RQ_SEQ_NUM_ENABLE = 0;
// RAM segment count
parameter SEG_COUNT = AXIS_PCIE_DATA_WIDTH > 64 ? AXIS_PCIE_DATA_WIDTH*2 / 128 : 2;
// RAM segment data width
parameter SEG_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH*2/SEG_COUNT;
// RAM segment address width
parameter SEG_ADDR_WIDTH = 8;
// RAM segment byte enable width
parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
// RAM select width
parameter RAM_SEL_WIDTH = 1;
// RAM address width
parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
// PCIe address width
parameter PCIE_ADDR_WIDTH = 64;
// Length field width
parameter LEN_WIDTH = 16;
// Tag field width
parameter TAG_WIDTH = 8;
// Operation table size
parameter OP_TABLE_SIZE = 2**(RQ_SEQ_NUM_WIDTH-1);
// In-flight transmit limit
parameter TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1);
// Transmit flow control
parameter TX_FC_ENABLE = 0;
// Number of ports
parameter PORTS = 4;
// Width of AXI stream interfaces in bits
parameter FRAME_DATA_WIDTH = 1024;
// 帧数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
parameter FRAME_PIPELINE = 1;

localparam PCIE_RAM_NUM = 4;
// 分段式RAM的输出数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
localparam PIPELINE = 0;

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_0;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_1;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output			m_axis_rq_seq_num_valid_0;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output			m_axis_rq_seq_num_valid_1;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output			m_axis_rq_tlast;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output			m_axis_rq_tvalid;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [SEG_COUNT*RAM_SEL_WIDTH-1:0] ram_rd_cmd_sel;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
output [PORTS-1:0]	read_frame_enb;		// From dma_client_port_inst of dma_client_port.v
output			s_axis_rq_tready;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
// End of automatics
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			clk;			// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v, ...
input [PORTS-1:0]	enable_port;		// To dma_client_port_inst of dma_client_port.v
input [2:0]		enable_tlp_ram;		// To dma_client_port_inst of dma_client_port.v
input			m_axis_rq_tready;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [2:0]		max_payload_size;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [15:0]		pcie_buf_cnt_max;	// To dma_client_port_inst of dma_client_port.v
input [15:0]		pcie_buf_size_kb;	// To dma_client_port_inst of dma_client_port.v
input [4*PCIE_ADDR_WIDTH-1:0] pcie_ram_base_addr;// To dma_client_port_inst of dma_client_port.v
input [11:0]		pcie_tx_fc_pd_av;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [7:0]		pcie_tx_fc_ph_av;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [PORTS*LEN_WIDTH-1:0] read_frame_len;	// To dma_client_port_inst of dma_client_port.v
input [PORTS-1:0]	read_frame_ready;	// To dma_client_port_inst of dma_client_port.v
input [PORTS*TAG_WIDTH-1:0] read_frame_tag;	// To dma_client_port_inst of dma_client_port.v
input [PORTS*FRAME_DATA_WIDTH-1:0] read_frame_tdata;// To dma_client_port_inst of dma_client_port.v
input [15:0]		requester_id;		// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			requester_id_enable;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			rst;			// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v, ...
input [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_0;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_1;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			s_axis_rq_seq_num_valid_0;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			s_axis_rq_seq_num_valid_1;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rq_tdata;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rq_tkeep;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			s_axis_rq_tlast;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input [AXIS_PCIE_RQ_USER_WIDTH-1:0] s_axis_rq_tuser;// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
input			s_axis_rq_tvalid;	// To dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [LEN_WIDTH-1:0]	axis_write_desc_len;	// From dma_client_port_inst of dma_client_port.v
wire [PCIE_ADDR_WIDTH-1:0] axis_write_desc_pcie_addr;// From dma_client_port_inst of dma_client_port.v
wire [RAM_ADDR_WIDTH-1:0] axis_write_desc_ram_addr;// From dma_client_port_inst of dma_client_port.v
wire			axis_write_desc_ready;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
wire [TAG_WIDTH-1:0]	axis_write_desc_tag;	// From dma_client_port_inst of dma_client_port.v
wire			axis_write_desc_valid;	// From dma_client_port_inst of dma_client_port.v
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_rd_cmd_addr;// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
wire [SEG_COUNT-1:0]	ram_rd_cmd_ready;	// From dma_psdpram_inst of dma_psdpram.v
wire [SEG_COUNT-1:0]	ram_rd_cmd_valid;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_rd_resp_data;// From dma_psdpram_inst of dma_psdpram.v
wire [SEG_COUNT-1:0]	ram_rd_resp_ready;	// From dma_if_pcie_us_wr_inst of dma_if_pcie_reg_wr.v
wire [SEG_COUNT-1:0]	ram_rd_resp_valid;	// From dma_psdpram_inst of dma_psdpram.v
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_wr_cmd_addr;// From dma_client_port_inst of dma_client_port.v
wire [SEG_COUNT*SEG_BE_WIDTH-1:0] ram_wr_cmd_be;// From dma_client_port_inst of dma_client_port.v
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_wr_cmd_data;// From dma_client_port_inst of dma_client_port.v
wire [SEG_COUNT-1:0]	ram_wr_cmd_ready;	// From dma_psdpram_inst of dma_psdpram.v
wire [SEG_COUNT-1:0]	ram_wr_cmd_valid;	// From dma_client_port_inst of dma_client_port.v
// End of automatics
/*AUTOREG*/
wire [TAG_WIDTH-1:0]	axis_write_desc_status_tag;// From dma_if_pcie_us_wr_inst of dma_if_pcie_us_wr.v
wire					axis_write_desc_status_valid;// From dma_if_pcie_us_wr_inst of dma_if_pcie_us_wr.v

reg  [31:0]				axis_write_desc_cnt = 0;
reg  [31:0]				axis_send_desc_cnt  = 0;

always @(posedge clk) begin
	if(axis_write_desc_valid & axis_write_desc_ready) begin
		axis_write_desc_cnt <= axis_write_desc_cnt + 1'b1;
	end
	if(axis_write_desc_status_valid) begin
		axis_send_desc_cnt <= axis_send_desc_cnt + 1'b1;
	end
end

/*dma_if_pcie_us_wr  AUTO_TEMPLATE(
	.s_axis_write_desc_pcie_addr(axis_write_desc_pcie_addr[]),
	.s_axis_write_desc_ram_sel({RAM_SEL_WIDTH{1'b0}} ),
	.s_axis_write_desc_ram_addr(axis_write_desc_ram_addr[]),
	.s_axis_write_desc_len(axis_write_desc_len[]),
	.s_axis_write_desc_tag(axis_write_desc_tag[]),
	.s_axis_write_desc_valid(axis_write_desc_valid),
	.s_axis_write_desc_ready(axis_write_desc_ready),
);*/

//`ifdef NEW_REG_WR
//dma_if_pcie_reg_wr
//`else
dma_if_pcie_us_wr
			#(/*AUTOINSTPARAM*/
			  // Parameters
			  .AXIS_PCIE_DATA_WIDTH	(AXIS_PCIE_DATA_WIDTH),
			  .AXIS_PCIE_KEEP_WIDTH	(AXIS_PCIE_KEEP_WIDTH),
			  .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
			  .RQ_SEQ_NUM_WIDTH	(RQ_SEQ_NUM_WIDTH),
			  .RQ_SEQ_NUM_ENABLE	(RQ_SEQ_NUM_ENABLE),
			  .SEG_COUNT		(SEG_COUNT),
			  .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
			  .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
			  .SEG_BE_WIDTH		(SEG_BE_WIDTH),
			  .RAM_SEL_WIDTH	(RAM_SEL_WIDTH),
			  .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
			  .PCIE_ADDR_WIDTH	(PCIE_ADDR_WIDTH),
			  .LEN_WIDTH		(LEN_WIDTH),
			  .TAG_WIDTH		(TAG_WIDTH),
			  .OP_TABLE_SIZE	(OP_TABLE_SIZE),
			  .TX_LIMIT		(TX_LIMIT),
			  .TX_FC_ENABLE		(TX_FC_ENABLE),
			  .PIPELINE			(PIPELINE))
dma_if_pcie_us_wr_inst (
			.enable		(|enable_port       ),
			.m_axis_write_desc_status_tag(axis_write_desc_status_tag[TAG_WIDTH-1:0]), 
			.m_axis_write_desc_status_valid(axis_write_desc_status_valid), 
			/*AUTOINST*/
			// Outputs
			.s_axis_rq_tready(s_axis_rq_tready),
			.m_axis_rq_tdata(m_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
			.m_axis_rq_tkeep(m_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
			.m_axis_rq_tvalid(m_axis_rq_tvalid),
			.m_axis_rq_tlast(m_axis_rq_tlast),
			.m_axis_rq_tuser(m_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
			.m_axis_rq_seq_num_0(m_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
			.m_axis_rq_seq_num_valid_0(m_axis_rq_seq_num_valid_0),
			.m_axis_rq_seq_num_1(m_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
			.m_axis_rq_seq_num_valid_1(m_axis_rq_seq_num_valid_1),
			.s_axis_write_desc_ready(axis_write_desc_ready), // Templated
			.ram_rd_cmd_sel	(ram_rd_cmd_sel[SEG_COUNT*RAM_SEL_WIDTH-1:0]),
			.ram_rd_cmd_addr(ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
			.ram_rd_cmd_valid(ram_rd_cmd_valid[SEG_COUNT-1:0]),
			.ram_rd_resp_ready(ram_rd_resp_ready[SEG_COUNT-1:0]),
			// Inputs
			.clk		(clk),
			.rst		(rst),
			.s_axis_rq_tdata(s_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
			.s_axis_rq_tkeep(s_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
			.s_axis_rq_tvalid(s_axis_rq_tvalid),
			.s_axis_rq_tlast(s_axis_rq_tlast),
			.s_axis_rq_tuser(s_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
			.m_axis_rq_tready(m_axis_rq_tready),
			.s_axis_rq_seq_num_0(s_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
			.s_axis_rq_seq_num_valid_0(s_axis_rq_seq_num_valid_0),
			.s_axis_rq_seq_num_1(s_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
			.s_axis_rq_seq_num_valid_1(s_axis_rq_seq_num_valid_1),
			.pcie_tx_fc_ph_av(pcie_tx_fc_ph_av[7:0]),
			.pcie_tx_fc_pd_av(pcie_tx_fc_pd_av[11:0]),
			.s_axis_write_desc_pcie_addr(axis_write_desc_pcie_addr[PCIE_ADDR_WIDTH-1:0]), // Templated
			.s_axis_write_desc_ram_sel({RAM_SEL_WIDTH{1'b0}} ), // Templated
			.s_axis_write_desc_ram_addr(axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]), // Templated
			.s_axis_write_desc_len(axis_write_desc_len[LEN_WIDTH-1:0]), // Templated
			.s_axis_write_desc_tag(axis_write_desc_tag[TAG_WIDTH-1:0]), // Templated
			.s_axis_write_desc_valid(axis_write_desc_valid), // Templated
			.ram_rd_cmd_ready(ram_rd_cmd_ready[SEG_COUNT-1:0]),
			.ram_rd_resp_data(ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
			.ram_rd_resp_valid(ram_rd_resp_valid[SEG_COUNT-1:0]),
			.requester_id	(requester_id[15:0]),
			.requester_id_enable(requester_id_enable),
			.max_payload_size(max_payload_size[2:0]));

/*dma_client_port  AUTO_TEMPLATE(
    .m_axis_write_desc_pcie_addr(axis_write_desc_pcie_addr[]),
	.m_axis_write_desc_ram_addr(axis_write_desc_ram_addr[]),
	.m_axis_write_desc_len(axis_write_desc_len[]),
	.m_axis_write_desc_tag(axis_write_desc_tag[]),
	.m_axis_write_desc_valid(axis_write_desc_valid),
	.m_axis_write_desc_ready(axis_write_desc_ready),
);*/

dma_client_port #(/*AUTOINSTPARAM*/
		  // Parameters
		  .PORTS		(PORTS),
		  .SEG_COUNT		(SEG_COUNT),
		  .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
		  .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		  .SEG_BE_WIDTH		(SEG_BE_WIDTH),
		  .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
		  .PCIE_ADDR_WIDTH	(PCIE_ADDR_WIDTH),
		  .FRAME_DATA_WIDTH	(FRAME_DATA_WIDTH),
		  .LEN_WIDTH		(LEN_WIDTH),
		  .TAG_WIDTH		(TAG_WIDTH),
		  .FRAME_PIPELINE	(FRAME_PIPELINE))
dma_client_port_inst (/*AUTOINST*/
		      // Outputs
		      .m_axis_write_desc_pcie_addr(axis_write_desc_pcie_addr[PCIE_ADDR_WIDTH-1:0]), // Templated
		      .m_axis_write_desc_ram_addr(axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]), // Templated
		      .m_axis_write_desc_len(axis_write_desc_len[LEN_WIDTH-1:0]), // Templated
		      .m_axis_write_desc_tag(axis_write_desc_tag[TAG_WIDTH-1:0]), // Templated
		      .m_axis_write_desc_valid(axis_write_desc_valid), // Templated
		      .read_frame_enb	(read_frame_enb[PORTS-1:0]),
		      .ram_wr_cmd_be	(ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
		      .ram_wr_cmd_addr	(ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
		      .ram_wr_cmd_data	(ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
		      .ram_wr_cmd_valid	(ram_wr_cmd_valid[SEG_COUNT-1:0]),
		      // Inputs
		      .clk		(clk),
		      .rst		(rst),
		      .m_axis_write_desc_ready(axis_write_desc_ready), // Templated
		      .read_frame_tdata	(read_frame_tdata[PORTS*FRAME_DATA_WIDTH-1:0]),
		      .read_frame_ready	(read_frame_ready[PORTS-1:0]),
		      .read_frame_len	(read_frame_len[PORTS*LEN_WIDTH-1:0]),
		      .read_frame_tag	(read_frame_tag[PORTS*TAG_WIDTH-1:0]),
		      .ram_wr_cmd_ready	(ram_wr_cmd_ready[SEG_COUNT-1:0]),
		      .enable_port	(enable_port[PORTS-1:0]),
		      .enable_tlp_ram	(enable_tlp_ram[2:0]),
		      .pcie_ram_base_addr(pcie_ram_base_addr[4*PCIE_ADDR_WIDTH-1:0]),
		      .pcie_buf_size_kb	(pcie_buf_size_kb[15:0]),
		      .pcie_buf_cnt_max	(pcie_buf_cnt_max[15:0]));

/*dma_psdpram  AUTO_TEMPLATE(
    .clk_wr         (clk                ),  
    .rst_wr         (rst                ),
    .clk_rd         (clk                ),
    .rst_rd         (rst                ),
    .rd_cmd_addr    (ram_rd_cmd_addr  []),
    .rd_cmd_valid   (ram_rd_cmd_valid []),
    .rd_cmd_ready   (ram_rd_cmd_ready []),
    .rd_resp_data   (ram_rd_resp_data []),
    .rd_resp_valid  (ram_rd_resp_valid[]),
    .rd_resp_ready  (ram_rd_resp_ready[]),
    .wr_cmd_be      (ram_wr_cmd_be    []),
    .wr_cmd_addr    (ram_wr_cmd_addr  []),
    .wr_cmd_data    (ram_wr_cmd_data  []),
    .wr_cmd_valid   (ram_wr_cmd_valid []),
    .wr_cmd_ready   (ram_wr_cmd_ready []),
);*/

dma_psdpram #(
	      // Parameters
	      .SIZE			    (4096/4),	//最小的缓存大小为1KB，即8096比特，选择使用块RAM实现时，默认大小为4Kbyte
	      .SEG_COUNT		(SEG_COUNT),
	      .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
	      .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		  .SEG_BE_WIDTH		(SEG_BE_WIDTH),
		  .PIPELINE			(PIPELINE))
dma_psdpram_inst (/*AUTOINST*/
		  // Outputs
		  .wr_cmd_ready		(ram_wr_cmd_ready [SEG_COUNT-1:0]), // Templated
		  .rd_cmd_ready		(ram_rd_cmd_ready [SEG_COUNT-1:0]), // Templated
		  .rd_resp_data		(ram_rd_resp_data [SEG_COUNT*SEG_DATA_WIDTH-1:0]), // Templated
		  .rd_resp_valid	(ram_rd_resp_valid[SEG_COUNT-1:0]), // Templated
		  // Inputs
		  .clk_wr		(clk                ),	 // Templated
		  .rst_wr		(rst                ),	 // Templated
		  .wr_cmd_be		(ram_wr_cmd_be    [SEG_COUNT*SEG_BE_WIDTH-1:0]), // Templated
		  .wr_cmd_addr		(ram_wr_cmd_addr  [SEG_COUNT*SEG_ADDR_WIDTH-1:0]), // Templated
		  .wr_cmd_data		(ram_wr_cmd_data  [SEG_COUNT*SEG_DATA_WIDTH-1:0]), // Templated
		  .wr_cmd_valid		(ram_wr_cmd_valid [SEG_COUNT-1:0]), // Templated
		  .clk_rd		(clk                ),	 // Templated
		  .rst_rd		(rst                ),	 // Templated
		  .rd_cmd_addr		(ram_rd_cmd_addr  [SEG_COUNT*SEG_ADDR_WIDTH-1:0]), // Templated
		  .rd_cmd_valid		(ram_rd_cmd_valid [SEG_COUNT-1:0]), // Templated
		  .rd_resp_ready	(ram_rd_resp_ready[SEG_COUNT-1:0])); // Templated

endmodule

// Local Variables:
// verilog-library-flags:("-y ./")
// verilog-auto-inst-param-value:t
// End:
