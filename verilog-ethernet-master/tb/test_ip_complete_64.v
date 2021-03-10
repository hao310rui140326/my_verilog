/*

Copyright (c) 2014-2018 Alex Forencich

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
 * Testbench for ip_complete_64
 */
module test_ip_complete_64;

// Parameters
parameter ARP_CACHE_ADDR_WIDTH = 2;
parameter ARP_REQUEST_RETRY_COUNT = 4;
parameter ARP_REQUEST_RETRY_INTERVAL = 150;
parameter ARP_REQUEST_TIMEOUT = 400;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg s_eth_hdr_valid = 0;
reg [47:0] s_eth_dest_mac = 0;
reg [47:0] s_eth_src_mac = 0;
reg [15:0] s_eth_type = 0;
reg [63:0] s_eth_payload_axis_tdata = 0;
reg [7:0] s_eth_payload_axis_tkeep = 0;
reg s_eth_payload_axis_tvalid = 0;
reg s_eth_payload_axis_tlast = 0;
reg s_eth_payload_axis_tuser = 0;
reg arp_response_valid = 0;
reg arp_response_error = 0;
reg [47:0] arp_response_mac = 0;
reg s_ip_hdr_valid = 0;
reg [5:0] s_ip_dscp = 0;
reg [1:0] s_ip_ecn = 0;
reg [15:0] s_ip_length = 0;
reg [7:0] s_ip_ttl = 0;
reg [7:0] s_ip_protocol = 0;
reg [31:0] s_ip_source_ip = 0;
reg [31:0] s_ip_dest_ip = 0;
reg [63:0] s_ip_payload_axis_tdata = 0;
reg [7:0] s_ip_payload_axis_tkeep = 0;
reg s_ip_payload_axis_tvalid = 0;
reg s_ip_payload_axis_tlast = 0;
reg s_ip_payload_axis_tuser = 0;
reg m_eth_hdr_ready = 0;
reg m_eth_payload_axis_tready = 0;
reg m_ip_hdr_ready = 0;
reg m_ip_payload_axis_tready = 0;
reg [47:0] local_mac = 0;
reg [31:0] local_ip = 0;
reg [31:0] gateway_ip = 0;
reg [31:0] subnet_mask = 0;
reg clear_arp_cache = 0;

