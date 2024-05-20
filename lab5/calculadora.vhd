library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculadora is
    port(
        reset : in std_logic;
        clk : in std_logic;
        estado: out unsigned(1 downto 0);
        pc_value : out unsigned(6 downto 0);
        instrucao: out unsigned(15 downto 0);
        data_reg_o: out unsigned(15 downto 0);
        data_acumulador_o: out unsigned(15 downto 0);
        ula_out: out unsigned(15 downto 0)
    );
end entity;

architecture arch_calculadora of calculadora is

    component uc is
        port(
            clk : in std_logic;
            rst : in std_logic;
            codigo_operacao : out unsigned(15 downto 0);
            maquina_estados_out : out unsigned(1 downto 0);
            pc_value_o : out unsigned(6 downto 0);
            const_to_regs : out unsigned(15 downto 0);
            read_add_reg : out unsigned(2 downto 0);
            write_add_reg : out unsigned(2 downto 0);
            op_ula : out unsigned(1 downto 0);
            en_reg : out std_logic;
            en_acumulador : out std_logic;
            mux_s_acumulador_o : out std_logic;
            mux_s_regs_o : out std_logic
        );
    end component;

    component bancoRegistradores is
        port(
            clk: in std_logic;
            write_en: in std_logic;
            rst: in std_logic;
            write_data: in std_logic_vector(15 downto 0);
            read_data_1: out std_logic_vector(15 downto 0);
            write_register: in std_logic_vector(2 downto 0);
            read_register_1: in std_logic_vector(2 downto 0)
        );
    end component;

    component ulaacumuladora is
        port(
            clk: in std_logic;
            rst: in std_logic;
            acumulador_source: in std_logic;
            wr_enable: in std_logic;
            flag_zero: out std_logic;
            flag_bigger: out std_logic;
            flag_equals: out std_logic;
            op: in std_logic_vector(1 downto 0);
            acumulador_value: out std_logic_vector(15 downto 0);
            data_i: in std_logic_vector(15 downto 0);
            data_o: out std_logic_vector(15 downto 0)
        );
    end component;

    
    signal maquina_estados_s: unsigned(1 downto 0);
    signal pc_value_s: unsigned(6 downto 0);
    signal const_to_regs_s: unsigned(15 downto 0);
    signal read_add_reg_s: unsigned(2 downto 0);
    signal write_add_reg_s: unsigned(2 downto 0);
    signal op_ula_s: unsigned(1 downto 0);
    signal en_reg_s: std_logic;
    signal en_acumulador_s: std_logic;
    signal instrucao_s: unsigned(15 downto 0);
    signal data_reg_s: std_logic_vector(15 downto 0);
    signal data_acumulador_s: std_logic_vector(15 downto 0);
    signal ula_out_s: std_logic_vector(15 downto 0);


    -- MUXes
    signal write_data_mux_s: std_logic;
    signal write_data_mux: std_logic_vector(15 downto 0);

    signal control_mux_pre_acumulador : std_logic;
    signal mux_pre_acumulador : std_logic_vector(15 downto 0);




begin

    write_data_mux <= std_logic_vector(ula_out_s) when write_data_mux_s = '1' else std_logic_vector(const_to_regs_s);
    mux_pre_acumulador <= data_reg_s when control_mux_pre_acumulador = '1' else std_logic_vector(ula_out_s);

    uc_inst: uc port map(
        clk => clk,
        rst => reset,
        codigo_operacao => instrucao_s,
        maquina_estados_out => maquina_estados_s,
        pc_value_o => pc_value_s,
        const_to_regs => const_to_regs_s,
        read_add_reg => read_add_reg_s,
        write_add_reg => write_add_reg_s,
        op_ula => op_ula_s,
        en_reg => en_reg_s,
        en_acumulador => en_acumulador_s,
        mux_s_acumulador_o => control_mux_pre_acumulador,
        mux_s_regs_o => write_data_mux_s
    );

    bancoReg_inst: bancoRegistradores port map(
        clk => clk,
        write_en => en_reg_s,
        rst => reset,
        write_data => write_data_mux,
        read_data_1 => data_reg_s,
        write_register => std_logic_vector(write_add_reg_s),
        read_register_1 => std_logic_vector(read_add_reg_s)
    );

    ula_inst: ulaacumuladora port map(
        clk => clk,
        rst => reset,
        acumulador_source => control_mux_pre_acumulador,
        wr_enable => en_acumulador_s,
        flag_zero => open,
        flag_bigger => open,
        flag_equals => open,
        op => std_logic_vector(op_ula_s),
        acumulador_value => data_acumulador_s,
        data_i => data_reg_s,
        data_o => ula_out_s
    );

    estado <= maquina_estados_s;
    pc_value <= pc_value_s;
    instrucao <= instrucao_s;
    data_reg_o <= unsigned(data_reg_s);
    data_acumulador_o <= unsigned(data_acumulador_s);
    ula_out <= unsigned(ula_out_s);

end architecture;
