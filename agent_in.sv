

class agent_in extends uvm_agent;
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
 uvm_event run_mon;
 uvm_event run_drv;

 sequencer sqr;
 driver drvi;
 monitor moni;
	
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(agent_in)
		
	`uvm_component_utils_end


/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase (phase));
extern function void connect_phase(uvm_phase(phase));


endclass :agent_in




////////////////////BODY/////////////////////////////
extern function agent_in::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction:new


extern function void agent_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	sqr = sequencer::type_id::create(.name("sqr"), .parent(this));
	drvi = driver_in::type_id::create(.name("drvi"), .parent(this));
	moni = monitor_in::type_id::create(.name("moni"), .parent(this));
endfunction: build_phase


extern function void agent_in::connect_phase (uvm_phase(phase));
	super.connect_phase(phase);

	drvi.seq_item_port.connect(sqr.seq_item_export);

endfunction : connect_phase


