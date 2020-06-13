/*

Copyright (c) 2015-2016 haorui

email:hao310rui@163.com

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
 * Content Addressable Memory (block RAM based)
 */
module com_inline #(
    // compare data bus width
    parameter DATA_WIDTH = 32,
    // compare data count
    parameter DATA_CNT   = 1024,
    parameter COM_STYLE = "UP"	    
)
(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire [DATA_WIDTH-1:0]    write_data[DATA_CNT-1:0]  ,
    input  wire                     write_en                  ,
    output reg                      compare_en                ,
    output reg  [DATA_WIDTH-1:0]    compare_data[DATA_CNT-1:0]
);

// iter number of slices 
localparam ITER_NUM   = $clog2(DATA_CNT);
localparam ITER_WIDTH = $clog2(ITER_NUM);

//reg     [DATA_WIDTH*DATA_CNT*(ITER_NUM+1)-1:0]    wr_data ;
reg     [DATA_WIDTH*DATA_CNT-1:0]                 wr_data     ;
reg     [DATA_WIDTH*DATA_CNT-1:0]                 wr_data_reg ;
wire    [DATA_WIDTH*DATA_CNT*ITER_NUM-1:0]        com_data    ;
wire    [DATA_WIDTH*DATA_CNT*ITER_NUM-1:0]        trans_data  ;
reg     [DATA_WIDTH*DATA_CNT*ITER_NUM-1:0]        rece_data   ;

reg     [DATA_WIDTH*DATA_CNT-1:0]                 itrans_data      ;
wire    [DATA_WIDTH*DATA_CNT-1:0]                 irece_data       ;

reg     [ITER_NUM-1:0]                            iter_en      ;
reg     [ITER_WIDTH-1:0]                          iter_cnt     ;

integer ii;
integer jj;
always @ (*)
begin
	for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
		wr_data_reg[ii*DATA_WIDTH+:DATA_WIDTH]      =  write_data[ii]       ;
		compare_data[ii]                            =  wr_data[ii*DATA_WIDTH+:DATA_WIDTH];
	end
end
always @ (*)
begin
	//if (iter_en=='d0) begin 
	//	itrans_data = 'd0 ;
	//end
	//else begin 
	//	for(jj=0;jj<ITER_NUM;jj=jj+1) begin  : itrans
	//		if (iter_en[jj])  begin 
	//			itrans_data =  trans_data[jj*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT] ;
	//			disable itrans;
	//		end
	//		//else                    itrans_data =  itrans_data_reg ;
	//	end
	//end
	itrans_data =  trans_data[iter_cnt*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT] ;
end

always @ (*)
begin
		for(jj=0;jj<ITER_NUM;jj=jj+1) begin  
			rece_data[jj*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT] = irece_data ; 
		end
end

//assign  wr_data[DATA_WIDTH*DATA_CNT-1:0] =  wr_data_reg ;
always @ (posedge clk )
begin
	if (write_en)   wr_data[DATA_WIDTH*DATA_CNT-1:0] <= wr_data_reg ;
	else   begin    
		for(ii=0;ii<ITER_NUM;ii=ii+1) begin 
			if (iter_en[ii])   wr_data <=  com_data[ii*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT] ;
		end     	
	end
end

always @ (posedge clk or negedge rst_n )
begin
	if (~rst_n)  begin 
	      	iter_en   <=  'd0 ;
	end
	else if (write_en)  begin          
		iter_en	 <=  'd1 ; 
	end
	else begin 
		iter_en	 <=   ( iter_en << 1 ); 
	end
end

always @ (posedge clk or negedge rst_n )
begin
	if (~rst_n)  begin 
	      	compare_en   <=  'd0 ;
	end
	else begin 
		compare_en	 <=   iter_en[ITER_NUM-1] ; 
	end
end

//iter_cnt
always @ (posedge clk or negedge rst_n )
begin
	if (~rst_n)  begin 
	      	iter_cnt   <=  'd0 ;
	end
	else if (write_en)  begin          
		iter_cnt	 <=  'd0 ; 
	end
	else if (|iter_en) begin 
		iter_cnt	 <=   iter_cnt + 1'd1 ; 
	end
end


genvar iter_ind;
generate
    for (iter_ind = 0; iter_ind < ITER_NUM; iter_ind = iter_ind + 1) begin : iter 
        localparam GROUP = 2**iter_ind    ;
        localparam GSTEP = DATA_CNT/GROUP ;
        localparam NUM   = GSTEP/2        ;
        localparam STEP  = GSTEP/2        ;

	iter_inline #(
    		.DATA_WIDTH (DATA_WIDTH)     ,
    		.DATA_CNT   (DATA_CNT  )     ,
   		.COM_STYLE  (COM_STYLE )     ,		
		.GROUP      (GROUP     )     ,
        	.GSTEP      (GSTEP     )     ,
        	.NUM        (NUM       )     ,
        	.STEP       (STEP      )     
	) u_iter_inline(
    		.clk                   (clk         )    ,
    		.rst_n                 (rst_n       )    ,

		.trans_data            (trans_data[iter_ind*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT]     )    ,
    		.rece_data             (rece_data[iter_ind*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT]      )    ,   

    		.write_data            (wr_data                                                     )    ,
    		.compare_data          (com_data[iter_ind*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT] )    
	);
    end
endgenerate

			genvar com_ind;
			generate
    				for (com_ind = 0; com_ind < DATA_CNT/2; com_ind = com_ind + 1) begin : com
					com_logic  #(.DATA_WIDTH(DATA_WIDTH) ,.COM_STYLE(COM_STYLE) )
						u_com_logic(
					    		.write_data0   (itrans_data[com_ind*DATA_WIDTH*2+:DATA_WIDTH]          ) ,
					    		.write_data1   (itrans_data[(com_ind*2+1)*DATA_WIDTH+:DATA_WIDTH]      ) ,
					    		.compare_data0 (irece_data[com_ind*DATA_WIDTH*2+:DATA_WIDTH]           ) ,
					    		.compare_data1 (irece_data[(com_ind*2+1)*DATA_WIDTH+:DATA_WIDTH]       ) 
						);
    				end
			endgenerate



endmodule

