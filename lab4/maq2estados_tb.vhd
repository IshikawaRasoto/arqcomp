library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq2estados_tb is
end entity;

architecture arch_maq2estados_tb of maq2estados_tb is

    signal clk_s, rst_s : std_logic := '0';
    signal data_s;

    component maquina 

    process()
    begin

        rst_s = '1';
        wait for 5 ns;
        clk_s = '1';
        wait for 5 ns;
        clk_s = '0';

