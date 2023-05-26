//interface
interface arb_if(input bit clk);
    logic [1:0] grant,request;
    logic rst;
    //modport make sure the signal direction
    //clocking make sure the trigger edge
    clocking cb @(posedge clk);
        output request;
        input grant;
    endclocking

    modport TEST(
        clocking cb,
        output rst
    );
    //design under test
    modport DUT(
        input request,rst,clk
        output grant
    );

    modport MONITOR(
        input clk,grant,request,rst
    );
endinterface

module test(arb_if.TEST arb);
    ...
endmodule

module arbitor (arb_if.DUT arb);
    ...
    if (arb.cb.rst)//dont forget .cb.
    ...
endmodule

module top;
    bit clk;
    always
        #5 clk = ~clk;
    
    arb_if arb(clk);
    arbitor rbt(arb);

endmodule


//timing problem
//blocking assignment
module mem(input bit start);
    always_ff @(posedge start)
        ...
endmodule

initial begin
    start = 0;
    #10 
    data  = 1;//assign first
    start = 1;

end
    
//timing driver
//use non-blocking assignment, DUT capture the value at the next clock cycle


##2 //two clock period

initial forever begin//no always in initial block, use forever as substitute
    
end

//monitor
$monitor


//assertion
assert1: assert (a==b);//error: a!=b
else $error("a!=b");
