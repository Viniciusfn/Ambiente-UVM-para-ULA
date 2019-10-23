interface interface_out(input clk_ula, clk_reg, rst);​

  logic [31:0] data_out;
  logic        valid_out;

  modport mst(input clk_ula, clk_reg, rst, data_out, valid_out);​
  modport slv(input clk_ula, clk_reg, rst, output data_out, valid_out;​
endinterface