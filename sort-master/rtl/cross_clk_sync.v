module cross_clk_sync(
	clock,                              
	rst_n,                            
	id24,
	od24
);
parameter  DSIZE = 8 ;
parameter  LAT   = 1 ;

input   clock ;
input   rst_n ;
input   [DSIZE-1:0]    id24  ;
output  [DSIZE-1:0]    od24  ;
reg     [DSIZE-1:0]    od24  ;


always @ (posedge clock)
begin
	od24 <=   id24 ;
end


endmodule

