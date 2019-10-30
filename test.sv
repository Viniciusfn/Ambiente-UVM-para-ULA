​class test extends uvm_test;​
  `uvm_component_utils(simple_test)​
  
  	env env_h;
	sequence_in seq;

	extern function new(string name, uvm_component parent);​
	extern virtual function void build_phase(uvm_phase phase);​
	extern task run_phase(uvm_phase phase);​

endclass: simple_test

///////////////FUNCTIONS BODIES///////////////////////////

extern function new(string name, uvm_component parent);​
	super.new(name, parent);​
endfunction: new​

extern virtual function void build_phase(uvm_phase phase);​
	super.build_phase(phase);​
	env_h = env::type_id::create("env_h", this);
​    seq = sequence_in::type_id::create("seq", this);
endfunction​

extern task run_phase(uvm_phase phase);​
	seq.start(env_h.mst.sqr);
endtask: run_phase​