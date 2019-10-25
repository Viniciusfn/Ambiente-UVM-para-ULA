
// from driver to monitor_in
// from monitor_in to coverage and refmod

class monitor_in extends  uvm_monitor;
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual interface_in moni_bus;	
	
	bit coverage_enable = 1;
	// bit control_checking = 1; -> control checking in this class and the interface
	uvm_analysis_port #(transaction_in) item_collected_port_ula;
	uvm_analysis_port#(transaction_in) item_collected_port_reg;

	event cov_in_en; // call covergroups from coverage

	bit clk_reg;
	bit clk_ula;


	
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(monitor_in)
		`uvm_field_int(coverage_enable, UVM_ALL_ON)
		//`uvm_field_int(control_checking, UVM_ALL_ON) uncomment this field if control checking signal is activated
	`uvm_component_utils_end


/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor

extern function new(string name = "agent_in", uvm_component parent = null);
extern virtual void function collect_transactions();

endclass : monitor_in

extern virtual void function agent_in::collect_transactions();
	forever begin::receive_data
		@posedge(moni_bus.clk_ula)
			ula_drv_2_moni();

		@posedge(moni_bus.clk_reg)
			reg_drv_2_moni();

			->cov_in_en; // sends to the Coverage object the permission to sample the input data

	end:receive_data

endfunction : collect_transactions


extern function agent_in::new(string name = "agent_in", uvm_component parent=null);
	super.new(name, parent);

endfunction: new