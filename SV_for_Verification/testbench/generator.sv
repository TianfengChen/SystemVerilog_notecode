class generator;
/* 发生器用于生成随机化的事务；并向驱动器发送这些事务 */

	/*定义一个事务句柄*/
	rand transaction trans;
	
	/* 定义信箱 */
	mailbox gen2driv;
	
	/* 定义最大事务数 */
	int repeat_count;
	
	/*生成结束事件*/
	event ended;
	
	/* 从evn类获得信箱 */
	function new(mailbox gen2driv,event ended);
		this.gen2driv = gen2driv;
		this.ended = ended;
	endfunction
	
	/* main task，用来生成并随机化数据包，放入信箱 */
	task main();
		repeat (repeat_count) begin
			trans = new();
			if (!trans.randomize()) $fatal("Gen::trans randomization failed");
			gen2driv.put(trans);
		end
		-> ended;
	endtask

endclass