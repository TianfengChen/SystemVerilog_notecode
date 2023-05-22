`define share_resource
//iverilog -g2012 -o adder testbench/adder_tb.sv verilog/adder.sv
//vvp adder
module adder
#(
    parameter add_bit = 4
)
(
    input clk,
    input reset,
    input [add_bit-1:0] a1,
    input [add_bit-1:0] a2,
    input [add_bit-1:0] b1,
    input [add_bit-1:0] b2,
    input sel,
    output logic [add_bit-1:0] sum,
    output logic carry
);
`ifdef share_resource
    logic [add_bit-1:0] a;
    logic [add_bit-1:0] b;
    assign a = sel ? a1 : a2;
    assign b = sel ? b1 : b2;
    assign {carry,sum} = a + b;
`else
    logic [add_bit-1:0] sum1;
    logic [add_bit-1:0] sum2;
    logic carry1;
    logic carry2;
    assign {carry1,sum1} = a1 + b1;
    assign {carry2,sum2} = a2 + b2;
    assign carry = sel ? carry1 : carry2;
    assign sum = sel ? sum1 : sum2;
`endif
endmodule