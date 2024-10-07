//iverilog -g2012 -o sync.vvp testbench/synchronizor_test.sv verilog/multistage_synchronizor.sv
parameter DEPTH = 2;
parameter WIDTH = 8;

module test;

    logic clk;
    logic reset;
    logic [WIDTH-1:0]	data_in;
    logic [WIDTH-1:0]	data_out;

    logic [15:0] time_;
    logic [3:0]  time_add;

    synchronizor#(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    )sync
    (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out)
    );

    always
    begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 1;
        time_ = 0;
        #10
        reset = 0;
        data_in = 8'h00;
        while (time_ < 16'd200)
        begin
            #10 time_ = time_ + 16'd10;
            data_in = data_in + 8'h01;
            $display("data_in=%d, data_out=%d",data_in,data_out);
        end
        #10 $finish;
    end

endmodule