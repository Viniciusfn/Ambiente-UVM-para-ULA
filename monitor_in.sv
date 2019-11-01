
/*-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------*/
virtual interface_in interface_mvif;	

class monitor_in extends  uvm_monitor;
	
	interface_mvif mvif;
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
extern virtual function void collect_transactions();
extern function void build_phase(uvm_phase phase);
extern function void run_phase(uvm_phase phase);
extern virtual task record_tr();


endclass : monitor_in
///////////////////BODY////////////////////////

function monitor_in::new(string name = "monitor_in", uvm_component parent=null);
	super.new(name, parent);
	item_collected_port_ula = new("item_collected_port",this);
endfunction: new


 virtual function void monitor_in::collect_transactions(uvm_phase phase);
	wait(!mvif.rst);
		@(posedge mvif.rst);

	forever begin 
		do begin_record	@(posedge mvif.clk);
		end while (mvif.valid_ula === 0 || mvif.valid_reg === 0);
		-> begin_record;

		 item_collected_port.write(tr_in);

		 @(posedge mvif.clk);
		 	-> end_record;
	end:receive_data
endfunction : collect_transactions


function void monitor_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	assert(uvm_config_db#(interface_mvif)::get(this, "", "mvif", mvif );
	tr_in = transaction_in::type_id::create("tr_in",this);
endfunction : build_phase

function void monitor_in::run_phase(uvm_phase phase);
	super.run_phase(phase);
	fork
		collect_transactions(phase);
		record_tr_in();
	join
endfunction : run_phase

virtual task monitor_in::record_tr();
	forever begin
		@(begin_record);
			begin_tr(tr_in,"monitor_in");
		@(end_record);
			end_tr(tr_in);	
endtask : record_tr





