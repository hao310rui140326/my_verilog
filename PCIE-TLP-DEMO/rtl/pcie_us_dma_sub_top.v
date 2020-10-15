/*

Copyright (c) 2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * Ultrascale PCIe AXI DMA
 */
 ///*AUTOARG*/

module pcie_us_dma_sub_top (/*AUTOARG*/
   // Outputs
   status_error_uncor, status_error_cor, s_axis_write_desc_ready,
   s_axis_write_data_tready, s_axis_read_desc_ready, s_axis_rc_tready,
   ram_wr_cmd_sel, ram_rd_cmd_sel, m_axis_write_desc_status_valid,
   m_axis_write_desc_status_user, m_axis_write_desc_status_tag,
   m_axis_write_desc_status_len, m_axis_write_desc_status_id,
   m_axis_write_desc_status_dest, m_axis_rq_tvalid, m_axis_rq_tuser,
   m_axis_rq_tlast, m_axis_rq_tkeep, m_axis_rq_tdata,
   m_axis_read_desc_status_valid, m_axis_read_desc_status_tag,
   m_axis_read_data_tvalid, m_axis_read_data_tuser,
   m_axis_read_data_tlast, m_axis_read_data_tkeep,
   m_axis_read_data_tid, m_axis_read_data_tdest,
   m_axis_read_data_tdata,
   // Inputs
   write_enable, s_axis_write_desc_valid, s_axis_write_desc_tag,
   s_axis_write_desc_ram_sel, s_axis_write_desc_ram_addr,
   s_axis_write_desc_len, s_axis_write_desc_dma_addr,
   s_axis_write_data_tvalid, s_axis_write_data_tuser,
   s_axis_write_data_tlast, s_axis_write_data_tkeep,
   s_axis_write_data_tid, s_axis_write_data_tdest,
   s_axis_write_data_tdata, s_axis_rq_seq_num_valid_1,
   s_axis_rq_seq_num_valid_0, s_axis_rq_seq_num_1,
   s_axis_rq_seq_num_0, s_axis_read_desc_valid, s_axis_read_desc_user,
   s_axis_read_desc_tag, s_axis_read_desc_ram_sel,
   s_axis_read_desc_ram_addr, s_axis_read_desc_len,
   s_axis_read_desc_id, s_axis_read_desc_dma_addr,
   s_axis_read_desc_dest, s_axis_rc_tvalid, s_axis_rc_tuser,
   s_axis_rc_tlast, s_axis_rc_tkeep, s_axis_rc_tdata, rst,
   requester_id_enable, requester_id, read_enable, pcie_tx_fc_ph_av,
   pcie_tx_fc_pd_av, pcie_tx_fc_nph_av, max_read_request_size,
   max_payload_size, m_axis_rq_tready, m_axis_read_data_tready,
   ext_tag_enable, enable, clk, abort
   );

   // Width of PCIe AXI stream interfaces in bits
   parameter AXIS_PCIE_DATA_WIDTH = 512;
   // PCIe AXI stream tkeep signal width (words per cycle)
   parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32);
   // PCIe AXI stream RC tuser signal width
   parameter AXIS_PCIE_RC_USER_WIDTH = AXIS_PCIE_DATA_WIDTH < 512 ? 75 : 161;
   // PCIe AXI stream RQ tuser signal width
   parameter AXIS_PCIE_RQ_USER_WIDTH = AXIS_PCIE_DATA_WIDTH < 512 ? 60 : 137;
   // RQ sequence number width
   parameter RQ_SEQ_NUM_WIDTH = AXIS_PCIE_RQ_USER_WIDTH == 60 ? 4 : 6;
   // RQ sequence number tracking enable
   parameter RQ_SEQ_NUM_ENABLE = 0;
   // Width of AXI data bus in bits
   parameter AXI_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH;
   // Width of AXI address bus in bits
   //parameter AXI_ADDR_WIDTH = 64;
   // Width of AXI wstrb (width of data bus in words)
   //parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
   // Width of AXI ID signal
   parameter AXI_ID_WIDTH = 8;
   // Maximum AXI burst length to generate
   //parameter AXI_MAX_BURST_LEN = 256;
   // PCIe address width
   parameter PCIE_ADDR_WIDTH = 64;
   // PCIe tag count
   parameter PCIE_TAG_COUNT = AXIS_PCIE_RQ_USER_WIDTH == 60 ? 64 : 256;
   // PCIe tag field width
   parameter PCIE_TAG_WIDTH = $clog2(PCIE_TAG_COUNT);
   // Support PCIe extended tags
   parameter PCIE_EXT_TAG_ENABLE = (PCIE_TAG_COUNT>32);
   // Length field width
   parameter LEN_WIDTH = 20;
   // Tag field width
   parameter TAG_WIDTH = 8;
   // Operation table size (read)
   parameter READ_OP_TABLE_SIZE = 2**(AXI_ID_WIDTH < PCIE_TAG_WIDTH ? AXI_ID_WIDTH : PCIE_TAG_WIDTH);
   // In-flight transmit limit (read)
   parameter READ_TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1);
   // Transmit flow control (read)
   parameter READ_TX_FC_ENABLE = 0;
   // Operation table size (write)
   parameter WRITE_OP_TABLE_SIZE = 2**(RQ_SEQ_NUM_WIDTH-1);
   // In-flight transmit limit (write)
   parameter WRITE_TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1);
   // Transmit flow control (write)
   parameter WRITE_TX_FC_ENABLE = 0;
    // Number of ports
   parameter PORTS = 2;
   // RAM segment count
   parameter SEG_COUNT = 2;
   // RAM segment data width
   parameter SEG_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH / SEG_COUNT;
   // RAM segment address width
   parameter SEG_ADDR_WIDTH = 8;
   // RAM segment byte enable width
   parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
   // Input RAM segment select width
   parameter S_RAM_SEL_WIDTH = 2;
   // Output RAM segment select width
   // Additional bits required for response routing
   parameter M_RAM_SEL_WIDTH = S_RAM_SEL_WIDTH+$clog2(PORTS);
   parameter RAM_SEL_WIDTH = M_RAM_SEL_WIDTH;
   // RAM address width
   parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
   // DMA address width
   parameter DMA_ADDR_WIDTH = PCIE_ADDR_WIDTH;  //64;
   // Length field width
   //parameter LEN_WIDTH = 16;
   // Input tag field width
   parameter S_TAG_WIDTH = 8;
   // Output tag field width (towards DMA module)
   // Additional bits required for response routing
   parameter M_TAG_WIDTH = S_TAG_WIDTH+$clog2(PORTS);
   // arbitration type: "PRIORITY" or "ROUND_ROBIN"
   parameter ARB_TYPE = "PRIORITY";
   // LSB priority: "LOW", "HIGH"
   parameter LSB_PRIORITY = "HIGH";

   // RAM size
   parameter SIZE = 4096;
   // RAM segment count
   //parameter SEG_COUNT = 2;
   // RAM segment data width
   //parameter SEG_DATA_WIDTH = 128;
   // RAM segment address width
   //parameter SEG_ADDR_WIDTH = 8;
   // RAM segment byte enable width
   //parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
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
   //parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
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
   //parameter LEN_WIDTH = 16;
   // Width of tag field
   //parameter TAG_WIDTH = 8;

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [AXIS_DATA_WIDTH-1:0] m_axis_read_data_tdata;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [AXIS_DEST_WIDTH-1:0] m_axis_read_data_tdest;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [AXIS_ID_WIDTH-1:0] m_axis_read_data_tid;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [AXIS_KEEP_WIDTH-1:0] m_axis_read_data_tkeep;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output			m_axis_read_data_tlast;	// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [AXIS_USER_WIDTH-1:0] m_axis_read_data_tuser;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output			m_axis_read_data_tvalid;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [TAG_WIDTH-1:0]	m_axis_read_desc_status_tag;// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output [PORTS-1:0]	m_axis_read_desc_status_valid;// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output			m_axis_rq_tlast;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output			m_axis_rq_tvalid;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output [AXIS_DEST_WIDTH-1:0] m_axis_write_desc_status_dest;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [AXIS_ID_WIDTH-1:0] m_axis_write_desc_status_id;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [LEN_WIDTH-1:0]	m_axis_write_desc_status_len;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [TAG_WIDTH-1:0]	m_axis_write_desc_status_tag;// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output [AXIS_USER_WIDTH-1:0] m_axis_write_desc_status_user;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [PORTS-1:0]	m_axis_write_desc_status_valid;// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output [PORTS*SEG_COUNT*S_RAM_SEL_WIDTH-1:0] ram_rd_cmd_sel;// From dma_if_mux_inst of dma_if_mux.v
output [PORTS*SEG_COUNT*S_RAM_SEL_WIDTH-1:0] ram_wr_cmd_sel;// From dma_if_mux_inst of dma_if_mux.v
output			s_axis_rc_tready;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output [PORTS-1:0]	s_axis_read_desc_ready;	// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output			s_axis_write_data_tready;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
output [PORTS-1:0]	s_axis_write_desc_ready;// From dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
output			status_error_cor;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
output			status_error_uncor;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
// End of automatics
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			abort;			// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input			clk;			// To dma_if_mux_inst of dma_if_mux.v, ...
input			enable;			// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input			ext_tag_enable;		// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			m_axis_read_data_tready;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input			m_axis_rq_tready;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [2:0]		max_payload_size;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [2:0]		max_read_request_size;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [7:0]		pcie_tx_fc_nph_av;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [11:0]		pcie_tx_fc_pd_av;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [7:0]		pcie_tx_fc_ph_av;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			read_enable;		// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [15:0]		requester_id;		// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			requester_id_enable;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			rst;			// To dma_if_mux_inst of dma_if_mux.v, ...
input [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rc_tdata;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rc_tkeep;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			s_axis_rc_tlast;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [AXIS_PCIE_RC_USER_WIDTH-1:0] s_axis_rc_tuser;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			s_axis_rc_tvalid;	// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [AXIS_DEST_WIDTH-1:0] s_axis_read_desc_dest;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [PORTS*DMA_ADDR_WIDTH-1:0] s_axis_read_desc_dma_addr;// To dma_if_mux_inst of dma_if_mux.v
input [AXIS_ID_WIDTH-1:0] s_axis_read_desc_id;	// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [LEN_WIDTH-1:0]	s_axis_read_desc_len;	// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [RAM_ADDR_WIDTH-1:0] s_axis_read_desc_ram_addr;// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [PORTS*S_RAM_SEL_WIDTH-1:0] s_axis_read_desc_ram_sel;// To dma_if_mux_inst of dma_if_mux.v
input [TAG_WIDTH-1:0]	s_axis_read_desc_tag;	// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [AXIS_USER_WIDTH-1:0] s_axis_read_desc_user;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [PORTS-1:0]	s_axis_read_desc_valid;	// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_0;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_1;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			s_axis_rq_seq_num_valid_0;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input			s_axis_rq_seq_num_valid_1;// To dma_if_pcie_us_inst of dma_if_pcie_us.v
input [AXIS_DATA_WIDTH-1:0] s_axis_write_data_tdata;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [AXIS_DEST_WIDTH-1:0] s_axis_write_data_tdest;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [AXIS_ID_WIDTH-1:0] s_axis_write_data_tid;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [AXIS_KEEP_WIDTH-1:0] s_axis_write_data_tkeep;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input			s_axis_write_data_tlast;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [AXIS_USER_WIDTH-1:0] s_axis_write_data_tuser;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input			s_axis_write_data_tvalid;// To pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v, ...
input [PORTS*DMA_ADDR_WIDTH-1:0] s_axis_write_desc_dma_addr;// To dma_if_mux_inst of dma_if_mux.v
input [LEN_WIDTH-1:0]	s_axis_write_desc_len;	// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [RAM_ADDR_WIDTH-1:0] s_axis_write_desc_ram_addr;// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [PORTS*S_RAM_SEL_WIDTH-1:0] s_axis_write_desc_ram_sel;// To dma_if_mux_inst of dma_if_mux.v
input [TAG_WIDTH-1:0]	s_axis_write_desc_tag;	// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input [PORTS-1:0]	s_axis_write_desc_valid;// To dma_if_mux_inst of dma_if_mux.v, ..., Couldn't Merge
input			write_enable;		// To dma_if_pcie_us_inst of dma_if_pcie_us.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] if_ram_rd_cmd_addr;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT-1:0]	if_ram_rd_cmd_ready;	// From dma_if_mux_inst of dma_if_mux.v
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0] if_ram_rd_cmd_sel;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT-1:0]	if_ram_rd_cmd_valid;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] if_ram_rd_resp_data;// From dma_if_mux_inst of dma_if_mux.v
wire [SEG_COUNT-1:0]	if_ram_rd_resp_ready;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT-1:0]	if_ram_rd_resp_valid;	// From dma_if_mux_inst of dma_if_mux.v
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] if_ram_wr_cmd_addr;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT*SEG_BE_WIDTH-1:0] if_ram_wr_cmd_be;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] if_ram_wr_cmd_data;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT-1:0]	if_ram_wr_cmd_ready;	// From dma_if_mux_inst of dma_if_mux.v
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0] if_ram_wr_cmd_sel;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [SEG_COUNT-1:0]	if_ram_wr_cmd_valid;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [DMA_ADDR_WIDTH-1:0] m_axis_read_desc_dma_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [LEN_WIDTH-1:0]	m_axis_read_desc_len;	// From dma_if_mux_inst of dma_if_mux.v
wire [RAM_ADDR_WIDTH-1:0] m_axis_read_desc_ram_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [M_RAM_SEL_WIDTH-1:0] m_axis_read_desc_ram_sel;// From dma_if_mux_inst of dma_if_mux.v
wire			m_axis_read_desc_ready;	// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [M_TAG_WIDTH-1:0]	m_axis_read_desc_tag;	// From dma_if_mux_inst of dma_if_mux.v
wire			m_axis_read_desc_valid;	// From dma_if_mux_inst of dma_if_mux.v
wire [DMA_ADDR_WIDTH-1:0] m_axis_write_desc_dma_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [LEN_WIDTH-1:0]	m_axis_write_desc_len;	// From dma_if_mux_inst of dma_if_mux.v
wire [RAM_ADDR_WIDTH-1:0] m_axis_write_desc_ram_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [M_RAM_SEL_WIDTH-1:0] m_axis_write_desc_ram_sel;// From dma_if_mux_inst of dma_if_mux.v
wire			m_axis_write_desc_ready;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [M_TAG_WIDTH-1:0]	m_axis_write_desc_tag;	// From dma_if_mux_inst of dma_if_mux.v
wire			m_axis_write_desc_valid;// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_rd_cmd_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT-1:0] ram_rd_cmd_valid;	// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT-1:0] ram_rd_resp_ready;	// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_wr_cmd_addr;// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT*SEG_BE_WIDTH-1:0] ram_wr_cmd_be;// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_wr_cmd_data;// From dma_if_mux_inst of dma_if_mux.v
wire [PORTS*SEG_COUNT-1:0] ram_wr_cmd_valid;	// From dma_if_mux_inst of dma_if_mux.v
// End of automatics
/*AUTOREG*/

