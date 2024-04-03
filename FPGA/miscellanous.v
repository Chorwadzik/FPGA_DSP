`include "global.v" 

module Sync_latch_input(clk_i, in, out, reset_i, set_i); 
	parameter OUT_POLARITY = 0; 
	parameter STEPS = 2; 
	localparam STEPS_INT = (STEPS < 2) ? 2 : STEPS; 
	input clk_i; 
	input in; 
	output reg out; 
	input reset_i; 
	input set_i; 

	reg [STEPS_INT-1:0] in_r; 
	reg in_latch; 
	always @(posedge clk_i or posedge in) begin
		if(in) 
			in_latch <= 1'b1; 
		else if(in_r[0]) 
			in_latch <= 1'b0;
	end 
 
	always @(posedge clk_i) begin 
		in_r <= {in_latch, in_r[STEPS_INT-1:1]}; 
		if(OUT_POLARITY) begin 
			if(reset_i) 
				out <= 1'b0;
			else if(in_r[1:0] == 2'b10 || set_i) 
				out <= 1'b1; 
		end 
		else begin 
			if(in_r[1:0] == 2'b10 || reset_i) 
				out <= 1'b0;	
			else if(set_i) 
				out <= 1'b1;				
		end 
	end 
 
	initial begin 
		in_latch = 0; 
		out = 0; 
		in_r = 0; 
	end 
endmodule 
