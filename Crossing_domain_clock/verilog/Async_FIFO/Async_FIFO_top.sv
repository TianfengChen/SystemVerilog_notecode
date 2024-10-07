module Async_FIFO_top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6,
    parameter DEPTH = 2**ADDR_WIDTH
)
    (
    input wclk,wreset,
    input rclk,rreset,
    input valid,
    input [DATA_WIDTH-1:0] data_in,
    input ren,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic valid_out,
    output logic full,
    output logic empty
    );

    logic wen;
    logic ram_valid;
    logic [ADDR_WIDTH-1:0] raddr_gray_rclk;
    logic [ADDR_WIDTH-1:0] waddr_gray_wclk;
    logic [ADDR_WIDTH-1:0] waddr;
    logic [ADDR_WIDTH-1:0] raddr;

    Async_FIFO_w #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )w_ctrl
    (
        .wclk(wclk),
        .wreset(wreset),
        .valid(valid),
        .raddr_gray_rclk(raddr_gray_rclk),
        .waddr_gray_wclk(waddr_gray_wclk),
        .waddr(waddr),
        .full(full),
        .wen(wen)
    );

    Async_FIFO_r #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )r_ctrl
    (
        .rclk(rclk),
        .rreset(rreset),
        .ren(ren),
        .waddr_gray_wclk(waddr_gray_wclk),
        .raddr_gray_rclk(raddr_gray_rclk),
        .raddr(raddr),
        .empty(empty),
        .valid(valid_out),
        .ram_valid(ram_valid)
    );
    
    Dual_Ram #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    )ram
    (
        .wclk(wclk),
        .rclk(rclk),
        .rreset(rreset),
        .wen(wen),
        .ren(ram_valid),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(data_in),
        .rdata(data_out)
    );

endmodule