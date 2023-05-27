//function
function void print_state();
    $display();
endfunction
    //parameter as an array
function void print_array(input logic [31:0] array[]);
    for(int i =0;i<array.size();i++)
        $display();
endfunction
    //return value
function int add(int a, int b);

//task, formal parameter.
task bus_read(input logic [31:0] addr, ref logic [31:0] data);//other than ref, other variable should be defined an input or output
    bus.request = 1'b1;
    @(posedge bus.grant)
    bus.addr = addr;
    @(posedge bus.enable)
    data = bus.data;
    bus.request = 1'b0;
    @(negedge bus.grant);
endtask

logic [31:0] addr,data;

initial 
    fork
        bus_read(32'h12345678, data);
        thread2: begin
            @data;
            $display();
        end
join

//program
    //store parameter data in stack and heap instead of static memory
program automatic test;
    task wait_for_mem(
        input logic [31:0] addr,
        input logic [31:0] data,
        output logic [31:0] done
    );
    while(bus.addr !== addr)
        @(posedge bus.grant);
        done = (bus.data === data);
    endtask

endprogram

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
        copy = new();
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
    function void cal_crc;
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


//Blueprint
//copy a blueprint to generate a new object
//declaration, initialization, call in different block
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

