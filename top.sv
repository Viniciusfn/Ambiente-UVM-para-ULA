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

	interface_in dut_in(	
							.clk_ula(clk),
							.clk_reg(clk),
							.rst(rst)
						);​

	interface_out dut_out(	
							.clk_ula(clk),
							.clk_reg(clk),
							.rst(rst)
						);​

	datapath DUT(
					.clk_ula(clk),
					.clk_reg(clk),
					.rst(rst),
		
					.valid_reg(dut_in.valid_reg),
					.addr(dut_in.addr),
					.data_in(dut_in.data_in),
		
					.reg_sel(dut_in.reg_sel),
		
					.valid_ula(dut_in.valid_ula),
					.instru(dut_in.instru),
					.A(dut_in.A),

					.data_out(dut_out.data_out),
					.valid_out(dut_out.valid_out)
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

endmodule