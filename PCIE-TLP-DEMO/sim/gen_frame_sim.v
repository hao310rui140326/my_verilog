// Language: Verilog 2001

`timescale 1ns / 1ps

module gen_frame_sim #(
    parameter DEFAULT_FRAME_LEN = 16'd64,
    parameter DEFAULT_TAG_VALUE = 8'd1,
    parameter DEFAULT_QUEUE_DEPTH = 16'd2,
    // Width of AXI stream interfaces in bits
    parameter FRAME_DATA_WIDTH = 512,
    // Width of length field
    parameter LEN_WIDTH = 16,
    // Width of tag field
    parameter TAG_WIDTH = 8,
    // 帧数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
    parameter FRAME_PIPELINE = 1,
    parameter FRAME_LEN_TEST_MODE = 4'd0,   //"INC",  //"0=INC","1=DEC","2=FIX","3=RAND"
    parameter FRAME_CON_TEST_MODE = 4'd0,   //"INC",  //"0=INC","1=DEC",        "3=RAND"
    parameter FRAME_LEN_MIN = 48,
    parameter FRAME_LEN_MAX = 2048,
    //parameter integer SEED  = 1,
    parameter USED_AXIS_FIFO = 1,
    parameter DEPTH = 4096 * 2,
    // Width of input AXI stream interface in bits
    parameter S_DATA_WIDTH = 16384,
    // Propagate tkeep signal on input interface
    // If disabled, tkeep assumed to be 1'b1
    parameter S_KEEP_ENABLE = (S_DATA_WIDTH>8),
    // tkeep signal width (words per cycle) on input interface
    parameter S_KEEP_WIDTH = (S_DATA_WIDTH/8)
)
(
    input  wire                                 clk       ,
    input  wire                                 rst       ,

    input  wire                           read_frame_enb  ,
    output wire [FRAME_DATA_WIDTH-1:0]    read_frame_tdata,
    output reg                            read_frame_ready,
    output wire [LEN_WIDTH-1:0]           read_frame_len  ,     //当ready信号有效时，len表示当前请求发送帧的长度
    output wire [TAG_WIDTH-1:0]           read_frame_tag      //当ready信号有效时，tag表示当前请求发送帧的tag值
    //output wire                           read_frame_sop,

);

localparam FRAME_LEN_INIT = DEFAULT_FRAME_LEN*8/FRAME_DATA_WIDTH + (DEFAULT_FRAME_LEN%(FRAME_DATA_WIDTH/8) ? 1'b1 : 1'b0);

wire [FRAME_DATA_WIDTH  -1:0]  m_axis_tdata;
wire [FRAME_DATA_WIDTH/8-1:0]  m_axis_tkeep;
wire                     m_axis_tvalid;
wire                     m_axis_tready;
wire                     m_axis_tlast;
wire [TAG_WIDTH-1:0]     m_axis_tid;
wire [LEN_WIDTH-1:0]     m_axis_tdest;
wire                     status_overflow;
wire                     status_bad_frame;
wire                     status_good_frame;
wire                     fifo_full;
wire                     fifo_empty;
/*AUTOWIRE*/

/*AUTOREG*/
   

assign read_frame_tag = DEFAULT_TAG_VALUE;
assign read_frame_len =  read_frame_tag*'d1024;
//assign read_frame_tdata = 512'h01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00_01020304_05060708_090a0b0c_0d0e0f00;
assign read_frame_tdata = {128{DEFAULT_TAG_VALUE}};
always @(posedge clk or posedge rst ) begin
	if (rst)	read_frame_ready <= 'd0 ;
	else 		read_frame_ready <= 'd1 ;
end

//always @* begin
//    state_next = STATE_IDLE;
//end
//
//always @(posedge clk) begin
//    state_reg <= state_next;
//end


endmodule

