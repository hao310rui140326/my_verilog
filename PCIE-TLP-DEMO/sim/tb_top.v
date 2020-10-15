// Language: Verilog 2001

`timescale 1ns / 1ps

module tb_top ();

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
	parameter RAM_SEL_WIDTH = 2;
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
	parameter FRAME_DATA_WIDTH = 1024;	//512;
	// 帧数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
	parameter FRAME_PIPELINE = 1;

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

wire [PORTS-1:0]	enable_port;		// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			m_axis_rq_tready;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [2:0]		max_payload_size;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [11:0]		pcie_tx_fc_pd_av;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [7:0]		pcie_tx_fc_ph_av;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [15:0]		requester_id;		// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			requester_id_enable;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_0;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire [RQ_SEQ_NUM_WIDTH-1:0] s_axis_rq_seq_num_1;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			s_axis_rq_seq_num_valid_0;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
wire			s_axis_rq_seq_num_valid_1;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rq_tdata;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rq_tkeep;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_tlast;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg  [AXIS_PCIE_RQ_USER_WIDTH-1:0] s_axis_rq_tuser;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
reg 			s_axis_rq_tvalid;	// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v

/*AUTOWIRE*/
/*AUTOREG*/
    
//wire [SEG_COUNT*RAM_SEL_WIDTH-1:0]   ram_rd_cmd_sel;
//wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]  ram_rd_cmd_addr;
//wire [SEG_COUNT-1:0]                 ram_rd_cmd_valid;
//wire [SEG_COUNT-1:0]                 ram_rd_cmd_ready;
//wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]  ram_rd_resp_data;
//wire [SEG_COUNT-1:0]                 ram_rd_resp_valid;
//wire [SEG_COUNT-1:0]                 ram_rd_resp_ready;
//
//wire [PORTS-1:0]	        		read_frame_enb;		// From dma_client_port_inst of dma_client_port.v
wire [PORTS*LEN_WIDTH-1:0]			read_frame_len;		// From gen_frame_sim_inst of gen_frame_sim.v
wire [PORTS-1:0]		    		read_frame_ready;	// From gen_frame_sim_inst of gen_frame_sim.v
wire [PORTS*TAG_WIDTH-1:0]			read_frame_tag;		// From gen_frame_sim_inst of gen_frame_sim.v
wire [PORTS*FRAME_DATA_WIDTH-1:0] 	read_frame_tdata;	// From gen_frame_sim_inst of gen_frame_sim.v
//wire [PORTS-1:0]	        		enable;
//
//wire [PCIE_ADDR_WIDTH-1:0]           m_axis_write_desc_pcie_addr;
//wire [RAM_ADDR_WIDTH-1:0]            m_axis_write_desc_ram_addr;
//wire [LEN_WIDTH-1:0]                 m_axis_write_desc_len;
//wire [TAG_WIDTH-1:0]                 m_axis_write_desc_tag;
wire [2:0]                  			 enable_tlp_ram = 3'd1;
reg  [PCIE_RAM_NUM*PCIE_ADDR_WIDTH-1:0]  pcie_ram_base_addr;
reg  [16-1:0]                            pcie_buf_size_kb;
reg  [16-1:0]                            pcie_buf_cnt_max;
	
reg clk,rst;

initial begin
    clk = 1'b0;

    forever #2 clk = ~clk;

end

initial begin
    rst = 1'b1;

    repeat(10) @(posedge clk);
    rst = 1'b0;

    //repeat(10000) @(posedge clk);
    //$finish;

end
//Max_Payload_Size
//This signal outputs the maximum payload size from Device
//Control register bits 7 down to 5. This field sets the maximum
//TLP payload size. As a Receiver, the logic must handle TLPs as
//large as the set value. As a Transmitter, the logic must not
//generate TLPs exceeding the set value.
//00b: 128 bytes maximum payload size
//01b: 256 bytes maximum payload size
//10b: 512 bytes maximum payload size
//11b: 1024 bytes maximum payload size

assign  s_axis_rq_seq_num_0       = 'd0 ;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
assign  s_axis_rq_seq_num_1       = 'd0 ;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
assign  s_axis_rq_seq_num_valid_0 = 'd0 ;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v
assign  s_axis_rq_seq_num_valid_1 = 'd0 ;// To pcie_dma_c2h_top_inst of pcie_dma_c2h_top.v

initial begin

	m_axis_rq_tready = 1'b1;
	s_axis_rq_tvalid = 1'b0;
	s_axis_rq_tuser  =  'd0;
	s_axis_rq_tlast  = 1'b0;
	s_axis_rq_tkeep  =  'd0;
	s_axis_rq_tdata  =  'd0;

	//Max_Payload_Size
	max_payload_size = 3'b001;
	pcie_tx_fc_ph_av = 8'h80;
	pcie_tx_fc_pd_av = 12'h800;
	requester_id     = 16'h1bd4;
	requester_id_enable = 1'b1;

	pcie_ram_base_addr	= 64'h0001_0000;
	pcie_buf_size_kb	= 16'd4;
	pcie_buf_cnt_max	= 16'd2048;

end

//initial begin
//	`ifdef NEW_REG_WR
//	$dumpfile("tb_top_new.lxt");
//	`else
//	$dumpfile("tb_top.lxt");
//	`endif
//    $dumpvars(0, tb_top);
//
//end


