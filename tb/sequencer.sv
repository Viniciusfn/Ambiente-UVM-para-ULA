

class sequencer extends uvm_sequencer #(transaction_in);

	`uvm_object_utils(sequencer)

	function new (string name = "sequencer", uvm_component parent = null);
			super.new(name);
	endfunction : new


endclass : sequencer



