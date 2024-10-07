//iverilog -g2012 -o async_fifo testbench/fifo_tb.sv verilog/Async_FIFO/master.sv verilog/Async_FIFO/Async_FIFO_controller.sv verilog/Async_FIFO/Async_FIFO_dual_ram.sv verilog/Async_FIFO/Async_FIFO_top.sv verilog/multistage_synchronizor.sv
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 3;
module test;
    logic wclk;
    logic rclk;
    logic wreset;
    logic rreset;
    logic ren;
    logic full;
    logic empty;
    logic valid;
    logic valid_out;
    logic [DATA_WIDTH-1:0]	data_in;
    logic [DATA_WIDTH-1:0]	data_out;

    logic [15:0] time_;
    logic [3:0]  time_add;

    master #(.DATA_WIDTH(DATA_WIDTH)) m
    (
        .wclk(wclk),
        .wreset(wreset),
        .full(full),
        .valid(valid),
        .data_in(data_in)
    );

    Async_FIFO_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) fifo_top
    (
        .wclk(wclk),
        .wreset(wreset),
        .rclk(rclk),
        .rreset(rreset),
        .valid(valid),
        .data_in(data_in),
        .ren(ren),
        .data_out(data_out),
        .valid_out(valid_out),
        .full(full),
        .empty(empty)
    );

    always 
    begin
        #7 wclk = ~wclk;
    end    
    
    always
    begin
        #13 rclk = ~rclk;
    end

    always
    begin
        #1
        $display("time = %d, wclk=%b, rclk=%b, ram0=%d, wen=%d, ram_waddr=%d, valid=%d, data_in=%d, ren=%d, data_out=%d, valid_out=%d, waddr_wclk=%d, raddr_wclk=%d, waddr_rclk=%d, raddr_rclk=%d, full=%d, empty=%d, ram_valid=%d",
        time_,
        wclk,
        rclk,
        fifo_top.ram.ram[0],
        fifo_top.ram.wen,
        fifo_top.ram.waddr,
        valid,
        data_in,
        ren,
        data_out,
        valid_out,
        fifo_top.w_ctrl.waddr,
        fifo_top.w_ctrl.raddr,
        fifo_top.r_ctrl.waddr,
        fifo_top.r_ctrl.raddr,
        full,
        empty,
        fifo_top.ram_valid);
    end
    

    initial begin
        wclk = 0;
        rclk = 0;
        wreset = 1;
        rreset = 1;
        #20
        ren  = 1;
        wreset = 0;
        rreset = 0;
        time_ = 0;
        while (time_ < 16'd1000)
        begin
            time_add = {$random} % 32;//0-31
            ren = ~ren;
            #time_add time_ = time_ + time_add;
        end

        #100 $finish;
    end
    
endmodule