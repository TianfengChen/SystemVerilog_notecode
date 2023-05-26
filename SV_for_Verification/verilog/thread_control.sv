//fork join thread control, block will be executed in concurrent
//fork join: fork will create a new thread, join will wait for all code in block to finish
//fork join_none: code after join_none will be executed in order at the same time with the block
//fork join_any: code after join_none will be executed in order after any one sentence was executed in the block
//code in begin end will execute in order
//fork join in class
class Gen_drive;
    task run(int n);
        rand_packet p;
        fork
            repeat(n) begin
                p = new();
                p.randomize();
                transmit(p);
            end
        join_none //make run not blocking
    endtask

    task transmit(input rand_packet p);
    endtask
endclass

//dynamic thread, no need to specify thread number, call a thread when needed
program automatic test();
    task check_trans();
        fork
            ...
        join_none
        wait fork;
    endtask

    Trans tr;
    initial begin
        repeat(10) begin
            tr=new();
            assert(tr.randomize());
            transmit(tr);
            check_trans(tr);
        end
        #0 display("finish");
    end
endprogram

//automatic variable, make all variable stored in stack, tr will not be shared between threads
initial begin
	for(int j = 0; j < 3; j++)
		fork
			automatic int k = j;		//创建索引的拷贝
			$write(k);
		join_none
	
	# 0 $display;
end
/*
在每轮循环中，k的一个拷贝被创建并且被设置为j的当前值，
然后fork...join_none($write)被调度，包括k的拷贝，
在循环完成后，#0阻塞了当前进程，因此三个进程一起运行，打印出各自拷贝值k，
当线程运行完成后，在当前时间片已经没有其他事件残留，这时SV就会前进到下一个语句执行$display
*/
//watch out! if i is defined in global, it will be shared between threads, and thread will have data race to modify the i

//stop a thread
//disable a timeout threads
parameter TIME_OUT = 1000;
task check_trans(Transaction tr);
    
    fork
        //thread 0
        check_trans();
    join

	fork
		begin
			//等待回应，或者达到某个最大时延
			fork : timeout_block		//用disable停止的署名块
            //thread 1
				begin
					wait(bus.cb.addr == tr.addr);
					$display("@%0t: Addr match %d", $time, tr.addr);
				end
            //thread 2
				# TIME_OUT $display("@%0t: Error: timeout", $time);
			join_any
			disable timeout_block;//thread 1 and 2 will be disabled, but not thread 0
		end
	join_none
endtask 

task wait_for_time_out(int id);
	if(id == 0)
		fork
			begin
				# 2;
				$display("@%0t: disable wait_for_time_out", $time);
				disable wait_for_time_out;
			end
		join_none
	
	fork : just_a_little
		begin
			$display("@%0t: %m: %0d entering thread", $time, id);
			# TIME_OUT;
			$display("@%0t: %m: %0d done", $time, id);
		end
	join_none
endtask

initial begin
	wait_for_time_out(0);		//衍生线程0
	wait_for_time_out(1);		//衍生线程1
	wait_for_time_out(2);		//衍生线程2
	# (TIME_OUT * 2) $display("@%0t: All done", $time);
end
/*
如果在某个任务内部禁止该任务，这就像时任务的返回语句，但是这也会停止所有由该任务启动的线程。
任务被调用三次，衍生了三个线程，线程0在#2延时之后禁止了该任务，导致三个线程最终都没完成。
*/
