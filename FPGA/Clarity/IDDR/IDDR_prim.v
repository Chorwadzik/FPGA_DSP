// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.11.3.469
// Netlist written on Thu Sep 23 01:29:26 2021
//
// Verilog Description of module IDDR
//

module IDDR (alignwd, clkin, ready, sclk, start, sync_clk, sync_reset, 
            datain, q) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(215[8:12])
    input alignwd;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(217[16:23])
    input clkin /* synthesis black_box_pad_pin=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(218[16:21])
    output ready;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(223[17:22])
    output sclk;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(224[17:21])
    input start;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(219[16:21])
    input sync_clk;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(220[16:24])
    input sync_reset;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(221[16:26])
    input [0:0]datain;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(222[22:28])
    output [3:0]q;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(225[23:24])
    
    wire sync_clk /* synthesis SET_AS_NETWORK=sync_clk, is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(220[16:24])
    wire sclk /* synthesis is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(224[17:21])
    wire eclki /* synthesis is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(228[10:15])
    wire eclko /* synthesis is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(235[10:15])
    
    wire stop, reset, dataini_t0, buf_dataini0, VCC_net, GND_net, 
        n425;
    
    CLKDIVF Inst4_CLKDIVF (.CLKI(eclko), .RST(reset), .ALIGNWD(alignwd), 
            .CDIVX(sclk)) /* synthesis syn_instantiated=1 */ ;
    defparam Inst4_CLKDIVF.GSR = "DISABLED";
    defparam Inst4_CLKDIVF.DIV = "2.0";
    ECLKSYNCB Inst3_ECLKSYNCB (.ECLKI(eclki), .STOP(stop), .ECLKO(eclko)) /* synthesis syn_instantiated=1 */ ;
    IDDRX2F Inst2_IDDRX2F0 (.D(dataini_t0), .SCLK(sclk), .RST(reset), 
            .ECLK(eclko), .ALIGNWD(alignwd), .Q0(q[0]), .Q1(q[1]), .Q2(q[2]), 
            .Q3(q[3])) /* synthesis syn_instantiated=1 */ ;
    defparam Inst2_IDDRX2F0.GSR = "ENABLED";
    DELAYG udel_dataini0 (.A(buf_dataini0), .Z(dataini_t0)) /* synthesis syn_instantiated=1 */ ;
    defparam udel_dataini0.DEL_MODE = "ECLK_CENTERED";
    defparam udel_dataini0.DEL_VALUE = 0;
    IB Inst1_IB0 (.I(datain[0]), .O(buf_dataini0)) /* synthesis IO_TYPE="LVCMOS33", syn_instantiated=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(258[8:51])
    VHI i5 (.Z(VCC_net));
    IDDRgddr_sync Inst_gddr_sync (.ready(ready), .stop(stop), .sync_clk(sync_clk), 
            .sync_reset(sync_reset), .n425(n425), .\ns_gddr_sync_2__N_22[2] (start), 
            .reset(reset)) /* synthesis syn_module_defined=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(249[19] 250[70])
    IB Inst5_IB (.I(clkin), .O(eclki)) /* synthesis IO_TYPE="LVCMOS33", syn_instantiated=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(240[8:43])
    GSR GSR_INST (.GSR(VCC_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i363 (.Z(GND_net));
    LUT4 m0_lut (.Z(n425)) /* synthesis lut_function=0, syn_instantiated=1 */ ;
    defparam m0_lut.init = 16'h0000;
    
endmodule
//
// Verilog Description of module IDDRgddr_sync
//

