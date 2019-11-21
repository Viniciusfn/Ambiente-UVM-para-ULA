


class monitor_out extends uvm_monitor;
	`uvm_component_utils(monitor_out)

	interface_vif vif;

	event begin_record, end_record;

	transaction_out tr_out;

	uvm_analysis_port #(transaction_out) resp_port;

	extern function new							( string name, uvm_component parent );
	extern virtual function void build_phase 		( uvm_phase phase );
	extern  task run_phase				( uvm_phase phase );
	extern task collect_transactions	( uvm_phase phase );
	extern  task record_tr				( );

endclass : monitor_out



function monitor_out::new (string name, uvm_component parent);
	super.new(name, parent);

	resp_port = new("resp_port",this);

endfunction : new

function void monitor_out::build_phase ( uvm_phase phase );
	super.build_phase(phase);

	if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end

	tr_out = transaction_out::type_id::create("tr_out",this);

endfunction : build_phase

task monitor_out::run_phase ( uvm_phase phase );
	super.run_phase(phase);

	fork
		collect_transactions(phase);
		record_tr();
	join

endtask : run_phase

task monitor_out::collect_transactions( uvm_phase phase );

	wait(vif.rst === 0);
	@(posedge vif.rst);

	forever begin
		wait( vif.valid_out === 1 );
		@(posedge vif.clk_ula or posedge vif.clk_reg);
		//wait( vif.valid_out === 1 );
		
		-> begin_record;

		tr_out.result = vif.data_out;
		resp_port.write(tr_out);

		@(posedge vif.clk_ula);
		-> end_record;
    end

endtask

task monitor_out::record_tr();
	forever begin
		@(begin_record);
			begin_tr(tr_out, "monitor_out");
		@(end_record);
			end_tr(tr_out);
	end
endtask