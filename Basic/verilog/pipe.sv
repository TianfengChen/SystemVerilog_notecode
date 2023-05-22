//`timescale 1ns/100ps
module pipe 
	#(
		parameter WIDTH=8,
		parameter DEPTH=4
		)
	(
	input clk, reset,
	input [WIDTH-1:0] data_in,
    input valid_in,
	output reg [WIDTH-1:0] data_out,
    output reg valid_out
	);
     
	wire [(DEPTH-1)*WIDTH-1:0] internal_wire_data;
	wire [DEPTH-1:0] internal_wire_valid;

	dff #(.WIDTH(WIDTH)) 
    data_chain [DEPTH-1:0] (
		.clock(clk),
		.reset(reset),
		.data_in({internal_wire_data,data_in}),
		.data_out({data_out,internal_wire_data})
		);

    dff #(.WIDTH(1)) 
    valid_chain [DEPTH-1:0] (
		.clock(clk),
		.reset(reset),
		.data_in({internal_wire_valid,valid_in}),
		.data_out({valid_out,internal_wire_valid})
		);

endmodule


module dff #(parameter WIDTH=8)
	(
	input clock, reset,
	input [WIDTH-1:0] data_in,

	output reg [WIDTH-1:0] data_out
	);

	//synopsys sync_set_reset "reset"
	always @(posedge clock) begin
		if (reset) begin
			data_out 	<=	0;
		end
		else begin
			data_out 	<= 	data_in;
		end
	end

endmodule
