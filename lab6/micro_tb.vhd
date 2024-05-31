library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro_tb is
end entity micro_tb;

architecture sim of micro_tb is
    
    component micro
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
    end component micro;

    
    -- Sinais básicos
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';


    -- Sinais de Interesse

    signal estado : unsigned(1 downto 0);
    signal pc_value : unsigned(6 downto 0);
    signal instrucao : unsigned(15 downto 0);
    signal data_reg_o : unsigned(15 downto 0);
    signal data_acumulador_o : unsigned(15 downto 0);
    signal ula_out : unsigned(15 downto 0);


    -- Sinais de simulação
    signal finish : boolean := false;
    
    constant clk_period : time := 10 ns;

begin

    micro_inst : micro
    port map(
        reset => rst,
        clk => clk,
        estado => estado,
        pc_value => pc_value,
        instrucao => instrucao,
        data_reg_o => data_reg_o,
        data_acumulador_o => data_acumulador_o,
        ula_out => ula_out
    );

    -- Processo Duração da Simulação
    sim_duration: process
    begin
        wait for clk_period*2000;
        finish <= true;
        wait;
    end process;

    -- Processo de reset
    reset: process
    begin
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        wait;
    end process;

    clock: process
    begin
        while not finish loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

end architecture;