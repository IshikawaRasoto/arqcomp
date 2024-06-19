library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro is
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

architecture arch_micro of micro is

    component uc is
        port(
            clk : in std_logic;
            rst : in std_logic;
            flag_zero : in std_logic;
            flag_bigger : in std_logic;
            flag_carry_out : in std_logic;
            registered_carry_out : out std_logic;
            subb_flag : out std_logic;
            codigo_operacao : out unsigned(15 downto 0);
            maquina_estados_out : out unsigned(1 downto 0);
            pc_value_o : out unsigned(6 downto 0);
            const_to_regs : out unsigned(15 downto 0);
            read_add_reg : out unsigned(2 downto 0);
            read_add_2_reg : out unsigned(2 downto 0);
            write_add_reg : out unsigned(2 downto 0);
            op_ula : out unsigned(1 downto 0);
            en_reg : out std_logic;
            en_acumulador : out std_logic;
            en_ram : out std_logic;
            mux_s_acumulador_o : out std_logic;
            mux_s_regs_o : out std_logic_vector(1 downto 0)
        );
    end component;

    component bancoRegistradores is
        port(
            clk: in std_logic;
            write_en: in std_logic;
            rst: in std_logic;
            write_data: in std_logic_vector(15 downto 0);
            read_data_1: out std_logic_vector(15 downto 0);
            read_data_2: out std_logic_vector(15 downto 0);
            write_register: in std_logic_vector(2 downto 0);
            read_register_1: in std_logic_vector(2 downto 0);
            read_register_2: in std_logic_vector(2 downto 0)
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
            carry_out: out std_logic;
            flag_carry_in: in std_logic;
            flag_subb: in std_logic;
            op: in std_logic_vector(1 downto 0);
            acumulador_value: out std_logic_vector(15 downto 0);
            data_i: in std_logic_vector(15 downto 0);
            data_o: out std_logic_vector(15 downto 0)
        );
    end component;

    component ram is
        port (
            clk : in std_logic;
            we : in std_logic;
            rst : in std_logic;
            addr : in unsigned(7 downto 0);
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Flags
    signal s_flag_zero: std_logic;
    signal s_flag_bigger: std_logic;
    signal s_flag_carry_out: std_logic;


    -- Sinais
    signal maquina_estados_s: unsigned(1 downto 0);
    signal pc_value_s: unsigned(6 downto 0);
    signal const_to_regs_s: unsigned(15 downto 0);
    signal read_add_reg_s: unsigned(2 downto 0);
    signal read_add_reg_2_s: unsigned(2 downto 0);
    signal write_add_reg_s: unsigned(2 downto 0);
    signal op_ula_s: unsigned(1 downto 0);
    signal en_reg_s: std_logic;
    signal en_acumulador_s: std_logic;
    signal instrucao_s: unsigned(15 downto 0);
    signal data_reg_s: std_logic_vector(15 downto 0);
    signal data_reg_2_s: std_logic_vector(15 downto 0);
    signal data_acumulador_s: std_logic_vector(15 downto 0);
    signal ula_out_s: std_logic_vector(15 downto 0);

    signal s_flag_carry_in: std_logic;
    signal s_flag_subb: std_logic;


    -- MUXes
    signal write_data_mux_s: std_logic_vector(1 downto 0);
    signal write_data_mux: std_logic_vector(15 downto 0);

    signal control_mux_pre_acumulador : std_logic;
    signal mux_pre_acumulador : std_logic_vector(15 downto 0);

    signal ram_in_mux : std_logic_vector(15 downto 0);


    -- RAM
    signal en_ram : std_logic;
    signal data_o_ram : unsigned(15 downto 0);
    signal data_i_ram : unsigned(15 downto 0);
    signal ram_addr : unsigned(7 downto 0);

begin

    write_data_mux <= std_logic_vector(ula_out_s) when write_data_mux_s = "01" else 
                      std_logic_vector(const_to_regs_s) when write_data_mux_s = "00" else
                      std_logic_vector(data_o_ram);

    mux_pre_acumulador <= data_reg_s when control_mux_pre_acumulador = '1' else std_logic_vector(ula_out_s);

    data_i_ram <= unsigned(data_reg_s);

    ram_addr <= unsigned(data_reg_2_s(7 downto 0));

    uc_inst: uc port map(
        clk => clk,
        rst => reset,
        flag_zero => s_flag_zero,
        flag_bigger => s_flag_bigger,
        flag_carry_out => s_flag_carry_out,
        registered_carry_out => s_flag_carry_in,
        subb_flag => s_flag_subb,
        codigo_operacao => instrucao_s,
        maquina_estados_out => maquina_estados_s,
        pc_value_o => pc_value_s,
        const_to_regs => const_to_regs_s,
        read_add_reg => read_add_reg_s,
        read_add_2_reg => read_add_reg_2_s,
        write_add_reg => write_add_reg_s,
        op_ula => op_ula_s,
        en_reg => en_reg_s,
        en_acumulador => en_acumulador_s,
        en_ram => en_ram,
        mux_s_acumulador_o => control_mux_pre_acumulador,
        mux_s_regs_o => write_data_mux_s
    );

    bancoReg_inst: bancoRegistradores port map(
        clk => clk,
        write_en => en_reg_s,
        rst => reset,
        write_data => write_data_mux,
        read_data_1 => data_reg_s,
        read_data_2 => data_reg_2_s,
        write_register => std_logic_vector(write_add_reg_s),
        read_register_1 => std_logic_vector(read_add_reg_s),
        read_register_2 => std_logic_vector(read_add_reg_2_s)
    );

    ula_inst: ulaacumuladora port map(
        clk => clk,
        rst => reset,
        acumulador_source => control_mux_pre_acumulador,
        wr_enable => en_acumulador_s,
        flag_zero => s_flag_zero,
        flag_bigger => s_flag_bigger,
        carry_out => s_flag_carry_out,
        flag_carry_in => s_flag_carry_in,
        flag_subb => s_flag_subb,
        op => std_logic_vector(op_ula_s),
        acumulador_value => data_acumulador_s,
        data_i => data_reg_s,
        data_o => ula_out_s
    );

    mem_inst: ram port map(
        clk => clk,
        we => en_ram,
        rst => reset,
        addr => ram_addr,
        data_in => data_i_ram,
        data_out => data_o_ram
    );

    estado <= maquina_estados_s;
    pc_value <= pc_value_s;
    instrucao <= instrucao_s;
    data_reg_o <= unsigned(data_reg_s);
    data_acumulador_o <= unsigned(data_acumulador_s);
    ula_out <= unsigned(ula_out_s);

end architecture;
