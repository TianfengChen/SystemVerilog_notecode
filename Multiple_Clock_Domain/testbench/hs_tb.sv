//iverilog -g2012 -o handshaker testbench/hs_tb.sv verilog/Handshake/slave.sv verilog/Handshake/master.sv verilog/Handshake/handshaking.sv verilog/pulse_synchronizor.sv

module test;
    logic clk_1;
    logic clk_2;
    logic reset_1;
    logic reset_2;
    logic [7:0] data_1;
    logic [7:0] data_2;
    logic [7:0] data_out;
    logic valid_1;
    logic valid_2;
    logic ready_1;
    logic ready_2;
    logic ready_level;
    logic valid_level;
    logic idle_s;
    
    logic [15:0] time_;
    logic [3:0]  time_add;

    master master_(
    .clk_1(clk_1),
    .reset_1(reset_1),
    .ready_1(ready_1),
    .valid_1(valid_1),
    .data_1(data_1)
    );

    slave slave_(
    .clk_2(clk_2),
    .reset_2(reset_2),
    .valid_2(valid_2),
    .data_2(data_2),
    .idle_s(idle_s),
    .ready_2(ready_2),
    .data_out(data_out)
    );

    handshake_reciever rx(
    .clk_2(clk_2),
    .reset_2(reset_2),
    .data_1(data_1),
    .data_2(data_2),
    .ready_2(ready_2),
    .ready_level(ready_level),
    .valid_level(valid_level),
    .valid_2(valid_2)
    );

    handshake_sender tx(
    .clk_1(clk_1),
    .reset_1(reset_1),
    .valid_1(valid_1),
    .valid_level(valid_level),
    .ready_level(ready_level),
    .ready_1(ready_1)
    );

    always 
    begin
        #7 clk_1 = ~clk_1;
    end    
    
    always
    begin
        #13 clk_2 = ~clk_2;
    end

    always
    begin
        #1
        $display("time = %d, data_1=%d,   data_2=%d,   data_out=%d,   valid_1=%d,   valid_2=%d,   ready_1=%d,   ready_2=%d,   ready_level=%d,   valid_level=%d,   idle_s=%d",time_,data_1,data_2,data_out,valid_1,valid_2,ready_1,ready_2,ready_level,valid_level,idle_s);
    end
    

    initial begin
        clk_1 = 0;
        clk_2 = 0;
        reset_1 = 1;
        reset_2 = 1;
        idle_s  = 1;
        #20
        idle_s  = 0;
        reset_1 = 0;
        reset_2 = 0;
        time_ = 0;
        while (time_ < 16'd1000)
        begin
            time_add = {$random} % 16;//0-15
            idle_s = ~idle_s;
            #time_add time_ = time_ + time_add;
        end

        #100 $finish;
    end
    
endmodule