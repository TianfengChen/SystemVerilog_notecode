module mux
    #(  parameter CASE0 = 2'b00,
        parameter CASE1 = 2'b01,
        parameter CASE2 = 2'b10,
        parameter CASE3 = 2'b11,
        parameter MUX_NUM = 4)
    (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [1:0] sel,
    output reg [3:0] out
    );

    generate
        if (MUX_NUM == 4)
        begin: mux4_1
            /*case
                synthesis: full case and parallel case
            */
            always @(*)
            begin
                case(sel)
                    CASE0: out = a;
                    CASE1: out = b;
                    CASE2: out = c;
                    CASE3: out = d;
                    default: out = 4'b0000;
                endcase
            end
        end
        else if (MUX_NUM == 2)
        begin: mux2_1
            /*if 
                synthesis: if has priority
                incomplete if will lead to latch
                latch will lead to timing problem
            */
            always @(*)
            begin
                if(sel == 2'b00)
                    out = a;
                else if(sel == 2'b01)
                    out = b;
                else
                    out = 4'b0000;
            end
        end
    endgenerate

endmodule