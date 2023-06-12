
//assertion(cover also available)
//direct assertion
assert1: assert (a==b);//error: a!=b
else $error("a!=b");
//concurrent assertion
//I1|=>I2|=>I3 === I1 ##1 I2 ##1 I3
//I1|->I2|->I3 === I1 && I2 && I3
//[*n] means sequential n times
//[*m:n] means sequential m-n times
//[=n] menas unsequential n times
//and next clock no need next condition to be true
//a ##1 b[=2] ##1 c
//a1 b0 b1 b0 b0 b1 b0 b0 c ok
//[->n] means unsequential n times
//and next clock need next condition to be true
//a ##1 b[->2] ##1 c
//a1 b0 b1 b0 b0 b1 c
//$rose(): LSB change from 0 to 1
//$fell(): LSB change from 1 to 0
//$stable(): LSB is stable
//$past(expr, [n]): expr value n clock ago
//1st level sequence:
sequence cks1;
    @(posedge clk)
    intr |=> iack ##1 data_enable[*2] ##1 done[*1:3];
endsequence
sequence cks2;

//2nd level property:like function
property ckp(ack,a,b);
    disable iff (ack)
    cks1;
    not @(clk) a |=> b;
endproperty
ap: assert property(ckp(ack,a,b));



