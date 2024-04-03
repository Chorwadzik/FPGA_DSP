/* synthesis translate_off*/
`define SBP_SIMULATION
/* synthesis translate_on*/
`ifndef SBP_SIMULATION
`define SBP_SYNTHESIS
`endif

//
// Verific Verilog Description of module Clarity
//
module Clarity (Dummy_slice_AA, Dummy_slice_AB, Dummy_slice_AMuxsel, Dummy_slice_BA, 
            Dummy_slice_BB, Dummy_slice_BMuxsel, Dummy_slice_C, Dummy_slice_CMuxsel, 
            Dummy_slice_Cin, Dummy_slice_Opcode, Dummy_slice_Result, Dummy_slice_SROA, 
            Dummy_slice_SROB, IDDR_datain, IDDR_q, PLL_SerDes_PHASESEL, 
            Dummy_slice_CE0, Dummy_slice_CLK0, Dummy_slice_EQOM, Dummy_slice_EQPAT, 
            Dummy_slice_EQPATB, Dummy_slice_EQZ, Dummy_slice_EQZM, Dummy_slice_OVER, 
            Dummy_slice_RST0, Dummy_slice_SignCin, Dummy_slice_SignR, 
            Dummy_slice_UNDER, IDDR_alignwd, IDDR_clkin, IDDR_ready, 
            IDDR_sclk, IDDR_start, IDDR_sync_clk, IDDR_sync_reset, PLL_DSP_CLKI, 
            PLL_DSP_CLKOP, PLL_DSP_CLKOS, PLL_SerDes_CLKI, PLL_SerDes_CLKOP, 
            PLL_SerDes_CLKOS, PLL_SerDes_CLKOS2, PLL_SerDes_CLKOS3, PLL_SerDes_LOCK, 
            PLL_SerDes_PHASEDIR, PLL_SerDes_PHASELOADREG, PLL_SerDes_PHASESTEP) /* synthesis sbp_module=true */ ;
    input [17:0]Dummy_slice_AA;
    input [17:0]Dummy_slice_AB;
    input [1:0]Dummy_slice_AMuxsel;
    input [17:0]Dummy_slice_BA;
    input [17:0]Dummy_slice_BB;
    input [1:0]Dummy_slice_BMuxsel;
    input [53:0]Dummy_slice_C;
    input [2:0]Dummy_slice_CMuxsel;
    input [53:0]Dummy_slice_Cin;
    input [3:0]Dummy_slice_Opcode;
    output [53:0]Dummy_slice_Result;
    output [17:0]Dummy_slice_SROA;
    output [17:0]Dummy_slice_SROB;
    input [0:0]IDDR_datain;
    output [3:0]IDDR_q;
    input [1:0]PLL_SerDes_PHASESEL;
    input Dummy_slice_CE0;
    input Dummy_slice_CLK0;
    output Dummy_slice_EQOM;
    output Dummy_slice_EQPAT;
    output Dummy_slice_EQPATB;
    output Dummy_slice_EQZ;
    output Dummy_slice_EQZM;
    output Dummy_slice_OVER;
    input Dummy_slice_RST0;
    input Dummy_slice_SignCin;
    output Dummy_slice_SignR;
    output Dummy_slice_UNDER;
    input IDDR_alignwd;
    input IDDR_clkin;
    output IDDR_ready;
    output IDDR_sclk;
    input IDDR_start;
    input IDDR_sync_clk;
    input IDDR_sync_reset;
    input PLL_DSP_CLKI;
    output PLL_DSP_CLKOP;
    output PLL_DSP_CLKOS;
    input PLL_SerDes_CLKI;
    output PLL_SerDes_CLKOP;
    output PLL_SerDes_CLKOS;
    output PLL_SerDes_CLKOS2;
    output PLL_SerDes_CLKOS3;
    output PLL_SerDes_LOCK;
    input PLL_SerDes_PHASEDIR;
    input PLL_SerDes_PHASELOADREG;
    input PLL_SerDes_PHASESTEP;
    
    
    Dummy_slice Dummy_slice_inst (.AA({Dummy_slice_AA}), .AB({Dummy_slice_AB}), 
            .AMuxsel({Dummy_slice_AMuxsel}), .BA({Dummy_slice_BA}), .BB({Dummy_slice_BB}), 
            .BMuxsel({Dummy_slice_BMuxsel}), .C({Dummy_slice_C}), .CMuxsel({Dummy_slice_CMuxsel}), 
            .Cin({Dummy_slice_Cin}), .Opcode({Dummy_slice_Opcode}), .Result({Dummy_slice_Result}), 
            .SROA({Dummy_slice_SROA}), .SROB({Dummy_slice_SROB}), .CE0(Dummy_slice_CE0), 
            .CLK0(Dummy_slice_CLK0), .EQOM(Dummy_slice_EQOM), .EQPAT(Dummy_slice_EQPAT), 
            .EQPATB(Dummy_slice_EQPATB), .EQZ(Dummy_slice_EQZ), .EQZM(Dummy_slice_EQZM), 
            .OVER(Dummy_slice_OVER), .RST0(Dummy_slice_RST0), .SignCin(Dummy_slice_SignCin), 
            .SignR(Dummy_slice_SignR), .UNDER(Dummy_slice_UNDER));
    IDDR IDDR_inst (.datain({IDDR_datain}), .q({IDDR_q}), .alignwd(IDDR_alignwd), 
         .clkin(IDDR_clkin), .ready(IDDR_ready), .sclk(IDDR_sclk), .start(IDDR_start), 
         .sync_clk(IDDR_sync_clk), .sync_reset(IDDR_sync_reset));
    PLL_DSP PLL_DSP_inst (.CLKI(PLL_DSP_CLKI), .CLKOP(PLL_DSP_CLKOP), .CLKOS(PLL_DSP_CLKOS));
    PLL_SerDes PLL_SerDes_inst (.PHASESEL({PLL_SerDes_PHASESEL}), .CLKI(PLL_SerDes_CLKI), 
            .CLKOP(PLL_SerDes_CLKOP), .CLKOS(PLL_SerDes_CLKOS), .CLKOS2(PLL_SerDes_CLKOS2), 
            .CLKOS3(PLL_SerDes_CLKOS3), .LOCK(PLL_SerDes_LOCK), .PHASEDIR(PLL_SerDes_PHASEDIR), 
            .PHASELOADREG(PLL_SerDes_PHASELOADREG), .PHASESTEP(PLL_SerDes_PHASESTEP));
    
endmodule

