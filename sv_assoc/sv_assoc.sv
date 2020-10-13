module sv_assoc(
clk  ,
rst_n,
wen  ,
wdin ,
ren  ,
addr ,
rdout
);

input         clk   ;
input         rst_n ;

input         wen   ;
input         ren   ;
input  [63:0] wdin  ;
input  [63:0] addr  ;
output [63:0] rdout ;
////////////////////////////////////////////////////
reg    [63:0] rdout ;
////////////////////////////////////////////////////

bit [63:0]  assoc[bit[63:0]],idx=1;

always @ (posedge clk or negedge rst_n)
begin
	if (wen) begin
		assoc[addr]<=wdin;
		$display("The array now has %0d elements",assoc.num);
	end
	if (ren) begin
		rdout<=assoc[addr];
	end
end

endmodule



