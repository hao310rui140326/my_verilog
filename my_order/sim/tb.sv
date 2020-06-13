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
wire [7:0]		compare_data [31:0];	// From u_cam of com_inline.v
wire			compare_en;		// From u_cam of com_inline.v
wire [7:0]		write_data [31:0];	// From u_tx_sys of tx_sys.v
wire			write_en;		// From u_tx_sys of tx_sys.v
// End of automatics


//com_pipline  #(
com_inline  #(
    .DATA_WIDTH (8) ,
    .DATA_CNT   (32) ,
    .COM_STYLE  ("UP") 	    
)
u_cam(
/*AUTOINST*/
      // Outputs
      .compare_en			(compare_en),
      .compare_data			(compare_data/*[7:0].[31:0]*/),
      // Inputs
      .clk				(clk),
      .rst_n				(rst_n),
      .write_data			(write_data/*[7:0].[31:0]*/),
      .write_en				(write_en));

tx_sys  #(
    .DATA_WIDTH (8) ,
    .DATA_CNT   (32) ,
    .COM_STYLE  ("UP") 	    
)
u_tx_sys(
/*AUTOINST*/
	 // Outputs
	 .write_en			(write_en),
	 .write_data			(write_data/*[7:0].[31:0]*/),
	 // Inputs
	 .clk				(clk),
	 .rst_n				(rst_n),
	 .compare_en			(compare_en),
	 .compare_data			(compare_data/*[7:0].[31:0]*/));

// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           




endmodule
