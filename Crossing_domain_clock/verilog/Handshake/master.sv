module master(
    input  clk_1,
    input  reset_1,
    input  ready_1,
    output logic valid_1,
    output logic [7:0] data_1
    );
    //logic idle_s;
    //assign idle_s = valid_1 & (~ready_1);
    always_ff @(posedge clk_1, posedge reset_1)
    begin
        if(reset_1==1)
        begin
            valid_1 <= 0;
            data_1  <= 1;
        end
        else
        begin
            if(ready_1 == 1)
            begin
                valid_1 <= 1'b1;
                data_1  <= data_1+1'b1;
            end
            else
            begin
                data_1  <= data_1;
                if(valid_1 == 0)
                    valid_1 <= 1'b1;
                else
                    valid_1 <= 0;
            end
        end
    end
endmodule