module slave(
    input  clk_2,
    input  reset_2,
    input  valid_2,
    input  [7:0] data_2,
    input  idle_s,
    output logic ready_2,
    output logic [7:0] data_out
    );
    assign ready_2 = ~idle_s;
    always_ff @(posedge clk_2, posedge reset_2)
    begin
        if(reset_2)
        begin
            data_out <= 0;
        end
        else
        begin
            if(valid_2)
            begin
                data_out <= data_2;
            end
            else
            begin
                data_out <= data_out;
            end

        end
    end
endmodule