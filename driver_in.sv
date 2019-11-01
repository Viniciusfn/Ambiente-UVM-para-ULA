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

	event begin_record, end_record;

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

	//Shared functions 
extern function void build_phase(uvm_phase (phase));
extern virtual task run_phase(uvm_phase(phase));
extern virtual protected task reset_signals();
	
	// functions
extern virtual protected task get_and_drive_reg(uvm_phase phase);
extern virtual protected task drive_transfer_reg(transaction_in tr_in);
extern virtual task record_tr_reg();

endclass :driver

//////////////////// BODY /////////////////////////////
function driver_in::new(string name = "driver_in", uvm_component parent = null);
	super.new(name,	parent);
endfunction:new


function void driver_in::build_phase(uvm_phase phase);
	super.build_phase(phase);
	assert(uvm_config_db#(interface_vif)::get(this, "", "vif", vif));
endfunction: build_phase

virtual task driver_in::run_phase (uvm_phase(phase));

		super.run_phase(phase);
		fork 
				reset_signals();

				get_and_drive(phase);
				record_tr();
		join
endtask : run_phase


virtual protected task driver_in::reset_signals();
	wait(!vif.rst)
	forever begin 
		vif.valid_reg 	<='0;
		vif.A 			<='x;
		vif.reg_sel 	<='x;
		vif.instru 		<='x;
		vif.valid_ula 	<='0;
		vif.addr 		<='x;
		vif.data_in 	<='x; 
		@(negedge vif.rst);
	end
endtask : reset_signals


virtual protected task driver_in::get_and_drive_ula(uvm_phase phase);
	wait(!vif.rst);
	@(posedge vif.rst);
	@(posedge vif.clk_ula or posedge vif.clk_reg);

	forever begin 
		seq_item_port.get(req);
		->begin_record;
		drive_transfer(req);
	end
endtask : get_and_drive_ula

virtual protected task driver_in::drive_transfer(tr tr_in);
	 vif.A = tr_in.A;
	 vif.reg_sel = reg_sel;
	 vif.valid_ula = tr_in.reg_sel;
	 vif.data_in = tr_in.data_in;
	 vif.addr = tr_in.addr;
	 vif.valid_reg = tr_in.valid_reg;

	 @(posedge vif.clk_ula or vif.clk_reg)
	 while(!vif.valid_out) 
		@(posedge vif.clk); 

	-> end_record;
	 @(posedge vif.clk);

	 vif.valid_ula = 0;
	 vif.valid_reg = 0; 
	 @(posedge vif.clk_reg or posedge vif.clk_ula)
endtask : drive_transfer

virtual task drive_in::record_tr();
	forever begin
		@(begin_record);
		begin_tr(req,"driver_in");
		@(end_record);
		end_tr(req);
	end
endtask : record_tr


