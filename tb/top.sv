module top;
	import uvm_pkg::*;
	import pkg::*;
	
	logic clk;
	logic rst;

	initial begin
		clk = 1;
		rst = 1;
		#20 rst = 0;
		#20 rst = 1;
	end

	always #10 clk = !clk;

	interface_if dut_if(	
					.clk_ula(clk),
					.clk_reg(clk),
					.rst(rst)
				);​
/*
	interface_out dut_out(	
							.clk_ula(clk),
							.clk_reg(clk),
							.rst(rst)
						);​
*/
	datapath DUT(
					.clk_ula(clk),
					.clk_reg(clk),
					.rst(rst),
		
					.valid_reg(dut_if.valid_reg),
					.addr(dut_if.addr),
					.data_in(dut_if.data_in),
		
					.reg_sel(dut_if.reg_sel),
		
					.valid_ula(dut_if.valid_ula),
					.instru(dut_if.instru),
					.A(dut_if.A),

					.data_out(dut_if.data_out),
					.valid_out(dut_if.valid_out)
				);

	initial begin​
		`ifdef XCELIUM​
			$recordvars();​
		`endif​
		`ifdef VCS​
			$vcdpluson;​
		`endif​
		`ifdef QUESTA​
			$wlfdumpvars();​
			set_config_int("*", "recording_detail", 1);​
		`endif​
	end

  initial begin
    uvm_config_db#(interface_vif)::set(uvm_root::get(), "*", "vif", dut_if);
  end

  initial begin
    run_test("test");​
  end

endmodule