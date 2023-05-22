//valid_1 pulse clk1->clk2 valid2 up 
//next clock if see ready2 ==1 , valid2 down
//pulse_2 clk2 -> clk1
//ready1
//clk1 fast to clk2 slow
//also need a two stage synchronizor to accross clock domain
//use clock gating
module handshake_reciever(
    input        clk_2,
    input        reset_2,
    input        [7:0] data_1,
    output logic [7:0] data_2,
    input        ready_2,
    output logic ready_level,
    input        valid_level,
    output logic valid_2
    );

    logic ready_pulse_2;
    logic valid_pulse_2;
    logic [7:0] data_reg;

    assign data_2 = data_reg;
    assign ready_pulse_2 = ready_2 & valid_2;

    sender_pulse_syn ready_sender(
        .clk(clk_2),
        .reset(reset_2),
        .pulse_in(ready_pulse_2),
        .level(ready_level)
    );
    reciever_pulse_syn valid_reciever(
        .clk(clk_2),
        .reset(reset_2),
        .level(valid_level),
        .pulse_out(valid_pulse_2)
    );

    always_ff @(posedge clk_2, posedge reset_2)
    begin
        if(reset_2==1)
        begin
            valid_2     <= 0;
            data_reg    <= 0;
        end
        else
        begin
            if (valid_pulse_2 == 1)
            begin
                valid_2 <= 1'b1;
                data_reg<= data_1;
            end
            else
            begin
                data_reg <= data_reg;
                if (ready_2 == 1)
                    valid_2  <= 1'b0;
                else
                    valid_2  <= valid_2;
            end
        end
    end
endmodule

module handshake_sender(
    input        clk_1,
    input        reset_1,
    input        valid_1,
    output logic valid_level,
    input        ready_level,
    output logic ready_1
    //input  [7:0] data_in,
    //output logic [7:0] data_out
);
    //assign data_out = data_in; //if circuit layout has limitation, use this
    sender_pulse_syn valid_sender(
        .clk(clk_1),
        .reset(reset_1),
        .pulse_in(valid_1),
        .level(valid_level)
    );
    reciever_pulse_syn ready_reciever(
        .clk(clk_1),
        .reset(reset_1),
        .level(ready_level),
        .pulse_out(ready_1)
    );

endmodule