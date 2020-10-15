// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXI stream sink DMA client
 */
module dma_client_port #
(
    // Number of ports
    parameter PORTS = 4,
    // RAM segment count
    parameter SEG_COUNT = 8,
    // RAM segment data width
    parameter SEG_DATA_WIDTH = 128,
    // RAM segment address width
    parameter SEG_ADDR_WIDTH = 8,
    // RAM segment byte enable width
    parameter SEG_BE_WIDTH = SEG_DATA_WIDTH/8,
    // RAM address width
    parameter RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH),
    // PCIe address width
    parameter PCIE_ADDR_WIDTH = 64,
    // Width of AXI stream interfaces in bits
    parameter FRAME_DATA_WIDTH = 512,
    // Use AXI stream tkeep signal
    // Width of length field
    parameter LEN_WIDTH = 16,
    // Width of tag field
    parameter TAG_WIDTH = 8,
    // 帧数据相对于读使能的延迟时钟周期数，0=表示无延迟，1=表示延迟1个时钟周期，2=表示延迟2个时钟周期，依次类推，最大不超过3
    parameter FRAME_PIPELINE = 1
)
(
    input  wire                                 clk,
    input  wire                                 rst,

    /*
     * AXI write descriptor status output
     */
    //output wire [RAM_SEL_WIDTH-1:0]             m_axis_write_desc_ram_sel,
    //output wire [AXIS_ID_WIDTH-1:0]             m_axis_write_desc_id,
    //output wire [AXIS_DEST_WIDTH-1:0]           m_axis_write_desc_dest,
    //output wire [AXIS_USER_WIDTH-1:0]           m_axis_write_desc_user,
    output reg  [PCIE_ADDR_WIDTH-1:0]           m_axis_write_desc_pcie_addr,
    output reg  [RAM_ADDR_WIDTH-1:0]            m_axis_write_desc_ram_addr,
    output reg  [LEN_WIDTH-1:0]                 m_axis_write_desc_len,
    output reg  [TAG_WIDTH-1:0]                 m_axis_write_desc_tag,
    output reg                                  m_axis_write_desc_valid,
    input  wire                                 m_axis_write_desc_ready,
    /*
     * frame read data input
     */
    output reg  [PORTS-1:0]                     read_frame_enb,
    input  wire [PORTS*FRAME_DATA_WIDTH-1:0]    read_frame_tdata,
    //input  wire [PORTS-1:0]                     read_frame_ack,
    input  wire [PORTS-1:0]                     read_frame_ready,
    input  wire [PORTS*LEN_WIDTH-1:0]           read_frame_len,     //当ready信号有效时，len表示当前请求发送帧的长度
    input  wire [PORTS*TAG_WIDTH-1:0]           read_frame_tag,     //当ready信号有效时，tag表示当前请求发送帧的tag值

    /*
     * RAM interface
     */
    output wire [SEG_COUNT*SEG_BE_WIDTH-1:0]    ram_wr_cmd_be,
    output wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]  ram_wr_cmd_addr,
    output wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]  ram_wr_cmd_data,
    output wire [SEG_COUNT-1:0]                 ram_wr_cmd_valid,
    input  wire [SEG_COUNT-1:0]                 ram_wr_cmd_ready,
    /*
     * Configuration
     */
    input  wire [PORTS-1:0]                         enable_port,
    // Host存储TLP帧的缓存空间数量，默认设置为1块，最大设置为4块
    input  wire [2:0]                               enable_tlp_ram,
    input  wire [4*PCIE_ADDR_WIDTH-1:0]             pcie_ram_base_addr,
    input  wire [16-1:0]                            pcie_buf_size_kb,
    input  wire [16-1:0]                            pcie_buf_cnt_max
);

