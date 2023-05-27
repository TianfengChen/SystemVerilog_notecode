interface mem_intf(input logic clk,reset);
/* 接口用于将信号捆绑，并指定方向，同步信号 */
	
	logic[1:0] addr;
	logic wr_en;
	logic rd_en;
	logic [7:0] wdata;
	logic [7:0] rdata;
	
	/* 驱动器时钟块 */
	clocking driver_cb @(posedge clk);
		default input #1 output #1;
		output addr;
		output wr_en;
		output rd_en;
		output wdata;
		input rdata;
	endclocking
	
	/* 监视器时钟块 */
	clocking monitor_cb @(posedge clk);
		default input #1 output #1;
		input addr;
		input wr_en;
		input rd_en;
		input wdata;
		input rdata;
	endclocking
	
	/* 驱动器modport */
	modport DRIVER (clocking driver_cb, input clk, reset);
	
	/* 监视器modport */
	modport MONITOR (clocking monitor_cb, input clk, reset);
	
	
endinterface