// Outputs
wire s_eth_hdr_ready;
wire s_eth_payload_axis_tready;
wire s_ip_hdr_ready;
wire s_ip_payload_axis_tready;
wire m_eth_hdr_valid;
wire [47:0] m_eth_dest_mac;
wire [47:0] m_eth_src_mac;
wire [15:0] m_eth_type;
wire [63:0] m_eth_payload_axis_tdata;
wire [7:0] m_eth_payload_axis_tkeep;
wire m_eth_payload_axis_tvalid;
wire m_eth_payload_axis_tlast;
wire m_eth_payload_axis_tuser;
wire arp_request_valid;
wire [31:0] arp_request_ip;
wire m_ip_hdr_valid;
wire [47:0] m_ip_eth_dest_mac;
wire [47:0] m_ip_eth_src_mac;
wire [15:0] m_ip_eth_type;
wire [3:0] m_ip_version;
wire [3:0] m_ip_ihl;
wire [5:0] m_ip_dscp;
wire [1:0] m_ip_ecn;
wire [15:0] m_ip_length;
wire [15:0] m_ip_identification;
wire [2:0] m_ip_flags;
wire [12:0] m_ip_fragment_offset;
wire [7:0] m_ip_ttl;
wire [7:0] m_ip_protocol;
wire [15:0] m_ip_header_checksum;
wire [31:0] m_ip_source_ip;
wire [31:0] m_ip_dest_ip;
wire [63:0] m_ip_payload_axis_tdata;
wire [7:0] m_ip_payload_axis_tkeep;
wire m_ip_payload_axis_tvalid;
wire m_ip_payload_axis_tlast;
wire m_ip_payload_axis_tuser;
wire rx_busy;
wire tx_busy;
wire rx_error_header_early_termination;
wire rx_error_payload_early_termination;
wire rx_error_invalid_header;
wire rx_error_invalid_checksum;
wire tx_error_payload_early_termination;
wire tx_error_arp_failed;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
        s_eth_hdr_valid,
        s_eth_dest_mac,
        s_eth_src_mac,
        s_eth_type,
        s_eth_payload_axis_tdata,
        s_eth_payload_axis_tkeep,
        s_eth_payload_axis_tvalid,
        s_eth_payload_axis_tlast,
        s_eth_payload_axis_tuser,
        s_ip_hdr_valid,
        s_ip_dscp,
        s_ip_ecn,
        s_ip_length,
        s_ip_ttl,
        s_ip_protocol,
        s_ip_source_ip,
        s_ip_dest_ip,
        s_ip_payload_axis_tdata,
        s_ip_payload_axis_tkeep,
        s_ip_payload_axis_tvalid,
        s_ip_payload_axis_tlast,
        s_ip_payload_axis_tuser,
        m_eth_hdr_ready,
        m_eth_payload_axis_tready,
        m_ip_hdr_ready,
        m_ip_payload_axis_tready,
        local_mac,
        local_ip,
        gateway_ip,
        subnet_mask,
        clear_arp_cache
    );
    $to_myhdl(
        s_eth_hdr_ready,
        s_eth_payload_axis_tready,
        s_ip_hdr_ready,
        s_ip_payload_axis_tready,
        m_eth_hdr_valid,
        m_eth_dest_mac,
        m_eth_src_mac,
        m_eth_type,
        m_eth_payload_axis_tdata,
        m_eth_payload_axis_tkeep,
        m_eth_payload_axis_tvalid,
        m_eth_payload_axis_tlast,
        m_eth_payload_axis_tuser,
        m_ip_hdr_valid,
        m_ip_eth_dest_mac,
        m_ip_eth_src_mac,
        m_ip_eth_type,
        m_ip_version,
        m_ip_ihl,
        m_ip_dscp,
        m_ip_ecn,
        m_ip_length,
        m_ip_identification,
        m_ip_flags,
        m_ip_fragment_offset,
        m_ip_ttl,
        m_ip_protocol,
        m_ip_header_checksum,
        m_ip_source_ip,
        m_ip_dest_ip,
        m_ip_payload_axis_tdata,
        m_ip_payload_axis_tkeep,
        m_ip_payload_axis_tvalid,
        m_ip_payload_axis_tlast,
        m_ip_payload_axis_tuser,
        rx_busy,
        tx_busy,
        rx_error_header_early_termination,
        rx_error_payload_early_termination,
        rx_error_invalid_header,
        rx_error_invalid_checksum,
        tx_error_payload_early_termination,
        tx_error_arp_failed
    );

    // dump file
    $dumpfile("test_ip_complete_64.lxt");
    $dumpvars(0, test_ip_complete_64);
end

