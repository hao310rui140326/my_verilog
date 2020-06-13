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
 * compare logic  
 */
module com_logic_inline #(
	// compare data bus width
    	parameter DATA_WIDTH = 64         ,
    	// compare data count
    	parameter DATA_CNT   = 1024       ,
   	parameter COM_STYLE = "UP"        		
)
(
    input  wire  [GSTEP*DATA_WIDTH-1:0]    write_data,
    output wire  [GSTEP*DATA_WIDTH-1:0]    compare_data
);

genvar ii;
generate
		for (ii = 0; ii < DATA_CNT/2; ii = ii + 1) begin : com_data
			com_logic #(.DATA_WIDTH(DATA_WIDTH) ,.COM_STYLE(COM_STYLE) )
				u_com_logic(
			    		.write_data0   (write_data[ii*DATA_WIDTH+:DATA_WIDTH]             ) ,
			    		.write_data1   (write_data[(ii+STEP)*DATA_WIDTH+:DATA_WIDTH]      ) ,
			    		.compare_data0 (compare_data[ii*DATA_WIDTH+:DATA_WIDTH]           ) ,
			    		.compare_data1 (compare_data[(ii+STEP)*DATA_WIDTH+:DATA_WIDTH]    ) 
				);
		end
endgenerate



endmodule

