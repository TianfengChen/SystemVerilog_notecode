//iverilog -g2012 -o decoder testbench/decoder_tb.sv verilog/decoder.sv
//vvp decoder

module decoder_2_4(
    input [1:0] in,
    input enable,
    output logic [3:0] out
);
    always @(*)
    begin
        if(enable)
        begin
            case(in)
                2'b00: out = 4'b0001;
                2'b01: out = 4'b0010;
                2'b10: out = 4'b0100;
                2'b11: out = 4'b1000;
            endcase
        end
        else
        begin
            out = 4'b0000;
        end
    end

endmodule

module decoder_4_16(
    input [3:0] in,
    input enable,
    output logic [15:0] out
);
    logic [3:0] out_1;

    decoder_2_4 level1(
        .in(in[3:2]),
        .enable(enable),
        .out(out_1)
    );
    decoder_2_4 level2[3:0](
        .in({4{in[1:0]}}),
        .enable(out_1),
        .out(out)
    );
endmodule

