//random 
$random(max) //number between 0 and max-1
{$random()} % max

//rand variable
class Days;
    typedef enum{
        SUN,MON,TUE,WED,THU,FRI,SAT
    } day_;
    day_e choices[$];//queue
    rand day_e today;
    constraint cday{today inside choices}
endclass

class rand_packet;
    bit judge;
    rand bit [31:0] src_addr,dst_addr,data[8];
    randc bit [7:0] kind;//only when all possible values are shown, the value can be repeated
    int fib[5] ='{1,3,4,5,7};
    //rand bit [7:0] d[];//bit is unsigned, better not use byte, int which is signed
    rand uint d[];//uint is unsigned
    int max_value;
    

    //constraint
    constraint c1 {src_addr > 60; src_addr < 1000;}
    constraint c2 { if (judge)//C++ style
                    {
                        dst_addr inside {[$:255]};//0-255
                    }
                    else
                    {
                        dst_addr inside {256,fib};
                        src_dest == 0;// ==  !
                    }
                }
    //weight :=  :/
    constraint c3 {0:/40,[1:$]:/60}//1-max
    constraint c4 {(src_addr == dst_addr) -> data==0;}//"->" means if then
    constraint c5 {d.size() inside {[1:10]};}//array size should be constrained
    constraint c6 {d.sum() <1024;}//better not use
    //use this: constraint to every item in array
    constraint c7 {foreach(d[i]) 
                    d[i] inside {[1:10]};
                   d.sum < 1024;
                   d.size() inside {[1:10]};}
    //unqiue
    function new(int max_value=10);
        this.max_value = max_value;
    endfunction
    constraint c8 {kind<max_value;}
    //atomic generator based on history event.....................
    function void pre_randomize();
        if (kind == 0) begin
            kind.rand_mode(1);
            kind = 1;
        end
    endfunction

    constraint c9 {}
endclass

rand_packet p1;
bit [7:0] uniq [10];
initial begin
    p1 = new(10);
    p1.c3.constraint_mode(0);//0:forbid c3 constraint
    assert(p1.randomize());//no randomize() function in class new()
    $display("src_addr = %0d",p1.src_addr);
    $display("dst_addr = %0d",p1.dst_addr);
    $display("kind = %0d",p1.kind);
    $display("data = %0d",p1.data);
    p1.src_addr.rand_mode(0);//0:forbid src_addr random
    p1.src_addr = 100;
    assert(p1.randomize());
    //use randc to generate unique value
    foreach (uniq[i]) begin
        assert(p1.randomize());
        uniq[i] = p1.kind;
    end
end
//atomic generator based on history event
task cfg_read_task;
endtask

initial begin
    for(int i=0;i<15;i++)begin
        randsequence (stream)
            stream: cfg_read := 1|
                    io_read  := 2|
                    mem_read := 3;
            ctg_read :{cfg_read_task;}|
                    {cfg_read_task;} cfg_read;
            ...
        endsequence
    end
end

//randcase
initial begin
    int len;
    randcase
        50: len = 1;//50% probability
        30: len = 2;
        20: len = 3;
    endcase
end
//randcase state machine
initial begin
    randcase
        50: write();
        30: read();
        20: idle();
    endcase

    task write();
        randcase
            50: read();
            50: idle();
        endcase
    endtask
    ...
end

//random number generator
//PRNG pseudo random number generator
