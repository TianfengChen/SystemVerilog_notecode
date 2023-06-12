//function
function void print_state();
    $display();
endfunction
//parameter as an array
function void print_array(input logic [31:0] array[]);
    for(int i =0;i<array.size();i++)
        $display();
endfunction
//return value, use function name as return
function int add(int a, int b);
    add = a+b;
endfunction

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

integer i;
generate
    for(i=0;i<10;i++) begin: loop
        initial begin
            wait_for_mem(32'h12345678, 32'h12345678, loop[i].done);
        end
    end
endgenerate