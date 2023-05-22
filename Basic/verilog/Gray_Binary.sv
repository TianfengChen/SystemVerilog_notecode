
module Binary2Gray
#(
    parameter WIDTH = 4
)
(
    input [WIDTH-1:0] binary,
    output logic [WIDTH-1:0] gray
);

    //assign gray[0] = binary[0];
    //assign gray[1] = binary[0] ^ binary[1];
    //assign gray[2] = binary[1] ^ binary[2];
    //assign gray[3] = binary[2] ^ binary[3];

    assign gray = binary ^ (binary >> 1);

endmodule

module Gray2Binary
#(
    parameter WIDTH = 4
)
(
    input [WIDTH-1:0] gray,
    output logic [WIDTH-1:0] binary
);
    assign binary[WIDTH-1] = gray[WIDTH-1];
    generate
        genvar i;
        for (i=0; i<WIDTH-1; i++)
        begin
            assign binary[i] = gray[i] ^ binary[i+1];
        end
    endgenerate
    
    //assign binary[3] = gray[3];
    //assign binary[2] = gray[3] ^ gray[2];
    //assign binary[1] = gray[3] ^ gray[2] ^ gray[1];
    //assign binary[0] = gray[3] ^ gray[2] ^ gray[1] ^ gray[0];

endmodule