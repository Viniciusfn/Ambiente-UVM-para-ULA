
/*-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------
-- Class declaration
-------------------------------------------------------------------------------*/
class monitor_in extends  uvm_monitor;
	
	interface_vif vif;
	transaction_in tr_in;

	uvm_analysis_port #(transaction_in) item_collected_port;

	event begin_record, end_record;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(monitor_in)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
extern function new(string name = "monitor_in", uvm_component parent = null);
extern task collect_transactions(uvm_phase phase);
extern virtual function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);
extern task record_tr();


endclass : monitor_in
///////////////////BODY////////////////////////

function monitor_in::new(string name = "monitor_in", uvm_component parent=null);
	super.new(name, parent);
	item_collected_port = new("item_collected_port",this);
endfunction: new


task  monitor_in::collect_transactions(uvm_phase phase);
	wait(!vif.rst );
		@(posedge vif.rst);

	forever begin :receive_data
		do begin
			@(posedge vif.clk_reg or posedge vif.clk_ula);
		end 
		while (vif.valid_ula === 0 || vif.valid_reg === 0);

		-> begin_record;

		 item_collected_port.write(tr_in);

		 @(posedge vif.clk_reg or posedge vif.clk_ula);
		 	-> end_record;
	end:receive_data
endtask : collect_transactions


function void monitor_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	assert(uvm_config_db#(interface_vif)::get(this, "", "vif", vif ));
	tr_in = transaction_in::type_id::create("tr_in",this);
endfunction : build_phase

task  monitor_in::run_phase(uvm_phase phase);
	super.run_phase(phase);
	fork
		collect_transactions(phase);
		record_tr();
	join
endtask : run_phase

task monitor_in::record_tr();
	forever begin
		@(begin_record);
			begin_tr(tr_in,"monitor_in");
		@(end_record);
			end_tr(tr_in);	
	end
endtask : record_tr





