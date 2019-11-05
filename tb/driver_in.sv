/*-------------------------------------------------------------------------------
-- Unit scope virtual driver's interface
-------------------------------------------------------------------------------*/
typedef virtual interface_if interface_vif;
/*-------------------------------------------------------------------------------
-- Class declaration
-------------------------------------------------------------------------------*/

class driver_in extends uvm_driver#(transaction_in);
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	interface_vif vif;

	transaction_in tr_in;

	event begin_record, end_record;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(driver_in)
		
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
extern function new(string name = "driver_in", uvm_component parent = null);

	//Shared functions 
extern function void build_phase(uvm_phase phase );
extern  task run_phase(uvm_phase phase);
extern  task reset_signals();
	
	// functions
extern task get_and_drive(uvm_phase phase);
extern task drive_transfer(transaction_in tr_in);
extern  task record_tr();

endclass :driver_in

//////////////////// BODY /////////////////////////////
function driver_in::new(string name = "driver_in", uvm_component parent = null);
	super.new(name,	parent);
endfunction:new


function void driver_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	assert(uvm_config_db#(interface_vif)::get(this, "", "vif", vif));
endfunction: build_phase

 task driver_in::run_phase (uvm_phase phase);

		super.run_phase(phase);
		fork 
				reset_signals();

				get_and_drive(phase);
				record_tr();
		join
endtask : run_phase


 task driver_in::reset_signals();
	wait(!vif.rst)
	forever begin 
		vif.valid_reg 	<='1;
		vif.A 			<='x;
		vif.reg_sel 	<='x;
		vif.instru 		<='x;
		vif.valid_ula 	<='1;
		vif.addr 		<='x;
		vif.data_in 	<='x; 
		@(negedge vif.rst);
	end
endtask : reset_signals


 task driver_in::get_and_drive(uvm_phase phase);
	wait(!vif.rst);
	@(posedge vif.rst);
	@(posedge vif.clk_ula or posedge vif.clk_reg);

	forever begin 
		seq_item_port.get(req);
		->begin_record;
		drive_transfer(req);
	end
endtask : get_and_drive

task driver_in::drive_transfer(transaction_in tr_in);
	 vif.A = tr_in.dt_A;
	 vif.reg_sel = tr_in.reg_sel;
	 vif.valid_ula = 1;
	 vif.data_in = tr_in.dt_in;
	 vif.addr = tr_in.addr;
	 vif.valid_reg = 1;
	 vif.instru = tr_in.instru;

	 @(posedge vif.clk_ula or vif.clk_reg)
	 while(!vif.valid_out) 
		@(posedge vif.clk_reg or posedge vif.clk_ula); 

	-> end_record;
	 @(posedge vif.clk_reg or posedge vif.clk_ula);

	 vif.valid_ula = 0;
	 vif.valid_reg = 0; 
	 @(posedge vif.clk_reg or posedge vif.clk_ula);
endtask : drive_transfer

 task driver_in::record_tr();
	forever begin
		@(begin_record);
		begin_tr(req,"driver_in");
		@(end_record);
		end_tr(req);
	end
endtask : record_tr