module IDDRgddr_sync (ready, stop, sync_clk, sync_reset, n425, \ns_gddr_sync_2__N_22[2] , 
            reset) /* synthesis syn_module_defined=1 */ ;
    output ready;
    output stop;
    input sync_clk;
    input sync_reset;
    input n425;
    input \ns_gddr_sync_2__N_22[2] ;
    output reset;
    
    wire sync_clk /* synthesis SET_AS_NETWORK=sync_clk, is_clock=1 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(220[16:24])
    
    wire n408;
    wire [2:0]cs_gddr_sync;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(79[13:25])
    
    wire n396;
    wire [2:0]stop_assert;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(78[13:24])
    wire [2:0]n17;
    wire [3:0]ctrl_cnt;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(77[13:21])
    
    wire sync_clk_enable_4, n224, n395, reset_flag, n397;
    wire [3:0]n2;
    
    wire n229, ddr_reset_d, n147, n411, sync_clk_enable_3;
    wire [2:0]n49;
    
    wire n410;
    wire [2:0]ns_gddr_sync_2__N_13;
    
    wire n209, sync_clk_enable_6, n227, n362, stop_assert_2__N_48, 
        n360, n10, n409, n14;
    wire [2:0]ns_gddr_sync_2__N_16;
    
    wire n361, n1;
    
    LUT4 reset_flag_bdd_4_lut (.A(n408), .B(cs_gddr_sync[1]), .C(ready), 
         .D(stop), .Z(n396)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam reset_flag_bdd_4_lut.init = 16'h0400;
    LUT4 i251_2_lut (.A(stop_assert[1]), .B(stop_assert[0]), .Z(n17[1])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam i251_2_lut.init = 16'h6666;
    FD1P3DX ctrl_cnt__i3 (.D(n224), .SP(sync_clk_enable_4), .CK(sync_clk), 
            .CD(sync_reset), .Q(ctrl_cnt[3])) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam ctrl_cnt__i3.GSR = "ENABLED";
    LUT4 i2_3_lut_rep_6_4_lut (.A(ctrl_cnt[1]), .B(ctrl_cnt[0]), .C(ctrl_cnt[3]), 
         .D(ctrl_cnt[2]), .Z(n408)) /* synthesis lut_function=(((C+(D))+!B)+!A) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(117[19:31])
    defparam i2_3_lut_rep_6_4_lut.init = 16'hfff7;
    PFUMX i355 (.BLUT(n396), .ALUT(n395), .C0(reset_flag), .Z(n397));
    FD1S3DX reset_flag_65 (.D(n397), .CK(sync_clk), .CD(sync_reset), .Q(reset_flag)) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam reset_flag_65.GSR = "ENABLED";
    FD1S3DX ctrl_cnt__i0 (.D(n2[0]), .CK(sync_clk), .CD(sync_reset), .Q(ctrl_cnt[0])) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam ctrl_cnt__i0.GSR = "ENABLED";
    FD1P3DX ctrl_cnt__i1 (.D(n229), .SP(sync_clk_enable_4), .CK(sync_clk), 
            .CD(sync_reset), .Q(ctrl_cnt[1])) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam ctrl_cnt__i1.GSR = "ENABLED";
    FD1S3BX ddr_reset_d_67 (.D(n425), .CK(sync_clk), .PD(sync_reset), 
            .Q(ddr_reset_d)) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam ddr_reset_d_67.GSR = "ENABLED";
    LUT4 i218_4_lut (.A(ctrl_cnt[3]), .B(n147), .C(ctrl_cnt[2]), .D(n411), 
         .Z(n224)) /* synthesis lut_function=(!(A ((C (D))+!B)+!A !(B (C (D))))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam i218_4_lut.init = 16'h4888;
    FD1P3DX cs_gddr_sync_i0 (.D(n49[0]), .SP(sync_clk_enable_3), .CK(sync_clk), 
            .CD(sync_reset), .Q(stop)) /* synthesis syn_preserve=1, LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam cs_gddr_sync_i0.GSR = "ENABLED";
    LUT4 i3_3_lut_4_lut (.A(stop_assert[1]), .B(n410), .C(stop_assert[0]), 
         .D(\ns_gddr_sync_2__N_22[2] ), .Z(ns_gddr_sync_2__N_13[0])) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;
    defparam i3_3_lut_4_lut.init = 16'h2000;
    LUT4 i108_4_lut (.A(reset_flag), .B(n408), .C(ready), .D(n209), 
         .Z(n147)) /* synthesis lut_function=(A (B+!(C+(D)))+!A (B (C+(D)))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(110[9] 111[33])
    defparam i108_4_lut.init = 16'hccca;
    LUT4 i11_3_lut (.A(cs_gddr_sync[1]), .B(ready), .C(stop), .Z(sync_clk_enable_6)) /* synthesis lut_function=(!(A (B+!(C))+!A (B (C)))) */ ;
    defparam i11_3_lut.init = 16'h3535;
    LUT4 i258_3_lut (.A(stop_assert[2]), .B(stop_assert[1]), .C(stop_assert[0]), 
         .Z(n17[2])) /* synthesis lut_function=(!(A (B (C))+!A !(B (C)))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam i258_3_lut.init = 16'h6a6a;
    FD1P3DX ctrl_cnt__i2 (.D(n227), .SP(sync_clk_enable_4), .CK(sync_clk), 
            .CD(sync_reset), .Q(ctrl_cnt[2])) /* synthesis LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam ctrl_cnt__i2.GSR = "ENABLED";
    FD1P3DX cs_gddr_sync_i1 (.D(n362), .SP(sync_clk_enable_6), .CK(sync_clk), 
            .CD(sync_reset), .Q(cs_gddr_sync[1])) /* synthesis syn_preserve=1, LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam cs_gddr_sync_i1.GSR = "ENABLED";
    FD1P3DX stop_assert_56__i2 (.D(n17[2]), .SP(stop_assert_2__N_48), .CK(sync_clk), 
            .CD(sync_reset), .Q(stop_assert[2]));   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam stop_assert_56__i2.GSR = "ENABLED";
    FD1P3DX cs_gddr_sync_i2 (.D(n360), .SP(sync_clk_enable_6), .CK(sync_clk), 
            .CD(sync_reset), .Q(ready)) /* synthesis syn_preserve=1, LSE_LINE_FILE_ID=5, LSE_LCOL=19, LSE_RCOL=70, LSE_LLINE=249, LSE_RLINE=250 */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam cs_gddr_sync_i2.GSR = "ENABLED";
    LUT4 i219_3_lut_4_lut (.A(ctrl_cnt[1]), .B(ctrl_cnt[0]), .C(n147), 
         .D(ctrl_cnt[2]), .Z(n227)) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(117[19:31])
    defparam i219_3_lut_4_lut.init = 16'h7080;
    FD1P3DX stop_assert_56__i1 (.D(n17[1]), .SP(stop_assert_2__N_48), .CK(sync_clk), 
            .CD(sync_reset), .Q(stop_assert[1]));   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam stop_assert_56__i1.GSR = "ENABLED";
    LUT4 i4_3_lut_4_lut (.A(ctrl_cnt[1]), .B(ctrl_cnt[0]), .C(reset_flag), 
         .D(ctrl_cnt[3]), .Z(n10)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(117[19:31])
    defparam i4_3_lut_4_lut.init = 16'h0080;
    FD1P3DX stop_assert_56__i0 (.D(n17[0]), .SP(stop_assert_2__N_48), .CK(sync_clk), 
            .CD(sync_reset), .Q(stop_assert[0]));   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam stop_assert_56__i0.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(stop), .B(cs_gddr_sync[1]), .Z(n209)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut.init = 16'heeee;
    LUT4 i5_4_lut (.A(ctrl_cnt[2]), .B(n10), .C(stop_assert[0]), .D(n409), 
         .Z(n14)) /* synthesis lut_function=(!(((C (D))+!B)+!A)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(143[3] 208[10])
    defparam i5_4_lut.init = 16'h0888;
    LUT4 i217_3_lut_3_lut (.A(ctrl_cnt[3]), .B(n147), .C(ctrl_cnt[0]), 
         .Z(n2[0])) /* synthesis lut_function=(A (B (C))+!A !((C)+!B)) */ ;
    defparam i217_3_lut_3_lut.init = 16'h8484;
    LUT4 i1_4_lut (.A(\ns_gddr_sync_2__N_22[2] ), .B(n209), .C(ready), 
         .D(n14), .Z(n360)) /* synthesis lut_function=(!((B+!(C+(D)))+!A)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(143[3] 208[10])
    defparam i1_4_lut.init = 16'h2220;
    LUT4 i336_2_lut_rep_5 (.A(ctrl_cnt[3]), .B(n147), .Z(sync_clk_enable_4)) /* synthesis lut_function=(!(A (B))) */ ;
    defparam i336_2_lut_rep_5.init = 16'h7777;
    LUT4 i326_2_lut_rep_7_3_lut (.A(reset_flag), .B(stop_assert[2]), .C(stop_assert[1]), 
         .Z(n409)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i326_2_lut_rep_7_3_lut.init = 16'h1010;
    LUT4 i214_2_lut_4_lut (.A(n411), .B(ctrl_cnt[2]), .C(ctrl_cnt[3]), 
         .D(reset_flag), .Z(ns_gddr_sync_2__N_16[0])) /* synthesis lut_function=((B+(C+!(D)))+!A) */ ;
    defparam i214_2_lut_4_lut.init = 16'hfdff;
    LUT4 reset_flag_bdd_4_lut_354 (.A(cs_gddr_sync[1]), .B(\ns_gddr_sync_2__N_22[2] ), 
         .C(ready), .D(stop), .Z(n395)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;
    defparam reset_flag_bdd_4_lut_354.init = 16'hffef;
    LUT4 i2_2_lut_3_lut (.A(reset_flag), .B(stop_assert[2]), .C(\ns_gddr_sync_2__N_22[2] ), 
         .Z(stop_assert_2__N_48)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i2_2_lut_3_lut.init = 16'h1010;
    LUT4 i1_2_lut_adj_14 (.A(stop), .B(ready), .Z(n361)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(143[3] 208[10])
    defparam i1_2_lut_adj_14.init = 16'h2222;
    LUT4 cs_gddr_sync_1__I_0_2_lut (.A(cs_gddr_sync[1]), .B(ddr_reset_d), 
         .Z(reset)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(89[20:49])
    defparam cs_gddr_sync_1__I_0_2_lut.init = 16'heeee;
    LUT4 i339_3_lut (.A(cs_gddr_sync[1]), .B(stop), .C(ready), .Z(sync_clk_enable_3)) /* synthesis lut_function=(!(A+(B (C)))) */ ;
    defparam i339_3_lut.init = 16'h1515;
    LUT4 i249_1_lut (.A(stop_assert[0]), .Z(n17[0])) /* synthesis lut_function=(!(A)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(123[22:37])
    defparam i249_1_lut.init = 16'h5555;
    LUT4 i231_3_lut (.A(ctrl_cnt[1]), .B(n147), .C(ctrl_cnt[0]), .Z(n229)) /* synthesis lut_function=(!(A ((C)+!B)+!A !(B (C)))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(105[3] 137[6])
    defparam i231_3_lut.init = 16'h4848;
    LUT4 i77_2_lut_rep_9 (.A(ctrl_cnt[1]), .B(ctrl_cnt[0]), .Z(n411)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(117[19:31])
    defparam i77_2_lut_rep_9.init = 16'h8888;
    PFUMX mux_34_Mux_0_i1 (.BLUT(ns_gddr_sync_2__N_13[0]), .ALUT(ns_gddr_sync_2__N_16[0]), 
          .C0(stop), .Z(n1));
    LUT4 i2_3_lut (.A(ready), .B(n1), .C(cs_gddr_sync[1]), .Z(n49[0])) /* synthesis lut_function=(!(A+((C)+!B))) */ ;
    defparam i2_3_lut.init = 16'h0404;
    LUT4 i207_2_lut_rep_8 (.A(reset_flag), .B(stop_assert[2]), .Z(n410)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i207_2_lut_rep_8.init = 16'heeee;
    LUT4 i1_4_lut_adj_15 (.A(reset_flag), .B(n361), .C(n408), .D(cs_gddr_sync[1]), 
         .Z(n362)) /* synthesis lut_function=(A (B (C (D)))+!A (B (C (D)+!C !(D)))) */ ;   // c:/users/mrtea/workspace_lattice/serdes/clarity/iddr/iddr.v(143[3] 208[10])
    defparam i1_4_lut_adj_15.init = 16'hc004;
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

