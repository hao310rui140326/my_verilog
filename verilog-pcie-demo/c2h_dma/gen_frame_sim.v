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
    input  wire                                 clk,
    input  wire                                 rst,

    input  wire                           read_frame_enb,
    output wire [FRAME_DATA_WIDTH-1:0]    read_frame_tdata,
    output wire                           read_frame_ready,
    output wire [LEN_WIDTH-1:0]           read_frame_len,     //当ready信号有效时，len表示当前请求发送帧的长度
    output wire [TAG_WIDTH-1:0]           read_frame_tag,     //当ready信号有效时，tag表示当前请求发送帧的tag值
    output wire                           read_frame_sop,

    input  wire [S_DATA_WIDTH-1:0]        s_axis_tdata,
    input  wire [S_KEEP_WIDTH-1:0]        s_axis_tkeep,
    input  wire                           s_axis_tvalid,
    output wire                           s_axis_tready,
    input  wire                           s_axis_tlast,
    input  wire [TAG_WIDTH-1:0]           s_axis_tid,
    input  wire [LEN_WIDTH-1:0]           s_axis_tdest

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
        
//always @* begin
//    state_next = STATE_IDLE;
//end
//
//always @(posedge clk) begin
//    state_reg <= state_next;
//end
///*AUTOINSTPARAM*/
///*AUTOINST*/
function integer get_frame_len_cycle(input integer frame_len);
begin
    get_frame_len_cycle = frame_len*8/FRAME_DATA_WIDTH + (frame_len%(FRAME_DATA_WIDTH/8) ? 1 : 0);
end
endfunction


