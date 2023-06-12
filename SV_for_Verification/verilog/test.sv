module test1;
	initial begin
		for (int i=0 ; i<10; i++)
            fork
                automatic int j = i;
                $display("No%0d,My face_grade is %0d", j ,j );
            join_none
		#0 $display("end\n");
        //or wait fork; $display("end\n");
	end
endmodule