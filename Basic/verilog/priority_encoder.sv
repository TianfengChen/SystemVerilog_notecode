module priority_encoder(
    input [3:0] in,
    output status,
    output logic [1:0] out
);
    always@(*)
    begin
        casez(in)
            4'b0001: begin status = 1; out = 2'b00; end
            4'b001?: begin status = 1; out = 2'b01; end
            4'b01??: begin status = 1; out = 2'b10; end
            4'b1???: begin status = 1; out = 2'b11; end
            default: begin status = 0; out = 2'b00; end
        endcase
    end

endmodule