interface interface_if(input clk_ula, clk_reg, rst);​

  logic [15:0] A;
  logic [31:0] data_out;
  logic [1:0]  reg_sel;
  logic [1:0]  instru;
  logic        valid_ula;
  logic [15:0] data_in;
  logic [1:0]  addr;
  logic        valid_reg;
  logic        valid_out;

  modport mst(input clk_ula, clk_reg, rst,
  				output A, reg_sel, instru, valid_ula, data_in, addr, valid_reg);​

  modport slv(input clk_ula, clk_reg, rst, A,
  				 reg_sel, instru, valid_ula, data_in, addr, valid_reg,
  				output data_out, valid_out);​

endinterface