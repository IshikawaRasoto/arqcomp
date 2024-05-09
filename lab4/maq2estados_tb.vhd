library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq2estados_tb is
end entity;

architecture arch_maq2estados_tb of maq2estados_tb is

    signal clk_s, rst_s : std_logic := '0';
    signal data_s : std_logic;

    component maq2estados is
        port(
            clk_i : in std_logic;
		    data_o : out std_logic;
		    rst_i : in std_logic
        );
    end component; 

begin

    uut : maq2estados port map(
        clk_i => clk_s,
        data_o => data_s,
        rst_i => rst_s
    );

    process
    begin

        rst_s <= '1';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
        clk_s <= '0';
        rst_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
        clk_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
        clk_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 2 ns;
        rst_s <= '1';
        wait for 1 ns;
        rst_s <= '0';
        wait for 2 ns;
        clk_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
        clk_s <= '0';
        wait for 5 ns;
        wait;
    end process;
end architecture;