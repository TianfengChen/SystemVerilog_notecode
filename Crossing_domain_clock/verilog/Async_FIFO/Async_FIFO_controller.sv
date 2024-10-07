//use gray code to generate the address
//use the address to generate the full and empty signal
//in this way, 
//for example, 0100 -> 1100, if meta happend, keep 0100 or become 1100

module Async_FIFO_w
#(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 2**ADDR_WIDTH
)
(
    input wclk,wreset,
    input valid,
    input [ADDR_WIDTH-1:0] raddr_gray_rclk,
    output logic [ADDR_WIDTH-1:0] waddr_gray_wclk,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic full,
    output logic wen
);

    logic [ADDR_WIDTH-1:0] raddr;
    logic [ADDR_WIDTH-1:0] waddr_plus_1;
    logic [ADDR_WIDTH-1:0] waddr_gray;
    logic [ADDR_WIDTH-1:0] raddr_gray_wclk;
    
    //encode waddr_gray
    assign waddr_gray = waddr ^ (waddr >> 1);

    //decode raddr_gray
    synchronizor #(.DEPTH(2),.WIDTH(ADDR_WIDTH))syn_wclk
    (
        .clk(wclk),
        .reset(wreset),
        .data_in(raddr_gray_rclk),
        .data_out(raddr_gray_wclk)
    );
    assign raddr[ADDR_WIDTH-1] = raddr_gray_wclk[ADDR_WIDTH-1];
    generate
        genvar i;
        for(i=0;i<ADDR_WIDTH-1;i=i+1)
        begin
            assign raddr[i] = raddr[i+1] ^ raddr_gray_wclk[i];
        end
    endgenerate
    
    //caculate fill and wen
    assign waddr_plus_1 = waddr + 1'b1;
    assign full  = (waddr_plus_1 == raddr);
    assign wen = valid && !full;

    always_ff@(posedge wclk, posedge wreset)
    begin
        if(wreset)
        begin
            waddr <= 0;
            waddr_gray_wclk <= 0;
        end
        else
        begin
            waddr_gray_wclk <= waddr_gray;
            if(wen)
                waddr <= waddr_plus_1;
            else
                waddr <= waddr;
        end
    end
endmodule


module Async_FIFO_r
#(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 2**ADDR_WIDTH
)
(
    input rclk,rreset,
    input ren,
    input [ADDR_WIDTH-1:0] waddr_gray_wclk,
    output logic [ADDR_WIDTH-1:0] raddr_gray_rclk,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic empty,
    output logic valid,
    output logic ram_valid
);
    logic [ADDR_WIDTH-1:0] waddr;
    logic [ADDR_WIDTH-1:0] raddr_plus_1;
    logic [ADDR_WIDTH-1:0] raddr_gray;
    logic [ADDR_WIDTH-1:0] waddr_gray_rclk;
    
    //encode raddr_gray
    assign raddr_gray = raddr ^ (raddr >> 1);

    //decode raddr_gray
    synchronizor#(.DEPTH(2),.WIDTH(ADDR_WIDTH))syn_rclk
    (
        .clk(rclk),
        .reset(rreset),
        .data_in(waddr_gray_wclk),
        .data_out(waddr_gray_rclk)
    );
    assign waddr[ADDR_WIDTH-1] = waddr_gray_rclk[ADDR_WIDTH-1];
    generate
        genvar i;
        for(i=0;i<ADDR_WIDTH-1;i=i+1)
        begin
            assign waddr[i] = waddr[i+1] ^ waddr_gray_rclk[i];
        end
    endgenerate

    assign raddr_plus_1 = raddr + 1'b1;
    assign empty  = (raddr == waddr);
    assign ram_valid = ren && !empty;

    always_ff@(posedge rclk, posedge rreset)
    begin
        if(rreset)
        begin
            raddr <= 0;
            valid <= 0;
            raddr_gray_rclk <= 0;
        end
        else
        begin
            valid <= ram_valid;
            raddr_gray_rclk <= raddr_gray;
            if(ram_valid)
                raddr <= raddr + 1'b1;
            else
                raddr <= raddr;
        end
    end
endmodule