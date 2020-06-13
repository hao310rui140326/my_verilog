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
module com_pipline #(
    // compare data bus width
    parameter DATA_WIDTH = 32,
    // compare data count
    parameter DATA_CNT   = 1024,
    parameter COM_STYLE = "UP"	    
)
(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire [DATA_WIDTH-1:0]    write_data[DATA_CNT-1:0]   ,
    input  wire                     write_en                   ,   
    output reg                      compare_en                ,    
    output reg  [DATA_WIDTH-1:0]    compare_data[DATA_CNT-1:0] 
);

// iter number of slices 
localparam ITER_NUM = $clog2(DATA_CNT);

wire    [DATA_WIDTH*DATA_CNT*(ITER_NUM+1)-1:0]    wr_data ;
reg     [DATA_WIDTH*DATA_CNT*ITER_NUM-1:0]        wr_data_reg ;

reg     [ITER_NUM-1:0]                            iter_en      ;

//reg     [DATA_WIDTH-1:0]    wr_data[ITER_NUM:0][DATA_CNT-1:0] ;
//wire  [DATA_WIDTH-1:0]    com_data[ITER_NUM-1:0][DATA_CNT-1:0];

//genvar iter_ind;
//generate
//    for (iter_ind = 0; iter_ind < ITER_NUM; iter_ind = iter_ind + 1) begin : iter 
//        localparam GROUP = 2**iter_ind    ;
//        localparam GSTEP = DATA_CNT/GROUP ;
//        localparam NUM   = GSTEP/2        ;
//        localparam STEP  = GSTEP/2        ;
//	genvar group_ind;
//	generate
//    		for (group_ind = 0; group_ind < GROUP; group_ind = group_ind + 1) begin : group
//			genvar step_ind;
//			generate
//    				for (step_ind = 0; step_ind < STEP; step_ind = step_ind + 1) begin : step
//					com_logic_reg #(.DATA_WIDTH(DATA_WIDTH) ,.COM_STYLE(COM_STYLE) )
//						u_com_logic(
//							.clk           (clk             ) ,
//							.rst_n         (rst_n           ) ,
//					    		.write_data0   (wr_data[iter_ind][GSTEP*group_ind+step_ind]          ) ,
//					    		.write_data1   (wr_data[iter_ind][GSTEP*group_ind+step_ind+STEP]     ) ,
//					    		.compare_data0 (com_data[iter_ind][GSTEP*group_ind+step_ind]         ) ,
//					    		.compare_data1 (com_data[iter_ind][GSTEP*group_ind+step_ind+STEP]    ) 
//						);
//    				end
//			endgenerate
//    		end
//	endgenerate
//    end
//endgenerate

//assign  wr_data[0]  =  write_data;


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




integer ii;
always @ (*)
begin
	for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
		wr_data_reg[ii*DATA_WIDTH+:DATA_WIDTH]      =  write_data[ii]       ;
		compare_data[ii]                            =  wr_data[ITER_NUM*DATA_CNT*DATA_WIDTH+ii*DATA_WIDTH+:DATA_WIDTH];
	end
end

assign  wr_data[DATA_WIDTH*DATA_CNT-1:0] =  wr_data_reg ;

genvar iter_ind;
generate
    for (iter_ind = 0; iter_ind < ITER_NUM; iter_ind = iter_ind + 1) begin : iter 
        localparam GROUP = 2**iter_ind    ;
        localparam GSTEP = DATA_CNT/GROUP ;
        localparam NUM   = GSTEP/2        ;
        localparam STEP  = GSTEP/2        ;

	iter_pipline #(
    		.DATA_WIDTH (DATA_WIDTH)     ,
    		.DATA_CNT   (DATA_CNT  )     ,
   		.COM_STYLE  (COM_STYLE )     ,		
		.GROUP      (GROUP     )     ,
        	.GSTEP      (GSTEP     )     ,
        	.NUM        (NUM       )     ,
        	.STEP       (STEP      )     
	) u_iter_pipline(
    		.clk                   (clk         )    ,
    		.rst_n                 (rst_n       )    , 
    		.write_data            (wr_data[iter_ind*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT]        )    ,
    		.compare_data          (wr_data[(iter_ind+1)*DATA_CNT*DATA_WIDTH+:DATA_WIDTH*DATA_CNT]    )    
	);
    end
endgenerate





endmodule

