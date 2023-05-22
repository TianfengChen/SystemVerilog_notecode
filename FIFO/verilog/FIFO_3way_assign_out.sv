//3 way FIFO
//watch out! array row of output in one clock cannot be inserted data.
module FIFO_3way(
    input clk,reset,
    input [7:0] data_in_0,
    input [7:0] data_in_1,
    input [7:0] data_in_2,
    input [2:0] valid_in,
    output logic [7:0] data_out_0,
    output logic [7:0] data_out_1,
    output logic [7:0] data_out_2,
    output logic [2:0] able_in,
    output logic [2:0] valid_out
    );

    logic [7:0] mem [0:31];
    logic [31:0]valid;
    logic [31:0]next_valid;
    logic [4:0] next_read_ptr;
    logic [4:0] write_ptr,read_ptr;
    
    logic [2:0] w_v;
    logic [4:0] write_ptr_plus_1;
    logic [4:0] write_ptr_plus_2;
    logic [4:0] read_ptr_plus_1;
    logic [4:0] read_ptr_plus_2;
    
    assign write_ptr_plus_1 = write_ptr + 1'b1;
    assign write_ptr_plus_2 = write_ptr + 2'b10;
    assign read_ptr_plus_1 = read_ptr + 1'b1;
    assign read_ptr_plus_2 = read_ptr + 2'b10;

    assign valid_out[0] =   valid[read_ptr];
    assign valid_out[1] =   valid[read_ptr] & valid[read_ptr_plus_1];
    assign valid_out[2] =   valid[read_ptr] & valid[read_ptr_plus_1] & valid[read_ptr_plus_2];

    assign w_v[0] =   ~valid[write_ptr];
    assign w_v[1] =   w_v[0] & ~valid[write_ptr_plus_1];
    assign w_v[2] =   w_v[1] & ~valid[write_ptr_plus_2];

    assign next_read_ptr = read_ptr + valid_out[0] + valid_out[1] + valid_out[2];
    assign able_in = w_v & valid_in;
    assign data_out_0 = mem[read_ptr];
    assign data_out_1 = mem[read_ptr_plus_1];
    assign data_out_2 = mem[read_ptr_plus_2];
    always@(*)
    begin
        next_valid = valid;
        next_valid[read_ptr] = 1'b0;
        next_valid[read_ptr_plus_1] = 1'b0;
        next_valid[read_ptr_plus_2] = 1'b0;

        if (able_in[0])
        begin
            next_valid[write_ptr] = 1'b1;
            if (able_in[1])
            begin
                next_valid[write_ptr_plus_1] = 1'b1;
                if (able_in[2])
                begin
                    next_valid[write_ptr_plus_2] = 1'b1;
                end
            end
        end
    end

    always_ff @(posedge clk,posedge reset)
    begin
        if (reset)
        begin
            write_ptr <= 5'b0;
            read_ptr  <= 5'b0;
            valid     <= 32'b0;
        end
        else
        begin
            valid     <= next_valid;
            //read
            read_ptr   <= next_read_ptr;
            
            //write
            if(able_in[0])
            begin
                mem[write_ptr] <= data_in_0;
                if(able_in[1])
                begin
                    mem[write_ptr_plus_1] <= data_in_1;
                    if(able_in[2])
                    begin
                        mem[write_ptr_plus_2] <= data_in_2;
                        write_ptr <= write_ptr + 2'b11;
                    end
                    else
                    begin
                        mem[write_ptr_plus_2] <= mem[write_ptr_plus_2];
                        write_ptr <= write_ptr + 2'b10;
                    end
                end
                else
                begin
                    mem[write_ptr_plus_1]    <= mem[write_ptr_plus_1];
                    mem[write_ptr_plus_2]   <= mem[write_ptr_plus_2];
                    write_ptr              <= write_ptr + 2'b01;
                end
            end
            else
            begin
                mem[write_ptr]           <= mem[write_ptr];
                mem[write_ptr_plus_1]    <= mem[write_ptr_plus_1];
                mem[write_ptr_plus_2]    <= mem[write_ptr_plus_2];
                write_ptr                <= write_ptr;
            end
        end
    end


endmodule