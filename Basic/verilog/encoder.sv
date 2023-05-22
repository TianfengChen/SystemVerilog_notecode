//iverilog -g2012 -o encoder testbench/encoder_tb.sv verilog/encoder.sv
//vvp encoder

module encoder_4_2(
    input [3:0] in,
    output status,
    output logic [1:0] out
);
    assign status = (in[3] | in[2] | in[1] | in[0]) ? 1'b1 : 1'b0;
    always@(*)
    begin
        case(in)
            4'b0001: out = 2'b00;
            4'b0010: out = 2'b01;
            4'b0100: out = 2'b10;
            4'b1000: out = 2'b11;
            default: out = 2'b00;
        endcase
    end
endmodule


module encoder_16_4(
    input [15:0] in,
    output status,
    output logic [3:0] out
);
    logic [3:0] status1;
    logic [7:0] out_01;
    encoder_4_2 level1[3:0](
        .in(in),
        .status(status1),
        .out(out_01)
    );
    
    encoder_4_2 level2(
        .in(status1),
        .status(status),
        .out(out[3:2])
    );
    assign out[0] = out_01[0]|out_01[2]|out_01[4]|out_01[6];
    assign out[1] = out_01[1]|out_01[3]|out_01[5]|out_01[7];
    
endmodule

