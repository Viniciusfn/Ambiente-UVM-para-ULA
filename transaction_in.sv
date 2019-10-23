class transaction_in extends uvm_sequence_item;​

  rand bit [15:0] dt_A;​
  rand bit [15:0] dt_B;
  rand bit [1:0] dt_instru;

  function new(string name = "");​
    super.new(name);​
  endfunction​

// não sei se isto está certo
  `uvm_object_param_utils_begin(transaction_in)​
    `uvm_field_int(dt_A, UVM_UNSIGNED)
    `uvm_field_int(dt_A, UVM_UNSIGNED)
    `uvm_field_int(dt_instru, UVM_UNSIGNED)​
  `uvm_object_utils_end​

  function string convert2string();​
    return $sformatf("{isntru = %d: A = %d, B = %d}", dt_instru, dt_A, dt_B);​
  endfunction​

endclass