//clk2 pulse1-> clk2 level-> clk1 pulse2
//flip level when pulse1 reachs synchronizor
//produce pulse2 signal when level flips
module sender_pulse_syn(
    input clk,reset,
    input pulse_in,
    output logic level
);
    logic level_next;
    logic pulse_edge;
    logic pulse_temp;

    assign pulse_edge = ~pulse_temp & pulse_in;//sensitive to posedge
    assign level_next = pulse_edge ^ level;

    always_ff@(posedge clk, posedge reset)
    begin
        if (reset == 1)
        begin
            pulse_temp <= 0;
            level      <= 0; 
        end
        else
        begin
            pulse_temp <= pulse_in;
            level      <= level_next;
        end
    end
endmodule

module reciever_pulse_syn(
    input clk,reset,
    input level,
    output logic pulse_out
);
    logic level_q;
    assign pulse_out = level_q ^ level;
    always_ff@(posedge clk, posedge reset)
    begin
        if (reset == 1)
            level_q      <= 0; 
        else
            level_q      <= level;
    end
endmodule