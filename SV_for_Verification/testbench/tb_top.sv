`include "interface.sv"
`include "test.sv"
`include "design.sv"
module tbench_top;
/* 最顶层的文件，用于连接DUT和验证平台； 包含DUT，测试以及接口实例； 接口能将DUT与验证平台相连 */
	
	bit clk;
	bit reset;
	
	/* 实例化接口 */
	mem_intf intf(clk,reset);
	
	/* 实例化DUT，并配置接口 */
	memory DUT (
		.clk(intf.clk),
		.reset(intf.reset),
		.addr(intf.addr),
		.wr_en(intf.wr_en),
		.rd_en(intf.rd_en),
		.wdata(intf.wdata),
		.rdata(intf.rdata)
	);
	
	/* 连接测试接口 */
	test t1(intf);
	
	always #5 clk = ~clk;
	
	initial begin
		reset = 1;
		#5 reset=0;
	end
	
	initial begin
		$dumpfile("dump.vcd");$dumpvars;
	end
endmodule