`define DRIV_IF mem_vif.DRIVER.driver_cb
class driver;
/* 驱动器用于接受发生器生成的事务，并通过接口驱动给DUT */
	
	/*创建虚接口句柄*/
	virtual mem_intf mem_vif;
	
	/* 创建信箱句柄 */
	mailbox gen2driv;
	
	/*事务数目*/
	int no_transactions;
	
	/* 构造函数 */
	function new(virtual mem_intf mem_vif, mailbox gen2driv);
		/*获取接口和信箱*/
		this.mem_vif = mem_vif;
		this.gen2driv = gen2driv;
	endfunction
	
	/*清零任务*/
	task reset;
		wait(mem_vif.reset);
		$display("-------[DRIVER] Reset Started-------");
		`DRIV_IF.wr_en <= 0;
		`DRIV_IF.rd_en <= 0;
		`DRIV_IF.addr <= 0;
		`DRIV_IF.wdata <= 0;
		wait(!mem_vif.reset);
		$display("--------[DRIVER] Reset Ended--------");
	endtask
	
	/* 将事务项目驱动到接口信号 */
	task main;
		forever begin
			transaction trans;
			`DRIV_IF.wr_en <= 0;
			`DRIV_IF.rd_en <= 0;
			gen2driv.get(trans);
			$display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
			
			@(posedge mem_vif.DRIVER.clk);
				`DRIV_IF.addr <= trans.addr;
			if (trans.wr_en) begin
				`DRIV_IF.wr_en <= trans.wr_en;
				`DRIV_IF.wdata <= trans.wdata;
				$display("\tADDR = %0h \tWDATA = %0h", trans.addr, trans.wdata);
				@(posedge mem_vif.DRIVER.clk);
			end
			
			if (trans.rd_en) begin
				`DRIV_IF.rd_en <= trans.rd_en;
				@(posedge mem_vif.DRIVER.clk);
				`DRIV_IF.rd_en <= 0;
				@(posedge mem_vif.DRIVER.clk);
				trans.rdata = `DRIV_IF.rdata;
				$display("\tADDR = %0h \tRDATA = %0h", trans.addr,`DRIV_IF.rdata);
			end
			$display("-------------------------");
			no_transactions++;
		end
	endtask
endclass