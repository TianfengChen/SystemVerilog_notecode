//`timescale 1ns/100ps
module synchronizor 
	#(
		parameter WIDTH=8,
		parameter DEPTH=4
		)
	(
	input clk, reset,
	input [WIDTH-1:0] data_in,

	output reg [WIDTH-1:0] data_out
	);
     
	wire [(DEPTH-1)*WIDTH-1:0] internal_wire;

	dff #(.WIDTH(WIDTH)) 
    dff_chain [DEPTH-1:0] (
		.clock(clk),
		.reset(reset),
		.data_in({internal_wire,data_in}),
		.data_out({data_out,internal_wire})
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
