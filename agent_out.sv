class agent_out extends uvm_agent;

	`uvm_component_utils(agent_out)

	monitor_out mon_o;

	uvm_analysis_port #(transaction_out) agt_resp_port;

	extern function new 					( string name, uvm_component parent );
	extern function void build_phase		( uvm_phase phase );
	extern function void connect_phase		( uvm_phase phase );

endclass : agent_out

extern function agent_out::new ( string name, uvm_component parent );
	super.new(name,parent);

	agt_resp_port = new("agt_resp_port", this);

endfunction : new

extern function void agent_out::build_phase ( uvm_phase phase);
	super.build_phase(phase);

	mon_o = monitor_out::type_id::create("mon_o", this);

endfunction : build_phase

extern function void agent_out::connect_phase ( uvm_phase phase );
	super.connect_phase(phase);
	
	mon_o.resp_port.connect(agt_resp_port);

endfunction : connect_phase