initial begin
	#5 ;
	$fsdbDumpon;
	$fsdbAutoSwitchDumpfile(500,"tb_top.fsdb",100);
	$fsdbDumpvars(0,tb_top);

	#2_000_000
	$finish;
end

//initial begin
//#5 ;	
//$vcdpluson;
//$vcdplusmemon;
//$vcdplusglitchon;
//$vcdplusflush;
//end

//////////////////////////////////////////////////////////////////////////////////////////////////


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
pcie_dma_c2h_top_inst (
			   .enable_port	({PORTS{1'b1}}),		
			   /*AUTOINST*/
		       // Outputs
		       .m_axis_rq_seq_num_0(m_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
		       .m_axis_rq_seq_num_1(m_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
		       .m_axis_rq_seq_num_valid_0(m_axis_rq_seq_num_valid_0),
		       .m_axis_rq_seq_num_valid_1(m_axis_rq_seq_num_valid_1),
		       .m_axis_rq_tdata	(m_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
		       .m_axis_rq_tkeep	(m_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
		       .m_axis_rq_tlast	(m_axis_rq_tlast),
		       .m_axis_rq_tuser	(m_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
		       .m_axis_rq_tvalid(m_axis_rq_tvalid),
		       .ram_rd_cmd_sel	(ram_rd_cmd_sel[SEG_COUNT*RAM_SEL_WIDTH-1:0]),
		       .read_frame_enb	(read_frame_enb[PORTS-1:0]),
		       .s_axis_rq_tready(s_axis_rq_tready),
		       // Inputs
		       .clk		(clk),
		       .enable_tlp_ram	(enable_tlp_ram[2:0]),
		       .m_axis_rq_tready(m_axis_rq_tready),
		       .max_payload_size(max_payload_size[2:0]),
		       .pcie_buf_cnt_max(pcie_buf_cnt_max[15:0]),
		       .pcie_buf_size_kb(pcie_buf_size_kb[15:0]),
		       .pcie_ram_base_addr(pcie_ram_base_addr[4*PCIE_ADDR_WIDTH-1:0]),
		       .pcie_tx_fc_pd_av(pcie_tx_fc_pd_av[11:0]),
		       .pcie_tx_fc_ph_av(pcie_tx_fc_ph_av[7:0]),
		       .read_frame_len	(read_frame_len[PORTS*LEN_WIDTH-1:0]),
		       .read_frame_ready(read_frame_ready[PORTS-1:0]),
		       .read_frame_tag	(read_frame_tag[PORTS*TAG_WIDTH-1:0]),
		       .read_frame_tdata(read_frame_tdata[PORTS*FRAME_DATA_WIDTH-1:0]),
		       .requester_id	(requester_id[15:0]),
		       .requester_id_enable(requester_id_enable),
		       .rst		(rst),
		       .s_axis_rq_seq_num_0(s_axis_rq_seq_num_0[RQ_SEQ_NUM_WIDTH-1:0]),
		       .s_axis_rq_seq_num_1(s_axis_rq_seq_num_1[RQ_SEQ_NUM_WIDTH-1:0]),
		       .s_axis_rq_seq_num_valid_0(s_axis_rq_seq_num_valid_0),
		       .s_axis_rq_seq_num_valid_1(s_axis_rq_seq_num_valid_1),
		       .s_axis_rq_tdata	(s_axis_rq_tdata[AXIS_PCIE_DATA_WIDTH-1:0]),
		       .s_axis_rq_tkeep	(s_axis_rq_tkeep[AXIS_PCIE_KEEP_WIDTH-1:0]),
		       .s_axis_rq_tlast	(s_axis_rq_tlast),
		       .s_axis_rq_tuser	(s_axis_rq_tuser[AXIS_PCIE_RQ_USER_WIDTH-1:0]),
		       .s_axis_rq_tvalid(s_axis_rq_tvalid));

//dma_client_port
//dma_client_port_inst (
//		      // Outputs
//		      .m_axis_write_desc_pcie_addr(m_axis_write_desc_pcie_addr[PCIE_ADDR_WIDTH-1:0]),
//		      .m_axis_write_desc_ram_addr(m_axis_write_desc_ram_addr[RAM_ADDR_WIDTH-1:0]),
//		      .m_axis_write_desc_len(m_axis_write_desc_len[LEN_WIDTH-1:0]),
//		      .m_axis_write_desc_tag(m_axis_write_desc_tag[TAG_WIDTH-1:0]),
//		      .m_axis_write_desc_valid(m_axis_write_desc_valid),
//		      .read_frame_enb	(read_frame_enb[PORTS-1:0]),
//		      .ram_rd_cmd_ready	(ram_rd_cmd_ready[SEG_COUNT-1:0]),
//		      .ram_rd_resp_data	(ram_rd_resp_data[SEG_COUNT*SEG_DATA_WIDTH-1:0]),
//		      .ram_rd_resp_valid(ram_rd_resp_valid[SEG_COUNT-1:0]),
//		      // Inputs
//		      .clk		(clk),
//		      .rst		(rst),
//		      .m_axis_write_desc_ready(1'b1),
//		      .read_frame_tdata	(read_frame_tdata[PORTS*FRAME_DATA_WIDTH-1:0]),
//		      .read_frame_ready	(read_frame_ready[PORTS-1:0]),
//		      .read_frame_len	(read_frame_len[PORTS*LEN_WIDTH-1:0]),
//		      .read_frame_tag	(read_frame_tag[PORTS*TAG_WIDTH-1:0]),
//		      .ram_rd_cmd_addr	(ram_rd_cmd_addr[SEG_COUNT*SEG_ADDR_WIDTH-1:0]),
//		      .ram_rd_cmd_valid	(ram_rd_cmd_valid[SEG_COUNT-1:0]),
//		      .ram_rd_resp_ready(ram_rd_resp_ready[SEG_COUNT-1:0]),
//		      .enable_port		({PORTS{1'b1}}));

///*AUTOINSTPARAM*/
///*AUTOINST*/
// 88 -> 856
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd65,16'd1024,16'd128,16'd48};
localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd588,16'd588,16'd588,16'd588};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd288,16'd288,16'd288,16'd288};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd88 ,16'd88 ,16'd88 ,16'd88 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd48 ,16'd48 ,16'd48 ,16'd48 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd88 ,16'd88 ,16'd88 ,16'd88 };
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd112,16'd112,16'd112,16'd112};
//localparam [PORTS*LEN_WIDTH-1:0]	DEFAULT_FRAME_LEN = {16'd113,16'd113,16'd113,16'd113};

localparam [PORTS*TAG_WIDTH-1:0]	DEFAULT_TAG_VALUE = {8'd4,8'd3,8'd2,8'd1};
reg 	   [PORTS-1:0]				gen_frame_sim_rst;

generate

	genvar n;
	for (n = 0; n < PORTS; n = n + 1) begin
		gen_frame_sim #(
				// Parameters
				.DEFAULT_FRAME_LEN	(DEFAULT_FRAME_LEN[n*LEN_WIDTH +: LEN_WIDTH]),
				.DEFAULT_TAG_VALUE	(DEFAULT_TAG_VALUE[n*TAG_WIDTH +: TAG_WIDTH]),
				.DEFAULT_QUEUE_DEPTH(1),
				.FRAME_DATA_WIDTH	(FRAME_DATA_WIDTH),
				.LEN_WIDTH		    (LEN_WIDTH),
				.TAG_WIDTH		    (TAG_WIDTH),
				.FRAME_PIPELINE		(FRAME_PIPELINE))
		gen_frame_sim_i(
				// Outputs
				.read_frame_tdata	(read_frame_tdata[n*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH]),
				.read_frame_ready	(read_frame_ready[n]),
				.read_frame_len	    (read_frame_len  [n*LEN_WIDTH +: LEN_WIDTH]),
				.read_frame_tag	    (read_frame_tag  [n*TAG_WIDTH +: TAG_WIDTH]),
				// Inputs
				.clk				(clk),
				.rst				(gen_frame_sim_rst[n]),
				.read_frame_enb	    (read_frame_enb  [n]));
	end
endgenerate

initial begin
	gen_frame_sim_rst = {PORTS{1'b1}};
	
	#35;
	gen_frame_sim_rst = {PORTS{1'b1}};
	//gen_frame_sim_rst = 'he;
	#2000;
	gen_frame_sim_rst = {PORTS{1'b1}};
	
	#35;
	gen_frame_sim_rst = {PORTS{1'b0}};

end

reg  [31:0]   time_cnt ;
initial begin
    time_cnt = 32'd0 ;
    forever  #1000_000  begin
    	time_cnt =time_cnt+1'd1;
    	$display(" now is %0d-ms ",time_cnt);
    end
end



endmodule

// Local Variables:
// verilog-library-flags:("-y ./")
// verilog-auto-inst-param-value:t
// End:
