// Check that analysis imports are connected.
/*`define CHECK_PORT_CONNECTION(PORT) \
  begin \
    uvm_port_list list; \
    PORT.get_provided_to(list); \
    if (!list.size()) begin \
      `uvm_fatal("AP_CONNECT", \
        $sformatf("Analysis port %s not connected.", PORT.get_full_name())); \
    end \
  end

`define CHECK_PORT_CONNECTIONS(PORT) \
  begin \
    uvm_port_list list; \
    PORT.get_connected_to(list); \
    if (list.size()) begin \
      `uvm_info("AP_CONNECT", \
                $sformatf("Analysis port %p connected.", list),UVM_LOW); \
    end \
  end

*/


package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	//transação - agent (in)
	`include "./tb/transaction_in.sv"
	`include "./tb/sequence_in.sv"
	// `include "./tb/sequencer.sv"

	`include "./tb/driver_in.sv"
	`include "./tb/monitor_in.sv"
	`include "./tb/agent_in.sv"

	//transação - agent (out)
	`include "./tb/transaction_out.sv"
	
	`include "./tb/monitor_out.sv"
	`include "./tb/agent_out.sv"

	//scoreboard
	`include "./tb/refmod.sv"
	`include "./tb/scoreboard.sv"

	//coverage
	`include "./tb/coverage.sv"
	//env e test
	`include "./tb/env.sv"
	`include "./tb/test.sv"

endpackage