//interface
interface arb_if(input bit clk);
    logic [1:0] grant,request;
    logic rst;
    //modport make sure the signal direction
    //clocking make sure the trigger edge
    clocking cb @(posedge clk);
        output request;
        input grant;
    endclocking

    modport TEST(
        clocking cb,
        output rst
    );
    //design under test
    modport DUT(
        input request,rst,clk
        output grant
    );

    modport MONITOR(
        input clk,grant,request,rst
    );
endinterface

module test(arb_if.TEST arb);
    ...
endmodule

module arbitor (arb_if.DUT arb);
    ...
    if (arb.cb.rst)//dont forget .cb.
    ...
endmodule

module top;
    bit clk;
    always
        #5 clk = ~clk;
    
    arb_if arb(clk);
    arbitor rbt(arb);

endmodule


//virtual interface
//connect dynamic object in testbench and static module in design
//DUT
module counter(input clk,resetn,
               input [3:0] load_value,
               input load_valid,
               output reg [3:0] q);
  always@(posedge clk or negedge resetn)begin
    if(!resetn)
      q<=4d0;
    else if(load_valid)
      q<=load_value;
    else
      q<=q+4'd1; 
  end
endmodule

//interface
interface counter_if(input logic clk);
  logic load_valid;
  logic [3:0] load_value;
endinterface

class transaction;//用rand来生成随机化激励
  rand logic load_valid;
  rand logic [3:0] load_value;
endclass

class driver;
  virtual counter_if vif;//生成一个virtual interface句柄
  function new(input virtual counter_if vif);//该new函数用来使虚接口句柄指向interface
    this.vif=vif
  endfunction
 
  transaction tr;
  task run(int n);
    for(int i=0;i<n;i++)begin
      tr=new;
      assert(tr.randomize());
      $display("tr.load_valid=%0d,tr.load_value=%0d",tr.load_valid,tr.load_value);
      @(posedge vif.clk)begin//在clk上升沿，通过虚接口将transaction中的随机激励传送到interface上
        vif.load_valid<=tr.load_valid;
        vif.load_value<=tr.load_value;
      end
    end
  endtask
endclass

module tb_top;
  logic clk,rstn;
  logic[3:0]q;
  
  counter_if dutif(clk);//实例化interface
  driver my_driver;//声明句柄
  counter u_counter(.resetn(rstn),
                    .clk(clk),
                    .load_valid(dutif.load_valid),
                    .load_value(dutif.load_value),
                    .q(out));//实例化DUT
 
  initial begin
    my_driver=new(dutif)//实例化驱动，使虚接口句柄指向interface
    repeat(2) @(posedge clk);
    @(posedge rstn);
    repeat(5) @(posedge clk);
    my_driver.run(20);//产生20次随机激励
  end
 
  initial begin//生成T=10的时钟
    clk=1'b0;
    forever #5 clk=~clk;
  end
  initial begin//复位信号的生成
    rstn=1;repeat(2) @(posedge clk);
    rstn=0;repeat(5) @(posedge clk);
    rstn=1;repeat(50) @(posedge clk);
    $finish;
  end
endmodule


//cross module reference(XMR)
//no need to use port list
program automatic test();
    virtual bus_ifc bus = top.bus;//XMR
endprogram

module top;
    bus_ifc bus();
    test t1();
endmodule

