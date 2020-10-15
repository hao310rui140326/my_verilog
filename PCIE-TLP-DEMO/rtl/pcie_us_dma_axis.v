`timescale 1ns / 1ps

module pcie_us_dma_axis (/*AUTOARG*/
   // Outputs
   s_axis_write_desc_ready, s_axis_write_data_tready,
   s_axis_read_desc_ready, m_axis_write_desc_status_valid,
   m_axis_write_desc_status_user, m_axis_write_desc_status_tag,
   m_axis_write_desc_status_len, m_axis_write_desc_status_id,
   m_axis_write_desc_status_dest, m_axis_read_desc_status_valid,
   m_axis_read_desc_status_tag, m_axis_read_data_tvalid,
   m_axis_read_data_tuser, m_axis_read_data_tlast,
   m_axis_read_data_tkeep, m_axis_read_data_tid,
   m_axis_read_data_tdest, m_axis_read_data_tdata, ram_wr_cmd_ready,
   ram_rd_cmd_ready, ram_rd_resp_data, ram_rd_resp_valid,
   // Inputs
   s_axis_write_desc_valid, s_axis_write_desc_tag,
   s_axis_write_desc_ram_addr, s_axis_write_desc_len,
   s_axis_write_data_tvalid, s_axis_write_data_tuser,
   s_axis_write_data_tlast, s_axis_write_data_tkeep,
   s_axis_write_data_tid, s_axis_write_data_tdest,
   s_axis_write_data_tdata, s_axis_read_desc_valid,
   s_axis_read_desc_user, s_axis_read_desc_tag,
   s_axis_read_desc_ram_addr, s_axis_read_desc_len,
   s_axis_read_desc_id, s_axis_read_desc_dest, rst,
   m_axis_read_data_tready, enable, clk, abort, ram_wr_cmd_be,
   ram_wr_cmd_addr, ram_wr_cmd_data, ram_wr_cmd_valid,
   ram_rd_cmd_addr, ram_rd_cmd_valid, ram_rd_resp_ready
   );

// RAM size
parameter SIZE = 4096;
// RAM segment count
parameter SEG_COUNT = 2;
// RAM segment data width
parameter SEG_DATA_WIDTH = 128;
// RAM segment address width
parameter SEG_ADDR_WIDTH = 8;
// RAM segment byte enable width
parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
// Read data output pipeline stages
parameter PIPELINE = 2;
// RAM segment count
//parameter SEG_COUNT = 2;
// RAM segment data width
//parameter SEG_DATA_WIDTH = 64;
// RAM segment address width
//parameter SEG_ADDR_WIDTH = 8;
// RAM segment byte enable width
//parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
// RAM address width
parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
// Width of AXI stream interfaces in bits
parameter AXIS_DATA_WIDTH = SEG_DATA_WIDTH*SEG_COUNT/2;
// Use AXI stream tkeep signal
parameter AXIS_KEEP_ENABLE = (AXIS_DATA_WIDTH>8);
// AXI stream tkeep signal width (words per cycle)
parameter AXIS_KEEP_WIDTH = (AXIS_DATA_WIDTH/8);
// Use AXI stream tlast signal
parameter AXIS_LAST_ENABLE = 1;
// Propagate AXI stream tid signal
parameter AXIS_ID_ENABLE = 0;
// AXI stream tid signal width
parameter AXIS_ID_WIDTH = 8;
// Propagate AXI stream tdest signal
parameter AXIS_DEST_ENABLE = 0;
// AXI stream tdest signal width
parameter AXIS_DEST_WIDTH = 8;
// Propagate AXI stream tuser signal
parameter AXIS_USER_ENABLE = 1;
// AXI stream tuser signal width
parameter AXIS_USER_WIDTH = 1;
// Width of length field
parameter LEN_WIDTH = 16;
// Width of tag field
parameter TAG_WIDTH = 8;

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [AXIS_DATA_WIDTH-1:0] m_axis_read_data_tdata;// From dma_client_axis_source_inst of dma_client_axis_source.v
output [AXIS_DEST_WIDTH-1:0] m_axis_read_data_tdest;// From dma_client_axis_source_inst of dma_client_axis_source.v
output [AXIS_ID_WIDTH-1:0] m_axis_read_data_tid;// From dma_client_axis_source_inst of dma_client_axis_source.v
output [AXIS_KEEP_WIDTH-1:0] m_axis_read_data_tkeep;// From dma_client_axis_source_inst of dma_client_axis_source.v
output			m_axis_read_data_tlast;	// From dma_client_axis_source_inst of dma_client_axis_source.v
output [AXIS_USER_WIDTH-1:0] m_axis_read_data_tuser;// From dma_client_axis_source_inst of dma_client_axis_source.v
output			m_axis_read_data_tvalid;// From dma_client_axis_source_inst of dma_client_axis_source.v
output [TAG_WIDTH-1:0]	m_axis_read_desc_status_tag;// From dma_client_axis_source_inst of dma_client_axis_source.v
output			m_axis_read_desc_status_valid;// From dma_client_axis_source_inst of dma_client_axis_source.v
output [AXIS_DEST_WIDTH-1:0] m_axis_write_desc_status_dest;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output [AXIS_ID_WIDTH-1:0] m_axis_write_desc_status_id;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output [LEN_WIDTH-1:0]	m_axis_write_desc_status_len;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output [TAG_WIDTH-1:0]	m_axis_write_desc_status_tag;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output [AXIS_USER_WIDTH-1:0] m_axis_write_desc_status_user;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output			m_axis_write_desc_status_valid;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output			s_axis_read_desc_ready;	// From dma_client_axis_source_inst of dma_client_axis_source.v
output			s_axis_write_data_tready;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
output			s_axis_write_desc_ready;// From dma_client_axis_sink_inst of dma_client_axis_sink.v
// End of automatics
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			abort;			// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input			clk;			// To dma_client_axis_sink_inst of dma_client_axis_sink.v, ...
input			enable;			// To dma_client_axis_sink_inst of dma_client_axis_sink.v, ...
input			m_axis_read_data_tready;// To dma_client_axis_source_inst of dma_client_axis_source.v
input			rst;			// To dma_client_axis_sink_inst of dma_client_axis_sink.v, ...
input [AXIS_DEST_WIDTH-1:0] s_axis_read_desc_dest;// To dma_client_axis_source_inst of dma_client_axis_source.v
input [AXIS_ID_WIDTH-1:0] s_axis_read_desc_id;	// To dma_client_axis_source_inst of dma_client_axis_source.v
input [LEN_WIDTH-1:0]	s_axis_read_desc_len;	// To dma_client_axis_source_inst of dma_client_axis_source.v
input [RAM_ADDR_WIDTH-1:0] s_axis_read_desc_ram_addr;// To dma_client_axis_source_inst of dma_client_axis_source.v
input [TAG_WIDTH-1:0]	s_axis_read_desc_tag;	// To dma_client_axis_source_inst of dma_client_axis_source.v
input [AXIS_USER_WIDTH-1:0] s_axis_read_desc_user;// To dma_client_axis_source_inst of dma_client_axis_source.v
input			s_axis_read_desc_valid;	// To dma_client_axis_source_inst of dma_client_axis_source.v
input [AXIS_DATA_WIDTH-1:0] s_axis_write_data_tdata;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [AXIS_DEST_WIDTH-1:0] s_axis_write_data_tdest;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [AXIS_ID_WIDTH-1:0] s_axis_write_data_tid;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [AXIS_KEEP_WIDTH-1:0] s_axis_write_data_tkeep;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input			s_axis_write_data_tlast;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [AXIS_USER_WIDTH-1:0] s_axis_write_data_tuser;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input			s_axis_write_data_tvalid;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [LEN_WIDTH-1:0]	s_axis_write_desc_len;	// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [RAM_ADDR_WIDTH-1:0] s_axis_write_desc_ram_addr;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input [TAG_WIDTH-1:0]	s_axis_write_desc_tag;	// To dma_client_axis_sink_inst of dma_client_axis_sink.v
input			s_axis_write_desc_valid;// To dma_client_axis_sink_inst of dma_client_axis_sink.v
// End of automatics

/*
 * write port
 */
input  wire [SEG_COUNT*SEG_BE_WIDTH-1:0]   ram_wr_cmd_be;
input  wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_wr_cmd_addr;
input  wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_wr_cmd_data;
input  wire [SEG_COUNT-1:0]                ram_wr_cmd_valid;
output wire [SEG_COUNT-1:0]                ram_wr_cmd_ready;

/*
 * Read port
 */
input  wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_rd_cmd_addr;
input  wire [SEG_COUNT-1:0]                ram_rd_cmd_valid;
output wire [SEG_COUNT-1:0]                ram_rd_cmd_ready;
output wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_rd_resp_data;
output wire [SEG_COUNT-1:0]                ram_rd_resp_valid;
input  wire [SEG_COUNT-1:0]                ram_rd_resp_ready;

/*AUTOWIRE*/
/*AUTOREG*/
/*
 * write port
 */
wire [SEG_COUNT*SEG_BE_WIDTH-1:0]   c2h_ram_wr_cmd_be;
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] c2h_ram_wr_cmd_addr;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] c2h_ram_wr_cmd_data;
wire [SEG_COUNT-1:0]                c2h_ram_wr_cmd_valid;
wire [SEG_COUNT-1:0]                c2h_ram_wr_cmd_ready;
 
 /*
  * Read port
  */
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] h2c_ram_rd_cmd_addr;
wire [SEG_COUNT-1:0]                h2c_ram_rd_cmd_valid;
wire [SEG_COUNT-1:0]                h2c_ram_rd_cmd_ready;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] h2c_ram_rd_resp_data;
wire [SEG_COUNT-1:0]                h2c_ram_rd_resp_valid;
wire [SEG_COUNT-1:0]                h2c_ram_rd_resp_ready;

dma_psdpram #(
   // Parameters
   .SIZE			         (SIZE),
   .SEG_COUNT		      (SEG_COUNT),
   .SEG_DATA_WIDTH		(SEG_DATA_WIDTH),
   .SEG_ADDR_WIDTH		(SEG_ADDR_WIDTH),
   .SEG_BE_WIDTH		   (SEG_BE_WIDTH),
   .PIPELINE			   (PIPELINE),
)
c2h_dma_ram_inst (
   .clk_wr		      (clk),
   .rst_wr		      (rst),
   .clk_rd		      (clk),
   .rst_rd		      (rst),
   // write
   .wr_cmd_be		   (c2h_ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
   .wr_cmd_addr		(c2h_ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
   .wr_cmd_data		(c2h_ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
   .wr_cmd_valid		(c2h_ram_wr_cmd_valid[SEG_COUNT-1:0]),
   .wr_cmd_ready		(c2h_ram_wr_cmd_ready[SEG_COUNT-1:0]),
   // read
   .rd_cmd_ready		(ram_rd_cmd_ready[SEG_COUNT-1:0]),
   .rd_resp_data		(ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
   .rd_resp_valid	   (ram_rd_resp_valid[SEG_COUNT-1:0]),
   .rd_cmd_addr		(ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
   .rd_cmd_valid		(ram_rd_cmd_valid[SEG_COUNT-1:0]),
   .rd_resp_ready	   (ram_rd_resp_ready[SEG_COUNT-1:0]));

dma_psdpram #(
   // Parameters
   .SIZE			         (SIZE),
   .SEG_COUNT		      (SEG_COUNT),
   .SEG_DATA_WIDTH		(SEG_DATA_WIDTH),
   .SEG_ADDR_WIDTH		(SEG_ADDR_WIDTH),
   .SEG_BE_WIDTH		   (SEG_BE_WIDTH),
   .PIPELINE			   (PIPELINE),
)
h2c_dma_ram_inst (
   .clk_wr		      (clk),
   .rst_wr		      (rst),
   .clk_rd		      (clk),
   .rst_rd		      (rst),
   // write
   .wr_cmd_be		   (ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
   .wr_cmd_addr		(ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
   .wr_cmd_data		(ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
   .wr_cmd_valid		(ram_wr_cmd_valid[SEG_COUNT-1:0]),
   .wr_cmd_ready		(ram_wr_cmd_ready[SEG_COUNT-1:0]),
   // read
   .rd_cmd_ready		(h2c_ram_rd_cmd_ready[SEG_COUNT-1:0]),
   .rd_resp_data		(h2c_ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
   .rd_resp_valid	   (h2c_ram_rd_resp_valid[SEG_COUNT-1:0]),
   .rd_cmd_addr		(h2c_ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
   .rd_cmd_valid		(h2c_ram_rd_cmd_valid[SEG_COUNT-1:0]),
   .rd_resp_ready	   (h2c_ram_rd_resp_ready[SEG_COUNT-1:0]));

dma_client_axis_sink #(
		       // Parameters
		       .SEG_COUNT	(SEG_COUNT),
		       .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
		       .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		       .SEG_BE_WIDTH	(SEG_BE_WIDTH),
		       .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
		       .AXIS_DATA_WIDTH	(AXIS_DATA_WIDTH),
		       .AXIS_KEEP_ENABLE(AXIS_KEEP_ENABLE),
		       .AXIS_KEEP_WIDTH	(AXIS_KEEP_WIDTH),
		       .AXIS_LAST_ENABLE(AXIS_LAST_ENABLE),
		       .AXIS_ID_ENABLE	(AXIS_ID_ENABLE),
		       .AXIS_ID_WIDTH	(AXIS_ID_WIDTH),
		       .AXIS_DEST_ENABLE(AXIS_DEST_ENABLE),
		       .AXIS_DEST_WIDTH	(AXIS_DEST_WIDTH),
		       .AXIS_USER_ENABLE(AXIS_USER_ENABLE),
		       .AXIS_USER_WIDTH	(AXIS_USER_WIDTH),
		       .LEN_WIDTH	(LEN_WIDTH),
		       .TAG_WIDTH	(TAG_WIDTH))
dma_client_axis_sink_inst (
             .ram_wr_cmd_be	   (c2h_ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
			    .ram_wr_cmd_addr	   (c2h_ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
			    .ram_wr_cmd_data	   (c2h_ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
             .ram_wr_cmd_valid	(c2h_ram_wr_cmd_valid[SEG_COUNT-1:0]),
             .ram_wr_cmd_ready	(c2h_ram_wr_cmd_ready[SEG_COUNT-1:0]),
             /*AUTOINST*/
			   // Outputs
			   .s_axis_write_desc_ready(s_axis_write_desc_ready),
			   .m_axis_write_desc_status_len(m_axis_write_desc_status_len[LEN_WIDTH-1:0]),
			   .m_axis_write_desc_status_tag(m_axis_write_desc_status_tag[TAG_WIDTH-1:0]),
			   .m_axis_write_desc_status_id(m_axis_write_desc_status_id[AXIS_ID_WIDTH-1:0]),
			   .m_axis_write_desc_status_dest(m_axis_write_desc_status_dest[AXIS_DEST_WIDTH-1:0]),
			   .m_axis_write_desc_status_user(m_axis_write_desc_status_user[AXIS_USER_WIDTH-1:0]),
			   .m_axis_write_desc_status_valid(m_axis_write_desc_status_valid),
			   .s_axis_write_data_tready(s_axis_write_data_tready),
			   // Inputs
			   .clk			(clk),
			   .rst			(rst),
			   .s_axis_write_desc_ram_addr(s_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
			   .s_axis_write_desc_len(s_axis_write_desc_len[LEN_WIDTH-1:0]),
			   .s_axis_write_desc_tag(s_axis_write_desc_tag[TAG_WIDTH-1:0]),
			   .s_axis_write_desc_valid(s_axis_write_desc_valid),
			   .s_axis_write_data_tdata(s_axis_write_data_tdata[AXIS_DATA_WIDTH-1:0]),
			   .s_axis_write_data_tkeep(s_axis_write_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
			   .s_axis_write_data_tvalid(s_axis_write_data_tvalid),
			   .s_axis_write_data_tlast(s_axis_write_data_tlast),
			   .s_axis_write_data_tid(s_axis_write_data_tid[AXIS_ID_WIDTH-1:0]),
			   .s_axis_write_data_tdest(s_axis_write_data_tdest[AXIS_DEST_WIDTH-1:0]),
			   .s_axis_write_data_tuser(s_axis_write_data_tuser[AXIS_USER_WIDTH-1:0]),
			   .enable		(enable),
			   .abort		(abort));

dma_client_axis_source #(
			 // Parameters
			 .SEG_COUNT		(SEG_COUNT),
			 .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
			 .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
			 .SEG_BE_WIDTH		(SEG_BE_WIDTH),
			 .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
			 .AXIS_DATA_WIDTH	(AXIS_DATA_WIDTH),
			 .AXIS_KEEP_ENABLE	(AXIS_KEEP_ENABLE),
			 .AXIS_KEEP_WIDTH	(AXIS_KEEP_WIDTH),
			 .AXIS_LAST_ENABLE	(AXIS_LAST_ENABLE),
			 .AXIS_ID_ENABLE	(AXIS_ID_ENABLE),
			 .AXIS_ID_WIDTH		(AXIS_ID_WIDTH),
			 .AXIS_DEST_ENABLE	(AXIS_DEST_ENABLE),
			 .AXIS_DEST_WIDTH	(AXIS_DEST_WIDTH),
			 .AXIS_USER_ENABLE	(AXIS_USER_ENABLE),
			 .AXIS_USER_WIDTH	(AXIS_USER_WIDTH),
			 .LEN_WIDTH		(LEN_WIDTH),
			 .TAG_WIDTH		(TAG_WIDTH))
dma_client_axis_source_inst (
               .ram_rd_cmd_addr	(h2c_ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
               .ram_rd_cmd_valid	(h2c_ram_rd_cmd_valid[SEG_COUNT-1:0]),
               .ram_rd_resp_ready(h2c_ram_rd_resp_ready[SEG_COUNT-1:0]),        
               .ram_rd_cmd_ready	(h2c_ram_rd_cmd_ready[SEG_COUNT-1:0]),
			      .ram_rd_resp_data	(h2c_ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
			      .ram_rd_resp_valid(h2c_ram_rd_resp_valid[SEG_COUNT-1:0]),       
               /*AUTOINST*/
			     // Outputs
			     .s_axis_read_desc_ready(s_axis_read_desc_ready),
			     .m_axis_read_desc_status_tag(m_axis_read_desc_status_tag[TAG_WIDTH-1:0]),
			     .m_axis_read_desc_status_valid(m_axis_read_desc_status_valid),
			     .m_axis_read_data_tdata(m_axis_read_data_tdata[AXIS_DATA_WIDTH-1:0]),
			     .m_axis_read_data_tkeep(m_axis_read_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
			     .m_axis_read_data_tvalid(m_axis_read_data_tvalid),
			     .m_axis_read_data_tlast(m_axis_read_data_tlast),
			     .m_axis_read_data_tid(m_axis_read_data_tid[AXIS_ID_WIDTH-1:0]),
			     .m_axis_read_data_tdest(m_axis_read_data_tdest[AXIS_DEST_WIDTH-1:0]),
			     .m_axis_read_data_tuser(m_axis_read_data_tuser[AXIS_USER_WIDTH-1:0]),
			     // Inputs
			     .clk		(clk),
			     .rst		(rst),
			     .s_axis_read_desc_ram_addr(s_axis_read_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
			     .s_axis_read_desc_len(s_axis_read_desc_len[LEN_WIDTH-1:0]),
			     .s_axis_read_desc_tag(s_axis_read_desc_tag[TAG_WIDTH-1:0]),
			     .s_axis_read_desc_id(s_axis_read_desc_id[AXIS_ID_WIDTH-1:0]),
			     .s_axis_read_desc_dest(s_axis_read_desc_dest[AXIS_DEST_WIDTH-1:0]),
			     .s_axis_read_desc_user(s_axis_read_desc_user[AXIS_USER_WIDTH-1:0]),
			     .s_axis_read_desc_valid(s_axis_read_desc_valid),
			     .m_axis_read_data_tready(m_axis_read_data_tready),
			     .enable		(enable));

endmodule

// Local Variables:
// verilog-library-flags:("â€“y ./")
// verilog-auto-inst-param-value:t
// End:
