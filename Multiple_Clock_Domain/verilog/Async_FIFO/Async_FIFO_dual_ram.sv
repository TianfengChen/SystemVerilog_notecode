//use gray code to generate the address
//use the address to generate the full and empty signal
//in this way, 
//for example, 0100 -> 1100, if meta happend, keep 0100 or become 1100
//
module Dual_Ram
#(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 2**ADDR_WIDTH
)
(
    input wclk,rclk,
    input rreset,
    input wen,ren,
    input [ADDR_WIDTH-1:0] waddr,
    input [ADDR_WIDTH-1:0] raddr,
    input [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata
);
    logic [DATA_WIDTH-1:0] ram [0:DEPTH-1];

    always_ff @(posedge wclk)
    begin
        if(wen)
            ram[waddr] <= wdata;
        else
            ram[waddr] <= ram[waddr];
    end

    always_ff @(posedge rclk or posedge rreset)
    begin
        if(rreset)
            rdata <= 0;
        else
        begin
            if(ren)
                rdata <=  ram[raddr];
            else
                rdata <= rdata;
        end
    end

endmodule