ip_complete_64 #(
    .ARP_CACHE_ADDR_WIDTH(ARP_CACHE_ADDR_WIDTH),
    .ARP_REQUEST_RETRY_COUNT(ARP_REQUEST_RETRY_COUNT),
    .ARP_REQUEST_RETRY_INTERVAL(ARP_REQUEST_RETRY_INTERVAL),
    .ARP_REQUEST_TIMEOUT(ARP_REQUEST_TIMEOUT)
)
UUT (
    .clk(clk),
    .rst(rst),
    // Ethernet frame input
    .s_eth_hdr_valid(s_eth_hdr_valid),
    .s_eth_hdr_ready(s_eth_hdr_ready),
    .s_eth_dest_mac(s_eth_dest_mac),
    .s_eth_src_mac(s_eth_src_mac),
    .s_eth_type(s_eth_type),
    .s_eth_payload_axis_tdata(s_eth_payload_axis_tdata),
    .s_eth_payload_axis_tkeep(s_eth_payload_axis_tkeep),
    .s_eth_payload_axis_tvalid(s_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready(s_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast(s_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser(s_eth_payload_axis_tuser),
    // Ethernet frame output
    .m_eth_hdr_valid(m_eth_hdr_valid),
    .m_eth_hdr_ready(m_eth_hdr_ready),
    .m_eth_dest_mac(m_eth_dest_mac),
    .m_eth_src_mac(m_eth_src_mac),
    .m_eth_type(m_eth_type),
    .m_eth_payload_axis_tdata(m_eth_payload_axis_tdata),
    .m_eth_payload_axis_tkeep(m_eth_payload_axis_tkeep),
    .m_eth_payload_axis_tvalid(m_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready(m_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast(m_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser(m_eth_payload_axis_tuser),
    // IP frame input
    .s_ip_hdr_valid(s_ip_hdr_valid),
    .s_ip_hdr_ready(s_ip_hdr_ready),
    .s_ip_dscp(s_ip_dscp),
    .s_ip_ecn(s_ip_ecn),
    .s_ip_length(s_ip_length),
    .s_ip_ttl(s_ip_ttl),
    .s_ip_protocol(s_ip_protocol),
    .s_ip_source_ip(s_ip_source_ip),
    .s_ip_dest_ip(s_ip_dest_ip),
    .s_ip_payload_axis_tdata(s_ip_payload_axis_tdata),
    .s_ip_payload_axis_tkeep(s_ip_payload_axis_tkeep),
    .s_ip_payload_axis_tvalid(s_ip_payload_axis_tvalid),
    .s_ip_payload_axis_tready(s_ip_payload_axis_tready),
    .s_ip_payload_axis_tlast(s_ip_payload_axis_tlast),
    .s_ip_payload_axis_tuser(s_ip_payload_axis_tuser),
    // IP frame output
    .m_ip_hdr_valid(m_ip_hdr_valid),
    .m_ip_hdr_ready(m_ip_hdr_ready),
    .m_ip_eth_dest_mac(m_ip_eth_dest_mac),
    .m_ip_eth_src_mac(m_ip_eth_src_mac),
    .m_ip_eth_type(m_ip_eth_type),
    .m_ip_version(m_ip_version),
    .m_ip_ihl(m_ip_ihl),
    .m_ip_dscp(m_ip_dscp),
    .m_ip_ecn(m_ip_ecn),
    .m_ip_length(m_ip_length),
    .m_ip_identification(m_ip_identification),
    .m_ip_flags(m_ip_flags),
    .m_ip_fragment_offset(m_ip_fragment_offset),
    .m_ip_ttl(m_ip_ttl),
    .m_ip_protocol(m_ip_protocol),
    .m_ip_header_checksum(m_ip_header_checksum),
    .m_ip_source_ip(m_ip_source_ip),
    .m_ip_dest_ip(m_ip_dest_ip),
    .m_ip_payload_axis_tdata(m_ip_payload_axis_tdata),
    .m_ip_payload_axis_tkeep(m_ip_payload_axis_tkeep),
    .m_ip_payload_axis_tvalid(m_ip_payload_axis_tvalid),
    .m_ip_payload_axis_tready(m_ip_payload_axis_tready),
    .m_ip_payload_axis_tlast(m_ip_payload_axis_tlast),
    .m_ip_payload_axis_tuser(m_ip_payload_axis_tuser),
    // Status signals
    .rx_busy(rx_busy),
    .tx_busy(tx_busy),
    .rx_error_header_early_termination(rx_error_header_early_termination),
    .rx_error_payload_early_termination(rx_error_payload_early_termination),
    .rx_error_invalid_header(rx_error_invalid_header),
    .rx_error_invalid_checksum(rx_error_invalid_checksum),
    .tx_error_payload_early_termination(tx_error_payload_early_termination),
    .tx_error_arp_failed(tx_error_arp_failed),
    // Configuration
    .local_mac(local_mac),
    .local_ip(local_ip),
    .gateway_ip(gateway_ip),
    .subnet_mask(subnet_mask),
    .clear_arp_cache(clear_arp_cache)
);

endmodule
