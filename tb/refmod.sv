import "DPI-C" context function int my_ULA(int A, int B, int instru);

class refmod extends uvm_component;
  `uvm_component_utils(refmod)​

  transaction_in tr_in;​
  transaction_out tr_out;​
  uvm_analysis_imp #(transaction_in, refmod) in;​
  uvm_analysis_port #(transaction_out) out; ​
  event begin_refmodtask, begin_record, end_record, begin_regrecord, end_regrecord;​
  bit [15:0] B;
  bit [15:0] registers [3:0];

  function new(string name = "refmod", uvm_component parent = null);​
    super.new(name, parent);​
    in = new("in", this);​
    out = new("out", this);​
    reg_reset();
  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​
    tr_out = transaction_out::type_id::create("tr_out", this);​

  endfunction: build_phase​

  virtual task run_phase(uvm_phase phase);​
    super.run_phase(phase);​
    fork​
      refmod_task();​
      reg_record();
      record_tr();​
    join​
  endtask: run_phase​

  task refmod_task();​
    forever begin​
      @begin_refmodtask;​
      tr_out = transaction_out::type_id::create("tr_out", this);​
      -> begin_record;​
      tr_out.result = my_ULA(tr_in.dt_A, B, tr_in.instru);
      #10;​
      -> end_record;​
      out.write(tr_out);​
    end​

  endtask : refmod_task​

  ​virtual function write (transaction_in t);​
    tr_in = transaction_in#()::type_id::create("tr_in", this);​
    tr_in.copy(t);​
    -> begin_regrecord;
    @(end_regrecord);
    -> begin_refmodtask;​
  endfunction​

  task reg_record();
    @begin_regrecord;
    registers[tr_in.addr] = tr_in.dt_in;
    B = registers[tr_in.reg_sel];
    -> end_regrecord;
  endtask

  virtual task record_tr();​
    forever begin​
      @(begin_record);​
      begin_tr(tr_out, "refmod");​
      @(end_record);​
      end_tr(tr_out);​
    end​
  endtask​ 

  function reg_reset();
    registers[0] = 16'hC4F3;
    registers[1] = 16'hB45E;
    registers[2] = 16'hD1E5;
    registers[3] = 16'h1DE4;
  endfunction

endclass: refmod​
