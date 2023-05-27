`define MON_IF mem_vif.MONITOR.monitor_cb
class monitor;
/* 采样接口信号，并转化信号级活动为事务级活动； 将采样到的事务通过信箱送往记分板； */

	virtual mem_intf mem_vif;
	
	mailbox mon2scb;
	
	function new(virtual mem_intf mem_vif, mailbox mon2scb);
		this.mem_vif = mem_vif;
		this.mon2scb = mon2scb;
	endfunction
	
	/* 主任务，实现采样逻辑，并送往记分板 */
	task main;
		forever begin
			transaction trans;
			trans = new();
			
			@(posedge mem_vif.MONITOR.clk);
			wait(`MON_IF.rd_en || `MON_IF.wr_en);
			trans.addr = `MON_IF.addr;
			trans.wr_en = `MON_IF.wr_en;
			trans.wdata = `MON_IF.wdata;
			if (`MON_IF.rd_en) begin
				trans.rd_en = `MON_IF.rd_en;
				@(posedge mem_vif.MONITOR.clk);
				@(posedge mem_vif.MONITOR.clk); 
				trans.rdata = `MON_IF.rdata;
			end
			mon2scb.put(trans);
		end
	endtask
endclass