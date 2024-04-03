`timescale 1ns/1ps

module Resonant_grid(clk_i, Mem1_data_i, Mem1_addrw_i, Mem1_we_i, Mem1_clk_w, Mem1_clk_en_w, enable_i, Mem2_addrw_o, Mem2_we_o, Mem2_data_o, WIP_flag_o, CIN, SIGNEDCIN, CO, SIGNEDCO);
	parameter HARMONICS_NUM = 25;
	parameter DEBUG = 0;
	localparam QMATH_SHIFT = 2;
	
	localparam READ_DELAY = 4;
	localparam HARMONICS_CNT_WIDTH = $clog2(HARMONICS_NUM);
	
	localparam M0_ADDR_WIDTH = 9;
	localparam M0_ADDR_NUM = 2**M0_ADDR_WIDTH;	
	localparam M0_STATES_OFFSET_NUMBER = 9'd5;
	localparam SM0_GX1 = 4'b0000; 
	localparam SM0_GX2 = 4'b0001;
	localparam SM0_CX1 = 4'b0010; 
	localparam SM0_CX2 = 4'b0011; 
	localparam SM0_ERR = 4'b0100;
	
	localparam M0_COMMON_OFFSET_NUMBER = 9'd2;
	localparam M0_START_COMMON = M0_STATES_OFFSET_NUMBER*HARMONICS_NUM;
	localparam CM0_SUM = 4'b1000;
	localparam CM0_IC = 4'b1001;
	
	localparam M0_PTR_WIDTH = ($clog2(M0_COMMON_OFFSET_NUMBER) > $clog2(M0_STATES_OFFSET_NUMBER) ? $clog2(M0_COMMON_OFFSET_NUMBER) : $clog2(M0_STATES_OFFSET_NUMBER))+1;
	localparam M0_SERIES_LENGTH = M0_STATES_OFFSET_NUMBER*HARMONICS_NUM + M0_COMMON_OFFSET_NUMBER;

	localparam M1_ADDR_WIDTH = 9;
	localparam M1_ADDR_NUM = 2**M1_ADDR_WIDTH;
	localparam M1_STATES_OFFSET_NUMBER = 9'd10;
	localparam M1_STATES_OFFSET_WIDTH = $clog2(M1_STATES_OFFSET_NUMBER);	
	localparam SM1_CA = 5'b00000;
	localparam SM1_SA = 5'b00001;
	localparam SM1_GCB = 5'b00010;
	localparam SM1_GSB = 5'b00011;
	localparam SM1_CCB = 5'b00100;
	localparam SM1_CSB = 5'b00101;
	localparam SM1_GCC = 5'b00110;
	localparam SM1_GSC = 5'b00111;
	localparam SM1_CCC = 5'b01000;
	localparam SM1_CSC = 5'b01001;
	
	localparam M1_COMMON_OFFSET_NUMBER = 9'd6;
	localparam M1_START_COMMON = M1_STATES_OFFSET_NUMBER*HARMONICS_NUM;
	localparam CM1_HC = 5'b10000;
	localparam CM1_HG = 5'b10001;
	localparam CM1_ZR = 5'b10010;
	localparam CM1_RT = 5'b10011;
	localparam CM1_IC = 5'b10100;
	localparam CM1_IG = 5'b10101;
	
	localparam M1_PTR_WIDTH = ($clog2(M1_COMMON_OFFSET_NUMBER) > $clog2(M1_STATES_OFFSET_NUMBER) ? $clog2(M1_COMMON_OFFSET_NUMBER) : $clog2(M1_STATES_OFFSET_NUMBER))+1;
	localparam M1_SERIES_LENGTH = M1_STATES_OFFSET_NUMBER*HARMONICS_NUM + M1_COMMON_OFFSET_NUMBER;

	localparam SEL_WIDTH = 4;
	localparam SEL_NONE = 4'b0000;
	localparam SEL_S_INC = 4'b0001;
	localparam SEL_S_RST = 4'b0010;
	localparam SEL_C_INC = 4'b0100;
	localparam SEL_C_RST = 4'b1000;

	localparam OPCODE_WIDTH = 4;
	localparam OPCODE_SUM_A_B_C = 4'b0100;
	localparam OPCODE_SUM_A_NB_C = 4'b0101; 
	localparam OPCODE_SUM_A_B_NC = 4'b0110;
	localparam OPCODE_SUM_A_NB_NC = 4'b0111; 
	localparam OPCODE_XNOR_BC = 4'b1100; 
	localparam OPCODE_XOR_BC = 4'b1110; 
	localparam OPCODE_NAND_BC = 4'b0000; 
	localparam OPCODE_AND_BC = 4'b1000; 
	localparam OPCODE_OR_BC = 4'b0011; 
	localparam OPCODE_NOR_BC = 4'b1011; 

	localparam AMUX_WIDTH = 2;
	localparam AMUX_ALU_FB = 2'b00; 
	localparam AMUX_MULTA = 2'b01; 
	localparam AMUX_A_ALU = 2'b10; 
	localparam AMUX_GND = 2'b11; 

	localparam BMUX_WIDTH = 2;
	localparam BMUX_MULTB_L18 = 2'b00; 
	localparam BMUX_MULTB = 2'b01;
	localparam BMUX_B_ALU = 2'b10; 
	localparam BMUX_GND = 2'b11; 

	localparam CMUX_WIDTH = 3; 
	localparam CMUX_GND = 3'b000; 
	localparam CMUX_CIN_R18 = 3'b001;
	localparam CMUX_CIN = 3'b010; 
	localparam CMUX_C_ALU = 3'b011; 
	localparam CMUX_A_ALU = 3'b100; 
	localparam CMUX_ALU_FB = 3'b101; 
	localparam CMUX_RND_PN = 3'b110; 
	localparam CMUX_RND_PNM = 3'b111; 

	localparam AAMEM_WIDTH = 1; 	
	localparam ABMEM_WIDTH = 1;
	localparam BAMEM_WIDTH = 1;
	localparam BBMEM_WIDTH = 1;
	localparam CMEM_WIDTH = 1; 
	
	localparam AA_M0L = 1'b0;
	localparam AA_M0H = 1'b1;

	localparam AB_M1L = 1'b0;
	localparam AB_M1H = 1'b1;
		
	localparam BA_M0L = 1'b0;
	localparam BA_M0H = 1'b1;
	
	localparam BB_RM1L = 1'b0;
	localparam BB_M1H = 1'b1;
	
	localparam C_M0 = 1'b0; 
	localparam C_M1 = 1'b1; 
	
	input clk_i;
	
	input [31:0] Mem1_data_i;
	input [M1_ADDR_WIDTH-1:0] Mem1_addrw_i;
	input Mem1_we_i;
	input Mem1_clk_w;
	input Mem1_clk_en_w;
	
	output [M0_ADDR_WIDTH-1:0] Mem2_addrw_o;
	output Mem2_we_o;
	output [35:0] Mem2_data_o;
	
	input enable_i;
	output WIP_flag_o;
	
	input wire [53:0] CIN;
	input wire SIGNEDCIN;
	output wire [53:0] CO;
	output wire SIGNEDCO;

	localparam CNT_WIDTH = 6;
	reg [CNT_WIDTH-1:0] cnt;
	reg [CNT_WIDTH-1:0] cnt_jump;
	
	reg [31:0] harmonics_grid;
	reg zero_error;
	
	reg [READ_DELAY:0] harm_save_r;
	reg [HARMONICS_CNT_WIDTH-1:0] harmonics_cmp;
	
	reg [HARMONICS_CNT_WIDTH-1:0] harmonics_cnt;	
	reg harmonics_inc;
	reg harmonics_rst;
	reg harmonics_end;
		
	reg[OPCODE_WIDTH-1:0]Opcode;
	reg[AMUX_WIDTH-1:0]AMuxsel;
	reg[BMUX_WIDTH-1:0]BMuxsel;
	reg[CMUX_WIDTH-1:0]CMuxsel;
	reg[AAMEM_WIDTH-1:0]AAMemsel;
	reg[ABMEM_WIDTH-1:0]ABMemsel;
	reg[BAMEM_WIDTH-1:0]BAMemsel;
	reg[BBMEM_WIDTH-1:0]BBMemsel;
	reg[CMEM_WIDTH-1:0]CMemsel;
    reg CE1;
			
	wire [35:0] Mem0_data_i;
	reg Mem0_we;				
	reg [SEL_WIDTH-1:0] addrw_M0_sel;
	reg [M0_PTR_WIDTH-1:0] addrw_M0_ptr;
	wire [M0_ADDR_WIDTH-1:0] addrw_M0_out;
	
	reg [SEL_WIDTH-1:0] addrr_M0_sel;
	reg [M0_PTR_WIDTH-1:0] addrr_M0_ptr;
	wire [M0_ADDR_WIDTH-1:0] addrr_M0_out;
	wire [35:0] Mem0_data_o;

	reg [SEL_WIDTH-1:0] addrr_M1_sel;
	reg [M1_PTR_WIDTH-1:0] addrr_M1_ptr;
	wire [M1_ADDR_WIDTH-1:0] addrr_M1_out;
	wire [35:0] Mem1_data_o;
	
	
	wire[OPCODE_WIDTH-1:0]Opcode_pip;
	wire[AMUX_WIDTH-1:0]AMuxsel_pip;
	wire[BMUX_WIDTH-1:0]BMuxsel_pip;
	wire[CMUX_WIDTH-1:0]CMuxsel_pip;
	wire[AAMEM_WIDTH-1:0]AAMemsel_pip;
	wire[ABMEM_WIDTH-1:0]ABMemsel_pip;
	wire[BAMEM_WIDTH-1:0]BAMemsel_pip;
	wire[BBMEM_WIDTH-1:0]BBMemsel_pip;
	wire[CMEM_WIDTH-1:0]CMemsel_pip;
		
	wire CE1_pip;
	
	wire [M0_ADDR_WIDTH-1:0] Mem0_addrw_pip;
	wire Mem0_we_pip;
	
	Sync_latch_input #(.OUT_POLARITY(1), .STEPS(2)) 
	code_start(.clk_i(clk_i), .in(enable_i), .out(WIP_flag_o), .reset_i(cnt == 62), .set_i(1'b0));
	
	assign Mem2_data_o = Mem0_data_i;
	assign Mem2_addrw_o = Mem0_addrw_pip;
	assign Mem2_we_o = Mem0_we_pip;	
	
	initial begin
		cnt = -1;
		harmonics_cnt = 0;
		harmonics_grid = 0;
		zero_error = 0;		
		Opcode = OPCODE_SUM_A_B_C;
		AMuxsel = AMUX_GND;
		BMuxsel = BMUX_GND;
		CMuxsel = CMUX_GND;
		CE1 = 0;
		addrr_M0_sel = 0;
		addrr_M0_ptr = 0;
		addrr_M1_sel = 0;
		addrr_M1_ptr = 0;
		addrw_M0_sel = 0;
		addrw_M0_ptr = 0;
		Mem0_we = 0;
		harmonics_cmp = 2;
		harm_save_r = 0;
	end
	
	reg cnt_25;
	
	always @(posedge clk_i) begin
		Opcode <= OPCODE_SUM_A_B_C;
		AMuxsel <= AMUX_GND;
		BMuxsel <= BMUX_GND;
		CMuxsel <= CMUX_GND;
		AAMemsel <= AA_M0H;
		ABMemsel <= AB_M1H;
		BAMemsel <= BA_M0H;
		BBMemsel <= BB_M1H;
		CMemsel <= C_M1;
		CE1 <= 1'b1;
		addrr_M0_sel <= 0;
		addrr_M0_ptr <= 0;
		addrr_M1_sel <= 0;
		addrr_M1_ptr <= 0;
		addrw_M0_sel <= 0;
		addrw_M0_ptr <= 0;
		Mem0_we <= 0;
		
		cnt_25 <= cnt == 24;
		if(cnt_25) harmonics_grid <= {1'b0, harmonics_grid[31:1]};
			
		harm_save_r <= {cnt == 2, harm_save_r[READ_DELAY:1]};
		if(harm_save_r[2]) harmonics_cmp <= Mem1_data_o[4 +: HARMONICS_CNT_WIDTH];
		if(harm_save_r[1]) harmonics_grid <= Mem1_data_o[4 +: 32];
		if(harm_save_r[0]) zero_error <= Mem1_data_o[4+32-QMATH_SHIFT];
			
		if(harmonics_inc) harmonics_cnt <= harmonics_cnt + 1'b1;
		if(harmonics_rst) harmonics_cnt <= 0;
		harmonics_end <= harmonics_cnt == harmonics_cmp;
		harmonics_inc <= 0;
		harmonics_rst <= 0;
						
		if(WIP_flag_o) begin
			cnt <= cnt + 1'b1;
			if(!harmonics_end & harmonics_inc) cnt <= cnt_jump;
		end
				
		case(cnt)
			0: begin
				addrr_M1_ptr <= CM1_HC;
			end
			1: begin
				addrr_M1_ptr <= CM1_HG;
			end 
			2: begin
				addrr_M1_ptr <= CM1_ZR;
			end 
			3: begin
				addrr_M1_ptr <= CM1_IC;
											
				CMemsel <= C_M1;
								
				CMuxsel <= CMUX_C_ALU;
				
				addrw_M0_ptr <= CM0_IC;
				Mem0_we <= 1'b1;	
			end
//-------------------------------------------------
			4: begin
				addrr_M1_ptr <= CM1_IG;
											
				CMemsel <= C_M1;
								
				CMuxsel <= CMUX_C_ALU;
				
				cnt_jump <= cnt;
				harmonics_inc <= 1'b1;		
			end
			5: begin
				addrr_M0_ptr <= SM0_GX1;
											
				CMemsel <= C_M0;
								
				AMuxsel <= AMUX_ALU_FB;
				CMuxsel <= CMUX_C_ALU;
				
				Opcode <= OPCODE_SUM_A_B_NC;
				
				addrw_M0_ptr <= SM0_ERR;
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			6: begin
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
//-------------------------------------------------
			7: begin
				addrr_M0_ptr <= SM0_GX2;
				addrr_M1_ptr <= SM1_SA;
																
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				Opcode <= OPCODE_SUM_A_B_NC;
				
				CE1 <= 1'b0;
				
				cnt_jump <= cnt;
			end
			8: begin
				addrr_M0_ptr <= SM0_GX1;
				addrr_M1_ptr <= SM1_CA;

				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_NB_NC;
			end
			9: begin
				addrr_M0_ptr <= SM0_GX1;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
			end
			10: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= SM1_GSB;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				CE1 <= 1'b0;
			end
			11: begin
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= SM0_GX1;				
				Mem0_we <= 1'b1;
			end
			12: begin
				addrr_M0_ptr <= SM0_GX1;
				addrr_M1_ptr <= SM1_SA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
								
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				CE1 <= 1'b0;
			end
			13: begin
				addrr_M0_ptr <= SM0_GX2;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
			end 
			14: begin
				addrr_M0_ptr <= SM0_GX2;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
			end
			15: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= SM1_GCB;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				CE1 <= 1'b0;
				
				harmonics_inc <= 1'b1;		
			end
			16: begin
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= SM0_GX2;
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			17: begin
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
//-------------------------------------------------
			18: begin
				addrr_M0_ptr <= SM0_GX2;
				addrr_M1_ptr <= SM1_GSC;
																
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				CE1 <= 1'b0;
				
				cnt_jump <= cnt;
			end
			19: begin
				addrr_M0_ptr <= SM0_GX1;
				addrr_M1_ptr <= SM1_GCC;

				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_NB_NC;
				
				harmonics_inc <= 1'b1;
			end
			20: begin
				addrr_M0_ptr <= SM0_GX1;
				addrr_M1_ptr <= SM1_GCC;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= SM0_ERR;
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			21: begin
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
//-------------------------------------------------
			22: begin
				addrr_M0_ptr <= CM0_IC;
				addrr_M1_ptr <= CM1_RT;
																
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				CE1 <= 1'b0;
				
				cnt_jump <= cnt;
			end
			23: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= CM1_RT;

				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_NB_NC;
			end
			24: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= CM1_RT;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				harmonics_inc <= 1'b1;		
			end
			25: begin
				addrr_M0_ptr <= CM0_IC;
											
				CMemsel <= C_M0;
								
				if(zero_error) begin
					if(harmonics_grid[0]) AMuxsel <= AMUX_ALU_FB;
					CMuxsel <= CMUX_C_ALU;			
				end
				
				addrw_M0_ptr <= SM0_ERR;
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			26: begin
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
//-------------------------------------------------
			27: begin
				addrr_M0_ptr <= SM0_CX2;
				addrr_M1_ptr <= SM1_SA;
																
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				CE1 <= 1'b0;
				
				cnt_jump <= cnt;
			end
			28: begin
				addrr_M0_ptr <= SM0_CX1;
				addrr_M1_ptr <= SM1_CA;

				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_NB_NC;
			end
			29: begin
				addrr_M0_ptr <= SM0_CX1;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
			end
			30: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= SM1_CSB;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				CE1 <= 1'b0;
			end
			31: begin
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= SM0_CX1;				
				Mem0_we <= 1'b1;
			end
			32: begin
				addrr_M0_ptr <= SM0_CX1;
				addrr_M1_ptr <= SM1_SA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
								
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				
				CE1 <= 1'b0;
			end
			33: begin
				addrr_M0_ptr <= SM0_CX2;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
			end 
			34: begin
				addrr_M0_ptr <= SM0_CX2;
				addrr_M1_ptr <= SM1_CA;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
			end
			35: begin
				addrr_M0_ptr <= SM0_ERR;
				addrr_M1_ptr <= SM1_CCB;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				CE1 <= 1'b0;
				
				harmonics_inc <= 1'b1;		
			end
			36: begin
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= SM0_CX2;
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			37: begin
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
//-------------------------------------------------
			38: begin
				addrr_M0_ptr <= SM0_CX2;
				addrr_M1_ptr <= SM1_CSC;
																
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_B_NC;
				
				CE1 <= 1'b0;
				
				cnt_jump <= cnt;
			end
			39: begin
				addrr_M0_ptr <= SM0_CX1;
				addrr_M1_ptr <= SM1_CCC;

				AAMemsel <= AA_M0H;
				ABMemsel <= AB_M1L;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_RM1L;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB;
				CMuxsel <= CMUX_ALU_FB;
				
				Opcode <= OPCODE_SUM_A_NB_NC;
				
				harmonics_inc <= 1'b1;		
			end
			40: begin
				addrr_M0_ptr <= SM0_CX1;
				addrr_M1_ptr <= SM1_CCC;
				
				AAMemsel <= AA_M0L;
				ABMemsel <= AB_M1H;
				BAMemsel <= BA_M0H;
				BBMemsel <= BB_M1H;
				
				AMuxsel <= AMUX_MULTA;
				BMuxsel <= BMUX_MULTB_L18;
				CMuxsel <= CMUX_ALU_FB;
				
				addrr_M0_sel <= SEL_S_INC;
				addrr_M1_sel <= SEL_S_INC;
				addrw_M0_sel <= SEL_S_INC;
			end
//-------------------------------------------------
			41: begin
				CMuxsel <= CMUX_ALU_FB;
				
				addrw_M0_ptr <= CM0_SUM;				
				Mem0_we <= 1'b1;
				
				addrr_M0_sel <= SEL_S_RST;
				addrr_M1_sel <= SEL_S_RST;
				addrw_M0_sel <= SEL_S_RST;
				
				harmonics_rst <= 1'b1;
			end
			42: begin
				addrr_M0_sel <= SEL_C_RST;
				addrr_M1_sel <= SEL_C_RST;
				addrw_M0_sel <= SEL_C_RST;
			end
			43: begin
			end
            44: begin
			end
			45: begin
            end
            46: begin
            end
			47: begin
			end
            48: begin
            end
			49: begin
			end
            50: begin
            end
			51: begin
			end
			52: begin
			end
            53: begin
            end
			54: begin
			end
			55: begin
			end
			56: begin
			end
            57: begin
			end
			58: begin
            end
            59: begin
            end
            60: begin
			end
			61: begin
            end
            62: begin
			end
			63: begin
            end
		endcase
	end
	
	reg [35:0] Mem0_data_r;
	reg [35:0] Mem1_data_r;
	
	wire [17:0] DataAA [2**AAMEM_WIDTH-1:0];
	assign DataAA[0] = Mem0_data_o[17:0];
	assign DataAA[1] = Mem0_data_o[35:18];
	wire [17:0] DataAB [2**ABMEM_WIDTH-1:0];
	assign DataAB[0] = Mem1_data_o[17:0];
	assign DataAB[1] = Mem1_data_o[35:18];
	wire [17:0] DataBA [2**BAMEM_WIDTH-1:0];
	assign DataBA[0] = Mem0_data_o[35:18];
	assign DataBA[1] = Mem0_data_o[35:18];
	wire [17:0] DataBB [2**BBMEM_WIDTH-1:0];	
	assign DataBB[0] = Mem1_data_r[17:0];
	assign DataBB[1] = Mem1_data_o[35:18];
	wire [35:0] DataC [1:0];
	assign DataC[0] = Mem0_data_o;
	assign DataC[1] = Mem1_data_o;

	reg [35:0] DataC_r;
	always @(posedge clk_i) begin
		DataC_r <= DataC[CMemsel_pip];
		Mem0_data_r <= Mem0_data_o;
		Mem1_data_r <= Mem1_data_o;
	end
	
	Slice2 #(.QMATH_SHIFT(QMATH_SHIFT)) Slice2(.CLK0(clk_i), .CE0(1'b1), .CE1(CE1_pip), .CE2(1'b0), .CE3(1'b0), .RST0(1'b0), .RST1(1'b0), .RST2(1'b0), .RST3(1'b0),
	.AA(DataAA[AAMemsel_pip]), .AB(DataAB[ABMemsel_pip]), .BA(DataBA[BAMemsel_pip]), .BB(DataBB[BBMemsel_pip]), .C(DataC_r),
	.SignAA(AAMemsel_pip[0]), .SignAB(ABMemsel_pip[0]), .SignBA(BAMemsel_pip[0]), .SignBB(BBMemsel_pip[0]),
	.AMuxsel(AMuxsel_pip), .BMuxsel(BMuxsel_pip), .CMuxsel(CMuxsel_pip), .Opcode(Opcode_pip),
	.Result(Mem0_data_i), .R(CO), .SIGNEDR(SIGNEDCO), .CIN(CIN), .SIGNEDCIN(SIGNEDCIN),
	.EQZ(), .EQZM(), .EQOM(), .EQPAT(), .EQPATB(), .OVER(), .UNDER());
	
	pmi_ram_dp #(.pmi_wr_addr_depth(M0_ADDR_NUM), .pmi_wr_addr_width(M0_ADDR_WIDTH), .pmi_wr_data_width(36),
	.pmi_rd_addr_depth(M0_ADDR_NUM), .pmi_rd_addr_width(M0_ADDR_WIDTH), .pmi_rd_data_width(36), .pmi_regmode("reg"), 
	.pmi_gsr("enable"), .pmi_resetmode("sync"), .pmi_optimization("speed"), .pmi_family("ECP5U"),
	.pmi_init_file("../Mem0.mem"), .pmi_init_file_format("hex")
	)
	Mem0(.Data(Mem0_data_i), .WrAddress(Mem0_addrw_pip), .RdAddress(addrr_M0_out), .WrClock(clk_i),
	.RdClock(clk_i), .WrClockEn(1'b1), .RdClockEn(1'b1), .WE(Mem0_we_pip), .Reset(1'b0), 
	.Q(Mem0_data_o));
	
	if(DEBUG)
		pmi_ram_dp #(.pmi_wr_addr_depth(M1_ADDR_NUM), .pmi_wr_addr_width(M1_ADDR_WIDTH), .pmi_wr_data_width(36),
		.pmi_rd_addr_depth(M1_ADDR_NUM), .pmi_rd_addr_width(M1_ADDR_WIDTH), .pmi_rd_data_width(36), .pmi_regmode("reg"), 
		.pmi_gsr("enable"), .pmi_resetmode("sync"), .pmi_optimization("speed"), .pmi_family("ECP5U"),
		.pmi_init_file("../Mem1_RG.mem"), .pmi_init_file_format("hex")
		)
		Mem1(.Data({Mem1_data_i,{4{Mem1_data_i[31]}}}), .WrAddress(Mem1_addrw_i), .RdAddress(addrr_M1_out), .WrClock(Mem1_clk_w),
		.RdClock(clk_i), .WrClockEn(Mem1_clk_en_w), .RdClockEn(1'b1), .WE(Mem1_we_i), .Reset(1'b0), 
		.Q(Mem1_data_o));
	else
		pmi_ram_dp #(.pmi_wr_addr_depth(M1_ADDR_NUM), .pmi_wr_addr_width(M1_ADDR_WIDTH), .pmi_wr_data_width(36),
		.pmi_rd_addr_depth(M1_ADDR_NUM), .pmi_rd_addr_width(M1_ADDR_WIDTH), .pmi_rd_data_width(36), .pmi_regmode("reg"), 
		.pmi_gsr("enable"), .pmi_resetmode("sync"), .pmi_optimization("speed"), .pmi_family("ECP5U")
		)
		Mem1(.Data({Mem1_data_i,{4{Mem1_data_i[31]}}}), .WrAddress(Mem1_addrw_i), .RdAddress(addrr_M1_out), .WrClock(Mem1_clk_w),
		.RdClock(clk_i), .WrClockEn(Mem1_clk_en_w), .RdClockEn(1'b1), .WE(Mem1_we_i), .Reset(1'b0), 
		.Q(Mem1_data_o));
		
	addr_gen_no_series #(.ADDR_START_STATES(0), .ADDR_START_COMMON(M0_START_COMMON), .ADDR_INC_STATES(M0_STATES_OFFSET_NUMBER),
	.ADDR_INC_COMMON(M0_COMMON_OFFSET_NUMBER), .ADDR_WIDTH(M0_ADDR_WIDTH))
	addrr_M0_gen (.clk(clk_i), .addr_sel(addrr_M0_sel),
	.addr_ptr(addrr_M0_ptr), .addr_out(addrr_M0_out));
	
	addr_gen_no_series #(.ADDR_START_STATES(0), .ADDR_START_COMMON(M0_START_COMMON), .ADDR_INC_STATES(M0_STATES_OFFSET_NUMBER),
	.ADDR_INC_COMMON(M0_COMMON_OFFSET_NUMBER), .ADDR_WIDTH(M0_ADDR_WIDTH))
	addrw_M0_gen (.clk(clk_i), .addr_sel(addrw_M0_sel),
	.addr_ptr(addrw_M0_ptr), .addr_out(addrw_M0_out));
	
	addr_gen_no_series #(.ADDR_START_STATES(0), .ADDR_START_COMMON(M1_START_COMMON), .ADDR_INC_STATES(M1_STATES_OFFSET_NUMBER),
	.ADDR_INC_COMMON(M1_COMMON_OFFSET_NUMBER), .ADDR_WIDTH(M1_ADDR_WIDTH))
	addrr_M1_gen (.clk(clk_i), .addr_sel(addrr_M1_sel),
	.addr_ptr(addrr_M1_ptr), .addr_out(addrr_M1_out));

					
	pipeline_delay #(.WIDTH(OPCODE_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	opcode_delay (.clk(clk_i), .in(Opcode), .out(Opcode_pip));
	
	pipeline_delay #(.WIDTH(AMUX_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	amux_delay (.clk(clk_i), .in(AMuxsel), .out(AMuxsel_pip));
	
	pipeline_delay #(.WIDTH(BMUX_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	bmux_delay (.clk(clk_i), .in(BMuxsel), .out(BMuxsel_pip));
	
	pipeline_delay #(.WIDTH(CMUX_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	cmux_delay (.clk(clk_i), .in(CMuxsel), .out(CMuxsel_pip));
	
	pipeline_delay #(.WIDTH(AAMEM_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	aamem_delay (.clk(clk_i), .in(AAMemsel), .out(AAMemsel_pip));
	
	pipeline_delay #(.WIDTH(ABMEM_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	abmem_delay (.clk(clk_i), .in(ABMemsel), .out(ABMemsel_pip));
	
	pipeline_delay #(.WIDTH(BAMEM_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	bamem_delay (.clk(clk_i), .in(BAMemsel), .out(BAMemsel_pip));
	
	pipeline_delay #(.WIDTH(BBMEM_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	bbmem_delay (.clk(clk_i), .in(BBMemsel), .out(BBMemsel_pip));
	
	pipeline_delay #(.WIDTH(CMEM_WIDTH),.CYCLES(READ_DELAY),.SHIFT_MEM(0)) 
	cmem_delay (.clk(clk_i), .in(CMemsel), .out(CMemsel_pip));
		
	pipeline_delay #(.WIDTH(1),.CYCLES(READ_DELAY+1),.SHIFT_MEM(0)) 
	ce_delay (.clk(clk_i), .in(CE1), .out(CE1_pip));
	
	pipeline_delay #(.WIDTH(1),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
	we_delay (.clk(clk_i), .in(Mem0_we), .out(Mem0_we_pip));
	
	
	pipeline_delay #(.WIDTH(9),.CYCLES(5),.SHIFT_MEM(0)) 
	addrw_M0_delay (.clk(clk_i), .in(addrw_M0_out), .out(Mem0_addrw_pip));
	
	wire [CNT_WIDTH-1:0] cnt_pip2;
	wire [HARMONICS_CNT_WIDTH-1:0] harmonics_cnt_pip2;
	
	wire[OPCODE_WIDTH-1:0]Opcode_pip2;
	wire[AMUX_WIDTH-1:0]AMuxsel_pip2;
	wire[BMUX_WIDTH-1:0]BMuxsel_pip2;
	wire[CMUX_WIDTH-1:0]CMuxsel_pip2;
	wire[AAMEM_WIDTH-1:0]AAMemsel_pip2;
	wire[ABMEM_WIDTH-1:0]ABMemsel_pip2;
	wire[BAMEM_WIDTH-1:0]BAMemsel_pip2;
	wire[BBMEM_WIDTH-1:0]BBMemsel_pip2;
	wire[CMEM_WIDTH-1:0]CMemsel_pip2;
		
	wire CE1_pip2;
	
	wire [M0_ADDR_WIDTH-1:0] addrr_M0_out_pip2;
	wire [35:0] Mem0_data_o_pip2;
	wire [M1_ADDR_WIDTH-1:0] addrr_M1_out_pip2;
	wire [35:0] Mem1_data_o_pip2;
		
	wire [M0_ADDR_WIDTH-1:0] Mem0_addrw_pip2;
	wire [35:0] Mem0_data_i_pip2;
	wire Mem0_we_pip2;
	
	assign Mem0_data_i_pip2 = Mem0_data_i;
		
	if(DEBUG) begin
		pipeline_delay #(.WIDTH(CNT_WIDTH),.CYCLES(READ_DELAY+4),.SHIFT_MEM(0)) 
		cnt_delay2 (.clk(clk_i), .in(cnt), .out(cnt_pip2));
			
		pipeline_delay #(.WIDTH(HARMONICS_CNT_WIDTH),.CYCLES(READ_DELAY+4),.SHIFT_MEM(0)) 
		harmonics_cnt_delay2 (.clk(clk_i), .in(harmonics_cnt), .out(harmonics_cnt_pip2));
		
		pipeline_delay #(.WIDTH(OPCODE_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		opcode_delay2 (.clk(clk_i), .in(Opcode), .out(Opcode_pip2));
		
		pipeline_delay #(.WIDTH(AMUX_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		amux_delay2 (.clk(clk_i), .in(AMuxsel), .out(AMuxsel_pip2));
		
		pipeline_delay #(.WIDTH(BMUX_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		bmux_delay2 (.clk(clk_i), .in(BMuxsel), .out(BMuxsel_pip2));
		
		pipeline_delay #(.WIDTH(CMUX_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		cmux_delay2 (.clk(clk_i), .in(CMuxsel), .out(CMuxsel_pip2));
		
		pipeline_delay #(.WIDTH(AAMEM_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		aamem_delay2 (.clk(clk_i), .in(AAMemsel), .out(AAMemsel_pip2));
		
		pipeline_delay #(.WIDTH(ABMEM_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		abmem_delay2 (.clk(clk_i), .in(ABMemsel), .out(ABMemsel_pip2));
		
		pipeline_delay #(.WIDTH(BAMEM_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		bamem_delay2 (.clk(clk_i), .in(BAMemsel), .out(BAMemsel_pip2));
		
		pipeline_delay #(.WIDTH(BBMEM_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		bbmem_delay2 (.clk(clk_i), .in(BBMemsel), .out(BBMemsel_pip2));
		
		pipeline_delay #(.WIDTH(CMEM_WIDTH),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		cmem_delay2 (.clk(clk_i), .in(CMemsel), .out(CMemsel_pip2));
			
		pipeline_delay #(.WIDTH(1),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		ce_delay2 (.clk(clk_i), .in(CE1), .out(CE1_pip2));
					
		pipeline_delay #(.WIDTH(1),.CYCLES(READ_DELAY+3),.SHIFT_MEM(0)) 
		we_delay2 (.clk(clk_i), .in(Mem0_we), .out(Mem0_we_pip2));
		
		
		pipeline_delay #(.WIDTH(9),.CYCLES(5),.SHIFT_MEM(0)) 
		addrw_M0_delay2 (.clk(clk_i), .in(addrw_M0_out), .out(Mem0_addrw_pip2));
		
		pipeline_delay #(.WIDTH(9),.CYCLES(5),.SHIFT_MEM(0)) 
		addrr_M0_delay2 (.clk(clk_i), .in(addrr_M0_out), .out(addrr_M0_out_pip2));
		
		pipeline_delay #(.WIDTH(9),.CYCLES(5),.SHIFT_MEM(0)) 
		addrr_M1_delay2 (.clk(clk_i), .in(addrr_M1_out), .out(addrr_M1_out_pip2));
		
		pipeline_delay #(.WIDTH(36),.CYCLES(3),.SHIFT_MEM(0)) 
		Mem0_data_o_delay2 (.clk(clk_i), .in(Mem0_data_o), .out(Mem0_data_o_pip2));

		pipeline_delay #(.WIDTH(36),.CYCLES(3),.SHIFT_MEM(0)) 
		Mem1_data_o_delay2 (.clk(clk_i), .in(Mem1_data_o), .out(Mem1_data_o_pip2));
	end
endmodule
