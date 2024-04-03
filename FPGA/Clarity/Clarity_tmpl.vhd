--VHDL instantiation template

component Clarity is
    port (Dummy_slice_AA: in std_logic_vector(17 downto 0);
        Dummy_slice_AB: in std_logic_vector(17 downto 0);
        Dummy_slice_AMuxsel: in std_logic_vector(1 downto 0);
        Dummy_slice_BA: in std_logic_vector(17 downto 0);
        Dummy_slice_BB: in std_logic_vector(17 downto 0);
        Dummy_slice_BMuxsel: in std_logic_vector(1 downto 0);
        Dummy_slice_C: in std_logic_vector(53 downto 0);
        Dummy_slice_CMuxsel: in std_logic_vector(2 downto 0);
        Dummy_slice_Cin: in std_logic_vector(53 downto 0);
        Dummy_slice_Opcode: in std_logic_vector(3 downto 0);
        Dummy_slice_Result: out std_logic_vector(53 downto 0);
        Dummy_slice_SROA: out std_logic_vector(17 downto 0);
        Dummy_slice_SROB: out std_logic_vector(17 downto 0);
        IDDR_datain: in std_logic_vector(0 downto 0);
        IDDR_q: out std_logic_vector(3 downto 0);
        PLL_SerDes_PHASESEL: in std_logic_vector(1 downto 0);
        Dummy_slice_CE0: in std_logic;
        Dummy_slice_CLK0: in std_logic;
        Dummy_slice_EQOM: out std_logic;
        Dummy_slice_EQPAT: out std_logic;
        Dummy_slice_EQPATB: out std_logic;
        Dummy_slice_EQZ: out std_logic;
        Dummy_slice_EQZM: out std_logic;
        Dummy_slice_OVER: out std_logic;
        Dummy_slice_RST0: in std_logic;
        Dummy_slice_SignCin: in std_logic;
        Dummy_slice_SignR: out std_logic;
        Dummy_slice_UNDER: out std_logic;
        IDDR_alignwd: in std_logic;
        IDDR_clkin: in std_logic;
        IDDR_ready: out std_logic;
        IDDR_sclk: out std_logic;
        IDDR_start: in std_logic;
        IDDR_sync_clk: in std_logic;
        IDDR_sync_reset: in std_logic;
        PLL_DSP_CLKI: in std_logic;
        PLL_DSP_CLKOP: out std_logic;
        PLL_DSP_CLKOS: out std_logic;
        PLL_SerDes_CLKI: in std_logic;
        PLL_SerDes_CLKOP: out std_logic;
        PLL_SerDes_CLKOS: out std_logic;
        PLL_SerDes_CLKOS2: out std_logic;
        PLL_SerDes_CLKOS3: out std_logic;
        PLL_SerDes_LOCK: out std_logic;
        PLL_SerDes_PHASEDIR: in std_logic;
        PLL_SerDes_PHASELOADREG: in std_logic;
        PLL_SerDes_PHASESTEP: in std_logic
    );
    
end component Clarity; -- sbp_module=true 
_inst: Clarity port map (IDDR_datain => __,IDDR_q => __,IDDR_alignwd => __,
            IDDR_clkin => __,IDDR_ready => __,IDDR_sclk => __,IDDR_start => __,
            IDDR_sync_clk => __,IDDR_sync_reset => __,PLL_SerDes_PHASESEL => __,
            PLL_SerDes_CLKI => __,PLL_SerDes_CLKOP => __,PLL_SerDes_CLKOS => __,
            PLL_SerDes_CLKOS2 => __,PLL_SerDes_CLKOS3 => __,PLL_SerDes_LOCK => __,
            PLL_SerDes_PHASEDIR => __,PLL_SerDes_PHASELOADREG => __,PLL_SerDes_PHASESTEP => __,
            PLL_DSP_CLKI => __,PLL_DSP_CLKOP => __,PLL_DSP_CLKOS => __,Dummy_slice_AA => __,
            Dummy_slice_AB => __,Dummy_slice_AMuxsel => __,Dummy_slice_BA => __,
            Dummy_slice_BB => __,Dummy_slice_BMuxsel => __,Dummy_slice_C => __,
            Dummy_slice_CMuxsel => __,Dummy_slice_Cin => __,Dummy_slice_Opcode => __,
            Dummy_slice_Result => __,Dummy_slice_SROA => __,Dummy_slice_SROB => __,
            Dummy_slice_CE0 => __,Dummy_slice_CLK0 => __,Dummy_slice_EQOM => __,
            Dummy_slice_EQPAT => __,Dummy_slice_EQPATB => __,Dummy_slice_EQZ => __,
            Dummy_slice_EQZM => __,Dummy_slice_OVER => __,Dummy_slice_RST0 => __,
            Dummy_slice_SignCin => __,Dummy_slice_SignR => __,Dummy_slice_UNDER => __);
