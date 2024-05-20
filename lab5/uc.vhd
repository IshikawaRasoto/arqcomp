library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
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
end entity uc;

architecture arch_uc of uc is 

    component pc is 
        port(
            clk_i : in std_logic;
            write_en_i : in std_logic;
            data_i : in unsigned (6 downto 0);
            data_o : out unsigned (6 downto 0);
            rst_i : in std_logic
        );
    end component;

    component rom is
        port(	
            clk : in std_logic;
            en : in std_logic;
            rst: in std_logic;
			endereco : in unsigned (6 downto 0);
			dado : out unsigned (15 downto 0)
		);
    end component;

    component maqestados is
        port(
            clk_i : in std_logic;
            data_o : out unsigned(1 downto 0);
            rst_i : in std_logic
        );
    end component;


    -- Sinal UC
    signal const_s : unsigned (7 downto 0);
    signal operation : unsigned(3 downto 0);


    -- ROM Signals
    signal en_rom : std_logic := '1';
    signal data_out_rom : unsigned(15 downto 0);

    -- Maquina de Estados
    signal maqestados_s : unsigned (1 downto 0);

    -- PC Signals
    signal data_out_pc : unsigned(6 downto 0);
    signal increment : unsigned(6 downto 0);
    signal jmp_address : unsigned(6 downto 0);
    signal mux_pc : unsigned(6 downto 0);
    signal en_pc : std_logic;
    

    -- Sinais Externos
    signal op_code : unsigned(3 downto 0);
    signal jump_enable : std_logic;
    signal read_add : unsigned(3 downto 0);
    signal write_add : unsigned (3 downto 0);


    

begin

    -- PC
    increment <= data_out_pc + 1;

    -- Unidade de Controle

    const_s <= data_out_rom(7 downto 0);
    read_add <= data_out_rom(7 downto 4); -- Dá um "conflito" com o const_to_regs, pode mudar a saída da ULA assincronamente, mas através das FLAGs isso não interfere na prática atual
    write_add <= data_out_rom(11 downto 8);
    operation <= data_out_rom(15 downto 12);
    
    
    -- Pinos de Saida

    codigo_operacao <= data_out_rom;
    maquina_estados_out <= maqestados_s;
    pc_value_o <= data_out_pc;
    const_to_regs <= "00000000" & const_s;

    read_add_reg <= "000" when read_add (3 downto 0) = "1010" else read_add (2 downto 0);
    write_add_reg <= "000" when write_add (3 downto 0) = "1010" else write_add (2 downto 0);
    
    -- ULA
    op_ula <=   "11" when operation = "0110" else -- or
                "10" when operation = "0101" else -- and
                "01" when operation = "0100" else -- sub
                "00";                             -- add

    -- Enables
    en_rom <= '1' when (maqestados_s = "00") else '0';
    en_reg <= '1' when (maqestados_s = "01")  and (operation = "0001" or operation = "0010") else '0';
    en_acumulador <= '1' when maqestados_s = "01" and ((write_add = "1010")
                    or (operation = "0011" or operation = "0100" or operation = "0101" or operation = "0110"))
                    else '0';
    en_pc <= '1' when maqestados_s = "10" else '0';

    -- PC MUX
    jmp_address <= const_s(6 downto 0);
    mux_pc <= jmp_address when operation = "1000" else increment;

    --MUXs
    mux_s_acumulador_o <= '1' when operation = "0001" else '0';
    mux_s_regs_o <= '1' when operation = "0001" else '0';
    
    

    pc_inst : pc
        port map(
            clk_i => clk,
            write_en_i => en_pc,
            data_i => mux_pc,
            data_o => data_out_pc,
            rst_i => rst
        );

    rom_inst : rom
        port map(
            clk => clk,
            en => en_rom,
            rst => rst,
            endereco => data_out_pc,
            dado => data_out_rom
        );

    maqestados_inst : maqestados
        port map(
            clk_i => clk,
            data_o => maqestados_s,
            rst_i => rst
        );

end architecture arch_uc;
    