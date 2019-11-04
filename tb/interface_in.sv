interface interface_in(input clk_ula, clk_reg, rst);​

  logic [15:0] A;
  logic [1:0]  reg_sel;
  logic [1:0]  instru;
  logic        valid_ula;
  logic [15:0] data_in;
  logic [1:0]  addr;
  logic        valid_reg;

  modport mst(input clk_ula, clk_reg, rst, output A, reg_sel, instru, valid_ula, data_in, addr, valid_reg);​
  modport slv(input clk_ula, clk_reg, rst, A, reg_sel, instru, valid_ula, data_in, addr, valid_reg);​
endinterface