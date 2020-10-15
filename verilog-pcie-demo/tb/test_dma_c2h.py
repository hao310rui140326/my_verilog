#!/usr/bin/env python
"""

Copyright (c) 2019 Alex Forencich

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

"""

from myhdl import *
import os

import pcie
import pcie_usp
import dma_ram
import axis_ep

module = 'test_dma_c2h'
testbench = 'test_dma_c2h_tb'

# DUT文件列表，Python自动调用iverilog进行编译和协同仿真
srcs = []
srcs.append("%s.v " % testbench                  )
srcs.append("fifo_read_monitor.v "               )
srcs.append("../c2h_dma/pcie_dma_c2h_top.v      ")
srcs.append("../c2h_dma/dma_client_port.v       ")
srcs.append("../c2h_dma/arbiter.v               ")
srcs.append("../c2h_dma/priority_encoder.v      ")
srcs.append("../c2h_dma/dma_psdpram.v           ")
srcs.append("../c2h_dma/gen_frame_sim.v         ")
srcs.append("../c2h_dma/dma_if_pcie_us_wr.v     ")
srcs.append("../c2h_dma/dma_if_pcie_reg_wr.v    ") 
srcs.append("../c2h_dma/axis_adapter.v          ")
srcs.append("../c2h_dma/axis_fifo.v             ")
srcs.append("../c2h_dma/axis_fifo_adapter.v     ")

src = ' '.join(srcs)
print(src)

build_cmd = "iverilog -o %s.vvp -D NEW_REG_WR %s" % (testbench, src)

