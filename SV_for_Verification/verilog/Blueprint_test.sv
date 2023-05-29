class Packet;
    integer i = 1;
    function integer get() ;
        get = i ;
    endfunction
endclass

class LinkedPacket extends Packet;
    integer i = 2;

    function new();
        super.new();
    endfunction

    function integer get();
        get = -1*i;
    endfunction
endclass

program BP_test;
    LinkedPacket lp;
    Packet p;
    initial begin
        lp = new();
        p = lp; 
        $display("p.i = %0d", p.i); // p.i = 1
        $display("p.get() = %0d", p.get()); // p.get() = 1
    end
endprogram