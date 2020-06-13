module  reg_delay #
 (parameter [4:0]  DELAY_CNT = 4'd3,
  parameter  REG_WIDTH = 8
 )
 ( clk ,
   rst_n,
   reg_in,
   reg_out
 );
 input clk , rst_n ;

input    [REG_WIDTH-1:0]    reg_in  ;
output   [REG_WIDTH-1:0]    reg_out ;

reg      [REG_WIDTH-1:0]    reg_out ;

/////////////////////////
reg     [REG_WIDTH-1:0]    reg_in_dly01  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly02  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly03  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly04  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly05  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly06  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly07  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly08  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly09  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0a  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0b  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0c  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0d  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0e  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly0f  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly10  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly11  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly12  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly13  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly14  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly15  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly16  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly17  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly18  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly19  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1a  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1b  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1c  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1d  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1e  = 'd0 ;
reg     [REG_WIDTH-1:0]    reg_in_dly1f  = 'd0 ;




//always @ (posedge clk or negedge rst_n)
always @ (posedge clk )
begin
  // if (~rst_n)  begin
  //    reg_in_dly01  <=  'd0  ; 
  //    reg_in_dly02  <=  'd0  ;
  //    reg_in_dly03  <=  'd0  ;
  //    reg_in_dly04  <=  'd0  ;
  //    reg_in_dly05  <=  'd0  ;
  //    reg_in_dly06  <=  'd0  ;
  //    reg_in_dly07  <=  'd0  ;
  //    reg_in_dly08  <=  'd0  ;
  //    reg_in_dly09  <=  'd0  ; 
  //    reg_in_dly0a  <=  'd0  ;
  //    reg_in_dly0b  <=  'd0  ;
  //    reg_in_dly0c  <=  'd0  ;
  //    reg_in_dly0d  <=  'd0  ;
  //    reg_in_dly0e  <=  'd0  ;
  //    reg_in_dly0f  <=  'd0  ;
  //    reg_in_dly10  <=  'd0  ;
  //    reg_in_dly11  <=  'd0  ;
  //    reg_in_dly12  <=  'd0  ;
  //    reg_in_dly13  <=  'd0  ;
  //    reg_in_dly14  <=  'd0  ;
  //    reg_in_dly15  <=  'd0  ;
  //    reg_in_dly16  <=  'd0  ;
  //    reg_in_dly17  <=  'd0  ;
  //    reg_in_dly18  <=  'd0  ;
  //    reg_in_dly19  <=  'd0  ;
  //    reg_in_dly1a  <=  'd0  ;
  //    reg_in_dly1b  <=  'd0  ;
  //    reg_in_dly1c  <=  'd0  ;
  //    reg_in_dly1d  <=  'd0  ;
  //    reg_in_dly1e  <=  'd0  ;
  //    reg_in_dly1f  <=  'd0  ;
  // end
  // else begin
      reg_in_dly01  <=  reg_in      ; 
      reg_in_dly02  <=  reg_in_dly01 ; 
      reg_in_dly03  <=  reg_in_dly02 ;
      reg_in_dly04  <=  reg_in_dly03 ;
      reg_in_dly05  <=  reg_in_dly04 ;
      reg_in_dly06  <=  reg_in_dly05 ;
      reg_in_dly07  <=  reg_in_dly06 ;
      reg_in_dly08  <=  reg_in_dly07 ;
      reg_in_dly09  <=  reg_in_dly08  ; 
      reg_in_dly0a  <=  reg_in_dly09  ;
      reg_in_dly0b  <=  reg_in_dly0a  ;
      reg_in_dly0c  <=  reg_in_dly0b  ;
      reg_in_dly0d  <=  reg_in_dly0c  ;
      reg_in_dly0e  <=  reg_in_dly0d  ;
      reg_in_dly0f  <=  reg_in_dly0e  ;
      reg_in_dly10  <=  reg_in_dly0f  ;
      reg_in_dly11  <=  reg_in_dly10  ;
      reg_in_dly12  <=  reg_in_dly11  ;
      reg_in_dly13  <=  reg_in_dly12  ;
      reg_in_dly14  <=  reg_in_dly13  ;
      reg_in_dly15  <=  reg_in_dly14  ;
      reg_in_dly16  <=  reg_in_dly15  ;
      reg_in_dly17  <=  reg_in_dly16  ;
      reg_in_dly18  <=  reg_in_dly17  ;
      reg_in_dly19  <=  reg_in_dly18  ;
      reg_in_dly1a  <=  reg_in_dly19  ;
      reg_in_dly1b  <=  reg_in_dly1a  ;
      reg_in_dly1c  <=  reg_in_dly1b  ;
      reg_in_dly1d  <=  reg_in_dly1c  ;
      reg_in_dly1e  <=  reg_in_dly1d  ;
      reg_in_dly1f  <=  reg_in_dly1e  ;
  // end
end


always @ ( * )
begin
    case (DELAY_CNT) 
     5'h00    :  reg_out  =  reg_in      ; 
     5'h01    :  reg_out  =  reg_in_dly01 ;
     5'h02    :  reg_out  =  reg_in_dly02 ;
     5'h03    :  reg_out  =  reg_in_dly03 ;
     5'h04    :  reg_out  =  reg_in_dly04 ;
     5'h05    :  reg_out  =  reg_in_dly05 ;
     5'h06    :  reg_out  =  reg_in_dly06 ;
     5'h07    :  reg_out  =  reg_in_dly07  ;    
     5'h08    :  reg_out  =  reg_in_dly08  ;
     5'h09    :  reg_out  =  reg_in_dly09  ;
     5'h0a    :  reg_out  =  reg_in_dly0a  ;
     5'h0b    :  reg_out  =  reg_in_dly0b  ;
     5'h0c    :  reg_out  =  reg_in_dly0c  ;
     5'h0d    :  reg_out  =  reg_in_dly0d  ;
     5'h0e    :  reg_out  =  reg_in_dly0e  ;
     5'h0f    :  reg_out  =  reg_in_dly0f  ;
     5'h10    :  reg_out  =  reg_in_dly10  ;
     5'h11    :  reg_out  =  reg_in_dly11  ;
     5'h12    :  reg_out  =  reg_in_dly12  ;
     5'h13    :  reg_out  =  reg_in_dly13  ;
     5'h14    :  reg_out  =  reg_in_dly14  ;
     5'h15    :  reg_out  =  reg_in_dly15  ;
     5'h16    :  reg_out  =  reg_in_dly16  ;
     5'h17    :  reg_out  =  reg_in_dly17  ;
     5'h18    :  reg_out  =  reg_in_dly18  ;
     5'h19    :  reg_out  =  reg_in_dly19  ;
     5'h1a    :  reg_out  =  reg_in_dly1a  ;
     5'h1b    :  reg_out  =  reg_in_dly1b  ;
     5'h1c    :  reg_out  =  reg_in_dly1c  ;
     5'h1d    :  reg_out  =  reg_in_dly1d  ;
     5'h1e    :  reg_out  =  reg_in_dly1e  ;
     //5'h1f  :  reg_out  =  reg_in_dly1f  ;
     default  :  reg_out  =  reg_in_dly1f ;
    endcase  
end



endmodule



