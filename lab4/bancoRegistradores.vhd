library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoRegistradores is
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
end entity;

architecture arq_bancoRegistradores of bancoRegistradores is
    
    component registrador16bits is
        port(
            clk: in std_logic;
            reset: in std_logic;
            wr_enable: in std_logic;
            A: in std_logic_vector(15 downto 0);
            S: out std_logic_vector(15 downto 0)
        );

    end component;

    signal 

