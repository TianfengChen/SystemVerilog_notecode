//class
class Transaction;
    bit [31:0] addr, data[8];
    static int count = 0;
    int id;
    //this, use when use same name
    //constructor
    function new(bit [31:0] addr, bit [31:0] data[8]);
        this.addr = addr;
        this.data = data;
        this.id = count++;
    endfunction
    extern function void print();
endclass

function void Transaction::print();
    $display();
endfunction

Transaction t1 = new(32'h12345678, 32'habcdef01);
initial begin
    t=new();
    t.print();
end

typedef class classname;//define a class type to use in other class before its content is defined

//transmit a object, ref or not
task taskname(T obj);

endtask

T obj;
taskname(obj);

//copy
//shallow copy
T a,b;
a = new();
b = new a;
//deep copy
class T;
    bit [31:0] data;
    A a;
    function T copy;
        copy = new();//because this is defined in class, so, it will call new() in class, no need to declare copy.
        copy.data = data;
        copy.a = a.copy();
    endfunction
endclass

//derivation and polymorphism
//base
class Tran;
    rand bit [31:0] src,dst,data[8];
    bit [31:0] crc;
    //virtual function
    virtual function void cal_crc;
        crc = src ^ dst;
    endfunction
endclass
//derive
class recieve extends Tran;
    bit [31:0] c_crc;
    virtual function void cal_crc;
        //suprer, call base class function
        super.cal_crc();
        crc = crc ^ c_crc;
    endfunction
endclass

recieve r;
r = new();
r.cal_crc();//call derive class function
r.Tranc::cal_crc();//call base class function
Tran r;
r = new();
r.cal_crc();//call base class function


//Blueprint, actually a abstract base class, called as a derive class
//copy a blueprint to generate a new object
//declaration, initialization, call in different block
//can be ussed to access different class function and random constraint
class Generator;
    mailbox gen2drv;
    Transaction blueprint;//declaration

    function new(input mailbox gen2drv);
        this.gen2drv = gen2drv;
        blueprint = new();//initialization
    endfunction

    task run;
        Transaction t;
        forever begin
            assert(blueprint.randomize)
            t = blueprint.copy();//copy
            gen2drv.put(t);
        end
    endtask
endclass

program automatic test;
    mailbox gen2drv;
    Generator gen;
    initial begin
        gen = new(gen2drv);
        BadTansaction bt; //BadTransaction is a derive class of Transaction
        gen.blueprint = bt;
        gen.run();//call BadTransaction class function
    end
endprogram

//upcasting: copy derived class obj to base class obj like c++ dynamic_cast,static_cast:no problem
//downcasting
$cast(derive,base);

//combination vs inheritance
//combination: use a class object as a member of another class
//inheritance: derive a class from another class, but can not derive from more than one class
//solution: use one class, declare all member in it
//define judge variable and constraint to decide which characteristic/member/constraint to use.

class eth_mac_frame;
    typedef enum{
        II,
        IEEE
    }kind_e;

    rand kind_e kind;

    constraint eth_mac_II{if(kind==II){...}}

    ...
endclass

//copy function
class Transaction;
    rand bit [31:0] src,dst,data[8];
    bit [31:0] crc;
    //copy function
    virtual function Transaction copy();
        Transaction copy;
        copy = new();
        copy.src = src;
        copy.dst = dst;
        copy.data = data;
        copy.cal_crc();
    endfunction
endclass

//abstract class and pure virtual function
//difference from C++ abstract class:
//in C++, no need to declare virtual function in derived class
//abstraction class may not have pure virtual function, and abstract class can be instantiated
//use virtual before class key words
//use pure virtual function key words

virtual class BaseTr;
    static int count;
    int id;
    function new();
        id = count++;
    endfunction
    
    pure virtual function void print();//no function body
    endfunction
endclass

class Transaction extends BaseTr;
    bit [31:0] src,dst,data[8];
    bit [31:0] crc;
    extern virtual function void print();//extern defined outside class
endclass


//call_back
//use a call back class "serving" main class
//instead of defining function in main class, call the function in call back class
//functions include:
//• Inject errors
//• Drop the transaction
//• Delay the transaction
//• Synchronize this transaction with others
//• Put the transaction in the scoreboard
//• Gather functional co verage data
//in this way, no need to modify main class, 
//use a call back derived class to modify function(serving class tree vs main class tree)
//but not in main class and its derived class
virtual class Driver_callback;
    virtual task pre_cb(ref Transaction t, ref bit drop);
        drop = ($urandom_range(0,99)==0);//drop one cell each 100 cells
    endtask

    virtual task post_cb(ref Transaction t);
    endtask
endclass

//use a queue to store call back class object
class Driver;
    Driver_callback cb[$];
    task run;
        Transaction t;
        bit drop;
        forever begin
            t = new();
            foreach(cb[i])
                cb[i].pre_cb(t,drop);
                if(!drop) continue;
                transmit(t);
            foreach(cb[i])
                cb[i].post_cb(t);
        end
    endtask
endclass


//scoreboard: store transaction, output expected value, store actual value, comparation
//use a queue to store transaction
class Scoreboard;
    Transaction scb[$];
    function store_exp(input Transaction t);
        scb.push_back(t);
    endfunction

    function compare(input Transaction t);
        int q[$];
        q = scb.find_index(x)with(x.src=tr.src);
        case(q.size())
            0:$display("no match found");
            1:scb.delete(q[0]);
            default:
                $display("Error, multiple match found");
        endcase
    endfunction
endclass

//use callback to connect scoreboard and driver
class Driver_callback_sb extends Driver_callback;
    Scoreboard sb;
    function new(input Scoreboard sb);
        this.sb = sb;
    endfunction

    virtual task pre_cb(ref Transaction t, ref bit drop);
        sb.store_exp(t);
    endtask

    virtual task post_cb(ref Transaction t);
        sb.compare(t);
    endtask
endclass

program automatic test;
    environment env;
    Scpreboard sb;

    initial begin
        env = new();
        env.gen_cfg();
        env.build();
        Driver_callback_sb dcb = new(sb);
        env.driver.cb.push_back(dcb);//connext scoreboard and driver
    end
endprogram

//parameterized classes (class template)
parameter int SIZE = 100;
class Stack #(type T=int);//default type is int
    local T stack[SIZE];
    local int top;
    function void push(input T t);
        stack[top++] = t;
    endfunction
    function T pop();
        return stack[--top];
    endfunction
endclass

//initialize
program test;
    initial begin
        Stack #(int) s1;
    end
endprogram

//static member in dynamic class
//print 
class print;
    static int error_count;
    static function void print_error(input string message);
        $display("Error: %s",message);
        if (++error_count > 10)
            $finish;
    endfunction
endclass

program test;
    initial begin
        print::print_error("error");
    end
endprogram

//use parameterized class and static member to create a database