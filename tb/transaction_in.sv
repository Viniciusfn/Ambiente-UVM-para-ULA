class transaction_in extends uvm_sequence_item;​

  rand bit [15:0] dt_A;​
  rand bit [1:0]  reg_sel;
  rand bit [1:0]  instru;
  rand bit [15:0] dt_in;
  rand bit [1:0]  addr;

  function new(string name = "");​
    super.new(name);​
  endfunction​

  `uvm_object_param_utils_begin(transaction_in)​
    `uvm_field_int(dt_A, UVM_UNSIGNED)
    `uvm_field_int(reg_sel, UVM_UNSIGNED)
    `uvm_field_int(instru, UVM_UNSIGNED)
    `uvm_field_int(dt_in, UVM_UNSIGNED)
    `uvm_field_int(addr, UVM_UNSIGNED)
  `uvm_object_utils_end​

  function string convert2string();​
    return $sformatf("{isntru = %d, A = %d, dt_in = %d, addr = %d, reg_sel = %d}", instru, dt_A, dt_in, addr, reg_sel);​
  endfunction​

endclass