localparam  FRAME_BYTE_WIDTH = FRAME_DATA_WIDTH/8;
localparam  FRAME_DATA_BE_WIDTH = $clog2(FRAME_DATA_WIDTH/8);
localparam  PART_COUNT       = SEG_COUNT*SEG_BE_WIDTH / FRAME_BYTE_WIDTH;
localparam  PART_COUNT_WIDTH = PART_COUNT > 1 ? $clog2(PART_COUNT) : 1;
localparam  PART_OFFSET_WIDTH = $clog2(FRAME_BYTE_WIDTH); 
//localparam  PARTS_PER_SEG = (SEG_BE_WIDTH + FRAME_BYTE_WIDTH - 1) / FRAME_BYTE_WIDTH;
//localparam  SEGS_PER_PART = (FRAME_BYTE_WIDTH + SEG_BE_WIDTH - 1) / SEG_BE_WIDTH;
localparam  PSDPRAM_BE_WIDTH = $clog2(SEG_COUNT*SEG_BE_WIDTH);

localparam  OFFSET_WIDTH = $clog2(FRAME_BYTE_WIDTH);
localparam  OFFSET_MASK  = {OFFSET_WIDTH{1'b1}};
localparam  ADDR_MASK    = {RAM_ADDR_WIDTH{1'b1}} << OFFSET_WIDTH;
localparam  CYCLE_COUNT_WIDTH = LEN_WIDTH - OFFSET_WIDTH + 1;

// bus width assertions
initial begin
    //if (RAM_WORD_SIZE * SEG_BE_WIDTH != SEG_DATA_WIDTH) begin
    //    $error("Error: RAM data width not evenly divisble (instance %m)");
    //    $finish;
    //end

    //if (AXIS_WORD_SIZE * AXIS_KEEP_WIDTH_INT != FRAME_DATA_WIDTH) begin
    //    $error("Error: AXI stream data width not evenly divisble (instance %m)");
    //    $finish;
    //end

    //if (RAM_WORD_SIZE != AXIS_WORD_SIZE) begin
    //    $error("Error: word size mismatch (instance %m)");
    //    $finish;
    //end

    //if (2**$clog2(RAM_WORD_WIDTH) != RAM_WORD_WIDTH) begin
    //    $error("Error: RAM word width must be even power of two (instance %m)");
    //    $finish;
    //end

    if (RAM_ADDR_WIDTH != SEG_ADDR_WIDTH+$clog2(SEG_COUNT)+$clog2(SEG_BE_WIDTH)) begin
        $error("Error: RAM_ADDR_WIDTH does not match RAM configuration (instance %m)");
        $finish;
    end

    if (FRAME_DATA_WIDTH > SEG_COUNT*SEG_DATA_WIDTH) begin
        $error("Error: AXI stream interface width must not be wider than RAM interface width (instance %m)");
        $finish;
    end

    //if (FRAME_DATA_WIDTH*2**PART_COUNT_WIDTH != SEG_COUNT*SEG_DATA_WIDTH) begin
    //    $error("Error: AXI stream interface width must be a power of two fraction of RAM interface width (instance %m)");
    //    $finish;
    //end
end

localparam [1:0]
    STATE_IDLE0 = 2'd0,
    STATE_ARBIT = 2'd1,
    STATE_READ  = 2'd2;

reg [1:0] arbit_state_reg;

///*AUTOASCIIENUM("arbit_state_reg" , "_stateascii_r" , "state_")*/

reg [7:0] beat_cnt,arbit_frame_beat,arbit_frame_tag;
reg [LEN_WIDTH-1:0] arbit_frame_len;
reg [$clog2(PORTS)-1:0] grant_encoded_reg,grant_encoded_reg_d1;

reg                                 frame_write_data_tlast;
reg                                 frame_write_data_tvalid;
reg  [FRAME_BYTE_WIDTH-1:0]         frame_write_data_tkeep1;
wire [FRAME_BYTE_WIDTH-1:0]         frame_write_data_tkeep;
wire [FRAME_DATA_WIDTH-1:0]         frame_write_data_tdata;

integer i;

reg [RAM_ADDR_WIDTH-1:0] addr_reg = {RAM_ADDR_WIDTH{1'b0}};

// internal datapath
reg  [SEG_COUNT*SEG_BE_WIDTH-1:0]   ram_wr_cmd_be_int;
reg  [SEG_COUNT*SEG_ADDR_WIDTH-1:0] ram_wr_cmd_addr_int;
reg  [SEG_COUNT*SEG_DATA_WIDTH-1:0] ram_wr_cmd_data_int;
reg  [SEG_COUNT-1:0]                ram_wr_cmd_valid_int;
reg  [SEG_COUNT-1:0]                ram_wr_cmd_ready_int_reg;
wire [SEG_COUNT-1:0]                ram_wr_cmd_ready_int_early;


wire [PORTS-1:0]         request;
reg  [PORTS-1:0]         acknowledge;
wire [PORTS-1:0]         grant;
wire                     grant_valid;
wire [$clog2(PORTS)-1:0] grant_encoded;

wire                     enable;

reg  [PCIE_ADDR_WIDTH-1:0]           pcie_ram_addr;
reg  [RAM_ADDR_WIDTH -1:0]           desc_ram_addr;
reg  [1:0]                           tlp_ram_cnt;
wire                                 m_axis_write_desc_ready_int;
reg                                  read_frame_mask;


assign request = read_frame_ready & enable_port;
assign enable  = |enable_port;


arbiter #(
	  // Parameters
	  .PORTS			(PORTS),
	  .TYPE				("ROUND_ROBIN"),
	  .BLOCK			("ACKNOWLEDGE"),
	  .LSB_PRIORITY		("HIGH"))
arbiter_inst (/*AUTOINST*/
	      // Outputs
	      .grant			(grant[PORTS-1:0]),
	      .grant_valid		(grant_valid),
	      .grant_encoded		(grant_encoded[$clog2(PORTS)-1:0]),
	      // Inputs
	      .clk			(clk),
	      .rst			(rst),
	      .request			(request[PORTS-1:0]),
	      .acknowledge		(acknowledge[PORTS-1:0]));

//assign m_axis_write_desc_ready_int = (arbit_frame_len > 112) ? m_axis_write_desc_ready : 1'b1;
assign m_axis_write_desc_ready_int = m_axis_write_desc_ready;

//调度状态机
always @(posedge clk) begin
    if (rst) begin
        arbit_state_reg <= STATE_IDLE0;
        read_frame_enb <= 'd0;
        acknowledge <= 'd0;
        grant_encoded_reg <= 'd0;
        arbit_frame_len <= 'd256;
        tlp_ram_cnt   <= 2'd0;
        pcie_ram_addr <= 'd0;
        desc_ram_addr <= 'd0;
        m_axis_write_desc_pcie_addr <= 'd0;
        m_axis_write_desc_ram_addr  <= 'd0;
        m_axis_write_desc_len   <= 'd0;
        m_axis_write_desc_tag   <= 'd0;
        m_axis_write_desc_valid <= 'd0;
        read_frame_mask <= 1'b0;
    end
    else begin
        case (arbit_state_reg)
            STATE_IDLE0 : begin
                if(|request) begin
                    arbit_state_reg <= STATE_ARBIT;
                end
                beat_cnt <= 'd0;
                arbit_frame_beat <= 'd0;
                arbit_frame_tag <= 'd0;
                read_frame_enb <= 'd0;
                acknowledge <= 'd0;
                read_frame_mask <= 1'b0;
                m_axis_write_desc_valid <= 1'b0;
            end

            STATE_ARBIT : begin
                if(grant_valid == 1'b1) begin
                    // 向TLP成帧模块添加描述符描述符
                    m_axis_write_desc_valid <= (request & grant) ? 1'b1 : 1'b0;
                    if(m_axis_write_desc_ready_int == 1'b1 && (request & grant) != 0) begin
                        if(enable_tlp_ram < 2) begin
                            tlp_ram_cnt <= 2'd0;
                            if((pcie_ram_addr >> 10) == (pcie_buf_size_kb * (pcie_buf_cnt_max - 1))) begin
                                pcie_ram_addr <= 'd0;
                            end
                            else begin
                                pcie_ram_addr <= pcie_ram_addr + (pcie_buf_size_kb << 10);
                            end
                        end
                        else if(enable_tlp_ram == 2) begin
                            if(tlp_ram_cnt < 1) begin
                                tlp_ram_cnt <= tlp_ram_cnt + 1'b1;
                            end
                            else begin
                                tlp_ram_cnt <= 2'd0;
                                if((pcie_ram_addr >> 10) == (pcie_buf_size_kb * (pcie_buf_cnt_max - 1))) begin
                                    pcie_ram_addr <= 'd0;
                                end
                                else begin
                                    pcie_ram_addr <= pcie_ram_addr + (pcie_buf_size_kb << 10);
                                end
                            end
                        end
                        else if(enable_tlp_ram == 3) begin
                            if(tlp_ram_cnt < 2) begin
                                tlp_ram_cnt <= tlp_ram_cnt + 1'b1;
                            end
                            else begin
                                tlp_ram_cnt <= 2'd0;
                                if((pcie_ram_addr >> 10) == (pcie_buf_size_kb * (pcie_buf_cnt_max - 1))) begin
                                    pcie_ram_addr <= 'd0;
                                end
                                else begin
                                    pcie_ram_addr <= pcie_ram_addr + (pcie_buf_size_kb << 10);
                                end
                            end
                        end
                        else if(enable_tlp_ram > 3) begin
                            if(tlp_ram_cnt < 3) begin
                                tlp_ram_cnt <= tlp_ram_cnt + 1'b1;
                            end
                            else begin
                                tlp_ram_cnt <= 2'd0;
                                if((pcie_ram_addr >> 10) == (pcie_buf_size_kb * (pcie_buf_cnt_max - 1))) begin
                                    pcie_ram_addr <= 'd0;
                                end
                                else begin
                                    pcie_ram_addr <= pcie_ram_addr + (pcie_buf_size_kb << 10);
                                end
                            end
                        end
                    end

                    m_axis_write_desc_pcie_addr <= pcie_ram_base_addr[tlp_ram_cnt*PCIE_ADDR_WIDTH +: PCIE_ADDR_WIDTH] + pcie_ram_addr;
                    
                    m_axis_write_desc_len <= read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH];
                    m_axis_write_desc_tag <= read_frame_tag[grant_encoded*TAG_WIDTH +: TAG_WIDTH];

                    m_axis_write_desc_ram_addr  <= desc_ram_addr << PSDPRAM_BE_WIDTH;
                    if(m_axis_write_desc_ready_int == 1'b1 && (request & grant) != 0) begin
                        desc_ram_addr <= desc_ram_addr + (read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH] >> PSDPRAM_BE_WIDTH) + 
                                        |(read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH] & {PSDPRAM_BE_WIDTH{1'b1}});
                        //m_axis_write_desc_valid <= 1'b0;
                    end
                    //else begin
                    //    m_axis_write_desc_valid <= 1'b1;
                    //end
                    // 根据仲裁的结果控制状态机转移到读数据帧的状态
                    if(m_axis_write_desc_ready_int == 1'b1) begin
                        read_frame_enb  <= (request & grant) ? grant :  'd0;
                        read_frame_mask <= (request & grant) ? 1'b0  : 1'b0;
                        arbit_state_reg <= (request & grant) ? STATE_READ : STATE_IDLE0;
                    end

                    if((request & grant) == 0) begin   //当frame_ready信号无效时，消除多产生的一次授权
                        acknowledge <= grant;
                    end
                    else if ((m_axis_write_desc_ready_int == 1'b1) && (read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH] <= FRAME_DATA_WIDTH/8)) begin
                        acknowledge <= grant;
                    end
                    else begin
                        acknowledge <= 'd0;
                    end
                end
                if(m_axis_write_desc_ready_int == 1'b1) begin
                    arbit_frame_beat <= (read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH] >> FRAME_DATA_BE_WIDTH) + 
                                       |(read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH] & {FRAME_DATA_BE_WIDTH{1'b1}});
                    arbit_frame_tag <= read_frame_tag[grant_encoded*TAG_WIDTH +: TAG_WIDTH];
                    arbit_frame_len <= read_frame_len[grant_encoded*LEN_WIDTH +: LEN_WIDTH];
                    grant_encoded_reg <= grant_encoded;
                    beat_cnt <= 'd1;
                end
            end

            STATE_READ  : begin
                m_axis_write_desc_valid <= 1'b0;
                read_frame_mask <= ~read_frame_mask;
                if(read_frame_mask == 1'b1) begin
                    beat_cnt <= beat_cnt + 1'b1;
                end
                if(arbit_frame_beat == 1) begin
                    acknowledge <= 'd0;
                    //read_frame_enb <= 'd0;
                end
                else if(beat_cnt == arbit_frame_beat-1 && read_frame_mask == 1'b1) begin
                    acknowledge <= grant;
                end
                else begin
                    acknowledge <= 'd0;
                end
                if(|acknowledge) begin
                    read_frame_enb <= 'd0;
                end
                else begin
                    read_frame_enb <= grant & {PORTS{read_frame_mask}};
                end
                if(|acknowledge && |request) begin
                    arbit_state_reg <= STATE_ARBIT;
                end
                else if(|acknowledge && |request == 0) begin
                    arbit_state_reg <= STATE_IDLE0;
                end
            end
            default : arbit_state_reg <= STATE_IDLE0;
        endcase
    end
end

generate
    if(FRAME_PIPELINE == 0) begin:p0
        //可以节省一个时钟周期的传输时延，需要后续发送状态机调整读地址的生成时间，对FIFO接口的时序压力很大
        //不建议采用这种配置
    end
    else if (FRAME_PIPELINE == 1) begin:p1
        //标准FIFO的读出数据时序设定，是此设计的默认值，按照此种设置，数据写入分段式RAM，下一个时钟就要读出使用
        //建议采用这种配置
        always @(posedge clk) begin
            if (rst) begin
                frame_write_data_tkeep1<= 'd0;
                frame_write_data_tlast <= 'd0;
                frame_write_data_tvalid<= 'd0;
                grant_encoded_reg_d1   <= 'd0;
            end
            else begin
                grant_encoded_reg_d1    <= grant_encoded_reg;
                frame_write_data_tvalid <= |read_frame_enb;
                frame_write_data_tlast  <= |acknowledge & |read_frame_enb;
                frame_write_data_tkeep1 <= (arbit_frame_len % FRAME_BYTE_WIDTH) ? ~({FRAME_BYTE_WIDTH{1'b1}} << (arbit_frame_len % FRAME_BYTE_WIDTH)) :
                                                                                    {FRAME_BYTE_WIDTH{1'b1}};
            end
        end
        assign frame_write_data_tdata  = read_frame_tdata[grant_encoded_reg_d1*FRAME_DATA_WIDTH +: FRAME_DATA_WIDTH];
        assign frame_write_data_tkeep  = frame_write_data_tlast ? frame_write_data_tkeep1 : {FRAME_BYTE_WIDTH{1'b1}};
    end
    else if (FRAME_PIPELINE == 2) begin:p2
        //在标准FIFO的读出数据时序基础上，增加1拍时钟的延时，有助于改善FIFO接口的时序
        //需要将写描述的输出时间延迟1个时钟周期输出，整体的传输时延要增加1个周期
        //如有必要可增加这种配置
        // TODO FRAME_PIPELINE == 2
    end
    else if (FRAME_PIPELINE == 3) begin:p3
        //在标准FIFO的读出数据时序基础上，增加2拍时钟的延时，有助于改善FIFO接口的时序或跨die设计的时序收敛
        //需要进一步延迟写描述符的输出时间，保证TLP发送状态机可以正确获得数据
        //如无十分必要不考虑此种配置
    end
endgenerate

// 写psdpram的控制逻辑
always @(posedge clk) begin
    if (rst) begin
        addr_reg <= 'd0;
        //ram_wr_cmd_be_int <= 'd0;
    end
    else begin
        if(m_axis_write_desc_valid) begin
            addr_reg <= m_axis_write_desc_ram_addr;
        end
        else if(frame_write_data_tvalid) begin
            addr_reg <= addr_reg + FRAME_BYTE_WIDTH;
        end
        //if(frame_write_data_tvalid) begin
        //    if(FRAME_DATA_WIDTH == 1024) begin
        //        ram_wr_cmd_be_int   <= frame_write_data_tkeep;
        //    end
        //    else begin
        //        ram_wr_cmd_be_int   <= frame_write_data_tkeep << (addr_reg & ({PART_COUNT_WIDTH{1'b1}} << PART_OFFSET_WIDTH));
        //    end
        //end
        //else begin
        //    ram_wr_cmd_be_int <= 'd0;
        //end
        //ram_wr_cmd_addr_int <= {SEG_COUNT{addr_reg[RAM_ADDR_WIDTH-1:RAM_ADDR_WIDTH-SEG_ADDR_WIDTH]}};
        //ram_wr_cmd_data_int <= {PART_COUNT{frame_write_data_tdata}};
    end
end

always @* begin
    ram_wr_cmd_be_int   = frame_write_data_tkeep;
    ram_wr_cmd_addr_int = {SEG_COUNT{addr_reg[RAM_ADDR_WIDTH-1:RAM_ADDR_WIDTH-SEG_ADDR_WIDTH]}};
    ram_wr_cmd_data_int = {PART_COUNT{frame_write_data_tdata}};
    for (i = 0; i < SEG_COUNT; i = i + 1) begin
        ram_wr_cmd_valid_int[i] = |ram_wr_cmd_be_int[i*SEG_BE_WIDTH +: SEG_BE_WIDTH];
    end
end

// output datapath logic (write data)
generate

genvar n;

for (n = 0; n < SEG_COUNT; n = n + 1) begin

    reg [SEG_BE_WIDTH-1:0]   ram_wr_cmd_be_reg = {SEG_BE_WIDTH{1'b0}};
    reg [SEG_ADDR_WIDTH-1:0] ram_wr_cmd_addr_reg = {SEG_ADDR_WIDTH{1'b0}};
    reg [SEG_DATA_WIDTH-1:0] ram_wr_cmd_data_reg = {SEG_DATA_WIDTH{1'b0}};
    reg                      ram_wr_cmd_valid_reg = 1'b0, ram_wr_cmd_valid_next;

    reg [SEG_BE_WIDTH-1:0]   temp_ram_wr_cmd_be_reg = {SEG_BE_WIDTH{1'b0}};
    reg [SEG_ADDR_WIDTH-1:0] temp_ram_wr_cmd_addr_reg = {SEG_ADDR_WIDTH{1'b0}};
    reg [SEG_DATA_WIDTH-1:0] temp_ram_wr_cmd_data_reg = {SEG_DATA_WIDTH{1'b0}};
    reg                      temp_ram_wr_cmd_valid_reg = 1'b0, temp_ram_wr_cmd_valid_next;

    // datapath control
    reg store_axi_w_int_to_output;
    reg store_axi_w_int_to_temp;
    reg store_axi_w_temp_to_output;

    assign ram_wr_cmd_be[n*SEG_BE_WIDTH +: SEG_BE_WIDTH] = ram_wr_cmd_be_reg;
    assign ram_wr_cmd_addr[n*SEG_ADDR_WIDTH +: SEG_ADDR_WIDTH] = ram_wr_cmd_addr_reg;
    assign ram_wr_cmd_data[n*SEG_DATA_WIDTH +: SEG_DATA_WIDTH] = ram_wr_cmd_data_reg;
    assign ram_wr_cmd_valid[n +: 1] = ram_wr_cmd_valid_reg;

    // enable ready input next cycle if output is ready or the temp reg will not be filled on the next cycle (output reg empty or no input)
    assign ram_wr_cmd_ready_int_early[n +: 1] = ram_wr_cmd_ready[n +: 1] || (!temp_ram_wr_cmd_valid_reg && (!ram_wr_cmd_valid_reg || !ram_wr_cmd_valid_int[n +: 1]));

    always @* begin
        // transfer sink ready state to source
        ram_wr_cmd_valid_next = ram_wr_cmd_valid_reg;
        temp_ram_wr_cmd_valid_next = temp_ram_wr_cmd_valid_reg;

        store_axi_w_int_to_output = 1'b0;
        store_axi_w_int_to_temp = 1'b0;
        store_axi_w_temp_to_output = 1'b0;
        
        if (ram_wr_cmd_ready_int_reg[n +: 1]) begin
            // input is ready
            if (ram_wr_cmd_ready[n +: 1] || !ram_wr_cmd_valid_reg) begin
                // output is ready or currently not valid, transfer data to output
                ram_wr_cmd_valid_next = ram_wr_cmd_valid_int[n +: 1];
                store_axi_w_int_to_output = 1'b1;
            end else begin
                // output is not ready, store input in temp
                temp_ram_wr_cmd_valid_next = ram_wr_cmd_valid_int[n +: 1];
                store_axi_w_int_to_temp = 1'b1;
            end
        end else if (ram_wr_cmd_ready[n +: 1]) begin
            // input is not ready, but output is ready
            ram_wr_cmd_valid_next = temp_ram_wr_cmd_valid_reg;
            temp_ram_wr_cmd_valid_next = 1'b0;
            store_axi_w_temp_to_output = 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            ram_wr_cmd_valid_reg <= 1'b0;
            ram_wr_cmd_ready_int_reg[n +: 1] <= 1'b0;
            temp_ram_wr_cmd_valid_reg <= 1'b0;
        end else begin
            ram_wr_cmd_valid_reg <= ram_wr_cmd_valid_next;
            ram_wr_cmd_ready_int_reg[n +: 1] <= ram_wr_cmd_ready_int_early[n +: 1];
            temp_ram_wr_cmd_valid_reg <= temp_ram_wr_cmd_valid_next;
        end

        // datapath
        if (store_axi_w_int_to_output) begin
            ram_wr_cmd_be_reg <= ram_wr_cmd_be_int[n*SEG_BE_WIDTH +: SEG_BE_WIDTH];
            ram_wr_cmd_addr_reg <= ram_wr_cmd_addr_int[n*SEG_ADDR_WIDTH +: SEG_ADDR_WIDTH];
            ram_wr_cmd_data_reg <= ram_wr_cmd_data_int[n*SEG_DATA_WIDTH +: SEG_DATA_WIDTH];
        end else if (store_axi_w_temp_to_output) begin
            ram_wr_cmd_be_reg <= temp_ram_wr_cmd_be_reg;
            ram_wr_cmd_addr_reg <= temp_ram_wr_cmd_addr_reg;
            ram_wr_cmd_data_reg <= temp_ram_wr_cmd_data_reg;
        end

        if (store_axi_w_int_to_temp) begin
            temp_ram_wr_cmd_be_reg <= ram_wr_cmd_be_int[n*SEG_BE_WIDTH +: SEG_BE_WIDTH];
            temp_ram_wr_cmd_addr_reg <= ram_wr_cmd_addr_int[n*SEG_ADDR_WIDTH +: SEG_ADDR_WIDTH];
            temp_ram_wr_cmd_data_reg <= ram_wr_cmd_data_int[n*SEG_DATA_WIDTH +: SEG_DATA_WIDTH];
        end
    end

end

endgenerate

endmodule

// Local Variables:
// verilog-library-flags:("-y ./")
// verilog-auto-inst-param-value:t
// End:
