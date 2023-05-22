module decoder_tb;

    logic clk;
    logic [3:0] in;
    logic enable;
    logic [15:0] out;

    decoder_4_16 decoder_(
        .*
    );

    always 
    begin 
        #5 clk = ~clk;
    end

    initial
    begin
        clk = 0;
        enable = 1;
        @(negedge clk);
        in = 4'b0000;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 4'b0011;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 4'b0100;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 4'b1111;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        in = 4'b1010;
        @(posedge clk);
        $display("in is %b out is %b",in, out);
        @(negedge clk);
        $finish;
    end

endmodule