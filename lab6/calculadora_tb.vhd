library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculadora_tb is 
end entity;

architecture arch_calculadora_tb of calculadora_tb is   

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal estado : unsigned(1 downto 0);
    signal pc_value : unsigned(6 downto 0);
    signal instrucao : unsigned(15 downto 0);
    signal data_reg_o : unsigned(15 downto 0);
    signal data_acumulador_o : unsigned(15 downto 0);
    signal ula_out : unsigned(15 downto 0);
    signal done : std_logic := '0';

    constant period : time := 10 ns;

    component calculadora is
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
    end component;

begin

    uut: calculadora port map(
        reset => rst,
        clk => clk,
        estado => estado,
        pc_value => pc_value,
        instrucao => instrucao,
        data_reg_o => data_reg_o,
        data_acumulador_o => data_acumulador_o,
        ula_out => ula_out
    );

    duracao: process
    begin
        wait for 50*period;
        done <= '1';
        wait;
    end process;

    begin_rst: process
    begin
        rst <= '1';
        wait for period;
        wait for period/2;
        rst <= '0';
        wait;
    end process;

    clock: process
    begin
        while done = '0' loop
            clk <= not clk;
            wait for period/2;
        end loop;
        wait;
    end process;

end architecture;