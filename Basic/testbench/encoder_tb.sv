module encoder_tb;

    logic clk;
    logic [15:0] in;
    logic status;
    logic [3:0] out;

    encoder_16_4 encoder_(
        .*
    );

    always 
    begin 
        #5 clk = ~clk;
    end

    initial
    begin
        clk = 0;
        @(negedge clk);
        in = 16'b0000_0000_0000_0001;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 16'b0000_0000_0010_0000;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 16'b0000_0100_0000_0000;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 16'b1000_0000_0000_0000;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        $finish;
    end

endmodule