generate
    if(USED_AXIS_FIFO == 0) begin:SIM_FIFO

        reg [FRAME_PIPELINE*FRAME_DATA_WIDTH-1:0]    frame_tdata_shift;
        reg [FRAME_DATA_WIDTH-1:0]                   frame_tdata_reg;
        reg [15:0]                                   cnt;
        //reg [31:0]                                   fifo_depth;
        reg                                          read_frame_ready_reg;

        reg [15:0] send_frame_cnt;
        reg [15:0] send_cycle_cnt;
        reg [15:0] read_frame_len_reg;
        integer SEED  = DEFAULT_TAG_VALUE;
        reg [31:0] triger_rand_num;

        assign read_frame_tag = DEFAULT_TAG_VALUE;
        
        
        //integer q_id = DEFAULT_TAG_VALUE,status;
        //initial begin
        //
        //    $q_initialize (q_id, 1, 10, status);
        //    $display("q_id=%d,status=%d",q_id,status);
        //    $q_add(q_id,1,100,status);
        //    $display("q_id=%d,status=%d",q_id,status);
        //
        //end

        if(FRAME_PIPELINE == 0)
            assign read_frame_tdata = {FRAME_DATA_WIDTH/16{DEFAULT_TAG_VALUE,cnt}};  //frame_tdata_reg;
        else if(FRAME_PIPELINE == 1)
            assign read_frame_tdata = frame_tdata_reg;  //frame_tdata_shift[(1-1)*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH];
        else if(FRAME_PIPELINE >= 2)
            assign read_frame_tdata = frame_tdata_shift[(FRAME_PIPELINE-2)*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH];    //frame_tdata_shift[(FRAME_PIPELINE-1)*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH];
        

        always @(posedge clk) begin
            if(rst) begin
                cnt <= 'd1;
                frame_tdata_reg <= 'd0;
                frame_tdata_shift <= 'd0;
            end
            else begin
                if(FRAME_CON_TEST_MODE == 0) begin  //"INC"
                    if(read_frame_enb == 1'b1) begin
                        cnt <= cnt + 1'b1;
                        if(read_frame_sop == 1'b1) begin
                            frame_tdata_reg <= {{(FRAME_DATA_WIDTH/16 - 1){DEFAULT_TAG_VALUE,cnt[7:0]}},read_frame_len_reg};
                        end
                        else begin
                            frame_tdata_reg <= {FRAME_DATA_WIDTH/16{DEFAULT_TAG_VALUE,cnt[7:0]}};
                        end
                    end
                end
                else if(FRAME_CON_TEST_MODE == 1) begin  //"DEC"
                    if(read_frame_enb == 1'b1) begin
                        cnt <= cnt + 1'b1;
                        if(read_frame_sop == 1'b1) begin
                            frame_tdata_reg <= {{(FRAME_DATA_WIDTH/16 - 1){DEFAULT_TAG_VALUE,~cnt[7:0]}},read_frame_len_reg};
                        end
                        else begin
                            frame_tdata_reg <= {FRAME_DATA_WIDTH/16{DEFAULT_TAG_VALUE,~cnt[7:0]}};
                        end
                    end
                end
                else if(FRAME_CON_TEST_MODE == 3) begin  //"RAND"
                    if(read_frame_enb == 1'b1) begin
                        cnt <= cnt + 1'b1;
                        if(read_frame_sop == 1'b1) begin
                            frame_tdata_reg <= {{(FRAME_DATA_WIDTH/16 - 2){$random(SEED)}},{DEFAULT_TAG_VALUE,cnt[7:0]},read_frame_len_reg};
                        end
                        else begin
                            frame_tdata_reg <= {FRAME_DATA_WIDTH/16{$random(SEED)}};
                        end
                    end
                end
                if(FRAME_PIPELINE > 1) begin
                    frame_tdata_shift <= {frame_tdata_shift[(FRAME_PIPELINE-1)*FRAME_DATA_WIDTH-1:0],frame_tdata_reg};
                end
            end
        end

        always @(posedge clk) begin
            if(rst) begin
                //fifo_depth <= FRAME_LEN_INIT * DEFAULT_QUEUE_DEPTH;
                read_frame_ready_reg <= 1'b0;
                send_frame_cnt <= 0;
                send_cycle_cnt <= 0;
                triger_rand_num <= {$random(SEED)};
            end
            else begin
                if(send_frame_cnt < DEFAULT_QUEUE_DEPTH) begin
                    if(send_cycle_cnt < get_frame_len_cycle(read_frame_len_reg)) begin
                        send_cycle_cnt <= (read_frame_enb == 1'b1) ? send_cycle_cnt + 1 : send_cycle_cnt;
                        if(get_frame_len_cycle(read_frame_len_reg) == 1 && read_frame_enb == 1'b1) begin
                            send_frame_cnt <= send_frame_cnt + 1;
                            send_cycle_cnt <= 0;
                            triger_rand_num<= {$random(SEED)};
                        end
                        else if(send_cycle_cnt == get_frame_len_cycle(read_frame_len_reg)-1 && read_frame_enb == 1'b1) begin
                            send_frame_cnt <= send_frame_cnt + 1;
                            send_cycle_cnt <= 0;
                            triger_rand_num<= {$random(SEED)};
                        end
                    end
                    //else begin
                    //    send_cycle_cnt <= 0;
                    //    send_frame_cnt <= send_frame_cnt + 1;
                    //    triger_rand_num<= {$random(SEED)};
                    //end
                    if(send_frame_cnt == DEFAULT_QUEUE_DEPTH-1 && send_cycle_cnt == get_frame_len_cycle(read_frame_len_reg)-1 && read_frame_enb == 1'b1) begin
                    //if(send_frame_cnt == DEFAULT_QUEUE_DEPTH-1 && (send_cycle_cnt == get_frame_len_cycle(read_frame_len_reg) || get_frame_len_cycle(read_frame_len_reg) == 1)) begin
                        read_frame_ready_reg <= 1'b0;
                    end
                    else begin
                        read_frame_ready_reg <= 1'b1;
                    end
                end
                else begin
                    read_frame_ready_reg <= 1'b0;
                end
            end
        end

        if(FRAME_LEN_TEST_MODE == 0) begin   //"INC"
            always @* begin
                if(rst) begin
                    read_frame_len_reg = FRAME_LEN_MIN;
                end
                else begin
                    read_frame_len_reg = FRAME_LEN_MIN + send_frame_cnt % (FRAME_LEN_MAX-FRAME_LEN_MIN);
                end
            end
        end
        else if(FRAME_LEN_TEST_MODE == 1) begin  //"DEC"
            always @* begin
                if(rst) begin
                    read_frame_len_reg = FRAME_LEN_MAX;
                end
                else begin
                    read_frame_len_reg = FRAME_LEN_MAX - send_frame_cnt % (FRAME_LEN_MAX-FRAME_LEN_MIN);
                end
            end
        end
        else if(FRAME_LEN_TEST_MODE == 2) begin  //"FIX"
            always @* begin
                if(rst) begin
                    read_frame_len_reg = DEFAULT_FRAME_LEN;
                end
                else begin
                    read_frame_len_reg = DEFAULT_FRAME_LEN;
                end
            end
        end
        else if(FRAME_LEN_TEST_MODE == 3) begin  //"RAND"
            always @* begin
                if(rst) begin
                    read_frame_len_reg = DEFAULT_FRAME_LEN;
                end
                else begin
                    read_frame_len_reg = FRAME_LEN_MIN + triger_rand_num % (FRAME_LEN_MAX-FRAME_LEN_MIN);;
                end
            end
        end

        assign read_frame_ready = read_frame_ready_reg;
        assign read_frame_len   = read_frame_len_reg;
        assign read_frame_sop   = (get_frame_len_cycle(read_frame_len_reg) == 1) ? 1'b1 : (send_cycle_cnt == 0) ? 1'b1 : 1'b0;
    end
    else if(USED_AXIS_FIFO == 1) begin:AXIS_FIFO

        reg [FRAME_DATA_WIDTH-1:0]    read_frame_tdata_reg;
        reg [LEN_WIDTH-1:0]           read_frame_len_reg;
        reg [TAG_WIDTH-1:0]           read_frame_tag_reg;


        axis_fifo_adapter #(
			    // Parameters
			    .DEPTH		    (DEPTH),
			    .S_DATA_WIDTH	(S_DATA_WIDTH),
			    .S_KEEP_ENABLE	(S_KEEP_ENABLE),
			    .S_KEEP_WIDTH	(S_KEEP_WIDTH),
			    .M_DATA_WIDTH	(FRAME_DATA_WIDTH),
			    .M_KEEP_ENABLE	(1),
			    .M_KEEP_WIDTH	(FRAME_DATA_WIDTH/8),
			    .ID_ENABLE		(1),
			    .ID_WIDTH		(TAG_WIDTH),
			    .DEST_ENABLE	(1),
			    .DEST_WIDTH		(LEN_WIDTH),
			    .USER_ENABLE	(0),
			    .USER_WIDTH		(1),
			    .FRAME_FIFO		(0))
			    //.USER_BAD_FRAME_VALUE(USER_BAD_FRAME_VALUE),
			    //.USER_BAD_FRAME_MASK(USER_BAD_FRAME_MASK),
			    //.DROP_BAD_FRAME	(DROP_BAD_FRAME),
			    //.DROP_WHEN_FULL	(DROP_WHEN_FULL))
        axis_fifo_adapter_inst (
				// Outputs
				.s_axis_tready	(s_axis_tready),
				.m_axis_tdata	(m_axis_tdata),
				.m_axis_tkeep	(m_axis_tkeep),
				.m_axis_tvalid	(m_axis_tvalid),
				.m_axis_tlast	(m_axis_tlast),
				.m_axis_tid	    (m_axis_tid),
				.m_axis_tdest	(m_axis_tdest),
				.m_axis_tuser	(),
				.status_overflow(status_overflow),
				.status_bad_frame(status_bad_frame),
				.status_good_frame(status_good_frame),
				.fifo_full	(fifo_full),
				.fifo_empty	(fifo_empty),
				// Inputs
				.clk		(clk),
				.rst		(rst),
				.s_axis_tdata	(s_axis_tdata),
				.s_axis_tkeep	(s_axis_tkeep),
				.s_axis_tvalid	(s_axis_tvalid),
				.s_axis_tlast	(s_axis_tlast),
				.s_axis_tid	    (s_axis_tid),
				.s_axis_tdest	(s_axis_tdest),
				.s_axis_tuser	(),
				.m_axis_tready	(m_axis_tready));

        assign read_frame_ready = !fifo_empty && m_axis_tvalid;
        assign m_axis_tready = read_frame_enb;
        assign read_frame_tdata = read_frame_tdata_reg;
        assign read_frame_len   = read_frame_len_reg;     //当ready信号有效时，len表示当前请求发送帧的长度
        assign read_frame_tag   = read_frame_tag_reg;

        always @(posedge clk) begin
            if(rst) begin
                read_frame_tdata_reg <= 'd0;
                read_frame_len_reg <= 'd0;
                read_frame_tag_reg <= 'd0;
            end
            else begin
                if(m_axis_tready == 1'b1 && m_axis_tvalid == 1'b1) begin
                    read_frame_tdata_reg <= m_axis_tdata;
                    read_frame_len_reg <= m_axis_tdest;
                    read_frame_tag_reg <= m_axis_tid;
                end
            end
        end
    end

endgenerate

endmodule
