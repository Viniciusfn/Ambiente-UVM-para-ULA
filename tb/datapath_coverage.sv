

class datapath_coverage_in extends uvm_subscriber#(transaction_in);

	`uvm_component_utils(datapath_coverage_in)

	transaction_in tr_in;
	real cov_num;

	uvm_analysis_imp#(transaction_in, datapath_coverage_in) covi;

	extern function new(string name = "datapath_coverage_in", uvm_component parent = null);
	extern function void sample ();
	extern function void write (transaction_in t);
	extern function void extract_phase(uvm_phase phase);    
    extern function void report_phase(uvm_phase phase);
   	
   	covergroup cov_input();
		option.name = "cov_input";
		option.per_instance = 1;

		// bins for covering inputs 

		cov_instru: coverpoint tr_in.instru {
		bins operation[] = {[0:$]};
		}
		
		cov_addr: coverpoint tr_in.addr {
		bins address[] = {[0:$]}; 
		}

		cov_reg_sel: coverpoint tr_in.reg_sel {
		bins reg_sel_bin = {[0:$]};
		}

		cov_dt_A: coverpoint tr_in.dt_A {
		bins dt_A_lo = {[$:300]};
		bins dt_A_hi = {[65036:$]};
		}
		cov_dt_in: coverpoint tr_in.dt_in {
		bins dt_in_lo = {[$:300]};
		bins dt_in_hi = {[65036:$]};
		}
	endgroup : cov_input

endclass : datapath_coverage_in

////////////////////////////BODY///////////////////////////////////

function datapath_coverage_in::new(string name = "datapath_coverage_in", uvm_component parent = null);
	super.new(name, parent);
	cov_input = new();
	covi = new("covi", this);
endfunction : new


function void datapath_coverage_in::sample();
	cov_input.sample();
endfunction

function void datapath_coverage_in::write(transaction_in t);
	this.tr_in = t;
	cov_input.sample();
endfunction :write

function void datapath_coverage_in::extract_phase(uvm_phase phase);    
  cov_num=cov_input.get_coverage();
endfunction:extract_phase

function void datapath_coverage_in::report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),$sformatf("Coverage is %d",cov_num),UVM_MEDIUM)
 endfunction : report_phase

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class datapath_coverage_out extends uvm_subscriber#(transaction_out);

	`uvm_component_utils(datapath_coverage_out)

	transaction_out tr_out;
	real cov_num;
	uvm_analysis_imp#(transaction_out, datapath_coverage_out) covo;


	extern function new(string name = "datapath_coverage_out", uvm_component parent = null);
	extern function void sample ();
	extern function void write(transaction_out t); 
	extern function void extract_phase(uvm_phase phase);    
  	extern function void report_phase(uvm_phase phase);
   
	covergroup cov_output();
	   	option.name = "cov_output";
		option.per_instance = 1;

		cov_out: coverpoint tr_out.result {
		illegal_bins overflow = {[18'h20000:$]};
		bins result_lo = {[$:300]};
		bins result_hi = {[(18'h20000-500):$]};
		}

	endgroup : cov_output


endclass : datapath_coverage_out

////////////////////////////BODY///////////////////////////////////

function datapath_coverage_out::new(string name = "datapath_coverage_out", uvm_component parent = null);
	super.new(name, parent);
	cov_output = new();
	covo = new("covo", this);
endfunction : new


function void datapath_coverage_out::sample();
	cov_output.sample();
endfunction


function void datapath_coverage_out::write(transaction_out t);
	this.tr_out = t;
	cov_output.sample();
endfunction : write

function void datapath_coverage_out::extract_phase(uvm_phase phase);    
    cov_num=cov_output.get_coverage();
endfunction:extract_phase

function void datapath_coverage_out::report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),$sformatf("Coverage is %d",cov_num),UVM_MEDIUM)
endfunction:report_phase
