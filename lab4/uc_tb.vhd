library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity;

architecture arch_uc_tb of uc_tb is

    signal clk, rst : std_logic := '0';
    signal data_out : std_logic_vector(11 downto 0) := (others => '0');

    signal finished : std_logic := '0';

    constant clk_period : time := 10 ns;

    component uc is
        port(
            clk : in std_logic;
            rst : in std_logic;
            data_out : out std_logic_vector(11 downto 0)
        );
    end component;




begin

    uut : uc
    port map(
        clk => clk,
        rst => rst,
        data_out => data_out
    );

    finish : process
    begin
        wait for 300 ns;
        finished <= '1';
        wait;
    end process;
    

    clock : process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    reset_global : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait;
    end process;

    -- teste: Executar vários clocks até ele pular para o endereço 1 a partir do valor do endereço 6
    
    





end architecture;