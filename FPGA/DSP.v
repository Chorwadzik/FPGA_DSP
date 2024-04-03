`timescale 1ns/1ps

module addr_gen_no_series(clk, addr_sel, addr_ptr, addr_out);
	parameter ADDR_WIDTH = 9;
	parameter [ADDR_WIDTH-1:0] ADDR_START_STATES = 9'd0;
	parameter [ADDR_WIDTH-1:0] ADDR_START_COMMON = 9'd0;
	parameter [ADDR_WIDTH-1:0] ADDR_INC_STATES = 1'b1;
	parameter [ADDR_WIDTH-1:0] ADDR_INC_COMMON = 1'b1;

	localparam OFFSET_WIDTH = ($clog2(ADDR_INC_STATES) > $clog2(ADDR_INC_COMMON) ? $clog2(ADDR_INC_STATES) : $clog2(ADDR_INC_COMMON))+1;

	input clk;
	input [3:0] addr_sel;
	input [OFFSET_WIDTH-1:0] addr_ptr;
	output reg [ADDR_WIDTH-1:0] addr_out;
	
	reg [ADDR_WIDTH-1:0] cnt[1:0];
	reg [OFFSET_WIDTH-1:0] addr_ptr_r[1:0];
	reg [ADDR_WIDTH-1:0] addr_reg[1:0];
	
	initial begin
		cnt[0] = ADDR_START_STATES;
		cnt[1] = ADDR_START_COMMON;
	end
	
	always @(posedge clk) begin
		addr_ptr_r[0] <= addr_ptr;
		addr_ptr_r[1] <= addr_ptr_r[0];
		addr_reg[0] <= cnt[addr_ptr[OFFSET_WIDTH-1]];
		addr_reg[1] <= addr_reg[0];
		addr_out <= addr_reg[0] + addr_ptr_r[0][OFFSET_WIDTH-2:0];
		if(addr_sel[0]) cnt[0] <= cnt[0] + ADDR_INC_STATES;
		if(addr_sel[1]) cnt[0] <= ADDR_START_STATES;
		if(addr_sel[2]) cnt[1] <= cnt[1] + ADDR_INC_COMMON;
		if(addr_sel[3]) cnt[1] <= ADDR_START_COMMON;
	end
endmodule

module addr_gen(clk, addr_sel, addr_ptr, addr_out, series_inc, series_rst);
	parameter ADDR_WIDTH = 9;
	parameter [ADDR_WIDTH-1:0] ADDR_START_STATES = 9'd0;
	parameter [ADDR_WIDTH-1:0] ADDR_START_COMMON = 9'd0;
	parameter [ADDR_WIDTH-1:0] ADDR_INC_STATES = 1'b1;
	parameter [ADDR_WIDTH-1:0] ADDR_INC_COMMON = 1'b1;
	parameter [ADDR_WIDTH-1:0] ADDR_INC_SERIES = 9'd0;

	localparam OFFSET_WIDTH = ($clog2(ADDR_INC_STATES) > $clog2(ADDR_INC_COMMON) ? $clog2(ADDR_INC_STATES) : $clog2(ADDR_INC_COMMON))+1;

	input clk;
	input [3:0] addr_sel;
	input [OFFSET_WIDTH-1:0] addr_ptr;
	output reg [ADDR_WIDTH-1:0] addr_out;
	input series_inc;
	input series_rst;
	
	reg [ADDR_WIDTH-1:0] cnt[1:0];
	reg [OFFSET_WIDTH-1:0] addr_ptr_r[1:0];
	reg [ADDR_WIDTH-1:0] addr_reg[1:0];
	reg [ADDR_WIDTH-1:0] series_r;
	reg series_inc_r;
	reg series_rst_r;
	
	initial begin
		cnt[0] = ADDR_START_STATES;
		cnt[1] = ADDR_START_COMMON;
		series_r = 0;
	end
	
	always @(posedge clk) begin
		series_inc_r <= series_inc;
		series_rst_r <= series_rst;
		if(series_inc_r) series_r <= series_r + ADDR_INC_SERIES;
		if(series_rst_r) series_r <= 0;
		addr_ptr_r[0] <= addr_ptr;
		addr_ptr_r[1] <= addr_ptr_r[0];
		addr_reg[0] <= cnt[addr_ptr[OFFSET_WIDTH-1]];
		addr_reg[1] <= addr_reg[0] + series_r;
		addr_out <= addr_reg[1] + addr_ptr_r[1][OFFSET_WIDTH-2:0];
		if(addr_sel[0]) cnt[0] <= cnt[0] + ADDR_INC_STATES;
		if(addr_sel[1]) cnt[0] <= ADDR_START_STATES;
		if(addr_sel[2]) cnt[1] <= cnt[1] + ADDR_INC_COMMON;
		if(addr_sel[3]) cnt[1] <= ADDR_START_COMMON;
	end
endmodule

module pipeline_delay(clk, in, out);
	parameter WIDTH = 1;
	parameter CYCLES = 1;
	parameter SHIFT_MEM = 0;
	input clk;
	input [WIDTH-1:0] in;
	output [WIDTH-1:0] out;
	reg [WIDTH-1:0] in_r[CYCLES-1:0];
	
	genvar i;
	
	//for (i = 0; i < CYCLES; i = i + 1)
        //initial in_r[i] = 0;

	if(SHIFT_MEM) begin
		pmi_distributed_shift_reg
		#(.pmi_data_width(WIDTH), .pmi_regmode("reg"), .pmi_shiftreg_type("fixed"), .pmi_num_shift(CYCLES - 1),
		.pmi_num_width(), .pmi_max_shift(), .pmi_max_width(), .pmi_init_file(),
		.pmi_init_file_format(), .pmi_family())
		Mem0_wreg(.Din(in), .Addr(), .Clock(clk), .ClockEn(1'b1), .Reset(1'b0),
		.Q(out));
	end
	else begin
		always @(posedge clk) in_r[CYCLES-1] <= in;
		for (i = 0; i < CYCLES-1; i = i + 1)
			always @(posedge clk) in_r[i] <= in_r[i+1];
		assign out = in_r[0];
	end
endmodule
