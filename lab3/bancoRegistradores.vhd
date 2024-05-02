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

    signal S_00, S_01, S_02, S_03, S_04, S_05, S_06, S_07: std_logic_vector(15 downto 0);
    signal we_00, we_01, we_02, we_03, we_04, we_05, we_06, we_07: std_logic;

    begin
        
        -- Lista dos Registradores
        reg0 : registrador16bits port map(clk, rst, we_00, write_data, S_00);
        reg1 : registrador16bits port map(clk, rst, we_01, write_data, S_01);
        reg2 : registrador16bits port map(clk, rst, we_02, write_data, S_02);
        reg3 : registrador16bits port map(clk, rst, we_03, write_data, S_03);
        reg4 : registrador16bits port map(clk, rst, we_04, write_data, S_04);
        reg5 : registrador16bits port map(clk, rst, we_05, write_data, S_05);
        reg6 : registrador16bits port map(clk, rst, we_06, write_data, S_06);
        reg7 : registrador16bits port map(clk, rst, we_07, write_data, S_07);

        -- Selector do Registrador de Escrita
        we_00 <= '0';
        we_01 <= write_en when write_register = "001" else '0';
        we_02 <= write_en when write_register = "010" else '0';
        we_03 <= write_en when write_register = "011" else '0';
        we_04 <= write_en when write_register = "100" else '0';
        we_05 <= write_en when write_register = "101" else '0';
        we_06 <= write_en when write_register = "110" else '0';
        we_07 <= write_en when write_register = "111" else '0';

        -- Mux para a Saida 1
        read_data_1 <= S_00 when read_register_1 = "000" else
                       S_01 when read_register_1 = "001" else
                       S_02 when read_register_1 = "010" else
                       S_03 when read_register_1 = "011" else
                       S_04 when read_register_1 = "100" else
                       S_05 when read_register_1 = "101" else
                       S_06 when read_register_1 = "110" else
                       S_07;

        -- Mux para a Saida 2
        read_data_2 <= S_00 when read_register_2 = "000" else
                          S_01 when read_register_2 = "001" else
                          S_02 when read_register_2 = "010" else
                          S_03 when read_register_2 = "011" else
                          S_04 when read_register_2 = "100" else
                          S_05 when read_register_2 = "101" else
                          S_06 when read_register_2 = "110" else
                          S_07;

end architecture;