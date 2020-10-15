// Language: Verilog 2001

`timescale 1ns / 1ps
//`include "sim_define.vh"

/*
 * Testbench for test_dma_c2h
 */
module test_dma_c2h_tb;

`include "sim_define.vh"

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
parameter SEG_ADDR_WIDTH = 4;
// RAM segment byte enable width
parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
// RAM select width
parameter RAM_SEL_WIDTH = 1;
// RAM address width
parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
// PCIe address width
parameter PCIE_ADDR_WIDTH = 64;
// Length field width
//parameter LEN_WIDTH = 16;
// Tag field width
//parameter TAG_WIDTH = 8;
// Operation table size
parameter OP_TABLE_SIZE = 2**(RQ_SEQ_NUM_WIDTH-1);
// In-flight transmit limit
parameter TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1);
// Transmit flow control
parameter TX_FC_ENABLE = 0;
// Number of ports
//parameter PORTS = 4;
// Width of AXI stream interfaces in bits
parameter FRAME_DATA_WIDTH = 1024;	//512;
// 帧数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
parameter FRAME_PIPELINE = 1;

parameter S_DATA_WIDTH = 1024;	//2048;	//16384;
// tkeep signal width (words per cycle) on input interface
parameter S_KEEP_WIDTH = (S_DATA_WIDTH/8);
localparam PCIE_RAM_NUM = 4;

///*AUTOOUTPUT*/

wire [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_0;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_1;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			m_axis_rq_seq_num_valid_0;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			m_axis_rq_seq_num_valid_1;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			m_axis_rq_tlast;	// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			m_axis_rq_tvalid;	// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [SEG_COUNT*RAM_SEL_WIDTH-1:0] ram_rd_cmd_sel;// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [PORTS-1:0]	read_frame_enb;		// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			s_axis_rq_tready;	// From pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v

///*AUTOINPUT*/

reg  [PORTS-1:0]	enable_port;		// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			m_axis_rq_tready;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [2:0]		max_payload_size;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [11:0]		pcie_tx_fc_pd_av;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [7:0]		pcie_tx_fc_ph_av;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [15:0]		requester_id;		// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			requester_id_enable;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_0;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_1;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_seq_num_valid_0;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_seq_num_valid_1;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rq_tdata;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rq_tkeep;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_tlast;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_RQ_USER_WIDTH-1:0] s_axis_rq_tuser;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_tvalid;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v

reg  [PORTS*S_DATA_WIDTH-1:0]        s_axis_tdata;
reg  [PORTS*S_KEEP_WIDTH-1:0]        s_axis_tkeep;
reg  [PORTS-1:0]                     s_axis_tvalid;
wire [PORTS-1:0]                     s_axis_tready;
reg  [PORTS-1:0]                     s_axis_tlast;
reg  [PORTS*TAG_WIDTH-1:0]           s_axis_tid;
reg  [PORTS*LEN_WIDTH-1:0]           s_axis_tdest;

wire [PORTS*FRAME_DATA_WIDTH-1:0] 	 read_frame_tdata;
wire [PORTS-1				  :0] 	 read_frame_ready;
wire [PORTS*LEN_WIDTH-1		  :0] 	 read_frame_len;
wire [PORTS*TAG_WIDTH-1		  :0] 	 read_frame_tag;
wire [PORTS-1				  :0] 	 read_frame_sop;

reg  [2:0]                               enable_tlp_ram;
reg  [PCIE_RAM_NUM*PCIE_ADDR_WIDTH-1:0]  pcie_ram_base_addr;
reg  [16-1:0]                            pcie_buf_size_kb;
reg  [16-1:0]                            pcie_buf_cnt_max;

// Parameters
//parameter AXIS_PCIE_DATA_WIDTH = 512;
//parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32);
//parameter AXIS_PCIE_RQ_USER_WIDTH = 137;
//parameter RQ_SEQ_NUM_WIDTH = AXIS_PCIE_RQ_USER_WIDTH == 60 ? 4 : 6;
//parameter RQ_SEQ_NUM_ENABLE = 1;
//parameter SEG_COUNT = AXIS_PCIE_DATA_WIDTH > 64 ? AXIS_PCIE_DATA_WIDTH*2 / 128 : 2;
//parameter SEG_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH*2/SEG_COUNT;
//parameter SEG_ADDR_WIDTH = 12;
//parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8;
//parameter RAM_SEL_WIDTH = 2;
//parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH);
//parameter PCIE_ADDR_WIDTH = 64;
//parameter LEN_WIDTH = 16;
//parameter TAG_WIDTH = 8;
//parameter OP_TABLE_SIZE = 2**(RQ_SEQ_NUM_WIDTH-1);
//parameter TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1);
//parameter TX_FC_ENABLE = 1;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;
reg final_step = 0;
wire  [31:0]                target_frame_num;
reg   [31:0]                target_frame_num_reg= 0;
wire  [31:0]				axis_write_desc_cnt = DUT.axis_write_desc_cnt;
wire  [31:0]				axis_send_desc_cnt  = DUT.axis_send_desc_cnt;
wire                        gen_frame_rst_pluse = &gen_frame_sim_rst;

integer i;
always @(negedge gen_frame_rst_pluse) begin
    for(i = 0; i < PORTS; i = i+1) begin
        target_frame_num_reg = target_frame_num_reg + DEFAULT_QUEUE_DEPTH[i*LEN_WIDTH +: LEN_WIDTH];
    end
end
assign target_frame_num    = target_frame_num_reg;

//reg [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rq_tdata = 0;
//reg [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rq_tkeep = 0;
//reg s_axis_rq_tvalid = 0;
//reg s_axis_rq_tlast = 0;
//reg [AXIS_PCIE_RQ_USER_WIDTH-1:0] s_axis_rq_tuser = 0;
//reg m_axis_rq_tready = 0;
//reg [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_0 = 0;
//reg s_axis_rq_seq_num_valid_0 = 0;
//reg [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_1 = 0;
//reg s_axis_rq_seq_num_valid_1 = 0;
//reg [7:0] pcie_tx_fc_ph_av = 0;
//reg [11:0] pcie_tx_fc_pd_av = 0;
//reg [PCIE_ADDR_WIDTH-1:0] s_axis_write_desc_pcie_addr = 0;
//reg [RAM_SEL_WIDTH-1:0] s_axis_write_desc_ram_sel = 0;
//reg [RAM_ADDR_WIDTH-1:0] s_axis_write_desc_ram_addr = 0;
//reg [LEN_WIDTH-1:0] s_axis_write_desc_len = 0;
//reg [TAG_WIDTH-1:0] s_axis_write_desc_tag = 0;
//reg s_axis_write_desc_valid = 0;
//reg [SEG_COUNT-1:0] ram_rd_cmd_ready = 0;
//reg [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_rd_resp_data = 0;
//reg [SEG_COUNT-1:0] ram_rd_resp_valid = 0;
//reg enable = 0;
//reg [15:0] requester_id = 0;
//reg requester_id_enable = 0;
//reg [2:0] max_payload_size = 0;

// Outputs
//wire s_axis_rq_tready;
//wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata;
//wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep;
//wire m_axis_rq_tvalid;
//wire m_axis_rq_tlast;
//wire [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser;
//wire [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_0;
//wire m_axis_rq_seq_num_valid_0;
//wire [RQ_SEQ_NUM_WIDTH-1:0] m_axis_rq_seq_num_1;
//wire m_axis_rq_seq_num_valid_1;
//wire s_axis_write_desc_ready;
//wire [TAG_WIDTH-1:0] m_axis_write_desc_status_tag;
//wire m_axis_write_desc_status_valid;
//wire [SEG_COUNT*RAM_SEL_WIDTH-1:0] ram_rd_cmd_sel;
//wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_rd_cmd_addr;
//wire [SEG_COUNT-1:0] ram_rd_cmd_valid;
//wire [SEG_COUNT-1:0] ram_rd_resp_ready;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
		final_step,
        s_axis_rq_tdata,
        s_axis_rq_tkeep,
        s_axis_rq_tvalid,
        s_axis_rq_tlast,
        s_axis_rq_tuser,
        m_axis_rq_tready,
        s_axis_rq_seq_num_0,
        s_axis_rq_seq_num_valid_0,
        s_axis_rq_seq_num_1,
        s_axis_rq_seq_num_valid_1,
        pcie_tx_fc_ph_av,
        pcie_tx_fc_pd_av,
        enable_port,
        requester_id,
        requester_id_enable,
        max_payload_size,
		s_axis_tdata,
		s_axis_tkeep,
		s_axis_tvalid,
		s_axis_tlast,
		s_axis_tid,
		s_axis_tdest,
		gen_frame_sim_rst,
        enable_tlp_ram
    );
    $to_myhdl(
        s_axis_rq_tready,
        m_axis_rq_tdata,
        m_axis_rq_tkeep,
        m_axis_rq_tvalid,
        m_axis_rq_tlast,
        m_axis_rq_tuser,
        m_axis_rq_seq_num_0,
        m_axis_rq_seq_num_valid_0,
        m_axis_rq_seq_num_1,
        m_axis_rq_seq_num_valid_1,
		s_axis_tready,
        axis_write_desc_cnt,
        axis_send_desc_cnt,
        target_frame_num
    );

    // dump file
    $dumpfile("test_dma_c2h_tb.lxt");
    $dumpvars(0, test_dma_c2h_tb);
end

//  initial begin
//	m_axis_rq_tready = 1'b1;
//	s_axis_rq_tvalid = 1'b0;
//	s_axis_rq_tuser  =  'd0;
//	s_axis_rq_tlast  = 1'b0;
//	s_axis_rq_tkeep  =  'd0;
//	s_axis_rq_tdata  =  'd0;
//
//	//Max_Payload_Size
//	max_payload_size = 3'b001;
//	pcie_tx_fc_ph_av = 8'h80;
//	pcie_tx_fc_pd_av = 12'h800;
//	requester_id     = 16'h1bd4;
//	requester_id_enable = 1'b1;

always @(enable_tlp_ram) begin
    case(enable_tlp_ram)
        3'd0,3'd1:begin
	        pcie_ram_base_addr[0*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[1*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[2*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[3*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;

	        pcie_buf_size_kb	= 16'd4;
	        pcie_buf_cnt_max	= 16'd4096;
        end
        3'd2 : begin
            pcie_ram_base_addr[0*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[1*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0080_0000;
            pcie_ram_base_addr[2*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[3*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;

	        pcie_buf_size_kb	= 16'd4;
	        pcie_buf_cnt_max	= 16'd2048;
        end
        3'd3 : begin
            pcie_ram_base_addr[0*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[1*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0040_0000;
            pcie_ram_base_addr[2*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0080_0000;
            pcie_ram_base_addr[3*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;

	        pcie_buf_size_kb	= 16'd4;
	        pcie_buf_cnt_max	= 16'd1024;
        end
        default : begin
            pcie_ram_base_addr[0*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0000_0000;
            pcie_ram_base_addr[1*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0040_0000;
            pcie_ram_base_addr[2*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h0080_0000;
            pcie_ram_base_addr[3*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH]	= 64'h00c0_0000;

	        pcie_buf_size_kb	= 16'd4;
	        pcie_buf_cnt_max	= 16'd1024;
        end
    endcase
end

pcie_dma_c2h_top #(/*AUTOINSTPARAM*/
		   // Parameters
		   .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
		   .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
		   .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
		   .RQ_SEQ_NUM_WIDTH	(RQ_SEQ_NUM_WIDTH),
		   .RQ_SEQ_NUM_ENABLE	(RQ_SEQ_NUM_ENABLE),
		   .SEG_COUNT		(SEG_COUNT),
		   .SEG_DATA_WIDTH	(SEG_DATA_WIDTH),
		   .SEG_ADDR_WIDTH	(SEG_ADDR_WIDTH),
		   .SEG_BE_WIDTH	(SEG_BE_WIDTH),
		   .RAM_SEL_WIDTH	(RAM_SEL_WIDTH),
		   .RAM_ADDR_WIDTH	(RAM_ADDR_WIDTH),
		   .PCIE_ADDR_WIDTH	(PCIE_ADDR_WIDTH),
		   .LEN_WIDTH		(LEN_WIDTH),
		   .TAG_WIDTH		(TAG_WIDTH),
		   .OP_TABLE_SIZE	(OP_TABLE_SIZE),
		   .TX_LIMIT		(TX_LIMIT),
		   .TX_FC_ENABLE	(TX_FC_ENABLE),
		   .PORTS		(PORTS),
		   .FRAME_DATA_WIDTH	(FRAME_DATA_WIDTH),
		   .FRAME_PIPELINE	(FRAME_PIPELINE))
DUT (
     //.enable_port	({PORTS{1'b1}}),		
     .enable_port	(enable_port),
	 /*AUTOINST*/
     // Outputs
     .m_axis_rq_seq_num_0		(m_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
     .m_axis_rq_seq_num_1		(m_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
     .m_axis_rq_seq_num_valid_0		(m_axis_rq_seq_num_valid_0),
     .m_axis_rq_seq_num_valid_1		(m_axis_rq_seq_num_valid_1),
     .m_axis_rq_tdata			(m_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
     .m_axis_rq_tkeep			(m_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
     .m_axis_rq_tlast			(m_axis_rq_tlast),
     .m_axis_rq_tuser			(m_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
     .m_axis_rq_tvalid			(m_axis_rq_tvalid),
     .ram_rd_cmd_sel			(ram_rd_cmd_sel[SEG_COUNT*RAM_SEL_WIDTH-1:0]),
     .read_frame_enb			(read_frame_enb[PORTS-1:0]),
     .s_axis_rq_tready			(s_axis_rq_tready),
     // Inputs
     .clk				(clk),
     .enable_tlp_ram			(enable_tlp_ram[2:0]),
     .m_axis_rq_tready			(m_axis_rq_tready),
     .max_payload_size			(max_payload_size[2:0]),
     .pcie_buf_cnt_max			(pcie_buf_cnt_max[15:0]),
     .pcie_buf_size_kb			(pcie_buf_size_kb[15:0]),
     .pcie_ram_base_addr		(pcie_ram_base_addr[4*PCIE_ADDR_WIDTH-1:0]),
     .pcie_tx_fc_pd_av			(pcie_tx_fc_pd_av[11:0]),
     .pcie_tx_fc_ph_av			(pcie_tx_fc_ph_av[7:0]),
     .read_frame_len			(read_frame_len[PORTS*LEN_WIDTH-1:0]),
     .read_frame_ready			(read_frame_ready[PORTS-1:0]),
     .read_frame_tag			(read_frame_tag[PORTS*TAG_WIDTH-1:0]),
     .read_frame_tdata			(read_frame_tdata[PORTS*FRAME_DATA_WIDTH-1:0]),
     .requester_id			(requester_id[15:0]),
     .requester_id_enable		(requester_id_enable),
     .rst				(rst),
     .s_axis_rq_seq_num_0		(s_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
     .s_axis_rq_seq_num_1		(s_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
     .s_axis_rq_seq_num_valid_0		(s_axis_rq_seq_num_valid_0),
     .s_axis_rq_seq_num_valid_1		(s_axis_rq_seq_num_valid_1),
     .s_axis_rq_tdata			(s_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
     .s_axis_rq_tkeep			(s_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
     .s_axis_rq_tlast			(s_axis_rq_tlast),
     .s_axis_rq_tuser			(s_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
     .s_axis_rq_tvalid			(s_axis_rq_tvalid));

// 88 -> 856
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd65,16'd1024,16'd128,16'd48};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd588,16'd588,16'd588,16'd588};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd288,16'd288,16'd288,16'd288};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd88 ,16'd88 ,16'd88 ,16'd88 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd48 ,16'd48 ,16'd48 ,16'd48 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd88 ,16'd88 ,16'd88 ,16'd88 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd112,16'd112,16'd112,16'd112};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd113,16'd113,16'd113,16'd113};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_QUEUE_DEPTH = {16'd1,16'd1,16'd1,16'd20};
//localparam [PORTS*TAG_WIDTH-1:0]	DEFAULT_TAG_VALUE = {8'd4,8'd3,8'd2,8'd1};
reg 	   [PORTS-1:0]				gen_frame_sim_rst;
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd65};
//localparam [PORTS*TAG_WIDTH-1:0]	DEFAULT_TAG_VALUE = {8'd3};

generate

	genvar n;
	for (n = 0; n < PORTS; n = n + 1) begin
		gen_frame_sim #(
				// Parameters
				.DEFAULT_FRAME_LEN	(DEFAULT_FRAME_LEN[n*LEN_WIDTH +: LEN_WIDTH]),
				.DEFAULT_TAG_VALUE	(DEFAULT_TAG_VALUE[n*TAG_WIDTH +: TAG_WIDTH]),
				.DEFAULT_QUEUE_DEPTH(DEFAULT_QUEUE_DEPTH[n*LEN_WIDTH +: LEN_WIDTH]),
				.FRAME_DATA_WIDTH	(FRAME_DATA_WIDTH),
				.LEN_WIDTH		    (LEN_WIDTH),
				.TAG_WIDTH		    (TAG_WIDTH),
                .FRAME_PIPELINE		(FRAME_PIPELINE),
                .FRAME_LEN_TEST_MODE(DEFAULT_FRAME_LEN_TEST_MODE[n*4 +: 4]),  //"INC","DEC","FIX","RAND"
                .FRAME_CON_TEST_MODE(DEFAULT_FRAME_CON_TEST_MODE[n*4 +: 4]),  //"INC","DEC","RAND"
                .FRAME_LEN_MIN      (DEFAULT_FRAME_LEN_MIN      [n*LEN_WIDTH +: LEN_WIDTH]),
                .FRAME_LEN_MAX      (DEFAULT_FRAME_LEN_MAX      [n*LEN_WIDTH +: LEN_WIDTH]),
                .USED_AXIS_FIFO     (0),
                .DEPTH              (4096*2),
                .S_DATA_WIDTH       (S_DATA_WIDTH),
                .S_KEEP_ENABLE      (1),
                .S_KEEP_WIDTH       (S_KEEP_WIDTH))
		gen_frame_sim_i(
				// Outputs
				.read_frame_tdata	(read_frame_tdata[n*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH]),
				.read_frame_ready	(read_frame_ready[n]),
				.read_frame_len	    (read_frame_len  [n*LEN_WIDTH +: LEN_WIDTH]),
				.read_frame_tag	    (read_frame_tag  [n*TAG_WIDTH +: TAG_WIDTH]),
				.read_frame_sop		(read_frame_sop  [n]),
				// Inputs
                .clk				(clk),
                //.rst				(rst),
                .rst				(gen_frame_sim_rst[n]),
                .read_frame_enb	    (read_frame_enb  [n]),
                .s_axis_tdata       (s_axis_tdata    [n*S_DATA_WIDTH +: S_DATA_WIDTH]),
                .s_axis_tkeep       (s_axis_tkeep    [n*S_KEEP_WIDTH +: S_KEEP_WIDTH]),
                .s_axis_tvalid      (s_axis_tvalid   [n]),
                .s_axis_tready      (s_axis_tready   [n]),
                .s_axis_tlast       (s_axis_tlast    [n]),
                .s_axis_tid         (s_axis_tid      [n*TAG_WIDTH +: TAG_WIDTH]),
                .s_axis_tdest       (s_axis_tdest    [n*LEN_WIDTH +: LEN_WIDTH])
            );
	end
endgenerate

fifo_read_monitor #(/*AUTOINSTPARAM*/
		    // Parameters
		    .FRAME_DATA_WIDTH	(FRAME_DATA_WIDTH),
		    .PORTS		(PORTS),
		    .LEN_WIDTH		(LEN_WIDTH),
		    .TAG_WIDTH		(TAG_WIDTH))
fifo_read_monitor_inst (
			// Inputs
			.sys_clk	(clk),
			.sys_rst	(rst),
			.final_step (final_step),
			/*AUTOINST*/
			// Inputs
			.read_frame_enb	(read_frame_enb[PORTS-1:0]),
			.read_frame_tdata(read_frame_tdata[PORTS*FRAME_DATA_WIDTH-1:0]),
			.read_frame_sop	(read_frame_sop[PORTS-1:0]),
			.read_frame_len	(read_frame_len[PORTS*LEN_WIDTH-1:0]),
			.read_frame_tag	(read_frame_tag[PORTS*TAG_WIDTH-1:0]));

endmodule

// Local Variables:
// verilog-library-flags:("-y ../c2h_dma -y ../tb")
// verilog-auto-inst-param-value:t
// End:
