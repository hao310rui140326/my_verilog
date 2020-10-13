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

//initial begin
//#5 ;	
//$vcdpluson;
//$vcdplusmemon;
//$vcdplusglitchon;
//$vcdplusflush;
//end

/////////////////////////////////////////////////////////////////////////////////////////////////////


/*AUTOOUTPUT*/
/*AUTOINPUT*/
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [63:0]		addr;			// From u_tx_sys of tx_sys.v
wire [63:0]		rdout;			// From u_assoc of sv_assoc.v
wire			ren;			// From u_tx_sys of tx_sys.v
wire [63:0]		wdin;			// From u_tx_sys of tx_sys.v
wire			wen;			// From u_tx_sys of tx_sys.v
// End of automatics


sv_assoc  u_assoc(
/*AUTOINST*/
		  // Outputs
		  .rdout		(rdout[63:0]),
		  // Inputs
		  .clk			(clk),
		  .rst_n		(rst_n),
		  .wen			(wen),
		  .ren			(ren),
		  .wdin			(wdin[63:0]),
		  .addr			(addr[63:0]));

tx_sys  
u_tx_sys(
/*AUTOINST*/
	 // Outputs
	 .wen				(wen),
	 .ren				(ren),
	 .wdin				(wdin[63:0]),
	 .addr				(addr[63:0]),
	 // Inputs
	 .clk				(clk),
	 .rst_n				(rst_n),
	 .rdout				(rdout[63:0]));

// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           




endmodule