def bench():
    """ 定义仿真平台 创建PCIe设备和DUT实例，定义接口信号，实现信号的连接，定义仿真控制逻辑函数，并调用"""
    # Parameters
    AXIS_PCIE_DATA_WIDTH = 512
    AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32)
    AXIS_PCIE_RQ_USER_WIDTH = 137
    RQ_SEQ_NUM_WIDTH = 4 if AXIS_PCIE_RQ_USER_WIDTH == 60 else 6
    #RQ_SEQ_NUM_ENABLE = 1
    SEG_COUNT = max(2, int(AXIS_PCIE_DATA_WIDTH*2/128))
    SEG_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH*2/SEG_COUNT
    SEG_ADDR_WIDTH = 12
    SEG_BE_WIDTH = int(SEG_DATA_WIDTH/8)
    #RAM_SEL_WIDTH = 2
    #RAM_ADDR_WIDTH = SEG_ADDR_WIDTH+(SEG_COUNT-1).bit_length()+(SEG_BE_WIDTH-1).bit_length()
    #PCIE_ADDR_WIDTH = 64
    LEN_WIDTH = 16
    TAG_WIDTH = 8
    #OP_TABLE_SIZE = 2**(RQ_SEQ_NUM_WIDTH-1)
    #TX_LIMIT = 2**(RQ_SEQ_NUM_WIDTH-1)
    #TX_FC_ENABLE = 1
    S_DATA_WIDTH = 1024 #2048
    S_KEEP_WIDTH = (S_DATA_WIDTH/8)
    PORTS = 4
    #增加端口的数量，需要同时关注enable_port和gen_frame_sim_rst的赋值

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    current_test = Signal(intbv(0)[8:])
    final_step = Signal(bool(0))

    s_axis_rq_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    s_axis_rq_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    s_axis_rq_tvalid = Signal(bool(0))
    s_axis_rq_tlast = Signal(bool(0))
    s_axis_rq_tuser = Signal(intbv(0)[AXIS_PCIE_RQ_USER_WIDTH:])
    m_axis_rq_tready = Signal(bool(0))
    s_axis_rq_seq_num_0 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    s_axis_rq_seq_num_valid_0 = Signal(bool(0))
    s_axis_rq_seq_num_1 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    s_axis_rq_seq_num_valid_1 = Signal(bool(0))
    pcie_tx_fc_ph_av = Signal(intbv(0)[8:])
    pcie_tx_fc_pd_av = Signal(intbv(0)[12:])
    #s_axis_write_desc_pcie_addr = Signal(intbv(0)[PCIE_ADDR_WIDTH:])
    #s_axis_write_desc_ram_sel = Signal(intbv(0)[RAM_SEL_WIDTH:])
    #s_axis_write_desc_ram_addr = Signal(intbv(0)[RAM_ADDR_WIDTH:])
    #s_axis_write_desc_len = Signal(intbv(0)[LEN_WIDTH:])
    #s_axis_write_desc_tag = Signal(intbv(0)[TAG_WIDTH:])
    #s_axis_write_desc_valid = Signal(bool(0))
    #ram_rd_cmd_ready = Signal(intbv(0)[SEG_COUNT:])
    #ram_rd_resp_data = Signal(intbv(0)[SEG_COUNT*SEG_DATA_WIDTH:])
    #ram_rd_resp_valid = Signal(intbv(0)[SEG_COUNT:])

    enable_port = Signal(intbv(0)[PORTS:])
    requester_id = Signal(intbv(0)[16:])
    requester_id_enable = Signal(bool(0))
    max_payload_size = Signal(intbv(0)[3:])
    s_axis_tready = Signal(bool(0))

    # Outputs
    s_axis_rq_tready = Signal(bool(0))
    m_axis_rq_tdata = Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:])
    m_axis_rq_tkeep = Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:])
    m_axis_rq_tvalid = Signal(bool(0))
    m_axis_rq_tlast = Signal(bool(0))
    m_axis_rq_tuser = Signal(intbv(0)[AXIS_PCIE_RQ_USER_WIDTH:])
    m_axis_rq_seq_num_0 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    m_axis_rq_seq_num_valid_0 = Signal(bool(0))
    m_axis_rq_seq_num_1 = Signal(intbv(0)[RQ_SEQ_NUM_WIDTH:])
    m_axis_rq_seq_num_valid_1 = Signal(bool(0))
    #s_axis_write_desc_ready = Signal(bool(0))
    #m_axis_write_desc_status_tag = Signal(intbv(0)[TAG_WIDTH:])
    #m_axis_write_desc_status_valid = Signal(bool(0))
    #ram_rd_cmd_sel = Signal(intbv(0)[SEG_COUNT*RAM_SEL_WIDTH:])
    #ram_rd_cmd_addr = Signal(intbv(0)[SEG_COUNT*SEG_ADDR_WIDTH:])
    #ram_rd_cmd_valid = Signal(intbv(0)[SEG_COUNT:])
    #ram_rd_resp_ready = Signal(intbv(0)[SEG_COUNT:])
    s_axis_tdata = Signal(intbv(0)[S_DATA_WIDTH:])
    s_axis_tkeep = Signal(intbv(0)[S_KEEP_WIDTH:])
    s_axis_tvalid= Signal(bool(0))
    s_axis_tlast = Signal(bool(0))
    s_axis_tid   = Signal(intbv(0)[TAG_WIDTH:])
    s_axis_tdest = Signal(intbv(0)[LEN_WIDTH:])
    source_pause = Signal(bool(0))
    gen_frame_sim_rst = Signal(intbv(-1)[PORTS:])
    axis_write_desc_cnt=Signal(intbv(0)[32:])
    axis_send_desc_cnt =Signal(intbv(0)[32:])
    target_frame_num   =Signal(intbv(0)[32:])
    enable_tlp_ram     =Signal(intbv(0)[3:])

    # Clock and Reset Interface
    user_clk=Signal(bool(0))
    user_reset=Signal(bool(0))
    sys_clk=Signal(bool(0))
    sys_reset=Signal(bool(0))

    # PCIe DMA RAM
    #dma_ram_inst = dma_ram.PSDPRam(2**16)
    #dma_ram_pause = Signal(bool(0))
    #
    #dma_ram_port0 = dma_ram_inst.create_read_ports(
    #    user_clk,
    #    ram_rd_cmd_addr=ram_rd_cmd_addr,
    #    ram_rd_cmd_valid=ram_rd_cmd_valid,
    #    ram_rd_cmd_ready=ram_rd_cmd_ready,
    #    ram_rd_resp_data=ram_rd_resp_data,
    #    ram_rd_resp_valid=ram_rd_resp_valid,
    #    ram_rd_resp_ready=ram_rd_resp_ready,
    #    pause=dma_ram_pause,
    #    name='port0'
    #)

    # sources and sinks
    #write_desc_source = axis_ep.AXIStreamSource()
    #write_desc_source_logic = write_desc_source.create_logic(
    #    user_clk,
    #    user_reset,
    #    tdata=(s_axis_write_desc_pcie_addr, s_axis_write_desc_ram_sel, s_axis_write_desc_ram_addr, s_axis_write_desc_len, s_axis_write_desc_tag),
    #    tvalid=s_axis_write_desc_valid,
    #    tready=s_axis_write_desc_ready,
    #    name='write_desc_source'
    #)

    #write_desc_status_sink = axis_ep.AXIStreamSink()
    #write_desc_status_sink_logic = write_desc_status_sink.create_logic(
    #    user_clk,
    #    user_reset,
    #    tdata=(m_axis_write_desc_status_tag,),
    #    tvalid=m_axis_write_desc_status_valid,
    #    name='write_desc_status_sink'
    #)

    #write_fifo_source = axis_ep.AXIStreamSource()
    #write_fifo_source_logic = write_fifo_source.create_logic(
    #    user_clk,
    #    user_reset,
    #    tdata=s_axis_tdata,
    #    tkeep=s_axis_tkeep,
    #    tvalid=s_axis_tvalid,
    #    tready=s_axis_tready,
    #    tlast=s_axis_tlast,
    #    tid=s_axis_tid,
    #    tdest=s_axis_tdest,
    #    pause=source_pause,
    #    name='write_fifo_source'
    #)

    # PCIe devices
    rc = pcie.RootComplex()

    mem_base, mem_data = rc.alloc_region(16*1024*1024)

    dev = pcie_usp.UltrascalePlusPCIe()

    dev.pcie_generation = 3
    dev.pcie_link_width = 16
    dev.user_clock_frequency = 256e6

    rc.make_port().connect(dev)

    cq_pause = Signal(bool(0))
    cc_pause = Signal(bool(0))
    rq_pause = Signal(bool(0))
    rc_pause = Signal(bool(0))

    pcie_logic = dev.create_logic(
        # Completer reQuest Interface
        m_axis_cq_tdata=Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:]),
        m_axis_cq_tuser=Signal(intbv(0)[183:]),
        m_axis_cq_tlast=Signal(bool(0)),
        m_axis_cq_tkeep=Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:]),
        m_axis_cq_tvalid=Signal(bool(0)),
        m_axis_cq_tready=Signal(bool(1)),
        pcie_cq_np_req=Signal(intbv(3)[2:]),
        pcie_cq_np_req_count=Signal(intbv(0)[6:]),

        # Completer Completion Interface
        s_axis_cc_tdata=Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:]),
        s_axis_cc_tuser=Signal(intbv(0)[81:]),
        s_axis_cc_tlast=Signal(bool(0)),
        s_axis_cc_tkeep=Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:]),
        s_axis_cc_tvalid=Signal(bool(0)),
        s_axis_cc_tready=Signal(bool(0)),

        # Requester reQuest Interface
        s_axis_rq_tdata=m_axis_rq_tdata,
        s_axis_rq_tuser=m_axis_rq_tuser,
        s_axis_rq_tlast=m_axis_rq_tlast,
        s_axis_rq_tkeep=m_axis_rq_tkeep,
        s_axis_rq_tvalid=m_axis_rq_tvalid,
        s_axis_rq_tready=m_axis_rq_tready,
        pcie_rq_seq_num0=s_axis_rq_seq_num_0,
        pcie_rq_seq_num_vld0=s_axis_rq_seq_num_valid_0,
        pcie_rq_seq_num1=s_axis_rq_seq_num_1,
        pcie_rq_seq_num_vld1=s_axis_rq_seq_num_valid_1,
        # pcie_rq_tag0=pcie_rq_tag0,
        # pcie_rq_tag1=pcie_rq_tag1,
        # pcie_rq_tag_av=pcie_rq_tag_av,
        # pcie_rq_tag_vld0=pcie_rq_tag_vld0,
        # pcie_rq_tag_vld1=pcie_rq_tag_vld1,

        # Requester Completion Interface
        m_axis_rc_tdata=Signal(intbv(0)[AXIS_PCIE_DATA_WIDTH:]),
        m_axis_rc_tuser=Signal(intbv(0)[161:]),
        m_axis_rc_tlast=Signal(bool(0)),
        m_axis_rc_tkeep=Signal(intbv(0)[AXIS_PCIE_KEEP_WIDTH:]),
        m_axis_rc_tvalid=Signal(bool(0)),
        m_axis_rc_tready=Signal(bool(0)),

        # Transmit Flow Control Interface
        # pcie_tfc_nph_av=pcie_tfc_nph_av,
        # pcie_tfc_npd_av=pcie_tfc_npd_av,

        # Configuration Flow Control Interface
        cfg_fc_ph=pcie_tx_fc_ph_av,
        cfg_fc_pd=pcie_tx_fc_pd_av,
        #cfg_fc_nph=cfg_fc_nph,
        #cfg_fc_npd=cfg_fc_npd,
        #cfg_fc_cplh=cfg_fc_cplh,
        #cfg_fc_cpld=cfg_fc_cpld,
        cfg_fc_sel=Signal(intbv(0b100)[3:]),

        # Configuration Control Interface
        # cfg_hot_reset_in=cfg_hot_reset_in,
        # cfg_hot_reset_out=cfg_hot_reset_out,
        # cfg_config_space_enable=cfg_config_space_enable,
        # cfg_dsn=cfg_dsn,
        # cfg_ds_port_number=cfg_ds_port_number,
        # cfg_ds_bus_number=cfg_ds_bus_number,
        # cfg_ds_device_number=cfg_ds_device_number,
        # cfg_ds_function_number=cfg_ds_function_number,
        # cfg_power_state_change_ack=cfg_power_state_change_ack,
        # cfg_power_state_change_interrupt=cfg_power_state_change_interrupt,
        # cfg_err_cor_in=cfg_err_cor_in,
        # cfg_err_uncor_in=cfg_err_uncor_in,
        # cfg_flr_done=cfg_flr_done,
        # cfg_vf_flr_done=cfg_vf_flr_done,
        # cfg_flr_in_process=cfg_flr_in_process,
        # cfg_vf_flr_in_process=cfg_vf_flr_in_process,
        # cfg_req_pm_transition_l23_ready=cfg_req_pm_transition_l23_ready,
        # cfg_link_training_enable=cfg_link_training_enable,

        # Clock and Reset Interface
        user_clk=user_clk,
        user_reset=user_reset,
        #user_lnk_up=user_lnk_up,
        sys_clk=sys_clk,
        sys_clk_gt=sys_clk,
        sys_reset=sys_reset,

        cq_pause=cq_pause,
        cc_pause=cc_pause,
        rq_pause=rq_pause,
        rc_pause=rc_pause
    )

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=user_clk,
        rst=user_reset,
        current_test=current_test,
        final_step=final_step,
        s_axis_rq_tdata=s_axis_rq_tdata,
        s_axis_rq_tkeep=s_axis_rq_tkeep,
        s_axis_rq_tvalid=s_axis_rq_tvalid,
        s_axis_rq_tready=s_axis_rq_tready,
        s_axis_rq_tlast=s_axis_rq_tlast,
        s_axis_rq_tuser=s_axis_rq_tuser,
        m_axis_rq_tdata=m_axis_rq_tdata,
        m_axis_rq_tkeep=m_axis_rq_tkeep,
        m_axis_rq_tvalid=m_axis_rq_tvalid,
        m_axis_rq_tready=m_axis_rq_tready,
        m_axis_rq_tlast=m_axis_rq_tlast,
        m_axis_rq_tuser=m_axis_rq_tuser,
        s_axis_rq_seq_num_0=s_axis_rq_seq_num_0,
        s_axis_rq_seq_num_valid_0=s_axis_rq_seq_num_valid_0,
        s_axis_rq_seq_num_1=s_axis_rq_seq_num_1,
        s_axis_rq_seq_num_valid_1=s_axis_rq_seq_num_valid_1,
        m_axis_rq_seq_num_0=m_axis_rq_seq_num_0,
        m_axis_rq_seq_num_valid_0=m_axis_rq_seq_num_valid_0,
        m_axis_rq_seq_num_1=m_axis_rq_seq_num_1,
        m_axis_rq_seq_num_valid_1=m_axis_rq_seq_num_valid_1,
        pcie_tx_fc_ph_av=pcie_tx_fc_ph_av,
        pcie_tx_fc_pd_av=pcie_tx_fc_pd_av,
        enable_port=enable_port,
        requester_id=requester_id,
        requester_id_enable=requester_id_enable,
        max_payload_size=max_payload_size,
        s_axis_tdata=s_axis_tdata,
        s_axis_tkeep=s_axis_tkeep,
        s_axis_tvalid=s_axis_tvalid,
        s_axis_tready=s_axis_tready,
        s_axis_tlast=s_axis_tlast,
        s_axis_tid=s_axis_tid,
        s_axis_tdest=s_axis_tdest,
        gen_frame_sim_rst=gen_frame_sim_rst,
        axis_write_desc_cnt=axis_write_desc_cnt,
        axis_send_desc_cnt=axis_send_desc_cnt,
        target_frame_num=target_frame_num,
        enable_tlp_ram=enable_tlp_ram
    )

    #创建时钟和复位，并运行
    @always(delay(4))
    def clkgen():
        clk.next = not clk

    @always_comb
    def clk_logic():
        sys_clk.next = clk
        sys_reset.next = not rst

    cq_pause_toggle = Signal(bool(0))
    cc_pause_toggle = Signal(bool(0))
    rq_pause_toggle = Signal(bool(0))
    rc_pause_toggle = Signal(bool(0))

    #定义需要的函数
    #def wait_normal():
    #    while s_axis_tvalid:
    #        yield sys_clk.posedge
    #
    #def wait_pause_source():
    #    while s_axis_tvalid :
    #        yield sys_clk.posedge
    #        yield sys_clk.posedge
    #        source_pause.next = False
    #        yield sys_clk.posedge
    #        source_pause.next = True
    #        yield sys_clk.posedge
    #
    #    source_pause.next = False

    def copy_mem_to_file(pcie_addr,enable_tlp_ram):
        """ copy_mem_to_file 从指定的pcie_addr开始，遇到空缓存区则停止，默认发送数据前两个字节为帧长，帧长等于0或大于4096则认为缓存空 """
        save_num = 0
        #with open("pcie_recv_frame.dat","w") as ff :
        with open("pcie_recv_frame.dat","a") as ff :
            print("pcie_addr=0x%x" % pcie_addr)
            frame_len = mem_data[pcie_addr] + mem_data[pcie_addr+1] * 256
            #frame_len = mem_data[pcie_addr:pcie_addr+1]
            print("frame_len=0x%x" % frame_len)
            while (frame_len > 0 and frame_len < 4096+1):
                data = mem_data[pcie_addr:pcie_addr+frame_len]
                ff.write("".join(("{:02x}".format(c) for c in bytearray(data[0:frame_len]))))
                ff.write("\n")
                mem_data[pcie_addr] = 0
                mem_data[pcie_addr+1] = 0
                save_num  += 1
                if(enable_tlp_ram < 2):
                    pcie_addr += 1024*4
                    if(pcie_addr == 16*1024*1024):
                        pcie_addr = 0
                elif(enable_tlp_ram == 2):
                    if((pcie_addr >> 23) == 0):
                        pcie_addr += 8*1024*1024
                    elif((pcie_addr >> 23) == 1):
                        pcie_addr = pcie_addr - 8*1024*1024 + 4*1024
                        if(pcie_addr == 8*1024*1024):
                            pcie_addr = 0
                elif(enable_tlp_ram == 3):
                    if((pcie_addr >> 22) == 0):
                        pcie_addr += 4*1024*1024
                    elif((pcie_addr >> 22) == 1):
                        pcie_addr = pcie_addr + 4*1024*1024
                    elif((pcie_addr >> 22) == 2):   
                        pcie_addr = pcie_addr - 8*1024*1024 + 4*1024
                        if(pcie_addr == 4*1024*1024):
                            pcie_addr = 0
                else:
                    if((pcie_addr >> 22) == 0):
                        pcie_addr += 4*1024*1024
                    elif((pcie_addr >> 22) == 1):
                        pcie_addr = pcie_addr + 4*1024*1024
                    elif((pcie_addr >> 22) == 2):   
                        pcie_addr = pcie_addr + 4*1024*1024
                    elif((pcie_addr >> 22) == 3):
                        pcie_addr = pcie_addr - 12*1024*1024 + 4*1024
                        if(pcie_addr == 4*1024*1024):
                            pcie_addr = 0

                frame_len =  mem_data[pcie_addr] + mem_data[pcie_addr+1] * 256
                print("frame_len=0x%x" % frame_len)
        #将读取的缓存空间个数和最后的pcie_addr返回函数外部
        return save_num,pcie_addr

    @instance
    def pause_toggle():
        while True:
            if (cq_pause_toggle or cc_pause_toggle or rq_pause_toggle or rc_pause_toggle):
                cq_pause.next = cq_pause_toggle
                cc_pause.next = cc_pause_toggle
                rq_pause.next = rq_pause_toggle
                rc_pause.next = rc_pause_toggle

                yield user_clk.posedge
                yield user_clk.posedge
                yield user_clk.posedge

                cq_pause.next = 0
                cc_pause.next = 0
                rq_pause.next = 0
                rc_pause.next = 0

            yield user_clk.posedge

    #check函数启动DUT的数据发送过程，并检查结构是否正确
    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        rst.next = 1
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        # testbench stimulus

        cur_tag = 1

        max_payload_size.next = 1
        #TLP_RAM使用数量的设置：1,2,4时都使用16MB的内存空间，3时只使用了12MB的内存空间，
        #需要与sim_define.vh文件中的发送帧数相匹配，一次发送帧数不能使TLP的缓存区溢出
        enable_tlp_ram.next = 4
        enable_port.next = 2**PORTS - 1

        yield user_clk.posedge
        #test1进行PCIe设备的枚举操作，保留
        print("test 1: enumeration")
        current_test.next = 1

        yield rc.enumerate(enable_bus_mastering=True)

        yield delay(100)

        yield user_clk.posedge

        #raise StopSimulation
        #test2 解除gen_frame_sim_rst的复位，上行数据开始从tb中的gen_frame_sim模块发出
        print("test 2: PCIe write")
        current_test.next = 2
        gen_frame_sim_rst.next = 0
        print("mem_base=%d" % mem_base)
        pcie_addr = 0x00000000
        #ram_addr = 0x00000000
        #test_data = b'\x11\x22\x33\x44'
        #data_keep = b'\x0f'
        #data_keep = 2**88 -1
        #dma_ram_inst.write_mem(ram_addr, test_data)
        #data = dma_ram_inst.read_mem(ram_addr, 32)
        #for i in range(0, len(data), 16):
        #    print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
        #test_frame1 = axis_ep.AXIStreamFrame(
        #        bytearray(range(88)),
        #        #test_data,
        #        #keep=data_keep,
        #        id=2,
        #        dest=88,
        #        last_cycle_user=1,
        #    )
        #for wait in wait_normal, wait_pause_source:
        #    write_fifo_source.send(test_frame1)
        #    print("write_fifo_source.send(test_frame1) processing")
            #yield user_clk.posedge
            #yield user_clk.posedge
            #yield wait()

        #yield write_desc_status_sink.wait(1000)
        yield delay(50)

        #status = write_desc_status_sink.recv()

        #print("status = %s" % status)

        #assert status.data[0][0] == cur_tag

        #data = mem_data[pcie_addr:pcie_addr+32]
        #for i in range(0, len(data), 16):
        #    print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))

        #assert mem_data[pcie_addr:pcie_addr+len(test_data)] == test_data

        cur_tag = (cur_tag + 1) % 256

        yield delay(100)
        #如果axis_write_desc_cnt（已发送帧数） < target_frame_num（目标接收帧数）则等待
        #print("axis_write_desc_cnt=%d target_frame_num=%d" % (axis_write_desc_cnt , target_frame_num))
        while axis_write_desc_cnt < target_frame_num :
            #print("axis_write_desc_cnt=%d target_frame_num=%d" % (axis_write_desc_cnt , target_frame_num))
            yield user_clk.posedge
            #yield delay(100)
            #yield user_clk.posedge

        yield delay(1000)
        yield user_clk.posedge

        #等到数据发送完成，则将TLP_RAM中的输出写入文件
        copy_num , pcie_addr = copy_mem_to_file(pcie_addr,enable_tlp_ram)
        print("copy_num=%d,pcie_addr=0x%x" % (copy_num,pcie_addr))

        # 打印内存中的数据到屏幕
        #for m in range(0,enable_tlp_ram,1):
        #    if(enable_tlp_ram == 1):
        #        pcie_addr = 0x0000_0000
        #    elif(enable_tlp_ram == 2):
        #        pcie_addr = m * 0x0080_0000
        #    else:
        #        pcie_addr = m * 0x0040_0000
        #    for n in range(0,int(240/enable_tlp_ram),1):
        #        print("pcie_addr=0x%x" % pcie_addr)
        #        data = mem_data[pcie_addr:pcie_addr+1024]
        #        for i in range(0, len(data), 64):
        #            print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+64]))))
        #        pcie_addr += 1024*4

        yield user_clk.posedge
        #final_step.next = 1
        yield user_clk.posedge
        
        #raise StopSimulation
        #如果需要测试发送帧能够正确跨越TLP_RAM的边界，则可次发送数据
        print("test 3: second writes")
        current_test.next = 3
        gen_frame_sim_rst.next = Signal(intbv(-1)[PORTS:])
        yield user_clk.posedge
        yield user_clk.posedge
        gen_frame_sim_rst.next = 0
        yield user_clk.posedge
        yield user_clk.posedge
        
        yield delay(100)
        #如果axis_write_desc_cnt（已发送帧数） < target_frame_num（目标接收帧数）则等待
        #print("axis_write_desc_cnt=%d target_frame_num=%d" % (axis_write_desc_cnt , target_frame_num))
        while axis_write_desc_cnt < target_frame_num :
            #print("axis_write_desc_cnt=%d target_frame_num=%d" % (axis_write_desc_cnt , target_frame_num))
            yield user_clk.posedge
            #yield delay(100)
            #yield user_clk.posedge

        yield delay(1000)
        yield user_clk.posedge

        copy_num , pcie_addr = copy_mem_to_file(pcie_addr,enable_tlp_ram)
        print("copy_num=%d,pcie_addr=0x%x" % (copy_num,pcie_addr))

        yield user_clk.posedge
        final_step.next = 1
        yield user_clk.posedge
        #发出仿真结束的信号
        raise StopSimulation
        #for length in list(range(1,67))+list(range(128-4,128+4))+[1024]:
        #    for pcie_offset in list(range(8,13))+list(range(4096-4,4096+4)):
        #        for ram_offset in list(range(8,137))+list(range(4096-128,4096)):
        #            for pause in [False, True]:
        #                print("length %d, pcie_offset %d, ram_offset %d"% (length, pcie_offset, ram_offset))
        #                #pcie_addr = length * 0x100000000 + pcie_offset * 0x10000 + offset
        #                pcie_addr = pcie_offset
        #                ram_addr = ram_offset
        #                test_data = bytearray([x%256 for x in range(length)])
        #
        #                dma_ram_inst.write_mem(ram_addr & 0xffff80, b'\x55'*(len(test_data)+256))
        #                mem_data[(pcie_addr-1) & 0xffff80:((pcie_addr-1) & 0xffff80)+len(test_data)+256] = b'\xaa'*(len(test_data)+256)
        #                dma_ram_inst.write_mem(ram_addr, test_data) 
        #
        #                data = dma_ram_inst.read_mem(ram_addr&0xfffff0, 64)
        #                for i in range(0, len(data), 16):
        #                    print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
        #
        #                rq_pause_toggle.next = pause
        #
        #                write_desc_source.send([(mem_base+pcie_addr, 0, ram_addr, len(test_data), cur_tag)])
        #
        #                yield write_desc_status_sink.wait(4000)
        #                yield delay(50)
        #
        #                rq_pause_toggle.next = 0
        #
        #                status = write_desc_status_sink.recv()
        #
        #                print(status)
        #
        #                assert status.data[0][0] == cur_tag
        #
        #                data = mem_data[pcie_addr&0xfffff0:(pcie_addr&0xfffff0)+64]
        #                for i in range(0, len(data), 16):
        #                    print(" ".join(("{:02x}".format(c) for c in bytearray(data[i:i+16]))))
        #
        #                print(mem_data[pcie_addr-1:pcie_addr+len(test_data)+1])
        #                assert mem_data[pcie_addr-1:pcie_addr+len(test_data)+1] == b'\xaa'+test_data+b'\xaa'
        #
        #                cur_tag = (cur_tag + 1) % 256
        #
        #                yield delay(100)
        #
        #raise StopSimulation

    return instances()

#运行仿真的函数
def test_bench():
    sim = Simulation(bench())
    #sim.config_sim(trace=True)
    sim.run()

#程序入口，test_bench运行结束，则比较收发文件是否正确，给出比较结果
if __name__ == '__main__':
    os.system("rm -rf pcie_recv_frame.dat")
    print("Running test...")
    test_bench()
    os.system("wc -l msg_output_all.dat")
    os.system("wc -l pcie_recv_frame.dat")
    if os.system("diff msg_output_all.dat pcie_recv_frame.dat"):
        raise Exception("Error running diff")
    else:
        print("diff pass!")

