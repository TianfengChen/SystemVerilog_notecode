//Macro
`define OPSIZE 4
`define OPREG reg [`OPSIZE-1:0]
`OPREG op1;

//structure
//union structure
typedef union packed {
    bit [31:0] data;
    struct packed {
        bit [7:0] addr;
        bit [23:0] data;
    } packet;
} signal_packet;

//impact structure, 'packed'
typedef struct packed {
    bit [7:0] addr;
    bit [31:0] data;
} signal_packet;

signal_packet packet1 = '{
    8'hFF, 
    32'h12345678
};

packet1.addr = 8'hFF;

//enum
typedef enum {INIT,DEC,IDLE} color_t;//INIT=0, DEC=1, IDLE=2
//or
typedef enum {INIT,DEC=2,IDLE} color_t;//INIT=0, DEC=2, IDLE=3


//const

//reference
function void swap (ref int a, ref int b);
    int temp;
    temp = a;
    a = b;
    b = temp;
endfunction

task bus_read(input logic [31:0] addr, ref logic [31:0] data);
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

//package
    package Mistake;
        class Bad;
            logic [31:0] data;
            function void display();
                for (int i=0; i<32; i++) //error, i is not declared
                    $display("%d", data[i]);
            endfunction
        endclass
    endpackage

    program test;
        int i;
        import Mistake::*;//will not see i, error found
        Bad bad;
        initial begin
            bad = new();
            bad.display();
        end
    endprogram


//wait repeat
program automatic test(arb_if.TEST arb);
    ...
    initial begin
        arb.cb.request <= 2'b01;
        repeat(2) @arb.cb;
        wait(arb.cb.grant == 2'b10);
        ...
    end
endprogram


//extern
//use extern to declare a function in class is defined in outside of class


//function
//display write, display will add /n, write in one line
//strobe, display only when end of time slot
//monitor,when variable change