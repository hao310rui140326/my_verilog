`timescale 1ns / 1ps

module tx_sys #(
    // compare data bus width
    parameter DATA_WIDTH = 64,
    // compare data count
    parameter DATA_CNT   = 1024,
    parameter COM_STYLE = "UP"	    
)
(
    input  wire                     clk,
    input  wire                     rst_n,

    output  reg                       write_en,   
    input   reg                       compare_en                ,    
    output  reg   [DATA_WIDTH-1:0]    write_data[DATA_CNT-1:0]  ,
    input   wire  [DATA_WIDTH-1:0]    compare_data[DATA_CNT-1:0]

);

integer  ii ;
always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
	  for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
	  	write_data[ii][DATA_WIDTH-1:0]      <=  'd0       ;
	  end
	end
	else   begin 
	  for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
	  	write_data[ii][DATA_WIDTH-1:0]      <= ii       ;
	  end
	end
end


reg    [3:0]  write_cnt  ;
always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		write_cnt      <=  'd0       ;
		write_en       <=  'd0       ;
	end
	else   begin
		write_cnt      <=  write_cnt + 'd1         ;
		write_en       <=  (write_cnt=='d15)       ;
	end
end



//integer  ii ;
//always@ ( * )
//begin
//	for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
//		write_data[ii][DATA_WIDTH-1:0]      =  ii       ;
//	end
//end

endmodule

