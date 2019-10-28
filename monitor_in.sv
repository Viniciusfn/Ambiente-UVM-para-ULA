
/*-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------*/
	virtual interface_in interface_mvif;	

class monitor_in extends  uvm_monitor;
	
	interface_mvif mvif;
	transaction_in tr_in;

	bit coverage_enable = 1;
	// bit control_checking = 1; -> control checking in this class and the interface
	uvm_analysis_port #(transaction_in) item_collected_port_ula;
	uvm_analysis_port#(transaction_in) item_collected_port_reg;

	event cov_in_en; // call covergroups from coverage
	event begin_record, end_reacord;

	uvm_event run_mon;
	uvm_event run_drv;

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
extern function new(string name = "monitor_in", uvm_component parent = null);
extern virtual function void collect_transactions();
extern function void build_phase(uvm_phase phase);
extern function void run_phase(uvm_phase phase);
extern virtual task record_tr();


endclass : monitor_in


///////////////////BODY////////////////////////

extern function monitor_in::new(string name = "monitor_in", uvm_component parent=null);
	super.new(name, parent);
	item_collected_port_ula = new("item_collected_port_ula",this);
	item_collected_port_reg = new("item_collected_port_reg",this);
endfunction: new


extern virtual function void monitor_in::collect_transactions();
	wait(mvif.rst);
		@(negedge mvif.rst);

	forever begin 
		do begin_record	@(posedge mvif.clk);
		end while (mvif.valid_ula === 0 || mvif.valid_reg === 0);
		-> begin_record;

		 item_collected_port_reg.write(tr_in);
		 item_collected_port_ula.write(tr_in);

		 @(posedge mvif.clk);
		 	-> end_record;
	end:receive_data
endfunction : collect_transactions


extern function void monitor_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	assert(uvm_config_db#(interface_mvif)::get(this, "", "mvif", mvif );
	tr_in = transaction_in::type_id::create("tr_in",this);
endfunction : build_phase

extern function void monitor_in::run_phase(uvm_phase phase);
	super.run_phase(phase);
	fork
		collect_transactions(phase);
		record_tr_in();
	join
endfunction : run_phase

extern virtual task monitor_in::record_tr();
	forever begin
		@(begin_record);
			begin_tr_in(tr_in,"monitor_in");
		@(end_record);
		end_tr_in(tr_in);	
endtask : record_tr





