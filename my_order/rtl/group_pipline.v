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
module group_pipline #(
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

    input  wire  [GSTEP*DATA_WIDTH-1:0]    write_data,
    output wire  [GSTEP*DATA_WIDTH-1:0]    compare_data
);


			genvar step_ind;
			generate
    				for (step_ind = 0; step_ind < STEP; step_ind = step_ind + 1) begin : step
					com_logic_reg #(.DATA_WIDTH(DATA_WIDTH) ,.COM_STYLE(COM_STYLE) )
						u_com_logic_reg(
							.clk           (clk             ) ,
							.rst_n         (rst_n           ) ,
					    		.write_data0   (write_data[step_ind*DATA_WIDTH+:DATA_WIDTH]             ) ,
					    		.write_data1   (write_data[(step_ind+STEP)*DATA_WIDTH+:DATA_WIDTH]      ) ,
					    		.compare_data0 (compare_data[step_ind*DATA_WIDTH+:DATA_WIDTH]           ) ,
					    		.compare_data1 (compare_data[(step_ind+STEP)*DATA_WIDTH+:DATA_WIDTH]    ) 
						);
    				end
			endgenerate



endmodule

