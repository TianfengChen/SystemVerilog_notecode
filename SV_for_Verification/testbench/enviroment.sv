`include"transaction.sv"
`include"generator.sv"
`include"driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
/* env是包含了发生器，驱动器和信箱的类 */
	
	generator gen;
	driver driv;
	monitor mon;
	scoreboard scb;
	
	mailbox gen2driv;
	mailbox mon2scb;
	
	/* 发生器和测试的同步事件 */
	event gen_ended;
	
	virtual mem_intf mem_vif;
	
	function new(virtual mem_intf mem_vif);
		/* 从测试类中获取接口 */
		this.mem_vif = mem_vif;
		
		/* 创建信箱句柄 */
		gen2driv = new();
		mon2scb = new();
		
		/* 实例化发生器和驱动器 */
		gen = new(gen2driv,gen_ended);
		driv = new(mem_vif,gen2driv);
		mon = new(mem_vif,mon2scb);
		scb = new(mon2scb);
	endfunction
	
	/* 发生器和驱动器的活动按照以下三部分 */
	task pre_test();
		driv.reset();
	endtask
	
	task test();
		fork
			gen.main();
			driv.main();
			mon.main();
			scb.main();
		join_any
	endtask
	
	task post_test();
		wait(gen_ended.triggered);
		wait(gen.repeat_count == driv.no_transactions);
		wait(gen.repeat_count == scb.no_transactions);
	endtask
	
	/* 使用run任务启动上述活动 */
	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask
endclass