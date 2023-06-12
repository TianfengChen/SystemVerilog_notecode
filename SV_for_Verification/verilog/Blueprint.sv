program BP_test;

    class Packet;
        integer i = 1;
        virtual function integer get() ;
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

    LinkedPacket lp;
    Packet p;
    initial begin
        lp = new();
        p = lp;//no need to instantiate p, just assign lp to p
        $display("p.i = %0d", p.i); // p.i = 1
        $display("p.get() = %0d", p.get()); // if base get() is not virtual: p.get() = 1,else p.get() = -2
    end
endprogram