wire [PORTS*SEG_COUNT-1:0]	ram_wr_cmd_ready;	// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v
wire [PORTS*SEG_COUNT-1:0]	ram_rd_cmd_ready;	// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v
wire [PORTS*SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_rd_resp_data;// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v
wire [PORTS*SEG_COUNT-1:0]	ram_rd_resp_valid;	// From pcie_us_dma_axis_inst1 of pcie_us_dma_axis.v
wire [PORTS*TAG_WIDTH-1:0]	s_axis_read_desc_status_tag;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [PORTS-1:0]			s_axis_read_desc_status_valid;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [PORTS*TAG_WIDTH-1:0]	s_axis_write_desc_status_tag;// From dma_if_pcie_us_inst of dma_if_pcie_us.v
wire [PORTS-1:0]			s_axis_write_desc_status_valid;// From dma_if_pcie_us_inst of dma_if_pcie_us.v

/*dma_if_mux  AUTO_TEMPLATE(
   .m_axis_read_desc_pcie_addr   (axis_read_desc_pcie_addr[]),  
);*/

dma_if_mux #(/*AUTOINSTPARAM*/
	     // Parameters
	     .PORTS			(PORTS),
	     .SEG_COUNT			(SEG_COUNT),
	     .SEG_DATA_WIDTH		(SEG_DATA_WIDTH),
	     .SEG_ADDR_WIDTH		(SEG_ADDR_WIDTH),
	     .SEG_BE_WIDTH		(SEG_BE_WIDTH),
	     .S_RAM_SEL_WIDTH		(S_RAM_SEL_WIDTH),
	     .M_RAM_SEL_WIDTH		(M_RAM_SEL_WIDTH),
	     .RAM_ADDR_WIDTH		(RAM_ADDR_WIDTH),
	     .DMA_ADDR_WIDTH		(DMA_ADDR_WIDTH),
	     .LEN_WIDTH			(LEN_WIDTH),
	     .S_TAG_WIDTH		(S_TAG_WIDTH),
	     .M_TAG_WIDTH		(M_TAG_WIDTH),
	     .ARB_TYPE			(ARB_TYPE),
	     .LSB_PRIORITY		(LSB_PRIORITY))
