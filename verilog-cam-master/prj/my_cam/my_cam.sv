module my_cam(/*AUTOARG*/
   // Outputs
   write_busy_reg, match_reg, match_addr_reg,
   // Inputs
   write_enable_wire, write_delete_wire, write_data_wire,
   write_addr_wire, rst, compare_data_wire, clk
   ) ;

/////////////////////////////////////////////////////////////////////////////////////////////////////


/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [8:0]		match_addr_reg;		// From u_cam_ctrl of cam_ctrl.v
output			match_reg;		// From u_cam_ctrl of cam_ctrl.v
output			write_busy_reg;		// From u_cam_ctrl of cam_ctrl.v
// End of automatics
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			clk;			// To u_cam of cam.v, ...
input [23:0]		compare_data_wire;	// To u_cam_ctrl of cam_ctrl.v
input			rst;			// To u_cam of cam.v, ...
input [8:0]		write_addr_wire;	// To u_cam_ctrl of cam_ctrl.v
input [23:0]		write_data_wire;	// To u_cam_ctrl of cam_ctrl.v
input			write_delete_wire;	// To u_cam_ctrl of cam_ctrl.v
input			write_enable_wire;	// To u_cam_ctrl of cam_ctrl.v
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [23:0]		compare_data;		// From u_cam_ctrl of cam_ctrl.v
wire			match;			// From u_cam of cam.v
wire [8:0]		match_addr;		// From u_cam of cam.v
wire [2**9-1:0]		match_many;		// From u_cam of cam.v
wire [2**9-1:0]		match_single;		// From u_cam of cam.v
wire [8:0]		write_addr;		// From u_cam_ctrl of cam_ctrl.v
wire			write_busy;		// From u_cam of cam.v
wire [23:0]		write_data;		// From u_cam_ctrl of cam_ctrl.v
wire			write_delete;		// From u_cam_ctrl of cam_ctrl.v
wire			write_enable;		// From u_cam_ctrl of cam_ctrl.v
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




cam_ctrl  #(
.DATA_WIDTH            ( 24              ), 
.ADDR_WIDTH            (  9              ), 
.CAM_STYLE       ( "BRAM"        ), 
.SLICE_WIDTH     ( 8             ) 
)
u_cam_ctrl(
/*AUTOINST*/
	   // Outputs
	   .write_addr			(write_addr[8:0]),
	   .write_data			(write_data[23:0]),
	   .write_delete		(write_delete),
	   .write_enable		(write_enable),
	   .compare_data		(compare_data[23:0]),
	   .write_busy_reg		(write_busy_reg),
	   .match_addr_reg		(match_addr_reg[8:0]),
	   .match_reg			(match_reg),
	   // Inputs
	   .clk				(clk),
	   .rst				(rst),
	   .write_busy			(write_busy),
	   .match_many			(match_many[2**9-1:0]),
	   .match_single		(match_single[2**9-1:0]),
	   .match_addr			(match_addr[8:0]),
	   .match			(match),
	   .write_addr_wire		(write_addr_wire[8:0]),
	   .write_data_wire		(write_data_wire[23:0]),
	   .write_delete_wire		(write_delete_wire),
	   .write_enable_wire		(write_enable_wire),
	   .compare_data_wire		(compare_data_wire[23:0]));




// Local Variables:                                                                 
// verilog-auto-inst-param-value:t                                                  
// End:           




endmodule
