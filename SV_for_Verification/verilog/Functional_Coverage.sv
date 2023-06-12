//constraint-random testing(CRT)
//covergroup
interface busifc;
    rand bit [2:0] port;
    rand bit [7:0] data;
    clocking cb @(posedge clk);
        input data;
    endclocking

    modport TB (
        clocking cb,
        output port
    );
endinterface

program automatic test(busifc.TB ifc);
    class Trans;
        rand bit [2:0] port;
        rand bit [7:0] data;
    endclass
    //covergroup: define in program block, define in class may have more overhead.
    //in class, covergroup need to be instantiated.
    //coverage defined in class
    class Transactor;
        Trans tr;
        //declare coverage event when trigger coverage
        //use cover assertion to trigger
        event write_event;
        cover property (@(posedge ifc.cb) tr.port == 0);
            ->write_event;
        bit [2:0] dst;
        //can also cover enumerated type
        typedef enum {INIT,DECODE,IDLE} state;
        function new();
            CovDst = new();
        endfunction

        covergroup CovDst(int ign);
            coverpoint port{option.auto_bin_max = 2;}//divide into 2 bins,2:0:3 bits and 8 values; 2:1,0 2and1 bits and 6 values 
            //self-defined bin
            port_:  coverpoint port;
            len: coverpoint data {
                bins zero = {0};
                bins lo = {[1:3]};
                bins hi[]={[8:$];//8-2^8-1
                bins misc=defalut;//4
                ignore_bins ignore = {ign};//ignore 5
                illegal_bins illegal = {6};//illegal 6
                //set weight
                type_option.weight = 0;//dont count this coverpoint
                }
            }
            cross port_,len{//3+8=11 bits
                //ignore bins in cross
                ignore_bins hi = binsof(port) intersect {2};
            }
        endgroup        
        //option
        //instance options that apply to a specif c cover group instance 
        //type options that apply to all instances of the cover group, and are analogous to static data members of classes
        /*
        If your testbench instantiates a coverage group multiple times, by default System-
        Verilog groups together all the coverage data from all the instances. However, if you
        have several generators, each creating very different streams of transactions, you
        will need to see separate reports. For example, one generator may be creating long
        transactions while another makes short ones. The cover group in Sample 9.41 can
        be instantiated in each separate generator. It keeps track of coverage for each
        instance, and has a unique comment string with the hierarchical path to the cover
        group instance.
        */
        //instance options 
        covergroup covlen(ref bit [2:0] len;
            coverpoint len;
            option.per_instance = 1;
            option.comment = $psprintf("% m");
        endgroup

        //type options


        task run();
            forever begin
                assert(tr.randomize);
                //trigger coverage
                //.sample() expicitly trigger coverage
                CovDst.sample();
                @ ifc.cb;
            end
        endtask
    endclass

    covergroup CovDst26;
        //label: coverpoint XX;
        covergroup CovDst @(ifc.cb) ;
            coverpoint tr.port;
        endgroup
        state: coverpoint state;
        //use cover only not during reset,iff
        //transition coverage: coverage of state change, statistic 
        port:  coverpoint tr.port{bins t1 = (0=>1),(0=>2=>3),(0=>3);} iff (!bus_if.rst);
        //wildcasd bin
        dst:   coverpoint tr.dst {
                wildcard bins even = {3'b??0};
                wildcard bins odd = {3'b??1};}
        data:  coverpoint tr.data;
    endgroup

    covergroup cg;
        port_cp : coverpoint tr.port;
        data_cp : coverpoint data;
    endgroup

    //defining an argument list to the sample method
    covergroup CobDst8 with function sample(bit [2:0] dst, bit hs);
        coverpoint dst;
        coverpoint data;
    endgroup

    initial begin
        Trans tr;
        cg ck;
        tr = new();
        ck = new();
        repeat(10) begin
            assert(tr.randomize);
            ifc.port <= tr.port;
            ifc.data <= tr.data;
            ck.sample(tr);
            @ ifc.cb;
        end
    end
endprogram


        


