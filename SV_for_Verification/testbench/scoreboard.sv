class scoreboard;
/* 接收监视器发送的采样数据； 如果是读事务，比较读到的数据和局部内存数据； 如果是写事务，局部内存则会进行储存 */
	
	mailbox mon2scb;
	
	int no_transactions;
	
	bit [7:0] mem[4];
	
	function new(mailbox mon2scb);
		this.mon2scb = mon2scb;
		foreach(mem[i]) mem[i] = 8'hFF;
	endfunction
	
	
	task main;
		transaction trans;
		
		forever begin
			//#50; 			mon2scb.get(trans);
			/* 读数据 */
			if (trans.rd_en) begin
				if (mem[trans.addr] != trans.rdata)
					$error("[SCB-FAIL] Addr = %0h,\n \t Data :: Expected = %0h Actual = %0h",
					trans.addr,mem[trans.addr],trans.rdata);
				else
					$display("[SCB-PASS] Addr = %0h,\n \t Data :: Expected = %0h Actual = %0h",
					trans.addr,mem[trans.addr],trans.rdata);
			end
			/* 写数据 */
			else if (trans.wr_en)
				mem[trans.addr] = trans.wdata;
			
			no_transactions++;
		end
	endtask

endclass