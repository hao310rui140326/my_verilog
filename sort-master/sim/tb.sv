module tb(/*AUTOARG*/) ;

logic clk;
logic rst_n;
initial begin
	clk = 0 ;
	rst_n = 0 ; 
	#100
	rst_n = 1 ; 
end
always #5 clk <= ~clk ;

initial begin
	#5 ;
	$fsdbDumpon;
	$fsdbAutoSwitchDumpfile(500,"tb_top.fsdb",100);
	$fsdbDumpvars(0,tb);

	#50_000_000
	$finish;
end

initial begin
#5 ;	
$vcdpluson;
  $vcdplusmemon;
      $vcdplusglitchon;
      $vcdplusflush;

end

/////////////////////////////////////////////////////////////////////////////////////////////////////


/*AUTOOUTPUT*/
/*AUTOINPUT*/
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics


logic[7:0]	id00 	, od00	;	  
logic[7:0]	id01  	, od01   ; 
logic[7:0]	id02  	, od02   ; 
logic[7:0]	id03  	, od03   ; 
logic[7:0]	id04  	, od04   ; 
logic[7:0]	id05  	, od05   ; 
logic[7:0]	id06  	, od06   ; 
logic[7:0]	id07  	, od07   ; 
logic[7:0]	id08  	, od08   ; 
logic[7:0]	id09  	, od09   ; 
logic[7:0]	id10 	, od10  ; 
logic[7:0]	id11 	, od11  ; 
logic[7:0]	id12 	, od12  ; 
logic[7:0]	id13 	, od13  ; 
logic[7:0]	id14 	, od14  ; 
logic[7:0]	id15 	, od15  ; 
logic[7:0]	id16 	, od16  ; 
logic[7:0]	id17 	, od17  ; 
logic[7:0]	id18 	, od18  ; 
logic[7:0]	id19 	, od19  ; 
logic[7:0]	id20 	, od20  ; 
logic[7:0]	id21 	, od21  ; 
logic[7:0]	id22 	, od22  ; 
logic[7:0]	id23 	, od23  ; 
logic[7:0]	id24 	, od24  ; 

always@(posedge clk )begin
	id00 	= 'd0;	
	id01  	= 'd1;
	id02  	= 'd2;
	id03  	= 'd3;
	id04  	= 'd4;
	id05  	= 'd5;
	id06  	= 'd6;
	id07  	= 'd7;
	id08  	= 'd8;
	id09  	= 'd9;
	id10 	= 'd10;
	id11 	= 'd11;
	id12 	= 'd12;
	id13 	= 'd13;
	id14 	= 'd14;
	id15 	= 'd15;
	id16 	= 'd16;
	id17 	= 'd17;
	id18 	= 'd18;
	id19 	= 'd19;
	id20 	= 'd20;
	id21 	= 'd21;
	id22 	= 'd22;
	id23 	= 'd23;
	id24 	= 'd24;
end






order_25D_switch #(         
	.TIMES				(14	),                                   
	.DSIZE				(8	)                                             
)order_25D_switch(                                        
	.clock		(clk		),			                        
	.id00       (id00        ),	.od00		(od00		),   
	.id01       (id01        ),	.od01       (od01        ),   
	.id02       (id02        ),	.od02       (od02        ),   
	.id03       (id03        ),	.od03       (od03        ),   
	.id04       (id04        ),	.od04       (od04        ),   
	.id05       (id05        ),	.od05       (od05        ),   
	.id06       (id06        ),	.od06       (od06        ),   
	.id07       (id07        ),	.od07       (od07        ),   
	.id08       (id08        ),	.od08       (od08        ),   
	.id09       (id09        ),	.od09       (od09        ),   
	.id10       (id10       ),	.od10       (od10       ),   
	.id11       (id11       ),	.od11       (od11       ),   
	.id12       (id12       ),	.od12       (od12       ),   
	.id13       (id13       ),	.od13       (od13       ),   
	.id14       (id14       ),	.od14       (od14       ),   
	.id15       (id15       ),	.od15       (od15       ),   
	.id16       (id16       ),	.od16       (od16       ),   
	.id17       (id17       ),	.od17       (od17       ),   
	.id18       (id18       ),	.od18       (od18       ),   
	.id19       (id19       ),	.od19       (od19       ),   
	.id20       (id20       ),	.od20       (od20       ),   
	.id21       (id21       ),	.od21       (od21       ),   
	.id22       (id22       ),	.od22       (od22       ),   
	.id23       (id23       ),	.od23       (od23       ),   
	.id24       (id24       ),	.od24       (od24       ) 	
		                                                        
);     




// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           




endmodule
