class transaction;
	/*定义事务项目*/
	rand bit [1:0] addr;
	rand bit wr_en;
	rand bit rd_en;
	rand bit [7:0] wdata;
	bit [7:0] rdata;
	bit [1:0] cnt;
	/*由于读写不能同时操作，所以施加约束*/
	constraint wr_rd_c {wr_en != rd_en;};
endclass