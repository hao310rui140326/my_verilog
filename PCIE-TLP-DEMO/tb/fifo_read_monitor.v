// fifo_read_monitor.v
`timescale 1ps/1ps
//`include "step_fast_param.vh"
//`include "step_sim_pkg.sv"

module fifo_read_monitor #(
  parameter FRAME_DATA_WIDTH   = 1024,    //transmit data width
  parameter PORTS              = 4,
  parameter LEN_WIDTH          = 16,
  parameter TAG_WIDTH          = 8
)(
    input  wire                                 sys_clk         ,
    input  wire                                 sys_rst         ,
    input  wire                                 final_step      ,
    input  wire [PORTS-1:0]                     read_frame_enb  ,
    input  wire [PORTS*FRAME_DATA_WIDTH-1:0]    read_frame_tdata,
    input  wire [PORTS-1:0]                     read_frame_sop,
    input  wire [PORTS*LEN_WIDTH-1:0]           read_frame_len,     //当ready信号有效时，len表示当前请求发送帧的长度
    input  wire [PORTS*TAG_WIDTH-1:0]           read_frame_tag      //当ready信号有效时，tag表示当前请求发送帧的tag值
);

integer fp_output_msg;


initial begin

  fp_output_msg       = $fopen("msg_output_all.dat","w");
  //fp_output_ua3202_10 = $fopen("msg_ua3202_10.dat","w");
  //fp_output_ua3202_50 = $fopen("msg_ua3202_50.dat","w");
  wait (final_step == 1'b1);
  $fclose(fp_output_msg      );

end

//initial begin
//  mac_tx_axis_tready = 1'b0;
//  #10ns;
//  mac_tx_axis_tready = 1'b1;
//
//end

//final begin
//
//  $fclose(fp_output_msg      );
//
//end

integer frame_len;
integer read_port;
integer i,j;
//integer str_index;
reg     frame_valid;
//reg     [8-1:0]  str[0:4096*2-1];

always @ (posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
      frame_len  <= 'd0;
      read_port  <= 'd0;
      frame_valid<= 'b0;
  end
  else begin
      for(i = 0 ; i < PORTS ; i = i +1) begin
          if(read_frame_enb[i] == 1'b1 && read_frame_sop[i] == 1'b1) begin
              read_port <= i;
              frame_len <= read_frame_len[i*LEN_WIDTH +: LEN_WIDTH];
              //str_index <= 0;
          end
      end
      frame_valid <= |read_frame_enb;
//      if(frame_valid == 1'b1) begin
//        if(frame_len >= FRAME_DATA_WIDTH/8 ) begin
//          for(j = 0; j < FRAME_DATA_WIDTH/8 ; j=j+1) begin
//            $sformat(str,"%s%2x",str,read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
//            //$dislpay("%s",str);
//          end
//          frame_len = frame_len - FRAME_DATA_WIDTH/8;
//          if(frame_len == 0)
//            $fwrite(fp_output_msg,"%s\n",str);
//        end
//        else if(frame_len > 0) begin
//          for(j = 0; j < frame_len ; j=j+1) begin
//            $sformat(str,"%s%2x",str,read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
//            //$dislpay("%s",str);
//          end
//          frame_len <= 0;
//          $fwrite(fp_output_msg,"%s\n",str);
//        end
//      end
  end
end

always @ (posedge sys_clk) begin
  if(frame_valid == 1'b1) begin
    if(frame_len >= FRAME_DATA_WIDTH/8 ) begin
      for(j = 0; j < FRAME_DATA_WIDTH/8 ; j=j+1) begin
        //$sformat(str[str_index+j*2],"%2x",read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
        $fwrite(fp_output_msg,"%2x",read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
        //$dislpay("%s",str);
      end
      //str_index = str_index + FRAME_DATA_WIDTH/8*2;
      frame_len = frame_len - FRAME_DATA_WIDTH/8;
      if(frame_len == 0)
        $fwrite(fp_output_msg,"%s","\n");
        //for(j = 0;j<str_index;j=j+1)
        //  $fwrite(fp_output_msg,"%s\n",str[i]);
    end
    else if(frame_len > 0) begin
      for(j = 0; j < frame_len ; j=j+1) begin
        //$sformat(str[str_index+j*2],"%2x",read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
        $fwrite(fp_output_msg,"%2x",read_frame_tdata[read_port*FRAME_DATA_WIDTH+j*8 +: 8]);
        //$dislpay("%s",str);
      end
      //str_index = str_index + frame_len*2;
      frame_len <= 0;
      $fwrite(fp_output_msg,"%s","\n");
      //for(j = 0;j<str_index;j=j+1)
      //    $fwrite(fp_output_msg,"%s\n",str[i]);
    end
  end
end

endmodule
