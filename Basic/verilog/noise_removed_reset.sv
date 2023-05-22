// --------------------------
// two asynchronous clock source
// --------------------------
module change_clk_source (
    input  clk1,
    input  clk0,
    input  select,
    input  rst_n,
    output outclk
);

reg out_r1;
reg out1;
reg out_r0;
reg out0;

always @(posedge clk1 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out_r1 <= 0;
        end
    else
        begin
            out_r1 <= ~out0 & select;
        end
end

always @(negedge clk1 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out1 <= 0;
        end
    else
        begin
            out1 <= out_r1;
        end
end

always @(posedge clk0 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out_r0 <= 0;
        end
    else
        begin
            out_r0 <= ~select & ~out1;
        end
end

always @(negedge clk0 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out0 <= 0
        end
    else
        begin
            out0 <= out_r0;
        end
end

assign outclk = (out1 & clk1) | (out0 & clk0);

endmodule

/*
// two clock with multiple integer ratio
module change_clk_source (
    input  clk1,
    input  clk0,
    input  select,
    input  rst_n,
    output outclk
);

reg out1;
reg out0;

always @(negedge clk1 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out1 <= 0;
        end
    else
        begin
            out1 <= ~out0 & select;
        end
end

always @(negedge clk0 or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            out0 <= 0;
        end
    else
        begin
            out0 <= ~select & ~out1;
        end
end

assign outclk = (out1 & clk1) | (out0 & clk0)

endmodule
*/
