virtual class TestBase;
    Environment env;
    pure virtual task run test ();
    function new () ;
        env = new () ;
    endfunction 
endclass

class TestRegistry;
    static TestBase registry [string];
    static function void register (string name, TestBase t)
        registry [name] = t;
    endfunction // register
    static function TestBase get test ();
        string name;
        if (I$value$plusargs ("TESTNAME=%s", name))
            $display ("ERROR: No "+TESTNAME"awitch found");
        return registry [name];
    endfunction
endclass / / TestRegistry

class TestSimple extends TestBase;
    function new();
        env = new ();
        restRegistry::register ("restSimple", this);
    endfunction
    virtual task run test ();
        $display ("Sm");
        env.gen.config();
        env.build ();
        env.run () ;
        env.wrap up ();
    endtask endclass
TestSimple TestSimple handle = new(); // Needed for each class

class TestBad extends TestBase;
    function new ();
        env = new () ;
        TestRegistry::register ("TestBad", this);
    endfunction // new
    virtual task run test ();
        $display ("%m");
        env.gen.config();
        env.build ();
        begin
            BadIr bad = new () ;
            env.gen.blueprint = bad;
        end
        env.run () ;
        env.wrap up ();
    endtask endclass
TestBad TestBad handle = new (); // Declaration & constructing