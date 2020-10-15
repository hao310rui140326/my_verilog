#!/usr/bin/env python
"""

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

"""

from myhdl import *
import os
import struct

import pcie
import pcie_us

module = 'fpga_core'
testbench = 'test_%s' % module

srcs = []

#srcs.append("%s.v" % testbench)
srcs.append("../rtl/%s.v" % module)
srcs.append("../rtl/axi_ram.v")
srcs.append("../rtl/axis_register.v")
srcs.append("../lib/pcie/rtl/axis_arb_mux.v")
srcs.append("../lib/pcie/rtl/pcie_us_axil_master.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma_rd.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_dma_wr.v")
srcs.append("../lib/pcie/rtl/pcie_tag_manager.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master_rd.v")
srcs.append("../lib/pcie/rtl/pcie_us_axi_master_wr.v")
srcs.append("../lib/pcie/rtl/pcie_us_axis_cq_demux.v")
srcs.append("../lib/pcie/rtl/pcie_us_cfg.v")
srcs.append("../lib/pcie/rtl/pcie_us_msi.v")
srcs.append("../lib/pcie/rtl/arbiter.v")
srcs.append("../lib/pcie/rtl/priority_encoder.v")
srcs.append("../lib/pcie/rtl/pulse_merge.v")
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "verilator --cc -Wno-WIDTH -Wno-SELRANGE --top-module %s  %s" % (testbench, src)

os.system(build_cmd)
