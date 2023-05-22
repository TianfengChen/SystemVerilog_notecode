module master
#(
    parameter DATA_WIDTH = 8
)
(
    input wclk,wreset,
    input full,
    output logic valid,
    output logic [DATA_WIDTH-1:0] data_in
);
    assign valid = 1'b1;
    always_ff @(posedge wclk or posedge wreset)
    begin
        if (wreset)
        begin
            data_in <= 0;
        end
        else
        begin
            if (~full)
            begin
                data_in <= data_in + 1'b1;
            end
            else
            begin
                data_in <= data_in;
            end
        end
    end
    
endmodule