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
module com_logic #(
    // compare data bus width
    parameter DATA_WIDTH = 64,
    parameter COM_STYLE = "UP"

)
(
    input  wire [DATA_WIDTH-1:0]    write_data0,
    input  wire [DATA_WIDTH-1:0]    write_data1,

    output wire  [DATA_WIDTH-1:0]    compare_data0,
    output wire  [DATA_WIDTH-1:0]    compare_data1
);


wire compare_flag ;
generate
    if (COM_STYLE == "UP") begin
	assign  compare_flag  =  (write_data0>=write_data1);
    end
    else if (COM_STYLE == "DOWN") begin
	assign  compare_flag  =  (write_data0<write_data1);
    end
endgenerate


assign  compare_data0 =  compare_flag  ?  write_data0 :  write_data1;
assign  compare_data1 =  compare_flag  ?  write_data1 :  write_data0;


endmodule

