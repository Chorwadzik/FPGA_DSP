`include "global.v"

module SerDes_tb;
	reg XTAL_250MHz;

	GSR GSR_INST (.GSR (1'b1));
	PUR PUR_INST (.PUR (1'b0));

	reg[15:0] i;

	always begin
		i = 0;
		forever begin
			#2
			i <= i+1;
			if(i>=4000) $stop;
		end
	end

	localparam EMIF_MEMORY_WIDTH = `COMM_MEMORY_EMIF_WIDTH+3;
	wire EMIF_oe_i; 
	wire EMIF_we_i; 
	wire EMIF_cs_i; 
	wire[31:0] EMIF_data_i;
	wire[EMIF_MEMORY_WIDTH-1:0] EMIF_address_i; 
 
	assign clk_DSP = XTAL_250MHz;
	
	wire Kalman1_WIP;
	wire Kalman1_START;
	
	wire Kalman1_Mem2_we;
	wire[8:0] Kalman1_Mem2_addrw;
	wire[35:0] Kalman1_Mem2_data;
	wire[31:0] Kalman1_data_o;
	wire [53:0] Kalman1_CIN;
	wire [53:0] Kalman1_CO;
	wire Kalman1_SIGNEDCIN;
	wire Kalman1_SIGNEDCO;

	parameter Kalman1_Mem2_key = 3'd6;
	Kalman #(.DEBUG(1), .HARMONICS_NUM(26), .IN_SERIES_NUM(6)) Kalman1(.clk_i(clk_DSP), .Mem1_data_i(EMIF_data_i), .Mem1_addrw_i(EMIF_address_i[`COMM_MEMORY_EMIF_WIDTH-1:0]), .Mem1_clk_w(EMIF_we_i),
	.Mem1_clk_en_w(EMIF_address_i[EMIF_MEMORY_WIDTH-2 +: 2] == Kalman1_Mem2_key[1 +: 2]), .Mem1_we_i(EMIF_address_i[EMIF_MEMORY_WIDTH-3] == Kalman1_Mem2_key[0]),
	.enable_i(Kalman1_START), .Mem2_addrw_o(Kalman1_Mem2_addrw), .Mem2_we_o(Kalman1_Mem2_we), .Mem2_data_o(Kalman1_Mem2_data), .WIP_flag_o(Kalman1_WIP),
	.CIN(Kalman1_CIN), .SIGNEDCIN(Kalman1_SIGNEDCIN), .CO(Kalman1_CO), .SIGNEDCO(Kalman1_SIGNEDCO));

	assign Kalman1_START = i[10];
	assign Kalman1_SIGNEDCIN = 1;
	assign Kalman1_CIN = 0;
	
	wire Resonant1_WIP;
	wire Resonant1_START;
	
	wire Resonant1_Mem2_we;
	wire[8:0] Resonant1_Mem2_addrw;
	wire[35:0] Resonant1_Mem2_data;
	wire[31:0] Resonant1_data_o;
	wire [53:0] Resonant1_CIN;
	wire [53:0] Resonant1_CO;
	wire Resonant1_SIGNEDCIN;
	wire Resonant1_SIGNEDCO;
	
	Resonant_grid #(.DEBUG(1)) Resonant1(.clk_i(clk_DSP), .Mem1_data_i(EMIF_data_i), .Mem1_addrw_i(EMIF_address_i[`COMM_MEMORY_EMIF_WIDTH-1:0]), .Mem1_clk_w(EMIF_we_i),
	.Mem1_clk_en_w(EMIF_address_i[EMIF_MEMORY_WIDTH-2 +: 2] == Kalman1_Mem2_key[1 +: 2]), .Mem1_we_i(EMIF_address_i[EMIF_MEMORY_WIDTH-3] == Kalman1_Mem2_key[0]),
	.enable_i(Resonant1_START), .Mem2_addrw_o(Resonant1_Mem2_addrw), .Mem2_we_o(Resonant1_Mem2_we), .Mem2_data_o(Resonant1_Mem2_data), .WIP_flag_o(Resonant1_WIP),
	.CIN(Resonant1_CIN), .SIGNEDCIN(Resonant1_SIGNEDCIN), .CO(Resonant1_CO), .SIGNEDCO(Resonant1_SIGNEDCO));

	assign Resonant1_START = i[10];
	assign Resonant1_SIGNEDCIN = 1;
	assign Resonant1_CIN = 0;
	
	assign EMIF_oe_i = 1; 
	assign EMIF_we_i = 1; 
	assign EMIF_cs_i = 1; 
	assign EMIF_data_i = 0;
	assign EMIF_address_i = 0; 
	
	always begin
		XTAL_250MHz = 0;
		forever
			#2 XTAL_250MHz = !XTAL_250MHz;
	end
endmodule

