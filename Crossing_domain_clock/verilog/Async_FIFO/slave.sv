module slave
#(
    parameter DATA_WIDTH = 8
)
(
    input wclk,wreset,
    input empty,
    input [DATA_WIDTH-1:0] data_out,
    input valid,
    output logic ren
);

    
endmodule