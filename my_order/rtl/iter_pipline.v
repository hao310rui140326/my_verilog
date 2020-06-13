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
module iter_pipline #(
	// compare data bus width
    	parameter DATA_WIDTH = 64         ,
    	// compare data count
    	parameter DATA_CNT   = 1024       ,
   	parameter COM_STYLE = "UP"        ,		
	parameter GROUP = 1               ,
        parameter GSTEP = 1024            ,
        parameter NUM   = 512             ,
        parameter STEP  = 512             
)
(
    input  wire                     clk,
    input  wire                     rst_n,

    //input  wire [DATA_WIDTH-1:0]     write_data[DATA_CNT-1:0],
    //output wire  [DATA_WIDTH-1:0]    compare_data[DATA_CNT-1:0]

    input  wire  [DATA_CNT*DATA_WIDTH-1:0]     write_data,
    output wire  [DATA_CNT*DATA_WIDTH-1:0]     compare_data
);

      reg   [DATA_CNT*DATA_WIDTH-1:0]    wr_data  ;
      wire  [DATA_CNT*DATA_WIDTH-1:0]    com_data ;

//integer ii;
//integer jj;
//always @ (*)
//begin
//	for(ii=0;ii<DATA_CNT;ii=ii+1) begin 
//		wr_data[ii*DATA_WIDTH+:DATA_WIDTH]   =  write_data[ii];
//	end
//end

	genvar group_ind;
	generate
    		for (group_ind = 0; group_ind < GROUP; group_ind = group_ind + 1) begin : group
			group_pipline #(
    				.DATA_WIDTH (DATA_WIDTH)     ,
    				.DATA_CNT   (DATA_CNT  )     ,
   				.COM_STYLE  (COM_STYLE )     ,		
				.GROUP      (GROUP     )     ,
        			.GSTEP      (GSTEP     )     ,
        			.NUM        (NUM       )     ,
        			.STEP       (STEP      )     
			) u_group_pipline(
    				.clk                   (clk         				)    ,
    				.rst_n                 (rst_n       				)    , 
    				.write_data            (write_data[GSTEP*group_ind*DATA_WIDTH+:DATA_WIDTH*GSTEP]      )    ,
    				.compare_data          (compare_data[GSTEP*group_ind*DATA_WIDTH+:DATA_WIDTH*GSTEP]    )    
			);

    		end
	endgenerate



endmodule

