module tb(/*AUTOARG*/) ;

logic clk;
logic rst;
initial begin
	clk = 0 ;
	rst = 1 ; 
	#100
	rst = 0 ; 
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
end

/////////////////////////////////////////////////////////////////////////////////////////////////////


/*AUTOOUTPUT*/
/*AUTOINPUT*/
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [23:0]		compare_data;		// From u_tx_sys of tx_sys.v
wire			match;			// From u_cam of cam.v
wire [8:0]		match_addr;		// From u_cam of cam.v
wire [2**9-1:0]		match_many;		// From u_cam of cam.v
wire [2**9-1:0]		match_single;		// From u_cam of cam.v
wire [8:0]		write_addr;		// From u_tx_sys of tx_sys.v
wire			write_busy;		// From u_cam of cam.v
wire [23:0]		write_data;		// From u_tx_sys of tx_sys.v
wire			write_delete;		// From u_tx_sys of tx_sys.v
wire			write_enable;		// From u_tx_sys of tx_sys.v
// End of automatics



cam  #(
.DATA_WIDTH            ( 24              ), 
.ADDR_WIDTH            (  9              ), 
.CAM_STYLE       ( "BRAM"        ), 
.SLICE_WIDTH     ( 8             ) 
)
u_cam(
/*AUTOINST*/
      // Outputs
      .write_busy			(write_busy),
      .match_many			(match_many[2**9-1:0]),
      .match_single			(match_single[2**9-1:0]),
      .match_addr			(match_addr[8:0]),
      .match				(match),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .write_addr			(write_addr[8:0]),
      .write_data			(write_data[23:0]),
      .write_delete			(write_delete),
      .write_enable			(write_enable),
      .compare_data			(compare_data[23:0]));



tx_sys  #(
.DATA_WIDTH            ( 24              ), 
.ADDR_WIDTH            (  9              ), 
.CAM_STYLE       ( "BRAM"        ), 
.SLICE_WIDTH     ( 8             ) 
)
u_tx_sys(
/*AUTOINST*/
	 // Outputs
	 .write_addr			(write_addr[8:0]),
	 .write_data			(write_data[23:0]),
	 .write_delete			(write_delete),
	 .write_enable			(write_enable),
	 .compare_data			(compare_data[23:0]),
	 // Inputs
	 .clk				(clk),
	 .rst				(rst),
	 .write_busy			(write_busy),
	 .match_many			(match_many[2**9-1:0]),
	 .match_single			(match_single[2**9-1:0]),
	 .match_addr			(match_addr[8:0]),
	 .match				(match));


  


// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           




endmodule