dma_if_mux_inst (/*AUTOINST*/
		 // Outputs
		 .m_axis_read_desc_dma_addr(m_axis_read_desc_dma_addr[DMA_ADDR_WIDTH-1:0]),
		 .m_axis_read_desc_ram_sel(m_axis_read_desc_ram_sel[M_RAM_SEL_WIDTH-1:0]),
		 .m_axis_read_desc_ram_addr(m_axis_read_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
		 .m_axis_read_desc_len	(m_axis_read_desc_len[LEN_WIDTH-1:0]),
		 .m_axis_read_desc_tag	(m_axis_read_desc_tag[M_TAG_WIDTH-1:0]),
		 .m_axis_read_desc_valid(m_axis_read_desc_valid),
		 .m_axis_write_desc_dma_addr(m_axis_write_desc_dma_addr[DMA_ADDR_WIDTH-1:0]),
		 .m_axis_write_desc_ram_sel(m_axis_write_desc_ram_sel[M_RAM_SEL_WIDTH-1:0]),
		 .m_axis_write_desc_ram_addr(m_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
		 .m_axis_write_desc_len	(m_axis_write_desc_len[LEN_WIDTH-1:0]),
		 .m_axis_write_desc_tag	(m_axis_write_desc_tag[M_TAG_WIDTH-1:0]),
		 .m_axis_write_desc_valid(m_axis_write_desc_valid),
		 .s_axis_read_desc_ready(s_axis_read_desc_ready[PORTS-1:0]),
		 .m_axis_read_desc_status_tag(m_axis_read_desc_status_tag[PORTS*S_TAG_WIDTH-1:0]),
		 .m_axis_read_desc_status_valid(m_axis_read_desc_status_valid[PORTS-1:0]),
		 .s_axis_write_desc_ready(s_axis_write_desc_ready[PORTS-1:0]),
		 .m_axis_write_desc_status_tag(m_axis_write_desc_status_tag[PORTS*S_TAG_WIDTH-1:0]),
		 .m_axis_write_desc_status_valid(m_axis_write_desc_status_valid[PORTS-1:0]),
		 .if_ram_wr_cmd_ready	(if_ram_wr_cmd_ready[SEG_COUNT-1:0]),
		 .if_ram_rd_cmd_ready	(if_ram_rd_cmd_ready[SEG_COUNT-1:0]),
		 .if_ram_rd_resp_data	(if_ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
		 .if_ram_rd_resp_valid	(if_ram_rd_resp_valid[SEG_COUNT-1:0]),
		 .ram_wr_cmd_sel	(ram_wr_cmd_sel[PORTS*SEG_COUNT*S_RAM_SEL_WIDTH-1:0]),
		 .ram_wr_cmd_be		(ram_wr_cmd_be[PORTS*SEG_COUNT*SEG_BE_WIDTH-1:0]),
		 .ram_wr_cmd_addr	(ram_wr_cmd_addr[PORTS*SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
		 .ram_wr_cmd_data	(ram_wr_cmd_data[PORTS*SEG_COUNT*SEG_DATA_WIDTH-1:0]),
		 .ram_wr_cmd_valid	(ram_wr_cmd_valid[PORTS*SEG_COUNT-1:0]),
		 .ram_rd_cmd_sel	(ram_rd_cmd_sel[PORTS*SEG_COUNT*S_RAM_SEL_WIDTH-1:0]),
		 .ram_rd_cmd_addr	(ram_rd_cmd_addr[PORTS*SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
		 .ram_rd_cmd_valid	(ram_rd_cmd_valid[PORTS*SEG_COUNT-1:0]),
		 .ram_rd_resp_ready	(ram_rd_resp_ready[PORTS*SEG_COUNT-1:0]),
		 // Inputs
		 .clk			(clk),
		 .rst			(rst),
		 .m_axis_read_desc_ready(m_axis_read_desc_ready),
		 .s_axis_read_desc_status_tag(s_axis_read_desc_status_tag[M_TAG_WIDTH-1:0]),
		 .s_axis_read_desc_status_valid(s_axis_read_desc_status_valid),
		 .m_axis_write_desc_ready(m_axis_write_desc_ready),
		 .s_axis_write_desc_status_tag(s_axis_write_desc_status_tag[M_TAG_WIDTH-1:0]),
		 .s_axis_write_desc_status_valid(s_axis_write_desc_status_valid),
		 .s_axis_read_desc_dma_addr(s_axis_read_desc_dma_addr[PORTS*DMA_ADDR_WIDTH-1:0]),
		 .s_axis_read_desc_ram_sel(s_axis_read_desc_ram_sel[PORTS*S_RAM_SEL_WIDTH-1:0]),
		 .s_axis_read_desc_ram_addr(s_axis_read_desc_ram_addr[PORTS*RAM_ADDR_WIDTH-1:0]),
		 .s_axis_read_desc_len	(s_axis_read_desc_len[PORTS*LEN_WIDTH-1:0]),
		 .s_axis_read_desc_tag	(s_axis_read_desc_tag[PORTS*S_TAG_WIDTH-1:0]),
		 .s_axis_read_desc_valid(s_axis_read_desc_valid[PORTS-1:0]),
		 .s_axis_write_desc_dma_addr(s_axis_write_desc_dma_addr[PORTS*DMA_ADDR_WIDTH-1:0]),
		 .s_axis_write_desc_ram_sel(s_axis_write_desc_ram_sel[PORTS*S_RAM_SEL_WIDTH-1:0]),
		 .s_axis_write_desc_ram_addr(s_axis_write_desc_ram_addr[PORTS*RAM_ADDR_WIDTH-1:0]),
		 .s_axis_write_desc_len	(s_axis_write_desc_len[PORTS*LEN_WIDTH-1:0]),
		 .s_axis_write_desc_tag	(s_axis_write_desc_tag[PORTS*S_TAG_WIDTH-1:0]),
		 .s_axis_write_desc_valid(s_axis_write_desc_valid[PORTS-1:0]),
		 .if_ram_wr_cmd_sel	(if_ram_wr_cmd_sel[SEG_COUNT*M_RAM_SEL_WIDTH-1:0]),
		 .if_ram_wr_cmd_be	(if_ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
		 .if_ram_wr_cmd_addr	(if_ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
		 .if_ram_wr_cmd_data	(if_ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
		 .if_ram_wr_cmd_valid	(if_ram_wr_cmd_valid[SEG_COUNT-1:0]),
		 .if_ram_rd_cmd_sel	(if_ram_rd_cmd_sel[SEG_COUNT*M_RAM_SEL_WIDTH-1:0]),
		 .if_ram_rd_cmd_addr	(if_ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
		 .if_ram_rd_cmd_valid	(if_ram_rd_cmd_valid[SEG_COUNT-1:0]),
		 .if_ram_rd_resp_ready	(if_ram_rd_resp_ready[SEG_COUNT-1:0]),
		 .ram_wr_cmd_ready	(ram_wr_cmd_ready[PORTS*SEG_COUNT-1:0]),
		 .ram_rd_cmd_ready	(ram_rd_cmd_ready[PORTS*SEG_COUNT-1:0]),
		 .ram_rd_resp_data	(ram_rd_resp_data[PORTS*SEG_COUNT*SEG_DATA_WIDTH-1:0]),
		 .ram_rd_resp_valid	(ram_rd_resp_valid[PORTS*SEG_COUNT-1:0]));


/*dma_if_pcie_us  AUTO_TEMPLATE(
   .s_axis_read_desc_pcie_addr   (m_axis_read_desc_dma_addr[]),  
   .s_axis_read_desc_ram_sel     (m_axis_read_desc_ram_sel[]),
   .s_axis_read_desc_ram_addr    (m_axis_read_desc_ram_addr[]),
   .s_axis_read_desc_len         (m_axis_read_desc_len[]),
   .s_axis_read_desc_tag         (m_axis_read_desc_tag[]),
   .s_axis_read_desc_valid       (m_axis_read_desc_valid),
   .s_axis_read_desc_ready       (m_axis_read_desc_ready),
   .m_axis_read_desc_status_tag  (s_axis_read_desc_status_tag[]),
   .m_axis_read_desc_status_valid(s_axis_read_desc_status_valid),
   .s_axis_write_desc_pcie_addr  (m_axis_write_desc_dma_addr[]),
   .s_axis_write_desc_ram_sel    (m_axis_write_desc_ram_sel[]),
   .s_axis_write_desc_ram_addr   (m_axis_write_desc_ram_addr[]),
   .s_axis_write_desc_len        (m_axis_write_desc_len[]),
   .s_axis_write_desc_tag        (m_axis_write_desc_tag[]),
   .s_axis_write_desc_valid      (m_axis_write_desc_valid),
   .s_axis_write_desc_ready      (m_axis_write_desc_ready),
   .m_axis_write_desc_status_tag (s_axis_write_desc_status_tag[]),
   .m_axis_write_desc_status_valid(s_axis_write_desc_status_valid),
   .ram_wr_cmd_sel	            (if_ram_wr_cmd_sel[]),
	.ram_wr_cmd_be	               (if_ram_wr_cmd_be[]),
	.ram_wr_cmd_addr	            (if_ram_wr_cmd_addr[]),
	.ram_wr_cmd_data	            (if_ram_wr_cmd_data[]),
	.ram_wr_cmd_valid	            (if_ram_wr_cmd_valid[]),
	.ram_rd_cmd_sel	            (if_ram_rd_cmd_sel[]),
	.ram_rd_cmd_addr	            (if_ram_rd_cmd_addr[]),
	.ram_rd_cmd_valid	            (if_ram_rd_cmd_valid[]),
   .ram_rd_resp_ready	         (if_ram_rd_resp_ready[]),
   .ram_wr_cmd_ready	            (if_ram_wr_cmd_ready[]),
	.ram_rd_cmd_ready	            (if_ram_rd_cmd_ready[]),
	.ram_rd_resp_data	            (if_ram_rd_resp_data[]),
	.ram_rd_resp_valid	         (if_ram_rd_resp_valid[]),
);*/

dma_if_pcie_us #(/*AUTOINSTPARAM*/
		 // Parameters
		 .AXIS_PCIE_DATA_WIDTH	(AXIS_PCIE_DATA_WIDTH),
		 .AXIS_PCIE_KEEP_WIDTH	(AXIS_PCIE_KEEP_WIDTH),
		 .AXIS_PCIE_RC_USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH),
		 .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
		 .RQ_SEQ_NUM_WIDTH	(RQ_SEQ_NUM_WIDTH),
		 .RQ_SEQ_NUM_ENABLE	(RQ_SEQ_NUM_ENABLE),
		 .SEG_COUNT		(SEG_COUNT),
		 .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
		 .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		 .SEG_BE_WIDTH		(SEG_BE_WIDTH),
		 .RAM_SEL_WIDTH		(RAM_SEL_WIDTH),
		 .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
		 .PCIE_ADDR_WIDTH	(PCIE_ADDR_WIDTH),
		 .PCIE_TAG_COUNT	(PCIE_TAG_COUNT),
		 .PCIE_TAG_WIDTH	(PCIE_TAG_WIDTH),
		 .PCIE_EXT_TAG_ENABLE	(PCIE_EXT_TAG_ENABLE),
		 .LEN_WIDTH		(LEN_WIDTH),
		 .TAG_WIDTH		(TAG_WIDTH),
		 .READ_OP_TABLE_SIZE	(READ_OP_TABLE_SIZE),
		 .READ_TX_LIMIT		(READ_TX_LIMIT),
		 .READ_TX_FC_ENABLE	(READ_TX_FC_ENABLE),
		 .WRITE_OP_TABLE_SIZE	(WRITE_OP_TABLE_SIZE),
		 .WRITE_TX_LIMIT	(WRITE_TX_LIMIT),
		 .WRITE_TX_FC_ENABLE	(WRITE_TX_FC_ENABLE))
dma_if_pcie_us_inst (/*AUTOINST*/
		     // Outputs
		     .s_axis_rc_tready	(s_axis_rc_tready),
		     .m_axis_rq_tdata	(m_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
		     .m_axis_rq_tkeep	(m_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
		     .m_axis_rq_tvalid	(m_axis_rq_tvalid),
		     .m_axis_rq_tlast	(m_axis_rq_tlast),
		     .m_axis_rq_tuser	(m_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
		     .s_axis_read_desc_ready(m_axis_read_desc_ready), // Templated
		     .m_axis_read_desc_status_tag(s_axis_read_desc_status_tag[TAG_WIDTH-1:0]), // Templated
		     .m_axis_read_desc_status_valid(s_axis_read_desc_status_valid), // Templated
		     .s_axis_write_desc_ready(m_axis_write_desc_ready), // Templated
		     .m_axis_write_desc_status_tag(s_axis_write_desc_status_tag[TAG_WIDTH-1:0]), // Templated
		     .m_axis_write_desc_status_valid(s_axis_write_desc_status_valid), // Templated
		     .ram_wr_cmd_sel	(if_ram_wr_cmd_sel[SEG_COUNT*RAM_SEL_WIDTH-1:0]), // Templated
		     .ram_wr_cmd_be	(if_ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]), // Templated
		     .ram_wr_cmd_addr	(if_ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]), // Templated
		     .ram_wr_cmd_data	(if_ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]), // Templated
		     .ram_wr_cmd_valid	(if_ram_wr_cmd_valid[SEG_COUNT-1:0]), // Templated
		     .ram_rd_cmd_sel	(if_ram_rd_cmd_sel[SEG_COUNT*RAM_SEL_WIDTH-1:0]), // Templated
		     .ram_rd_cmd_addr	(if_ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]), // Templated
		     .ram_rd_cmd_valid	(if_ram_rd_cmd_valid[SEG_COUNT-1:0]), // Templated
		     .ram_rd_resp_ready	(if_ram_rd_resp_ready[SEG_COUNT-1:0]), // Templated
		     .status_error_cor	(status_error_cor),
		     .status_error_uncor(status_error_uncor),
		     // Inputs
		     .clk		(clk),
		     .rst		(rst),
		     .s_axis_rc_tdata	(s_axis_rc_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
		     .s_axis_rc_tkeep	(s_axis_rc_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
		     .s_axis_rc_tvalid	(s_axis_rc_tvalid),
		     .s_axis_rc_tlast	(s_axis_rc_tlast),
		     .s_axis_rc_tuser	(s_axis_rc_tuser[AXIS_PCIE_RC_USER_WIDTH-1:0]),
		     .m_axis_rq_tready	(m_axis_rq_tready),
		     .s_axis_rq_seq_num_0(s_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
		     .s_axis_rq_seq_num_valid_0(s_axis_rq_seq_num_valid_0),
		     .s_axis_rq_seq_num_1(s_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
		     .s_axis_rq_seq_num_valid_1(s_axis_rq_seq_num_valid_1),
		     .pcie_tx_fc_nph_av	(pcie_tx_fc_nph_av[7:0]),
		     .pcie_tx_fc_ph_av	(pcie_tx_fc_ph_av[7:0]),
		     .pcie_tx_fc_pd_av	(pcie_tx_fc_pd_av[11:0]),
		     .s_axis_read_desc_pcie_addr(m_axis_read_desc_dma_addr[PCIE_ADDR_WIDTH-1:0]), // Templated
		     .s_axis_read_desc_ram_sel(m_axis_read_desc_ram_sel[RAM_SEL_WIDTH-1:0]), // Templated
		     .s_axis_read_desc_ram_addr(m_axis_read_desc_ram_addr[RAM_ADDR_WIDTH-1:0]), // Templated
		     .s_axis_read_desc_len(m_axis_read_desc_len[LEN_WIDTH-1:0]), // Templated
		     .s_axis_read_desc_tag(m_axis_read_desc_tag[TAG_WIDTH-1:0]), // Templated
		     .s_axis_read_desc_valid(m_axis_read_desc_valid), // Templated
		     .s_axis_write_desc_pcie_addr(m_axis_write_desc_dma_addr[PCIE_ADDR_WIDTH-1:0]), // Templated
		     .s_axis_write_desc_ram_sel(m_axis_write_desc_ram_sel[RAM_SEL_WIDTH-1:0]), // Templated
		     .s_axis_write_desc_ram_addr(m_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]), // Templated
		     .s_axis_write_desc_len(m_axis_write_desc_len[LEN_WIDTH-1:0]), // Templated
		     .s_axis_write_desc_tag(m_axis_write_desc_tag[TAG_WIDTH-1:0]), // Templated
		     .s_axis_write_desc_valid(m_axis_write_desc_valid), // Templated
		     .ram_wr_cmd_ready	(if_ram_wr_cmd_ready[SEG_COUNT-1:0]), // Templated
		     .ram_rd_cmd_ready	(if_ram_rd_cmd_ready[SEG_COUNT-1:0]), // Templated
		     .ram_rd_resp_data	(if_ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]), // Templated
		     .ram_rd_resp_valid	(if_ram_rd_resp_valid[SEG_COUNT-1:0]), // Templated
		     .read_enable	(read_enable),
		     .write_enable	(write_enable),
		     .ext_tag_enable	(ext_tag_enable),
		     .requester_id	(requester_id[15:0]),
		     .requester_id_enable(requester_id_enable),
		     .max_read_request_size(max_read_request_size[2:0]),
		     .max_payload_size	(max_payload_size[2:0]));



pcie_us_dma_axis #(/*AUTOINSTPARAM*/
		   // Parameters
		   .SIZE		(SIZE),
		   .SEG_COUNT		(SEG_COUNT),
		   .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
		   .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		   .SEG_BE_WIDTH	(SEG_BE_WIDTH),
		   .PIPELINE		(PIPELINE),
		   .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
		   .AXIS_DATA_WIDTH	(AXIS_DATA_WIDTH),
		   .AXIS_KEEP_ENABLE	(AXIS_KEEP_ENABLE),
		   .AXIS_KEEP_WIDTH	(AXIS_KEEP_WIDTH),
		   .AXIS_LAST_ENABLE	(AXIS_LAST_ENABLE),
		   .AXIS_ID_ENABLE	(AXIS_ID_ENABLE),
		   .AXIS_ID_WIDTH	(AXIS_ID_WIDTH),
		   .AXIS_DEST_ENABLE	(AXIS_DEST_ENABLE),
		   .AXIS_DEST_WIDTH	(AXIS_DEST_WIDTH),
		   .AXIS_USER_ENABLE	(AXIS_USER_ENABLE),
		   .AXIS_USER_WIDTH	(AXIS_USER_WIDTH),
		   .LEN_WIDTH		(LEN_WIDTH),
		   .TAG_WIDTH		(TAG_WIDTH))
pcie_us_dma_axis_inst1 (/*AUTOINST*/
			// Outputs
			.m_axis_read_data_tdata(m_axis_read_data_tdata[AXIS_DATA_WIDTH-1:0]),
			.m_axis_read_data_tdest(m_axis_read_data_tdest[AXIS_DEST_WIDTH-1:0]),
			.m_axis_read_data_tid(m_axis_read_data_tid[AXIS_ID_WIDTH-1:0]),
			.m_axis_read_data_tkeep(m_axis_read_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
			.m_axis_read_data_tlast(m_axis_read_data_tlast),
			.m_axis_read_data_tuser(m_axis_read_data_tuser[AXIS_USER_WIDTH-1:0]),
			.m_axis_read_data_tvalid(m_axis_read_data_tvalid),
			.m_axis_read_desc_status_tag(m_axis_read_desc_status_tag[TAG_WIDTH-1:0]),
			.m_axis_read_desc_status_valid(m_axis_read_desc_status_valid),
			.m_axis_write_desc_status_dest(m_axis_write_desc_status_dest[AXIS_DEST_WIDTH-1:0]),
			.m_axis_write_desc_status_id(m_axis_write_desc_status_id[AXIS_ID_WIDTH-1:0]),
			.m_axis_write_desc_status_len(m_axis_write_desc_status_len[LEN_WIDTH-1:0]),
			.m_axis_write_desc_status_tag(m_axis_write_desc_status_tag[TAG_WIDTH-1:0]),
			.m_axis_write_desc_status_user(m_axis_write_desc_status_user[AXIS_USER_WIDTH-1:0]),
			.m_axis_write_desc_status_valid(m_axis_write_desc_status_valid),
			.s_axis_read_desc_ready(s_axis_read_desc_ready),
			.s_axis_write_data_tready(s_axis_write_data_tready),
			.s_axis_write_desc_ready(s_axis_write_desc_ready),
			.ram_wr_cmd_ready(ram_wr_cmd_ready[SEG_COUNT-1:0]),
			.ram_rd_cmd_ready(ram_rd_cmd_ready[SEG_COUNT-1:0]),
			.ram_rd_resp_data(ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
			.ram_rd_resp_valid(ram_rd_resp_valid[SEG_COUNT-1:0]),
			// Inputs
			.abort		(abort),
			.clk		(clk),
			.enable		(enable),
			.m_axis_read_data_tready(m_axis_read_data_tready),
			.rst		(rst),
			.s_axis_read_desc_dest(s_axis_read_desc_dest[AXIS_DEST_WIDTH-1:0]),
			.s_axis_read_desc_id(s_axis_read_desc_id[AXIS_ID_WIDTH-1:0]),
			.s_axis_read_desc_len(s_axis_read_desc_len[LEN_WIDTH-1:0]),
			.s_axis_read_desc_ram_addr(s_axis_read_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
			.s_axis_read_desc_tag(s_axis_read_desc_tag[TAG_WIDTH-1:0]),
			.s_axis_read_desc_user(s_axis_read_desc_user[AXIS_USER_WIDTH-1:0]),
			.s_axis_read_desc_valid(s_axis_read_desc_valid),
			.s_axis_write_data_tdata(s_axis_write_data_tdata[AXIS_DATA_WIDTH-1:0]),
			.s_axis_write_data_tdest(s_axis_write_data_tdest[AXIS_DEST_WIDTH-1:0]),
			.s_axis_write_data_tid(s_axis_write_data_tid[AXIS_ID_WIDTH-1:0]),
			.s_axis_write_data_tkeep(s_axis_write_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
			.s_axis_write_data_tlast(s_axis_write_data_tlast),
			.s_axis_write_data_tuser(s_axis_write_data_tuser[AXIS_USER_WIDTH-1:0]),
			.s_axis_write_data_tvalid(s_axis_write_data_tvalid),
			.s_axis_write_desc_len(s_axis_write_desc_len[LEN_WIDTH-1:0]),
			.s_axis_write_desc_ram_addr(s_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
			.s_axis_write_desc_tag(s_axis_write_desc_tag[TAG_WIDTH-1:0]),
			.s_axis_write_desc_valid(s_axis_write_desc_valid),
			.ram_wr_cmd_be	(ram_wr_cmd_be[SEG_COUNT*SEG_BE_WIDTH-1:0]),
			.ram_wr_cmd_addr(ram_wr_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
			.ram_wr_cmd_data(ram_wr_cmd_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
			.ram_wr_cmd_valid(ram_wr_cmd_valid[SEG_COUNT-1:0]),
			.ram_rd_cmd_addr(ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
			.ram_rd_cmd_valid(ram_rd_cmd_valid[SEG_COUNT-1:0]),
			.ram_rd_resp_ready(ram_rd_resp_ready[SEG_COUNT-1:0]));

//pcie_us_dma_axis #(/*AUTOINSTPARAM*/
//		   // Parameters
//		   .SIZE		(SIZE),
//		   .SEG_COUNT		(SEG_COUNT),
//		   .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
//		   .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
//		   .SEG_BE_WIDTH	(SEG_BE_WIDTH),
//		   .PIPELINE		(PIPELINE),
//		   .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
//		   .AXIS_DATA_WIDTH	(AXIS_DATA_WIDTH),
//		   .AXIS_KEEP_ENABLE	(AXIS_KEEP_ENABLE),
//		   .AXIS_KEEP_WIDTH	(AXIS_KEEP_WIDTH),
//		   .AXIS_LAST_ENABLE	(AXIS_LAST_ENABLE),
//		   .AXIS_ID_ENABLE	(AXIS_ID_ENABLE),
//		   .AXIS_ID_WIDTH	(AXIS_ID_WIDTH),
//		   .AXIS_DEST_ENABLE	(AXIS_DEST_ENABLE),
//		   .AXIS_DEST_WIDTH	(AXIS_DEST_WIDTH),
//		   .AXIS_USER_ENABLE	(AXIS_USER_ENABLE),
//		   .AXIS_USER_WIDTH	(AXIS_USER_WIDTH),
//		   .LEN_WIDTH		(LEN_WIDTH),
//		   .TAG_WIDTH		(TAG_WIDTH))
//pcie_us_dma_axis_inst2 (
//         .ram_wr_cmd_ready(ram_wr_cmd_ready  [SEG_COUNT +: SEG_COUNT]),
//         .ram_rd_cmd_ready(ram_rd_cmd_ready  [SEG_COUNT +: SEG_COUNT]),
//         .ram_rd_resp_data(ram_rd_resp_data  [SEG_COUNT*SEG_DATA_WIDTH +: SEG_COUNT*SEG_DATA_WIDTH]),
//         .ram_rd_resp_valid(ram_rd_resp_valid[SEG_COUNT +: SEG_COUNT]),   
//         .ram_wr_cmd_be	(ram_wr_cmd_be       [SEG_COUNT*SEG_BE_WIDTH   +: SEG_COUNT*SEG_BE_WIDTH]),
//			.ram_wr_cmd_addr(ram_wr_cmd_addr    [SEG_COUNT*SEG_ADDR_WIDTH +: SEG_COUNT*SEG_ADDR_WIDTH]),
//			.ram_wr_cmd_data(ram_wr_cmd_data    [SEG_COUNT*SEG_DATA_WIDTH +: SEG_COUNT*SEG_DATA_WIDTH]),
//			.ram_wr_cmd_valid(ram_wr_cmd_valid  [SEG_COUNT +: SEG_COUNT]),
//			.ram_rd_cmd_addr(ram_rd_cmd_addr    [SEG_COUNT*SEG_ADDR_WIDTH +: SEG_COUNT*SEG_ADDR_WIDTH]),
//			.ram_rd_cmd_valid(ram_rd_cmd_valid  [SEG_COUNT +: SEG_COUNT]),
//			.ram_rd_resp_ready(ram_rd_resp_ready[SEG_COUNT +: SEG_COUNT]),
//         /*AUTOINST*/
//			// Outputs
//			.m_axis_read_data_tdata(m_axis_read_data_tdata[AXIS_DATA_WIDTH-1:0]),
//			.m_axis_read_data_tdest(m_axis_read_data_tdest[AXIS_DEST_WIDTH-1:0]),
//			.m_axis_read_data_tid(m_axis_read_data_tid[AXIS_ID_WIDTH-1:0]),
//			.m_axis_read_data_tkeep(m_axis_read_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
//			.m_axis_read_data_tlast(m_axis_read_data_tlast),
//			.m_axis_read_data_tuser(m_axis_read_data_tuser[AXIS_USER_WIDTH-1:0]),
//			.m_axis_read_data_tvalid(m_axis_read_data_tvalid),
//			.m_axis_read_desc_status_tag(m_axis_read_desc_status_tag[TAG_WIDTH-1:0]),
//			.m_axis_read_desc_status_valid(m_axis_read_desc_status_valid),
//			.m_axis_write_desc_status_dest(m_axis_write_desc_status_dest[AXIS_DEST_WIDTH-1:0]),
//			.m_axis_write_desc_status_id(m_axis_write_desc_status_id[AXIS_ID_WIDTH-1:0]),
//			.m_axis_write_desc_status_len(m_axis_write_desc_status_len[LEN_WIDTH-1:0]),
//			.m_axis_write_desc_status_tag(m_axis_write_desc_status_tag[TAG_WIDTH-1:0]),
//			.m_axis_write_desc_status_user(m_axis_write_desc_status_user[AXIS_USER_WIDTH-1:0]),
//			.m_axis_write_desc_status_valid(m_axis_write_desc_status_valid),
//			.s_axis_read_desc_ready(s_axis_read_desc_ready),
//			.s_axis_write_data_tready(s_axis_write_data_tready),
//			.s_axis_write_desc_ready(s_axis_write_desc_ready),
//			// Inputs
//			.abort		(abort),
//			.clk		(clk),
//			.enable		(enable),
//			.m_axis_read_data_tready(m_axis_read_data_tready),
//			.rst		(rst),
//			.s_axis_read_desc_dest(s_axis_read_desc_dest[AXIS_DEST_WIDTH-1:0]),
//			.s_axis_read_desc_id(s_axis_read_desc_id[AXIS_ID_WIDTH-1:0]),
//			.s_axis_read_desc_len(s_axis_read_desc_len[LEN_WIDTH-1:0]),
//			.s_axis_read_desc_ram_addr(s_axis_read_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
//			.s_axis_read_desc_tag(s_axis_read_desc_tag[TAG_WIDTH-1:0]),
//			.s_axis_read_desc_user(s_axis_read_desc_user[AXIS_USER_WIDTH-1:0]),
//			.s_axis_read_desc_valid(s_axis_read_desc_valid),
//			.s_axis_write_data_tdata(s_axis_write_data_tdata[AXIS_DATA_WIDTH-1:0]),
//			.s_axis_write_data_tdest(s_axis_write_data_tdest[AXIS_DEST_WIDTH-1:0]),
//			.s_axis_write_data_tid(s_axis_write_data_tid[AXIS_ID_WIDTH-1:0]),
//			.s_axis_write_data_tkeep(s_axis_write_data_tkeep[AXIS_KEEP_WIDTH-1:0]),
//			.s_axis_write_data_tlast(s_axis_write_data_tlast),
//			.s_axis_write_data_tuser(s_axis_write_data_tuser[AXIS_USER_WIDTH-1:0]),
//			.s_axis_write_data_tvalid(s_axis_write_data_tvalid),
//			.s_axis_write_desc_len(s_axis_write_desc_len[LEN_WIDTH-1:0]),
//			.s_axis_write_desc_ram_addr(s_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
//			.s_axis_write_desc_tag(s_axis_write_desc_tag[TAG_WIDTH-1:0]),
//			.s_axis_write_desc_valid(s_axis_write_desc_valid));

endmodule

// Local Variables:
// verilog-library-flags:("–y ./")
// verilog-auto-inst-param-value:t
// End:
