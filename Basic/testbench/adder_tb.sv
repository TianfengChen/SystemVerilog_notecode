module testbench;
logic clk;
logic reset;
logic [3:0] a1;
logic [3:0] a2;
logic [3:0] b1;
logic [3:0] b2;
logic sel;
logic [3:0] sum;
logic carry;

integer file;

adder #(.add_bit(4)) adder1
(
    .*
);

always 
begin 
    #5 clk = ~clk;
end

//file read
initial begin
    file = $fopen("./testbench.txt","r");
    clk = 0;
    reset = 0;
    #20 reset = 1;
    while (!$feof(file)) begin
        @(negedge clk);
        $fscanf(file,"%d %d %d %d %d",a1,a2,b1,b2,sel);
        $display("a1 = %d, a2 = %d, b1 = %d, b2 = %d, sel = %d, sum = %d, carry = %d",a1,a2,b1,b2,sel,sum,carry);
    end
    
    $fclose(file);
    #10 $finish;
end

endmodule