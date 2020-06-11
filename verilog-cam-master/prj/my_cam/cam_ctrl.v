`timescale 1ns / 1ps

module cam_ctrl #(
    // search data bus width
    parameter DATA_WIDTH = 64,
    // memory size in log2(words)
    parameter ADDR_WIDTH = 5,
    // CAM style (SRL, BRAM)
    parameter CAM_STYLE = "BRAM",
    // width of data bus slices
    parameter SLICE_WIDTH = 4
)
(
    input  wire                     clk,
    input  wire                     rst,

    output  reg  [ADDR_WIDTH-1:0]    write_addr,
    output  reg  [DATA_WIDTH-1:0]    write_data,
    output  reg                      write_delete,
    output  reg                      write_enable,
    input   wire                     write_busy,

    output  reg  [DATA_WIDTH-1:0]    compare_data,
    input   wire   [2**ADDR_WIDTH-1:0] match_many,
    input   wire   [2**ADDR_WIDTH-1:0] match_single,
    input   wire   [ADDR_WIDTH-1:0]    match_addr,
    input   wire                       match   ,


    input wire   [ADDR_WIDTH-1:0]    write_addr_wire,
    input wire   [DATA_WIDTH-1:0]    write_data_wire,
    input wire                       write_delete_wire,
    input wire                       write_enable_wire,
    output   reg                     write_busy_reg,

    input   wire   [DATA_WIDTH-1:0]    compare_data_wire,

//    output  reg    [2**ADDR_WIDTH-1:0] match_many_reg,
//    output  reg    [2**ADDR_WIDTH-1:0] match_single_reg,
    output  reg    [ADDR_WIDTH-1:0]    match_addr_reg,
    output  reg                        match_reg


);

always@(posedge clk or posedge rst)
begin
	if (rst) begin 
                write_busy_reg   <=  'd0  ;
	end
	else  begin 
                write_busy_reg  <=  write_busy ;		
	end
end

always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		write_addr    <=  'd0  ;   
		write_data    <=  'd0  ;
                write_delete  <=  'd0  ;
                write_enable  <=  'd0  ;
	end
	else  begin 
		write_addr    <=  write_addr_wire  ;   
		write_data    <=  write_data_wire  ;
                write_delete  <=  write_delete_wire;
                write_enable  <=  write_enable_wire ;		
	end
end

always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		compare_data    <=  'd1024  ;  
	        match_addr_reg  <=  'd0 ;
       	        match_reg       <=  'd0 ;		       
	end
	else begin 
		compare_data   <=   compare_data_wire  ;   
		match_addr_reg  <=  match_addr ;
       	        match_reg       <=  match ;
	end
end




endmodule

