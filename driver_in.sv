/*-------------------------------------------------------------------------------
-- Unit scope virtual driver's interface
-------------------------------------------------------------------------------*/

typedef virtual interface_in interface_vif;
/*-------------------------------------------------------------------------------
-- Class declaration
-------------------------------------------------------------------------------*/

class driver_in extends uvm_driver#(transaction_in);
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	interface_vif vif;

	transaction tr_in;

	uvm_put_port #(packet_in) put_port_h;

	uvm_event run_mon;
	uvm_event run_drv;
	uvm_event_pool pl;
	event begin_record, endrecord;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(driver_in)
		
	`uvm_component_utils_end


/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
extern function new(string name = "driver_in", uvm_component parent = null);
extern function void build_phase(uvm_phase (phase));
extern function void connect_phase(uvm_phase(phase));
extern virtual task run_phase(uvm_phase(phase));
extern virtual protected task reset_signals();
extern virtual protected task get_and_driver();
extern virtual protected task drive_transfer(transaction_in tr_in);
extern virtual task record_tr();


endclass :driver




////////////////////BODY/////////////////////////////

extern function driver_in::new(string name = "driver_in", uvm_component parent = null);
	super.new(name, parent);
endfunction:new


extern function void driver_in::build_phase(uvm_phase phase);
	super.build_phase(phase);

	assert(uvm_config_db#(interface_vif)::get(this, "", "vif", vif));
	//pl = uvm_event_pool::get_global_pool();
	//run_drv = pl.get("run_drv");
	//run_mon = pl.get("run_mon");
	//put_port_h = new("put_port_h" this);
endfunction: build_phase


extern function void driver_in::connect_phase (uvm_phase(phase));
	super.connect_phase(phase);
	drvi.seq_item_port.connect(sqr.seq_item_export);
endfunction : connect_phase


extern virtual task driver_in::run_phase (uvm_phase(phase));

		super.run_phase(phase);
		fork 
				reset_signals();
				get_and_driver();
				record_tr();
		join
endtask : run_phase


extern virtual protected task driver_in::reset_signals();
	wait(vif.rst)
	forever begin 
		vif.valid_reg 	<='0;
		vif.A 			<='x;
		vif.reg_sel 	<='x;
		vif.instru 		<='x;
		vif.valid_ula 	<='0;
		vif.addr 		<='x;
		vif.data_in 	<='x; 
		@(posedge vif.rst);
	end
endtask : reset_signals


extern virtual protected task driver_in::get_and_driver();
	wait(vif.rst);
	@(negedge vif.rst);
	@(posedge vif.clk);

	forever begin 
		seq_item_port.get(req);
		->begin_record;
		drive_transfer(req);
	end
endtask : get_and_driver


extern virtual protected task driver_in::drive_transfer(tra tr_in);
	 vif.A = tr_in.A;
	 vif.reg_sel = reg_sel;
	 vif.valid_ula = tr_in.reg_sel;
	 vif.data_in = tr_in.data_in;
	 vif.addr = tr_in.addr;
	 vif.valid_reg = tr_in.valid_reg;

	 @(posedge vif.clk)
		//valid insertion missing !!!
		// sugestion -> use clocking block (left for checking later)
	 while(vif.valid_reg && vif.valid_ula) ///////
		@(posedge vif.clk); // hold time
	 vif.valid_ula = 0;
	 vif.valid_reg = 0;

	 @(posedge vif.clk);
endtask : drive_transfer


extern virtual task drive_in::record_tr();
	forever begin
		@(begin_record);
		begin_tr_in(req,"driver_in");
		@(endrecord);
		end_tr_in(req);
	end
endtask : record_tr


