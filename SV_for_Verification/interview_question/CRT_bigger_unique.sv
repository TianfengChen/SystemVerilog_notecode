class rand_p;
  rand bit [4:0] numbers[10];

  // Constraint block
  constraint unique_numbers {
    // Sort numbers in ascending order
    foreach (numbers[i]) {
      numbers[i] inside {[0:$]}; // Generate numbers between 0 and the maximum value
    }
    // Ensure each number is greater than the previous one
    foreach (numbers[i]) {
      if (i > 0) {
        numbers[i] > numbers[i - 1];
      }
    }
  }
endclass

        
module UniqueNumberGenerator;
  rand_p r;
  initial begin
    r = new();
    assert(r.randomize());
    $display("Generated unique numbers:");
    foreach (r.numbers[i]) begin
        $display("Number[%0d] = %0d", i, r.numbers[i]);
    end
    $finish;
  end

endmodule