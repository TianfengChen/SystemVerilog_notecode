module FIFO
#(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 64,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
)
(
    input clk, reset,
    input [DATA_WIDTH-1:0] data_in,
    input write,
    input read,
    output logic full,
    output logic empty,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic valid
);
    logic [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
    logic [ADDR_WIDTH-1:0] w_ptr;
    logic [ADDR_WIDTH-1:0] r_ptr;
    logic [ADDR_WIDTH-1:0] next_w_ptr;
    logic [ADDR_WIDTH-1:0] next_r_ptr;
    logic [ADDR_WIDTH-1:0] w_ptr_plus_1;

    assign w_ptr_plus_1 = w_ptr + 1'b1;
    assign full = (w_ptr_plus_1 == r_ptr);
    assign empty = (w_ptr == r_ptr);

    always_ff*(posedge clk, negedge reset)
    begin
        if (reset)
        begin
            w_ptr <= 0;
            r_ptr <= 0;
            valid <= 0;
        end
        else
        begin
            //write
            if (write && !full)
            begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr_plus_1;
            end
            else
            begin
                mem[w_ptr] <= mem[w_ptr];
                w_ptr <= w_ptr;
            end

            //read
            valid    <= !empty;
            data_out <= mem[r_ptr];
            if (read && !empty)
            begin
                r_ptr <= r_ptr + 1'b1;
            end
        end
    end

endmodule