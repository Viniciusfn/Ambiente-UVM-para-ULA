`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class coverage extends uvm_component;​
  `uvm_component_utils(coverage)​

  //transaction_in req;​
  uvm_analysis_imp_in#(transaction_in, coverage) req_port;​
  uvm_analysis_imp_out#(transaction_out, coverage) resp_port;​

  int min_tr = 20000​0;
  int n_tr = 0;​
  event end_of_simulation;​

  function new(string name = "coverage", uvm_component parent= null);​
    super.new(name, parent);​
    req_port = new("req_port", this);​
    resp_port = new("resp_port", this);

  
  endfunction​

  function void build_phase(uvm_phase phase);​
    super.build_phase (phase);​

  endfunction​

  task run_phase(uvm_phase phase);​
    phase.raise_objection(this);​
    @(end_of_simulation);​
    phase.drop_objection(this);​

  endtask: run_phase​

  function void write_in(transaction_in t);​
    n_tr = n_tr + 1;​
    if(n_tr > min_tr)begin​
      ->end_of_simulation;​
    end​   
  endfunction

  function void write_out(transaction_out t);​
     
  endfunction

endclass : coverage​