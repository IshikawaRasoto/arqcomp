library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_regs_tb is

end entity ula_regs_tb;

architecture arch_ula_regs_tb of ula_regs_tb is

    component ula_regs is
        port (
            clk : in std_logic;
            reset : in std_logic;
            write_enable : in std_logic;
            write_address : in std_logic_vector(2 downto 0);
            read_address_1 : in std_logic_vector(2 downto 0);
            read_address_2 : in std_logic_vector(2 downto 0);
            op : in std_logic_vector(1 downto 0);
            result_out : out std_logic_vector(15 downto 0);
            control_B : in std_logic;
            ext_const : in std_logic_vector(15 downto 0);
            flag_zero : out std_logic;
            flag_bigger : out std_logic;
            flag_equals : out std_logic
        );
    end component ula_regs;

    -- Controle da Simulação
    constant PERIOD : time := 100 ns;
    signal finished : std_logic := '0';

    -- Sinais de Entrada e Saída
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal write_enable : std_logic := '0';
    signal write_address : std_logic_vector(2 downto 0) := "000";
    signal read_address_1 : std_logic_vector(2 downto 0) := "000";
    signal read_address_2 : std_logic_vector(2 downto 0) := "000";
    signal ula_op : std_logic_vector(1 downto 0) := "00";
    signal result_out : std_logic_vector(15 downto 0);
    signal control_B : std_logic := '0';
    signal ext_const : std_logic_vector(15 downto 0) := "0000000000000000";
    signal flag_zero : std_logic;
    signal flag_bigger : std_logic;
    signal flag_equals : std_logic;


begin

    -- Instância do ULA_REGS
    ula_regs_inst : ula_regs
        port map (
            clk => clk,
            reset => rst,
            write_enable => write_enable,
            write_address => write_address,
            read_address_1 => read_address_1,
            read_address_2 => read_address_2,
            op => ula_op,
            result_out => result_out,
            control_B => control_B,
            ext_const => ext_const,
            flag_zero => flag_zero,
            flag_bigger => flag_bigger,
            flag_equals => flag_equals
        );

    -- Geração de Clock
    clk_gen : process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for PERIOD / 2;
            clk <= '1';
            wait for PERIOD / 2;
        end loop;
        wait;
    end process clk_gen;

    -- Reset Global
    rst_gen : process
    begin
        rst <= '1';
        wait for PERIOD*2;
        rst <= '0';
        wait;
    end process rst_gen;

    simulation_finished : process
    begin
        wait for PERIOD*8;
        finished <= '1';
        wait;
    end process simulation_finished;

    -- Teste 1
    -- Inserir o valor 5 no registrador 3 e em seguida mostrar o valor do registrador 3
    
    -- Teste 2
    -- Inserir o valor 7 no registrador 4 e em seguida mostrar o valor do registrador 4 

    -- Teste 3
    -- Somar o valor do registrador 3 e do registrador 4 e salva no resgistrador 5, e em seguida mostra o resultado
    
    test : process
    begin
        
        wait for PERIOD*2;

        -- Teste 1
        read_address_1 <= "000";
        read_address_2 <= "000";
        write_enable <= '1';
        write_address <= "011";
        control_B <= '1';
        ext_const <= "0000000000000101";
        ula_op <= "00";
        wait for PERIOD;
        read_address_1 <= "000";
        read_address_2 <= "011";
        write_enable <= '0';
        write_address <= "000";
        control_B <= '0';
        ext_const <= "0000000000000000";
        ula_op <= "00";
        wait for PERIOD;

        -- Teste 2
        read_address_1 <= "000";
        read_address_2 <= "000";
        write_enable <= '1';
        write_address <= "100";
        control_B <= '1';
        ext_const <= "0000000000000111";
        ula_op <= "11";
        wait for PERIOD;
        read_address_1 <= "000";
        read_address_2 <= "100";
        write_enable <= '0';
        write_address <= "000";
        control_B <= '0';
        ext_const <= "0000000000000000";
        ula_op <= "11";
        wait for PERIOD;

        -- Teste 3
        read_address_1 <= "011";
        read_address_2 <= "100";
        write_enable <= '1';
        write_address <= "101";
        control_B <= '0';
        ext_const <= "0000000000000000";
        ula_op <= "00";
        wait for PERIOD;
        read_address_1 <= "000";
        read_address_2 <= "101";
        write_enable <= '0';
        write_address <= "000";
        control_B <= '0';
        ext_const <= "0000000000000000";
        ula_op <= "00";
        wait;


    end process test;

end architecture arch_ula_regs_tb;