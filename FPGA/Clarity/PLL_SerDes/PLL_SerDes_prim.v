// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.11.3.469
// Netlist written on Mon Jan 03 15:01:29 2022
//
// Verilog Description of module PLL_SerDes
//

module PLL_SerDes (CLKI, PHASESEL, PHASEDIR, PHASESTEP, PHASELOADREG, 
            CLKOP, CLKOS, CLKOS2, CLKOS3, LOCK) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(8[8:18])
    input CLKI;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(10[16:20])
    input [1:0]PHASESEL;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(11[22:30])
    input PHASEDIR;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(12[16:24])
    input PHASESTEP;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(13[16:25])
    input PHASELOADREG;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(14[16:28])
    output CLKOP;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(15[17:22])
    output CLKOS;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(16[17:22])
    output CLKOS2;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(17[17:23])
    output CLKOS3;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(18[17:23])
    output LOCK;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(19[17:21])
    
    wire CLKI /* synthesis is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(10[16:20])
    wire CLKOS3 /* synthesis is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/pll_serdes/pll_serdes.v(18[17:23])
    
    wire scuba_vlo, VCC_net;
    
    VLO scuba_vlo_inst (.Z(scuba_vlo));
    EHXPLLL PLLInst_0 (.CLKI(CLKI), .CLKFB(CLKOS3), .PHASESEL0(PHASESEL[0]), 
            .PHASESEL1(PHASESEL[1]), .PHASEDIR(PHASEDIR), .PHASESTEP(PHASESTEP), 
            .PHASELOADREG(PHASELOADREG), .STDBY(scuba_vlo), .PLLWAKESYNC(scuba_vlo), 
            .RST(scuba_vlo), .ENCLKOP(scuba_vlo), .ENCLKOS(scuba_vlo), 
            .ENCLKOS2(scuba_vlo), .ENCLKOS3(scuba_vlo), .CLKOP(CLKOP), 
            .CLKOS(CLKOS), .CLKOS2(CLKOS2), .CLKOS3(CLKOS3), .LOCK(LOCK)) /* synthesis FREQUENCY_PIN_CLKOS3="125.000000", FREQUENCY_PIN_CLKOS2="125.000000", FREQUENCY_PIN_CLKOS="250.000000", FREQUENCY_PIN_CLKOP="250.000000", FREQUENCY_PIN_CLKI="25.000000", ICP_CURRENT="9", LPF_RESISTOR="8", syn_instantiated=1 */ ;
    defparam PLLInst_0.CLKI_DIV = 1;
    defparam PLLInst_0.CLKFB_DIV = 5;
    defparam PLLInst_0.CLKOP_DIV = 2;
    defparam PLLInst_0.CLKOS_DIV = 2;
    defparam PLLInst_0.CLKOS2_DIV = 4;
    defparam PLLInst_0.CLKOS3_DIV = 4;
    defparam PLLInst_0.CLKOP_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS2_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS3_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOP_CPHASE = 1;
    defparam PLLInst_0.CLKOS_CPHASE = 1;
    defparam PLLInst_0.CLKOS2_CPHASE = 3;
    defparam PLLInst_0.CLKOS3_CPHASE = 3;
    defparam PLLInst_0.CLKOP_FPHASE = 0;
    defparam PLLInst_0.CLKOS_FPHASE = 0;
    defparam PLLInst_0.CLKOS2_FPHASE = 0;
    defparam PLLInst_0.CLKOS3_FPHASE = 0;
    defparam PLLInst_0.FEEDBK_PATH = "CLKOS3";
    defparam PLLInst_0.CLKOP_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOP_TRIM_DELAY = 0;
    defparam PLLInst_0.CLKOS_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOS_TRIM_DELAY = 0;
    defparam PLLInst_0.OUTDIVIDER_MUXA = "DIVA";
    defparam PLLInst_0.OUTDIVIDER_MUXB = "DIVB";
    defparam PLLInst_0.OUTDIVIDER_MUXC = "DIVC";
    defparam PLLInst_0.OUTDIVIDER_MUXD = "DIVD";
    defparam PLLInst_0.PLL_LOCK_MODE = 0;
    defparam PLLInst_0.PLL_LOCK_DELAY = 200;
    defparam PLLInst_0.STDBY_ENABLE = "DISABLED";
    defparam PLLInst_0.REFIN_RESET = "DISABLED";
    defparam PLLInst_0.SYNC_ENABLE = "DISABLED";
    defparam PLLInst_0.INT_LOCK_STICKY = "ENABLED";
    defparam PLLInst_0.DPHASE_SOURCE = "ENABLED";
    defparam PLLInst_0.PLLRST_ENA = "DISABLED";
    defparam PLLInst_0.INTFB_WAKE = "DISABLED";
    GSR GSR_INST (.GSR(VCC_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VHI i92 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

