//iverilog -g2012 -o FIFO  testbench/testbench.sv verilog/FIFO.sv
module test;
    logic clk;
    logic reset;
    logic [7:0] data_in_0;
    logic [7:0] data_in_1;
    logic [7:0] data_in_2;
    logic [2:0] valid_in;

    logic [7:0] data_out_0;
    logic [7:0] data_out_1;
    logic [7:0] data_out_2;
    logic [2:0] able_in;
    logic [2:0] valid_out;
    logic [7:0] data_in;
    //logic [4:0] write_ptr;
    //logic [4:0] read_ptr;

    logic [15:0] time_;

    FIFO_3way sync_FIFO(
        .*
    );

    always 
    begin
        #5 clk = ~clk;   
    end

    initial
    begin
        reset = 1;
        clk = 0;
        data_in_0 = 8'd0;
        data_in_1 = 8'd1;
        data_in_2 = 8'd2;
        valid_in  = 3'b0;
        data_in   = 8'd0;

        #10 reset = 0;

        time_ = 0;
        while (time_ < 16'd2000)
        begin
            #10 time_ = time_ + 4'd10;
            
            valid_in[0] = {$random} % 2;
            valid_in[1] = valid_in[0] & {$random} % 2;
            valid_in[2] = valid_in[1] & {$random} % 2;
            if (valid_in[0])
            begin
                data_in_0 = data_in + 1'b1;
                data_in   = data_in + 1'b1;
                if (valid_in[1])
                begin
                    data_in_1 = data_in + 1'b1;
                    data_in   = data_in + 1'b1;
                    if (valid_in[2])
                    begin
                        data_in_2 = data_in + 1'b1;
                        data_in   = data_in + 1'b1;
                    end
                end
            end
            //$display("write_ptr = %d, read_ptr = %d, valid_in = %b, able_in = %b, , data_in_2 = %d, data_in_1 = %d, data_in_0 = %d, valid_out = %b, data_out_2 = %d, data_out_1 = %d, data_out_0 = %d", write_ptr, read_ptr, valid_in, able_in, data_in_0, data_in_1, data_in_2, valid_out, data_out_2, data_out_1, data_out_0);
            $display("valid_in = %b, able_in = %b, , data_in_2 = %d, data_in_1 = %d, data_in_0 = %d, valid_out = %b, data_out_2 = %d, data_out_1 = %d, data_out_0 = %d", valid_in, able_in, data_in_0, data_in_1, data_in_2, valid_out, data_out_2, data_out_1, data_out_0);
        end
        #100 $finish;
    end

endmodule
