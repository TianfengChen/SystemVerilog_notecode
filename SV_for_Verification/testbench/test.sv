`include"environment.sv"
program test(mem_intf intf);
	/* 创建环境，配置验证条件，初始化验证 */
	
	environment env;
	
	initial begin
		/* 实例化环境类 */
		env = new(intf);
		
		/* 设置事务数目 */
		env.gen.repeat_count = 10;
		
		/* 启动环境 */
		env.run();
	end
	
endprogram