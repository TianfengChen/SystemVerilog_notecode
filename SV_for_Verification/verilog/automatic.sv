//automatic key word make variable stored in stack and heap of the function/task/thread memory space.
//1.unable to use recursion
module tryfact;
// define the function
  function integer factorial (input [31:0] operand);
    if (operand >= 2)
      factorial = factorial (operand - 1) * operand;
    else
      factorial = 1;
   endfunction: factorial
// test the function
  integer result;
  initial begin
    for (int n = 0; n <= 7; n++) begin
      result = factorial(n);
      $display("%0d factorial=%0d", n, result);
    end
  end
endmodule: tryfact
// output always 1, the function return value is statically stored in one memory allocated
// everytime the data in memory was renewed
//modified version: add automatic in function


//2. thread data race
module test();
 
task add(int a, int b);
	#2;
	$display("the sum is %0d", a+b);
endtask
 
initial
	fork
		begin
			add(2,3);
		end
		begin
			#1;
			add(3,4);
		end
	join
endmodule
/*
@0, add(2+3), a=2, b=3
@1, add(3+4), a=3, b=4
@2, display 7
@3, display 7
*/
//modified version:
//add automatic in module

//3.the order of thread construction and data update
//join_none would not stop to wait thread
//first thread was constructed, then the data was updated
module test1;
	initial begin
		for (int i=0 ; i<10; i++)
            fork
            $display("No%0d,My face_grade is %0d", i ,i );
            join_none
		#0 $display("end\n");
	end
endmodule
//all 10
//modified version:
module test1;
	initial begin
		for (int i=0 ; i<10; i++)
      fork
      automatic int j = i;
      $display("No%0d,My face_grade is %0d", j ,j );
      join_none
		//#0 $display("end\n");//avoid to use #0
    wait fork;
    $display("end\n");
	end
endmodule

