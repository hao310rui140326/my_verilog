//-----------------------------------------------------------------------------
// Project       : fpga-hash-table
//-----------------------------------------------------------------------------
// Author        : Ivan Shevchuk (github/johan92)
//-----------------------------------------------------------------------------
// Description:
//   Little scoreboard for hashtable:
//   it get commands and dut results, and execute this command on 
//   hash table reference model. if result is not the same - error
//   will be displayed.
//-----------------------------------------------------------------------------

`ifndef _HT_SCOREBOARD_
`define _HT_SCOREBOARD_

class ht_scoreboard;
  
  mailbox #( ht_command_t ) drv2scb; 
  mailbox #( ht_result_t  ) mon2scb; 
  
  ref_hash_table            ref_ht;

  function new( input mailbox #( ht_command_t ) _drv2scb,
                      mailbox #( ht_result_t  ) _mon2scb );
    this.drv2scb = _drv2scb;
    this.mon2scb = _mon2scb;

    this.ref_ht  = new( 2**TABLE_ADDR_WIDTH ); 
  endfunction

  task run( );
    ht_command_t to_dut;
    ht_result_t  from_dut;

    forever
      begin
        mon2scb.get( from_dut );
        drv2scb.get( to_dut   ); 

        check( to_dut, from_dut );
      end
  endtask

  function void check( input ht_command_t c, ht_result_t r );
    ht_result_t ref_res;
    
    if( r.cmd != c )
      begin
        $error("DUT command in result don't match (maybe lost some command or reordering...?)");
        return;
      end

    ref_res = ref_ht.do_command( c );

    case( c.opcode )
      OP_SEARCH:
        begin
          if( ( ref_res.rescode     != r.rescode     ) || 
              ( ref_res.found_value != r.found_value ) )
            begin
              $error("Did not in %s: key = 0x%x REF: %s found = 0x%x, DUT: %s found = 0x%x", c.opcode, c.key, ref_res.rescode, ref_res.found_value, r.rescode, r.found_value );
            end
        end

      OP_INSERT, OP_DELETE:
        begin
          if( ref_res.rescode != r.rescode )
            begin
              $error("Did not in %s REF: %s, DUT: %s", c.opcode, ref_res.rescode, r.rescode );
            end
        end
    endcase

  endfunction

endclass

`endif
