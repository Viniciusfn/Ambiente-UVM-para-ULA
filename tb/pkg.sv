package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	//transação - agent (in)
	`include "./transaction_in.sv"
	`include "./sequence_in.sv"
	`include "./sequencer.sv"

	`include "./driver_in.sv"
	`include "./monitor_in.sv"
	`include "./agent_in.sv"

	//transação - agent (out)
	`include "./transaction_out.sv"
	
	`include "./monitor_out.sv"
	`include "./agent_out.sv"

	//scoreboard
	`include "./refmod.sv"
	`include "./scoreboard.sv"

	//coverage
	`include "./coverage.sv"
	//env e test
	`include "./env.sv"
	`include "./test.sv"

endpackage