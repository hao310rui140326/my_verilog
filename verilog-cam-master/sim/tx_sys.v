`timescale 1ns / 1ps

module tx_sys #(
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

    output  wire  [ADDR_WIDTH-1:0]    write_addr,
    output  wire  [DATA_WIDTH-1:0]    write_data,
    output  reg                      write_delete,
    output  wire                      write_enable,
    input   wire                     write_busy,

    output  reg  [DATA_WIDTH-1:0]    compare_data,
    input   wire [2**ADDR_WIDTH-1:0] match_many,
    input   wire [2**ADDR_WIDTH-1:0] match_single,
    input   wire [ADDR_WIDTH-1:0]    match_addr,
    input   wire                     match
);


reg      [31:0]   write_cnt   ;
reg               write_enable_reg ;
always@(posedge clk or posedge rst)
begin
	if (rst) begin 
                write_enable_reg  <=  'd0  ;
	end
	else if (write_cnt<='d511)   begin 
                write_enable_reg  <=  'd1  ;		
	end
	else if ((write_cnt>='d511)&&~write_busy ) begin 
                write_enable_reg  <=  'd0  ;		
	end
end
assign  write_enable = write_enable_reg&&~write_busy ;

always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		write_cnt     <=  'd0  ; 
	end
	else if (write_cnt<='d32768)   begin 
                write_cnt     <=  ~write_busy  ?    write_cnt + 'd1  :  write_cnt ;		
	end
end

      reg  [ADDR_WIDTH-1:0]    write_addr_pre;
      reg  [DATA_WIDTH-1:0]    write_data_pre;

      
      reg  [ADDR_WIDTH-1:0]    write_addr_pre2;
      reg  [DATA_WIDTH-1:0]    write_data_pre2;


always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		write_addr_pre    <=  'd0  ;   
		write_data_pre    <=  'd0  ;
                write_delete  <=  'd0  ;
	end
	else if (write_enable)   begin 
		write_addr_pre    <=  ~write_busy ?  write_addr_pre   + 'd1  :  write_addr_pre;   
		write_data_pre    <=  ~write_busy ?  write_data_pre   + 'd1  :  write_data_pre;
	end
end
always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		write_addr_pre2    <=  'd0  ;   
		write_data_pre2    <=  'd0  ;
	end
	else  if (write_enable)  begin 
		write_addr_pre2    <=    write_addr_pre;   
		write_data_pre2    <=    write_data_pre;
	end
end

assign  write_addr = write_enable ?  write_addr_pre :  write_addr_pre2 ;
assign  write_data = write_enable ?  write_data_pre :  write_data_pre2 ;



always@(posedge clk or posedge rst)
begin
	if (rst) begin 
		compare_data    <=  'd1024  ;   
	end
	else if (write_cnt=='d1024)   begin 
		compare_data    <=   'd1  ;   
	end
	else if ( (write_cnt>'d1024)  && ( &write_cnt[1:0] ) ) begin 
		compare_data[8:0]    <=   compare_data[8:0] + 'd1  ;   
	end
end




















endmodule

