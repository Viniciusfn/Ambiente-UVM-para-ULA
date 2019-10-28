// general configuration of higher level of anbstraction models


class configuration extends uvm_object;

	`uvm_object_utilis(configuration);

	extern function new(string name = "");



endclass:configuration 

extern function configuration::new(string name = "");
	super.new(name);
endfunction : new