module onehot_mux 
#(
    parameter WIDTH = 8,
    parameter NUM_INPUTS = 4
)
(
    input [WIDTH-1:0] data [NUM_INPUTS`-1:0],
    input [NUM_INPUTS-1:0] sel,
    output reg [WIDTH-1:0] out
);

always @(*)
begin
    case(sel)
        4'b0001: out = data[0];
        4'b0010: out = data[1];
        4'b0100: out = data[2];
        4'b1000: out = data[3];
    endcase
end

endmodule