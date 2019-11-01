

class agent_in extends uvm_agent;
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
 sequencer sqr;
 driver_in drv;
 monitor_in mon;
	
uvm_analysis_port #(transaction_in) item_collected_port;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(agent_in)
		

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
extern function new(string name, uvm_component parent = null);
extern function void build_phase(uvm_phase (phase));
extern function void connect_phase(uvm_phase(phase));


endclass :agent_in




////////////////////BODY/////////////////////////////
extern function agent_in::new(string name, uvm_component parent = null);
	super.new(name, parent);
	item_collected_port = new("item_collected_port", this);
endfunction:new


extern function void agent_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	sqr = sequencer::type_id::create("sqr", this);
	drv = driver_in::type_id::create("drv", this);
	mon = monitor_in::type_id::create("mon",this);
endfunction: build_phase


extern function void agent_in::connect_phase (uvm_phase(phase));
	super.connect_phase(phase);
	mon.item_collected_port.connect(item_collected_port);
	drv.seq_item_port.connect(sqr.seq_item_export);

endfunction : connect_phase


