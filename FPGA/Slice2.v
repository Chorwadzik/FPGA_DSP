`timescale 1 ns / 1 ps

module Slice2 (CLK0, CE0, CE1, CE2, CE3, RST0, RST1, RST2, RST3,
	AA, AB, BA, BB, C,
	SignAA, SignAB, SignBA, SignBB,
	AMuxsel, BMuxsel, CMuxsel, Opcode, 
	Result, R, SIGNEDR, CIN, SIGNEDCIN,
	EQZ, EQZM, EQOM, EQPAT, EQPATB, OVER, UNDER);
    input wire CLK0;
    input wire CE0;
	input wire CE1;
	input wire CE2;
	input wire CE3;
    input wire RST0;
    input wire RST1;
    input wire RST2;
    input wire RST3;
	input wire [17:0] AA;
	input wire [17:0] AB;
	input wire [17:0] BA;
	input wire [17:0] BB;
	input wire [35:0] C;
	input wire SignAA;
	input wire SignAB;
    input wire SignBA;
	input wire SignBB;
	input wire [1:0] AMuxsel;
    input wire [1:0] BMuxsel;
    input wire [2:0] CMuxsel;
    input wire [3:0] Opcode;
    output wire [35:0] Result;
	output wire [53:0] R;
	output wire SIGNEDR;
	input wire [53:0] CIN;
	input wire SIGNEDCIN;
    output wire EQZ;
    output wire EQZM;
    output wire EQOM;
    output wire EQPAT;
    output wire EQPATB;
    output wire OVER;
    output wire UNDER;

	parameter QMATH_SHIFT = 2;
	
    wire [53:0] ALU_R;
    wire [17:0] ALU_A_H;
    wire [17:0] ALU_A_L;
	wire [17:0] ALU_B_H;
    wire [17:0] ALU_B_L;
    wire [53:0] ALU_C;
	wire [35:0] ALU_MA;
	wire [35:0] ALU_MB;
	wire ALU_MA_SIGN;
	wire ALU_MB_SIGN;
    wire [53:0] ALU_CFB;
	wire [53:0] ALU_CO;
    
	
    wire [17:0] MULTA_A;
    wire [17:0] MULTA_B;
	wire [17:0] MULTA_C;
    wire [17:0] MULTA_SRIA;
    wire [17:0] MULTA_SRIB;
    wire [17:0] MULTA_ROB;
    wire [17:0] MULTA_ROA;
    wire [17:0] MULTA_SROA;
    wire [17:0] MULTA_SROB;
    wire [35:0] MULTA_P;
    wire MULTA_P_SIGN;
	
	wire [17:0] MULTB_A;
    wire [17:0] MULTB_B;
	wire [17:0] MULTB_C;
    wire [17:0] MULTB_SRIA;
    wire [17:0] MULTB_SRIB;
    wire [17:0] MULTB_ROB;
    wire [17:0] MULTB_ROA;
    wire [17:0] MULTB_SROA;
    wire [17:0] MULTB_SROB;
    wire [35:0] MULTB_P;
    wire MULTB_P_SIGN;
	
	wire scuba_vhi;
    wire scuba_vlo;
	
	assign ALU_A_H = MULTA_ROB;
	assign ALU_A_L = MULTA_ROA;
	assign ALU_B_H = MULTB_ROB;
	assign ALU_B_L = MULTB_ROA;
	if(QMATH_SHIFT)
		assign ALU_C[54-QMATH_SHIFT +: QMATH_SHIFT] = {QMATH_SHIFT{C[35]}};
	assign ALU_C[18-QMATH_SHIFT +: 36] = C;
	assign ALU_C[17-QMATH_SHIFT:0] = {18-QMATH_SHIFT{C[35]}};
	assign ALU_MA = MULTA_P;
	assign ALU_MB = MULTB_P;
	assign ALU_MA_SIGN = MULTA_P_SIGN;
	assign ALU_MB_SIGN = MULTB_P_SIGN;
	assign ALU_CFB = {54{scuba_vlo}};
	
	assign MULTA_A = AA;
	assign MULTA_B = AB;
	assign MULTA_C = {18{scuba_vlo}};//ALU_C[17:0];
	assign MULTA_SRIA = {18{scuba_vlo}};
	assign MULTA_SRIB = {18{scuba_vlo}};
	
	assign MULTB_A = BA;
	assign MULTB_B = BB;
	assign MULTB_C = {18{scuba_vlo}};//ALU_C[44:27];
	assign MULTB_SRIA = {18{scuba_vlo}};
	assign MULTB_SRIB = {18{scuba_vlo}};
	
	defparam dsp_alu.CLK3_DIV = "ENABLED" ;
    defparam dsp_alu.CLK2_DIV = "ENABLED" ;
    defparam dsp_alu.CLK1_DIV = "DISABLED" ;
    defparam dsp_alu.CLK0_DIV = "ENABLED" ;
    defparam dsp_alu.REG_INPUTCFB_RST = "RST0" ;
    defparam dsp_alu.REG_INPUTCFB_CE = "CE0" ;
    defparam dsp_alu.REG_INPUTCFB_CLK = "NONE" ;
    defparam dsp_alu.REG_OPCODEIN_1_RST = "RST0" ;
    defparam dsp_alu.REG_OPCODEIN_1_CE = "CE0" ;
    defparam dsp_alu.REG_OPCODEIN_1_CLK = "CLK0" ;
    defparam dsp_alu.REG_OPCODEIN_0_RST = "RST0" ;
    defparam dsp_alu.REG_OPCODEIN_0_CE = "CE0" ;
    defparam dsp_alu.REG_OPCODEIN_0_CLK = "CLK0" ;
    defparam dsp_alu.REG_OPCODEOP1_1_CLK = "CLK0" ;
    defparam dsp_alu.REG_OPCODEOP1_0_CLK = "CLK0" ;
    defparam dsp_alu.REG_OPCODEOP0_1_RST = "RST0" ;
    defparam dsp_alu.REG_OPCODEOP0_1_CE = "CE0" ;
    defparam dsp_alu.REG_OPCODEOP0_1_CLK = "CLK0" ;
    defparam dsp_alu.REG_OPCODEOP0_0_RST = "RST0" ;
    defparam dsp_alu.REG_OPCODEOP0_0_CE = "CE0" ;
    defparam dsp_alu.REG_OPCODEOP0_0_CLK = "CLK0" ;
    defparam dsp_alu.REG_INPUTC1_RST = "RST0" ;
    defparam dsp_alu.REG_INPUTC1_CE = "CE0" ;
    defparam dsp_alu.REG_INPUTC1_CLK = "CLK1" ;
    defparam dsp_alu.REG_INPUTC0_RST = "RST0" ;
    defparam dsp_alu.REG_INPUTC0_CE = "CE0" ;
    defparam dsp_alu.REG_INPUTC0_CLK = "CLK1" ;
    defparam dsp_alu.LEGACY = "DISABLED" ;
    defparam dsp_alu.REG_FLAG_RST = "RST0" ;
    defparam dsp_alu.REG_FLAG_CE = "CE0" ;
    defparam dsp_alu.REG_FLAG_CLK = "CLK0" ;
    defparam dsp_alu.REG_OUTPUT1_RST = "RST0" ;
    defparam dsp_alu.REG_OUTPUT1_CE = "CE0" ;
    defparam dsp_alu.REG_OUTPUT1_CLK = "CLK0" ;
    defparam dsp_alu.REG_OUTPUT0_RST = "RST0" ;
    defparam dsp_alu.REG_OUTPUT0_CE = "CE0" ;
    defparam dsp_alu.REG_OUTPUT0_CLK = "CLK0" ;
    defparam dsp_alu.MULT9_MODE = "DISABLED" ;
    defparam dsp_alu.RNDPAT = "0x00000000000000" ;
    defparam dsp_alu.MASKPAT = "0x00000000000000" ;
    defparam dsp_alu.MCPAT = "0x00000000000000" ;
    defparam dsp_alu.MASK01 = "0x00000000000000" ;
    defparam dsp_alu.MASKPAT_SOURCE = "STATIC" ;
    defparam dsp_alu.MCPAT_SOURCE = "STATIC" ;
    defparam dsp_alu.RESETMODE = "SYNC" ;
    defparam dsp_alu.GSR = "ENABLED" ;
    ALU54B dsp_alu (.A35(ALU_A_H[17]), .A34(ALU_A_H[16]), 
        .A33(ALU_A_H[15]), .A32(ALU_A_H[14]), 
        .A31(ALU_A_H[13]), .A30(ALU_A_H[12]), 
        .A29(ALU_A_H[11]), .A28(ALU_A_H[10]), 
        .A27(ALU_A_H[9]), .A26(ALU_A_H[8]), 
        .A25(ALU_A_H[7]), .A24(ALU_A_H[6]), 
        .A23(ALU_A_H[5]), .A22(ALU_A_H[4]), 
        .A21(ALU_A_H[3]), .A20(ALU_A_H[2]), 
        .A19(ALU_A_H[1]), .A18(ALU_A_H[0]), 
        .A17(ALU_A_L[17]), .A16(ALU_A_L[16]), 
        .A15(ALU_A_L[15]), .A14(ALU_A_L[14]), 
        .A13(ALU_A_L[13]), .A12(ALU_A_L[12]), 
        .A11(ALU_A_L[11]), .A10(ALU_A_L[10]), 
        .A9(ALU_A_L[9]), .A8(ALU_A_L[8]), .A7(ALU_A_L[7]), 
        .A6(ALU_A_L[6]), .A5(ALU_A_L[5]), .A4(ALU_A_L[4]), 
        .A3(ALU_A_L[3]), .A2(ALU_A_L[2]), .A1(ALU_A_L[1]), 
        .A0(ALU_A_L[0]), .B35(ALU_B_H[17]), 
        .B34(ALU_B_H[16]), .B33(ALU_B_H[15]), 
        .B32(ALU_B_H[14]), .B31(ALU_B_H[13]), 
        .B30(ALU_B_H[12]), .B29(ALU_B_H[11]), 
        .B28(ALU_B_H[10]), .B27(ALU_B_H[9]), 
        .B26(ALU_B_H[8]), .B25(ALU_B_H[7]), 
        .B24(ALU_B_H[6]), .B23(ALU_B_H[5]), 
        .B22(ALU_B_H[4]), .B21(ALU_B_H[3]), 
        .B20(ALU_B_H[2]), .B19(ALU_B_H[1]), 
        .B18(ALU_B_H[0]), .B17(ALU_B_L[17]), 
        .B16(ALU_B_L[16]), .B15(ALU_B_L[15]), 
        .B14(ALU_B_L[14]), .B13(ALU_B_L[13]), 
        .B12(ALU_B_L[12]), .B11(ALU_B_L[11]), 
        .B10(ALU_B_L[10]), .B9(ALU_B_L[9]), 
        .B8(ALU_B_L[8]), .B7(ALU_B_L[7]), .B6(ALU_B_L[6]), 
        .B5(ALU_B_L[5]), .B4(ALU_B_L[4]), .B3(ALU_B_L[3]), 
        .B2(ALU_B_L[2]), .B1(ALU_B_L[1]), .B0(ALU_B_L[0]), 
        .CFB53(ALU_CFB[53]), .CFB52(ALU_CFB[52]), .CFB51(ALU_CFB[51]), .CFB50(ALU_CFB[50]), 
        .CFB49(ALU_CFB[49]), .CFB48(ALU_CFB[48]), .CFB47(ALU_CFB[47]), .CFB46(ALU_CFB[46]), 
        .CFB45(ALU_CFB[45]), .CFB44(ALU_CFB[44]), .CFB43(ALU_CFB[43]), .CFB42(ALU_CFB[42]), 
        .CFB41(ALU_CFB[41]), .CFB40(ALU_CFB[40]), .CFB39(ALU_CFB[39]), .CFB38(ALU_CFB[38]), 
        .CFB37(ALU_CFB[37]), .CFB36(ALU_CFB[36]), .CFB35(ALU_CFB[35]), .CFB34(ALU_CFB[34]), 
        .CFB33(ALU_CFB[33]), .CFB32(ALU_CFB[32]), .CFB31(ALU_CFB[31]), .CFB30(ALU_CFB[30]), 
        .CFB29(ALU_CFB[29]), .CFB28(ALU_CFB[28]), .CFB27(ALU_CFB[27]), .CFB26(ALU_CFB[26]), 
        .CFB25(ALU_CFB[25]), .CFB24(ALU_CFB[24]), .CFB23(ALU_CFB[23]), .CFB22(ALU_CFB[22]), 
        .CFB21(ALU_CFB[21]), .CFB20(ALU_CFB[20]), .CFB19(ALU_CFB[19]), .CFB18(ALU_CFB[18]), 
        .CFB17(ALU_CFB[17]), .CFB16(ALU_CFB[16]), .CFB15(ALU_CFB[15]), .CFB14(ALU_CFB[14]), 
        .CFB13(ALU_CFB[13]), .CFB12(ALU_CFB[12]), .CFB11(ALU_CFB[11]), .CFB10(ALU_CFB[10]), 
        .CFB9(ALU_CFB[9]), .CFB8(ALU_CFB[8]), .CFB7(ALU_CFB[7]), .CFB6(ALU_CFB[6]), 
        .CFB5(ALU_CFB[5]), .CFB4(ALU_CFB[4]), .CFB3(ALU_CFB[3]), .CFB2(ALU_CFB[2]), 
        .CFB1(ALU_CFB[1]), .CFB0(ALU_CFB[0]), .C53(ALU_C[53]), .C52(ALU_C[52]), .C51(ALU_C[51]), 
        .C50(ALU_C[50]), .C49(ALU_C[49]), .C48(ALU_C[48]), .C47(ALU_C[47]), .C46(ALU_C[46]), 
        .C45(ALU_C[45]), .C44(ALU_C[44]), .C43(ALU_C[43]), .C42(ALU_C[42]), .C41(ALU_C[41]), 
        .C40(ALU_C[40]), .C39(ALU_C[39]), .C38(ALU_C[38]), .C37(ALU_C[37]), .C36(ALU_C[36]), 
        .C35(ALU_C[35]), .C34(ALU_C[34]), .C33(ALU_C[33]), .C32(ALU_C[32]), .C31(ALU_C[31]), 
        .C30(ALU_C[30]), .C29(ALU_C[29]), .C28(ALU_C[28]), .C27(ALU_C[27]), .C26(ALU_C[26]), 
        .C25(ALU_C[25]), .C24(ALU_C[24]), .C23(ALU_C[23]), .C22(ALU_C[22]), .C21(ALU_C[21]), 
        .C20(ALU_C[20]), .C19(ALU_C[19]), .C18(ALU_C[18]), .C17(ALU_C[17]), .C16(ALU_C[16]), 
        .C15(ALU_C[15]), .C14(ALU_C[14]), .C13(ALU_C[13]), .C12(ALU_C[12]), .C11(ALU_C[11]), 
        .C10(ALU_C[10]), .C9(ALU_C[9]), .C8(ALU_C[8]), .C7(ALU_C[7]), .C6(ALU_C[6]), .C5(ALU_C[5]), 
        .C4(ALU_C[4]), .C3(ALU_C[3]), .C2(ALU_C[2]), .C1(ALU_C[1]), .C0(ALU_C[0]), .CE0(CE0), 
        .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi), .CLK0(CLK0), 
        .CLK1(CLK0), .CLK2(scuba_vlo), .CLK3(scuba_vlo), .RST0(RST0), .RST1(RST1), 
        .RST2(RST2), .RST3(RST3), .SIGNEDIA(ALU_MA_SIGN), 
        .SIGNEDIB(ALU_MB_SIGN), .SIGNEDCIN(SIGNEDCIN), .MA35(ALU_MA[35]), 
        .MA34(ALU_MA[34]), .MA33(ALU_MA[33]), 
        .MA32(ALU_MA[32]), .MA31(ALU_MA[31]), 
        .MA30(ALU_MA[30]), .MA29(ALU_MA[29]), 
        .MA28(ALU_MA[28]), .MA27(ALU_MA[27]), 
        .MA26(ALU_MA[26]), .MA25(ALU_MA[25]), 
        .MA24(ALU_MA[24]), .MA23(ALU_MA[23]), 
        .MA22(ALU_MA[22]), .MA21(ALU_MA[21]), 
        .MA20(ALU_MA[20]), .MA19(ALU_MA[19]), 
        .MA18(ALU_MA[18]), .MA17(ALU_MA[17]), 
        .MA16(ALU_MA[16]), .MA15(ALU_MA[15]), 
        .MA14(ALU_MA[14]), .MA13(ALU_MA[13]), 
        .MA12(ALU_MA[12]), .MA11(ALU_MA[11]), 
        .MA10(ALU_MA[10]), .MA9(ALU_MA[9]), .MA8(ALU_MA[8]), 
        .MA7(ALU_MA[7]), .MA6(ALU_MA[6]), .MA5(ALU_MA[5]), 
        .MA4(ALU_MA[4]), .MA3(ALU_MA[3]), .MA2(ALU_MA[2]), 
        .MA1(ALU_MA[1]), .MA0(ALU_MA[0]), .MB35(ALU_MB[35]), 
        .MB34(ALU_MB[34]), .MB33(ALU_MB[33]), 
        .MB32(ALU_MB[32]), .MB31(ALU_MB[31]), 
        .MB30(ALU_MB[30]), .MB29(ALU_MB[29]), 
        .MB28(ALU_MB[28]), .MB27(ALU_MB[27]), 
        .MB26(ALU_MB[26]), .MB25(ALU_MB[25]), 
        .MB24(ALU_MB[24]), .MB23(ALU_MB[23]), 
        .MB22(ALU_MB[22]), .MB21(ALU_MB[21]), 
        .MB20(ALU_MB[20]), .MB19(ALU_MB[19]), 
        .MB18(ALU_MB[18]), .MB17(ALU_MB[17]), 
        .MB16(ALU_MB[16]), .MB15(ALU_MB[15]), 
        .MB14(ALU_MB[14]), .MB13(ALU_MB[13]), 
        .MB12(ALU_MB[12]), .MB11(ALU_MB[11]), 
        .MB10(ALU_MB[10]), .MB9(ALU_MB[9]), .MB8(ALU_MB[8]), 
        .MB7(ALU_MB[7]), .MB6(ALU_MB[6]), .MB5(ALU_MB[5]), 
        .MB4(ALU_MB[4]), .MB3(ALU_MB[3]), .MB2(ALU_MB[2]), 
        .MB1(ALU_MB[1]), .MB0(ALU_MB[0]), .CIN53(CIN[53]), 
        .CIN52(CIN[52]), .CIN51(CIN[51]), .CIN50(CIN[50]), .CIN49(CIN[49]), 
        .CIN48(CIN[48]), .CIN47(CIN[47]), .CIN46(CIN[46]), .CIN45(CIN[45]), 
        .CIN44(CIN[44]), .CIN43(CIN[43]), .CIN42(CIN[42]), .CIN41(CIN[41]), 
        .CIN40(CIN[40]), .CIN39(CIN[39]), .CIN38(CIN[38]), .CIN37(CIN[37]), 
        .CIN36(CIN[36]), .CIN35(CIN[35]), .CIN34(CIN[34]), .CIN33(CIN[33]), 
        .CIN32(CIN[32]), .CIN31(CIN[31]), .CIN30(CIN[30]), .CIN29(CIN[29]), 
        .CIN28(CIN[28]), .CIN27(CIN[27]), .CIN26(CIN[26]), .CIN25(CIN[25]), 
        .CIN24(CIN[24]), .CIN23(CIN[23]), .CIN22(CIN[22]), .CIN21(CIN[21]), 
        .CIN20(CIN[20]), .CIN19(CIN[19]), .CIN18(CIN[18]), .CIN17(CIN[17]), 
        .CIN16(CIN[16]), .CIN15(CIN[15]), .CIN14(CIN[14]), .CIN13(CIN[13]), 
        .CIN12(CIN[12]), .CIN11(CIN[11]), .CIN10(CIN[10]), .CIN9(CIN[9]), 
        .CIN8(CIN[8]), .CIN7(CIN[7]), .CIN6(CIN[6]), .CIN5(CIN[5]), .CIN4(CIN[4]), 
        .CIN3(CIN[3]), .CIN2(CIN[2]), .CIN1(CIN[1]), .CIN0(CIN[0]), .OP10(Opcode[3]), 
        .OP9(Opcode[2]), .OP8(Opcode[1]), .OP7(Opcode[0]), .OP6(CMuxsel[2]), 
        .OP5(CMuxsel[1]), .OP4(CMuxsel[0]), .OP3(BMuxsel[1]), .OP2(BMuxsel[0]), 
        .OP1(AMuxsel[1]), .OP0(AMuxsel[0]), .R53(ALU_R[53]), 
        .R52(ALU_R[52]), .R51(ALU_R[51]), 
        .R50(ALU_R[50]), .R49(ALU_R[49]), 
        .R48(ALU_R[48]), .R47(ALU_R[47]), 
        .R46(ALU_R[46]), .R45(ALU_R[45]), 
        .R44(ALU_R[44]), .R43(ALU_R[43]), 
        .R42(ALU_R[42]), .R41(ALU_R[41]), 
        .R40(ALU_R[40]), .R39(ALU_R[39]), 
        .R38(ALU_R[38]), .R37(ALU_R[37]), 
        .R36(ALU_R[36]), .R35(ALU_R[35]), 
        .R34(ALU_R[34]), .R33(ALU_R[33]), 
        .R32(ALU_R[32]), .R31(ALU_R[31]), 
        .R30(ALU_R[30]), .R29(ALU_R[29]), 
        .R28(ALU_R[28]), .R27(ALU_R[27]), 
        .R26(ALU_R[26]), .R25(ALU_R[25]), 
        .R24(ALU_R[24]), .R23(ALU_R[23]), 
        .R22(ALU_R[22]), .R21(ALU_R[21]), 
        .R20(ALU_R[20]), .R19(ALU_R[19]), 
        .R18(ALU_R[18]), .R17(ALU_R[17]), 
        .R16(ALU_R[16]), .R15(ALU_R[15]), 
        .R14(ALU_R[14]), .R13(ALU_R[13]), 
        .R12(ALU_R[12]), .R11(ALU_R[11]), 
        .R10(ALU_R[10]), .R9(ALU_R[9]), 
        .R8(ALU_R[8]), .R7(ALU_R[7]), .R6(ALU_R[6]), 
        .R5(ALU_R[5]), .R4(ALU_R[4]), .R3(ALU_R[3]), 
        .R2(ALU_R[2]), .R1(ALU_R[1]), .R0(ALU_R[0]), 
		.CO53(ALU_CO[53]), .CO52(ALU_CO[52]), .CO51(ALU_CO[51]), .CO50(ALU_CO[50]), .CO49(ALU_CO[49]), .CO48(ALU_CO[48]), .CO47(ALU_CO[47]), .CO46(ALU_CO[46]),
		.CO45(ALU_CO[45]), .CO44(ALU_CO[44]), .CO43(ALU_CO[43]), .CO42(ALU_CO[42]), .CO41(ALU_CO[41]), .CO40(ALU_CO[40]), .CO39(ALU_CO[39]), .CO38(ALU_CO[38]),
		.CO37(ALU_CO[37]), .CO36(ALU_CO[36]), .CO35(ALU_CO[35]), .CO34(ALU_CO[34]), .CO33(ALU_CO[33]), .CO32(ALU_CO[32]), .CO31(ALU_CO[31]), .CO30(ALU_CO[30]),
		.CO29(ALU_CO[29]), .CO28(ALU_CO[28]), .CO27(ALU_CO[27]), .CO26(ALU_CO[26]), .CO25(ALU_CO[25]), .CO24(ALU_CO[24]), .CO23(ALU_CO[23]), .CO22(ALU_CO[22]),
		.CO21(ALU_CO[21]), .CO20(ALU_CO[20]), .CO19(ALU_CO[19]), .CO18(ALU_CO[18]), .CO17(ALU_CO[17]), .CO16(ALU_CO[16]), .CO15(ALU_CO[15]), .CO14(ALU_CO[14]),
		.CO13(ALU_CO[13]), .CO12(ALU_CO[12]), .CO11(ALU_CO[11]), .CO10(ALU_CO[10]), .CO9(ALU_CO[9]), .CO8(ALU_CO[8]), .CO7(ALU_CO[7]), .CO6(ALU_CO[6]),
		.CO5(ALU_CO[5]), .CO4(ALU_CO[4]), .CO3(ALU_CO[3]), .CO2(ALU_CO[2]), .CO1(ALU_CO[1]), .CO0(ALU_CO[0]), .EQZ(EQZ), .EQZM(EQZM), 
        .EQOM(EQOM), .EQPAT(EQPAT), .EQPATB(EQPATB), .OVER(OVER), .UNDER(UNDER), 
        .OVERUNDER(), .SIGNEDR(SIGNEDR));

    defparam dsp_mult_A.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_A.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_A.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_A.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_A.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_A.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_A.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_A.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_A.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_A.MULT_BYPASS = "DISABLED" ;
    defparam dsp_mult_A.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_A.RESETMODE = "SYNC" ;
    defparam dsp_mult_A.GSR = "ENABLED" ;
    defparam dsp_mult_A.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_A.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_A.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_A.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_A.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_A.REG_PIPELINE_CLK = "CLK0" ;
    defparam dsp_mult_A.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_A.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_A.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_A.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_A.REG_INPUTA_CE = "CE0" ;
    defparam dsp_mult_A.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_A (.A17(MULTA_A[17]), .A16(MULTA_A[16]), 
		.A15(MULTA_A[15]), .A14(MULTA_A[14]), .A13(MULTA_A[13]),
		.A12(MULTA_A[12]), .A11(MULTA_A[11]), .A10(MULTA_A[10]), 
		.A9(MULTA_A[9]), .A8(MULTA_A[8]), .A7(MULTA_A[7]), 
		.A6(MULTA_A[6]), .A5(MULTA_A[5]), .A4(MULTA_A[4]), 
		.A3(MULTA_A[3]), .A2(MULTA_A[2]), .A1(MULTA_A[1]), 
		.A0(MULTA_A[0]), .B17(MULTA_B[17]), .B16(MULTA_B[16]), 
		.B15(MULTA_B[15]), .B14(MULTA_B[14]), .B13(MULTA_B[13]),
		.B12(MULTA_B[12]), .B11(MULTA_B[11]), .B10(MULTA_B[10]), 
		.B9(MULTA_B[9]), .B8(MULTA_B[8]), .B7(MULTA_B[7]), 
		.B6(MULTA_B[6]), .B5(MULTA_B[5]), .B4(MULTA_B[4]), 
		.B3(MULTA_B[3]), .B2(MULTA_B[2]), .B1(MULTA_B[1]), 
		.B0(MULTA_B[0]), .C17(MULTA_C[17]), 
        .C16(MULTA_C[16]), .C15(MULTA_C[15]), .C14(MULTA_C[14]), .C13(MULTA_C[13]), 
        .C12(MULTA_C[12]), .C11(MULTA_C[11]), .C10(MULTA_C[10]), .C9(MULTA_C[9]), 
        .C8(MULTA_C[8]), .C7(MULTA_C[7]), .C6(MULTA_C[6]), .C5(MULTA_C[5]), 
        .C4(MULTA_C[4]), .C3(MULTA_C[3]), .C2(MULTA_C[2]), .C1(MULTA_C[1]), 
        .C0(MULTA_C[0]), .SIGNEDA(SignAA), .SIGNEDB(SignAB), .SOURCEA(scuba_vlo), 
        .SOURCEB(scuba_vlo), .CE0(CE0), .CE1(CE1), .CE2(scuba_vhi), 
        .CE3(scuba_vhi), .CLK0(CLK0), .CLK1(scuba_vlo), .CLK2(scuba_vlo), 
        .CLK3(scuba_vlo), .RST0(RST0), .RST1(RST1), .RST2(RST2), 
        .RST3(RST3), .SRIA17(MULTA_SRIA[17]), .SRIA16(MULTA_SRIA[16]), .SRIA15(MULTA_SRIA[15]), 
        .SRIA14(MULTA_SRIA[14]), .SRIA13(MULTA_SRIA[13]), .SRIA12(MULTA_SRIA[12]), .SRIA11(MULTA_SRIA[11]), 
        .SRIA10(MULTA_SRIA[10]), .SRIA9(MULTA_SRIA[9]), .SRIA8(MULTA_SRIA[8]), .SRIA7(MULTA_SRIA[7]), 
        .SRIA6(MULTA_SRIA[6]), .SRIA5(MULTA_SRIA[5]), .SRIA4(MULTA_SRIA[4]), .SRIA3(MULTA_SRIA[3]), 
        .SRIA2(MULTA_SRIA[2]), .SRIA1(MULTA_SRIA[1]), .SRIA0(MULTA_SRIA[0]), .SRIB17(MULTA_SRIB[17]), 
        .SRIB16(MULTA_SRIB[16]), .SRIB15(MULTA_SRIB[15]), .SRIB14(MULTA_SRIB[14]), .SRIB13(MULTA_SRIB[13]), 
        .SRIB12(MULTA_SRIB[12]), .SRIB11(MULTA_SRIB[11]), .SRIB10(MULTA_SRIB[10]), .SRIB9(MULTA_SRIB[9]), 
        .SRIB8(MULTA_SRIB[8]), .SRIB7(MULTA_SRIB[7]), .SRIB6(MULTA_SRIB[6]), .SRIB5(MULTA_SRIB[5]), 
        .SRIB4(MULTA_SRIB[4]), .SRIB3(MULTA_SRIB[3]), .SRIB2(MULTA_SRIB[2]), .SRIB1(MULTA_SRIB[1]), 
        .SRIB0(MULTA_SRIB[0]), .SROA17(MULTA_SROA[17]), .SROA16(MULTA_SROA[16]), .SROA15(MULTA_SROA[15]), .SROA14(MULTA_SROA[14]), .SROA13(MULTA_SROA[13]), 
        .SROA12(MULTA_SROA[12]), .SROA11(MULTA_SROA[11]), .SROA10(MULTA_SROA[10]), .SROA9(MULTA_SROA[9]), .SROA8(MULTA_SROA[8]), .SROA7(MULTA_SROA[7]), .SROA6(MULTA_SROA[6]), 
        .SROA5(MULTA_SROA[5]), .SROA4(MULTA_SROA[4]), .SROA3(MULTA_SROA[3]), .SROA2(MULTA_SROA[2]), .SROA1(MULTA_SROA[1]), .SROA0(MULTA_SROA[0]), .SROB17(MULTA_SROB[17]), 
        .SROB16(MULTA_SROB[16]), .SROB15(MULTA_SROB[15]), .SROB14(MULTA_SROB[14]), .SROB13(MULTA_SROB[13]), .SROB12(MULTA_SROB[12]), .SROB11(MULTA_SROB[11]), 
        .SROB10(MULTA_SROB[10]), .SROB9(MULTA_SROB[9]), .SROB8(MULTA_SROB[8]), .SROB7(MULTA_SROB[7]), .SROB6(MULTA_SROB[6]), .SROB5(MULTA_SROB[5]), .SROB4(MULTA_SROB[4]), 
        .SROB3(MULTA_SROB[3]), .SROB2(MULTA_SROB[2]), .SROB1(MULTA_SROB[1]), .SROB0(MULTA_SROB[0]), .ROA17(MULTA_ROA[17]), 
        .ROA16(MULTA_ROA[16]), .ROA15(MULTA_ROA[15]), 
        .ROA14(MULTA_ROA[14]), .ROA13(MULTA_ROA[13]), 
        .ROA12(MULTA_ROA[12]), .ROA11(MULTA_ROA[11]), 
        .ROA10(MULTA_ROA[10]), .ROA9(MULTA_ROA[9]), 
        .ROA8(MULTA_ROA[8]), .ROA7(MULTA_ROA[7]), 
        .ROA6(MULTA_ROA[6]), .ROA5(MULTA_ROA[5]), 
        .ROA4(MULTA_ROA[4]), .ROA3(MULTA_ROA[3]), 
        .ROA2(MULTA_ROA[2]), .ROA1(MULTA_ROA[1]), 
        .ROA0(MULTA_ROA[0]), .ROB17(MULTA_ROB[17]), 
        .ROB16(MULTA_ROB[16]), .ROB15(MULTA_ROB[15]), 
        .ROB14(MULTA_ROB[14]), .ROB13(MULTA_ROB[13]), 
        .ROB12(MULTA_ROB[12]), .ROB11(MULTA_ROB[11]), 
        .ROB10(MULTA_ROB[10]), .ROB9(MULTA_ROB[9]), 
        .ROB8(MULTA_ROB[8]), .ROB7(MULTA_ROB[7]), 
        .ROB6(MULTA_ROB[6]), .ROB5(MULTA_ROB[5]), 
        .ROB4(MULTA_ROB[4]), .ROB3(MULTA_ROB[3]), 
        .ROB2(MULTA_ROB[2]), .ROB1(MULTA_ROB[1]), 
        .ROB0(MULTA_ROB[0]), .ROC17(), .ROC16(), .ROC15(), .ROC14(), 
        .ROC13(), .ROC12(), .ROC11(), .ROC10(), .ROC9(), .ROC8(), .ROC7(), 
        .ROC6(), .ROC5(), .ROC4(), .ROC3(), .ROC2(), .ROC1(), .ROC0(), .P35(MULTA_P[35]), 
        .P34(MULTA_P[34]), .P33(MULTA_P[33]), .P32(MULTA_P[32]), 
        .P31(MULTA_P[31]), .P30(MULTA_P[30]), .P29(MULTA_P[29]), 
        .P28(MULTA_P[28]), .P27(MULTA_P[27]), .P26(MULTA_P[26]), 
        .P25(MULTA_P[25]), .P24(MULTA_P[24]), .P23(MULTA_P[23]), 
        .P22(MULTA_P[22]), .P21(MULTA_P[21]), .P20(MULTA_P[20]), 
        .P19(MULTA_P[19]), .P18(MULTA_P[18]), .P17(MULTA_P[17]), 
        .P16(MULTA_P[16]), .P15(MULTA_P[15]), .P14(MULTA_P[14]), 
        .P13(MULTA_P[13]), .P12(MULTA_P[12]), .P11(MULTA_P[11]), 
        .P10(MULTA_P[10]), .P9(MULTA_P[9]), .P8(MULTA_P[8]), 
        .P7(MULTA_P[7]), .P6(MULTA_P[6]), .P5(MULTA_P[5]), 
        .P4(MULTA_P[4]), .P3(MULTA_P[3]), .P2(MULTA_P[2]), 
        .P1(MULTA_P[1]), .P0(MULTA_P[0]), .SIGNEDP(MULTA_P_SIGN));

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam dsp_mult_B.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_B.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_B.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_B.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_B.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_B.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_B.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_B.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_B.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_B.MULT_BYPASS = "DISABLED" ;
    defparam dsp_mult_B.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_B.RESETMODE = "SYNC" ;
    defparam dsp_mult_B.GSR = "ENABLED" ;
    defparam dsp_mult_B.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_B.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_B.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_B.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_B.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_B.REG_PIPELINE_CLK = "CLK0" ;
    defparam dsp_mult_B.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_B.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_B.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_B.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_B.REG_INPUTA_CE = "CE1" ;
    defparam dsp_mult_B.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_B (.A17(MULTB_A[17]), .A16(MULTB_A[16]), 
		.A15(MULTB_A[15]), .A14(MULTB_A[14]), .A13(MULTB_A[13]),
		.A12(MULTB_A[12]), .A11(MULTB_A[11]), .A10(MULTB_A[10]), 
		.A9(MULTB_A[9]), .A8(MULTB_A[8]), .A7(MULTB_A[7]), 
		.A6(MULTB_A[6]), .A5(MULTB_A[5]), .A4(MULTB_A[4]), 
		.A3(MULTB_A[3]), .A2(MULTB_A[2]), .A1(MULTB_A[1]), 
		.A0(MULTB_A[0]), .B17(MULTB_B[17]), .B16(MULTB_B[16]), 
		.B15(MULTB_B[15]), .B14(MULTB_B[14]), .B13(MULTB_B[13]),
		.B12(MULTB_B[12]), .B11(MULTB_B[11]), .B10(MULTB_B[10]), 
		.B9(MULTB_B[9]), .B8(MULTB_B[8]), .B7(MULTB_B[7]), 
		.B6(MULTB_B[6]), .B5(MULTB_B[5]), .B4(MULTB_B[4]), 
		.B3(MULTB_B[3]), .B2(MULTB_B[2]), .B1(MULTB_B[1]), 
		.B0(MULTB_B[0]), .C17(MULTB_C[17]), 
        .C16(MULTB_C[16]), .C15(MULTB_C[15]), .C14(MULTB_C[14]), .C13(MULTB_C[13]), 
        .C12(MULTB_C[12]), .C11(MULTB_C[11]), .C10(MULTB_C[10]), .C9(MULTB_C[9]), 
        .C8(MULTB_C[8]), .C7(MULTB_C[7]), .C6(MULTB_C[6]), .C5(MULTB_C[5]), 
        .C4(MULTB_C[4]), .C3(MULTB_C[3]), .C2(MULTB_C[2]), .C1(MULTB_C[1]),
        .C0(MULTB_C[0]), .SIGNEDA(SignBA), .SIGNEDB(SignBB), .SOURCEA(scuba_vlo), 
        .SOURCEB(scuba_vlo), .CE0(CE0), .CE1(CE1), .CE2(scuba_vhi), 
        .CE3(scuba_vhi), .CLK0(CLK0), .CLK1(scuba_vlo), .CLK2(scuba_vlo), 
        .CLK3(scuba_vlo), .RST0(RST0), .RST1(RST1), .RST2(RST2), 
        .RST3(RST3), .SRIA17(MULTB_SRIA[17]), .SRIA16(MULTB_SRIA[16]), .SRIA15(MULTB_SRIA[15]), 
        .SRIA14(MULTB_SRIA[14]), .SRIA13(MULTB_SRIA[13]), .SRIA12(MULTB_SRIA[12]), .SRIA11(MULTB_SRIA[11]), 
        .SRIA10(MULTB_SRIA[10]), .SRIA9(MULTB_SRIA[9]), .SRIA8(MULTB_SRIA[8]), .SRIA7(MULTB_SRIA[7]), 
        .SRIA6(MULTB_SRIA[6]), .SRIA5(MULTB_SRIA[5]), .SRIA4(MULTB_SRIA[4]), .SRIA3(MULTB_SRIA[3]), 
        .SRIA2(MULTB_SRIA[2]), .SRIA1(MULTB_SRIA[1]), .SRIA0(MULTB_SRIA[0]), .SRIB17(MULTB_SRIB[17]), 
        .SRIB16(MULTB_SRIB[16]), .SRIB15(MULTB_SRIB[15]), .SRIB14(MULTB_SRIB[14]), .SRIB13(MULTB_SRIB[13]), 
        .SRIB12(MULTB_SRIB[12]), .SRIB11(MULTB_SRIB[11]), .SRIB10(MULTB_SRIB[10]), .SRIB9(MULTB_SRIB[9]), 
        .SRIB8(MULTB_SRIB[8]), .SRIB7(MULTB_SRIB[7]), .SRIB6(MULTB_SRIB[6]), .SRIB5(MULTB_SRIB[5]), 
        .SRIB4(MULTB_SRIB[4]), .SRIB3(MULTB_SRIB[3]), .SRIB2(MULTB_SRIB[2]), .SRIB1(MULTB_SRIB[1]), 
        .SRIB0(MULTB_SRIB[0]), .SROA17(MULTB_SROA[17]), .SROA16(MULTB_SROA[16]), .SROA15(MULTB_SROA[15]), .SROA14(MULTB_SROA[14]), .SROA13(MULTB_SROA[13]), 
        .SROA12(MULTB_SROA[12]), .SROA11(MULTB_SROA[11]), .SROA10(MULTB_SROA[10]), .SROA9(MULTB_SROA[9]), .SROA8(MULTB_SROA[8]), .SROA7(MULTB_SROA[7]), .SROA6(MULTB_SROA[6]), 
        .SROA5(MULTB_SROA[5]), .SROA4(MULTB_SROA[4]), .SROA3(MULTB_SROA[3]), .SROA2(MULTB_SROA[2]), .SROA1(MULTB_SROA[1]), .SROA0(MULTB_SROA[0]), .SROB17(MULTB_SROB[17]), 
        .SROB16(MULTB_SROB[16]), .SROB15(MULTB_SROB[15]), .SROB14(MULTB_SROB[14]), .SROB13(MULTB_SROB[13]), .SROB12(MULTB_SROB[12]), .SROB11(MULTB_SROB[11]), 
        .SROB10(MULTB_SROB[10]), .SROB9(MULTB_SROB[9]), .SROB8(MULTB_SROB[8]), .SROB7(MULTB_SROB[7]), .SROB6(MULTB_SROB[6]), .SROB5(MULTB_SROB[5]), .SROB4(MULTB_SROB[4]), 
        .SROB3(MULTB_SROB[3]), .SROB2(MULTB_SROB[2]), .SROB1(MULTB_SROB[1]), .SROB0(MULTB_SROB[0]), .ROA17(MULTB_ROA[17]), 
        .ROA16(MULTB_ROA[16]), .ROA15(MULTB_ROA[15]), 
        .ROA14(MULTB_ROA[14]), .ROA13(MULTB_ROA[13]), 
        .ROA12(MULTB_ROA[12]), .ROA11(MULTB_ROA[11]), 
        .ROA10(MULTB_ROA[10]), .ROA9(MULTB_ROA[9]), 
        .ROA8(MULTB_ROA[8]), .ROA7(MULTB_ROA[7]), 
        .ROA6(MULTB_ROA[6]), .ROA5(MULTB_ROA[5]), 
        .ROA4(MULTB_ROA[4]), .ROA3(MULTB_ROA[3]), 
        .ROA2(MULTB_ROA[2]), .ROA1(MULTB_ROA[1]), 
        .ROA0(MULTB_ROA[0]), .ROB17(MULTB_ROB[17]), 
        .ROB16(MULTB_ROB[16]), .ROB15(MULTB_ROB[15]), 
        .ROB14(MULTB_ROB[14]), .ROB13(MULTB_ROB[13]), 
        .ROB12(MULTB_ROB[12]), .ROB11(MULTB_ROB[11]), 
        .ROB10(MULTB_ROB[10]), .ROB9(MULTB_ROB[9]), 
        .ROB8(MULTB_ROB[8]), .ROB7(MULTB_ROB[7]), 
        .ROB6(MULTB_ROB[6]), .ROB5(MULTB_ROB[5]), 
        .ROB4(MULTB_ROB[4]), .ROB3(MULTB_ROB[3]), 
        .ROB2(MULTB_ROB[2]), .ROB1(MULTB_ROB[1]), 
        .ROB0(MULTB_ROB[0]), .ROC17(), .ROC16(), .ROC15(), .ROC14(), 
        .ROC13(), .ROC12(), .ROC11(), .ROC10(), .ROC9(), .ROC8(), .ROC7(), 
        .ROC6(), .ROC5(), .ROC4(), .ROC3(), .ROC2(), .ROC1(), .ROC0(), .P35(MULTB_P[35]), 
        .P34(MULTB_P[34]), .P33(MULTB_P[33]), .P32(MULTB_P[32]), 
        .P31(MULTB_P[31]), .P30(MULTB_P[30]), .P29(MULTB_P[29]), 
        .P28(MULTB_P[28]), .P27(MULTB_P[27]), .P26(MULTB_P[26]), 
        .P25(MULTB_P[25]), .P24(MULTB_P[24]), .P23(MULTB_P[23]), 
        .P22(MULTB_P[22]), .P21(MULTB_P[21]), .P20(MULTB_P[20]), 
        .P19(MULTB_P[19]), .P18(MULTB_P[18]), .P17(MULTB_P[17]), 
        .P16(MULTB_P[16]), .P15(MULTB_P[15]), .P14(MULTB_P[14]), 
        .P13(MULTB_P[13]), .P12(MULTB_P[12]), .P11(MULTB_P[11]), 
        .P10(MULTB_P[10]), .P9(MULTB_P[9]), .P8(MULTB_P[8]), 
        .P7(MULTB_P[7]), .P6(MULTB_P[6]), .P5(MULTB_P[5]), 
        .P4(MULTB_P[4]), .P3(MULTB_P[3]), .P2(MULTB_P[2]), 
        .P1(MULTB_P[1]), .P0(MULTB_P[0]), .SIGNEDP(MULTB_P_SIGN));

    assign Result = ALU_R[18-QMATH_SHIFT +: 36];	
	assign R = ALU_R;
endmodule
