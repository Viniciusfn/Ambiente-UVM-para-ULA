class transaction_in extends uvm_sequence_item;​

  rand bit [15:0] dt_A;​
  rand bit [1:0]  tr_reg_sel;
  rand bit [1:0]  tr_instru;
  rand bit        tr_valid_ula;
  rand bit [15:0] dt_in;
  rand bit [1:0]  tr_addr;
  rand bit        tr_valid_reg;

  function new(string name = "");​
    super.new(name);​
  endfunction​

// não sei se isto está certo
  `uvm_object_param_utils_begin(transaction_in)​
    `uvm_field_int(dt_A, UVM_UNSIGNED)
    `uvm_field_int(tr_reg_sel, UVM_UNSIGNED)
    `uvm_field_int(tr_instru, UVM_UNSIGNED)
    `uvm_field_int(tr_valid_ula, UVM_UNSIGNED)
    `uvm_field_int(dt_in, UVM_UNSIGNED)
    `uvm_field_int(tr_addr, UVM_UNSIGNED)
    `uvm_field_int(tr_valid_reg, UVM_UNSIGNED)
  `uvm_object_utils_end​

  function string convert2string();​
    return $sformatf("{isntru = %d: A = %d, B = %d}", dt_instru, dt_A, dt_B);​
  endfunction​

endclass