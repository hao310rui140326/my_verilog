`timescale 1ns / 1ps

module tx_sys (
    input  wire                     clk,
    input  wire                     rst_n,

    output reg          wen   ,
    output reg          ren   ,
    output reg   [63:0] wdin  ,
    output reg   [63:0] addr  ,
    input  wire  [63:0] rdout 

);

reg    [3:0]  write_cnt  ;
always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		write_cnt      <=  'd0       ;
	end
	else   begin
		write_cnt      <=  write_cnt + 'd1         ;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		wen            <=  'd0       ;
		ren            <=  'd0       ;
	end
	else   begin
		wen            <=  (write_cnt==4'd10 ) ;
		ren            <=  (write_cnt==4'd15 ) ;
	end
end
always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		addr           <=  'd0       ;
		wdin           <=  'd0       ;
	end
	else  if ((write_cnt==4'd10 ) )  begin
		addr            <=  {$random}%4294967295;
		wdin           <=   {$random}%4294967295;
	end
end


endmodule

