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

//event
//event@ is a variable, it can be used to trigger a thread(thread will wait for the event to be triggered)

//event can be triggered by ->, .notify, @
//trigger event:
//-> event_name
//blocked by event:
//@ event_name
//wait trigger event:
//wait(event_name.triggered());

//locked by missing event
event el,e2; 
initial begin
	$display("@% 0t:1:before trigger",$time);
	->el;
	//@e2; //sensitive to edge, replaced by level sensitive wait
	wait (e2. triggered()); 
	$display("@% 0t:1:after trigger",$time); 
end 
initial begin $display("@% 0t:2:before trigger",$time);
	->e2;
	//@e1;
	wait(el. triggered());
	display("@% 0t:2:after trigger",$time); 
end

//no need as a global event, but as handle to share with obj
//event transferred into constructor new()

class Generator;
	event e;

	function new(event e);
		this.e = e;
	endfunction

	task run();
		fork
			begin
				#10;
				->e;
				$display("e triggered");
			end
		join_none
	endtask
endclass

program automatic test;
	event e;
	Generator gen;

	initial begin
		gen = new(e)
		gen.run();
		#20;
		$display("trigger e");
		->e;
		wait(gen.e.triggered());
	end
endprogram

//wait for many events
//solution 1: wait wait_trigger fork
parameter N_GEN = 3;
event done[N_GEN];
initial begin
	//create generator
	foreach(gen[i]) begin
		gen[i] = new(done[i]);
		gen[i].run();
	end
	//wait for all generator done
	foreach(done[i]) begin
		fork
			automatic int k = i;
			wait(done[k].triggered());
		join_none
		wait fork;//wait for all fork to finish
	end
end
//solution 2: wait counter
parameter N_GEN = 3;
event done[N_GEN];
int done_num = 0;
initial begin
	//create generator
	foreach(gen[i]) begin
		gen[i] = new(done[i]);
		gen[i].run();
	end
	foreach(gen[i])begin
		fork
			begin
			automatic int k = i;
				wait(done[k].triggered());
				done_num++;
			end
		join_none
		wait(done_num == N_GEN);
	end
end

//solution 3: use static variable to count
class Generator;
	static int count=0;
	task run();
		count++;
		fork
			begin
				//execute
				count--;
			end
		join_none
	endtask
endclass

Generator gen[N_GEN];
initial begin
	foreach(gen[i])
		gen[i] = new();
	foreach(gen[i])
		gen[i] = new();
	wait(Generator::count==0);
end

//semaphore exclussive access(lock)
//new(num) will initialize a semaphore with num
//get() will block if semaphore is 0, put() will release semaphore
//use semaphore to abtain exclussive access to a resource(bus)
program automatic test(bus.TB bus);
	semaphore bus_lock;
	initial begin
		bus_lock = new(1);
		fork
			sequencer();
			sequencer();//produce two bus event thread
		join
	end

	task sequencer();
		fork
			sendTrans();
		join_none
	endtask

	task sendTrans();
				//wait for bus_lock
				bus_lock.get(1);
				//execute
				...
				//send bus transaction
				bus_lock.put(1);
	endtask
endprogram

//mailbox
//generator---driver
//avoid shallow copy, use new() to create a new object, parameter is the size of mailbox
//mailbox is a queue, can be used to transfer object between threads
//put() will block if mailbox is full, get() will block if mailbox is empty

task generator(mailbox mbx);
	Transaction t;
	repeat(10) begin
		t = new();
		t.randomize();
		mbx.put(t);
	end
endtask

task driver(mailbox mbx);
	Transaction t;
	repeat(10) begin
		mbx.get(t);
	end
endtask


//mail box in class and connect generator and driver
class Generator;
	mailbox mbx;
	Transaction t;

	function new(mailbox mbx);
		this.mbx = mbx;
	endfunction

	task run(int n);
		repeat(n)
		begin
			tr = new();
			assert(tr.randomize());
			mbx.put(tr);
		end
	endtask
endclass

class Driver;
	mailbox mbx;
	Transaction t;

	function new(mailbox mbx);
		this.mbx = mbx;
	endfunction

	task run(int n);
		repeat(n) begin
			mbx.get(t);
		end
	endtask
endclass

initial begin
	int count = 10;
	mailbox mbx = new(11);//size of mailbox is 11
	Generator gen = new(mbx);
	Driver drv = new(mbx);
	fork
		gen.run(count);
		drv.run(count);
	join
end

//asynchronous mailbox
//peek() will return the next object in mailbox, but not remove it
//no synchronizor, no blocking
initial begin
	mbx = new();//new(1);  //use size 1 mailbox to synchronize
	fork
		p.run();//thread 1 will not be blocked until it finished executing
		c.run();
	join
end

//use shakehand event to synchronize
program automatic skhd_evt;
	mailbox mbx;
	event handshake;
	class Generator;
		task

//use semaphore to synchronize

//use rx and tx mailbox to synchronize





