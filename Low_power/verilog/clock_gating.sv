module clk_gating
(
    input clk,
    input reset
    input D,
    input sel,
    output logic Q
);

//without clock gating
logic D_;
assign D_ = sel ? D : D_;
always@(posedge clk or posedge reset)
begin
    if(reset)
        Q <= 0;
    else
        Q <= D_;
end

//with clock gating condition in non-blocking block
always@(posedge clk)
begin
    if(reset)
        Q <= 0;
    else 
        if(sel)
            Q <= D;
        else
            Q <= Q;
end
endmodule