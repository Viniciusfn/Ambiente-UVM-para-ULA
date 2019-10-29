class monitor_out extends uvm_monitor;
	`uvm_component_utils(monitor_out)

	interface_out vif;

	event begin_record, end_record;

	transaction_out tr_out;

	uvm_analysis_port #(transaction_out) resp_port;

	extern function new						( string name, uvm_component parent );
	extern virtual function build_phase 	( uvm_phase phase );
	extern virtual task run_phase			( uvm_phase phase );
	extern virtual task collect_transactions( uvm_phase phase );

endclass : monitor_out

extern function monitor_out::new (string name, uvm_component parent);
	super.new(name, parent);

	resp_port = new("resp_port",this);

endfunction : new

extern virtual function monitor_out::build_phase ( uvm_phase phase );
	super.build(phase);

	assert(uvm_config_db#(interface_mvif)::get(this, "", "mvif", mvif))begin
		`uvm_fatal("NOVIF", "failed to get virtual interface")
	end

	tr_out = transaction_out::type_id::create("tr_out",this);

endfunction : build_phase

extern virtual task monitor_out::run_phase ( uvm_phase phase );
	super.run(phase);

	fork
		collect_transactions(phase);
	join

endtask : run_phase

//olhar isso aqui direito pq acho q ta muito errado
extern virtual task monitor_out::collect_transactions( uvm_phase phase );

	forever begin
		@(posedge mvif.clk)begin
			if(vif.busy_o)begin
				@(negedge vif.busy_o)
				begin_tr(tr_out, "resp");
					tr_out.result = mvif.dt_o;
					resp_port.write(tr_out);
					@(negedge mvif.clk)
				end_tr(tr_out);
			end
		end
	end

endtask