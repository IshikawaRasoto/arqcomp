library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaacumuladora is
    port(
        clk: in std_logic;
        rst: in std_logic;
        acumulador_source: in std_logic;
        wr_enable: in std_logic;
        flag_zero: out std_logic;
        flag_bigger: out std_logic;
        flag_equals: out std_logic;
        op: in std_logic_vector(1 downto 0);
        data_i: in std_logic_vector(15 downto 0);
        data_o: out std_logic_vector(15 downto 0)
    );
end entity ulaacumuladora;

architecture arch_ulaacumuladora of ulaacumuladora is
    
    component ula16bits is 
    port(	
        in_A : in unsigned (15 downto 0);
        in_B : in unsigned (15 downto 0);
        in_op_sel : in unsigned (1 downto 0);
        out_R : out unsigned (15 downto 0);
        flag_zero : out std_logic;
        flag_bigger : out std_logic;
        flag_equals : out std_logic
    );
    end component ula16bits;

    component registrador16bits is 
        port(
            clk: in std_logic;
            reset: in std_logic;
            wr_enable: in std_logic;
            A: in std_logic_vector(15 downto 0);
            S: out std_logic_vector(15 downto 0)
        );
    end component registrador16bits;

    signal data_b, data_r, data_s: unsigned(15 downto 0);
    signal data_a : std_logic_vector(15 downto 0);

begin
    data_b <= unsigned(data_i);
    data_s <= data_b when acumulador_source = '1' else data_r;
    data_o <= std_logic_vector(data_r);

    acumulador: registrador16bits port map(
        clk => clk,
        reset => rst,
        wr_enable => wr_enable,
        A => std_logic_vector(data_s),
        S => data_a
    );

    ula: ula16bits port map(
        in_A => unsigned(data_a),
        in_B => data_b,
        in_op_sel => unsigned(op),
        out_R => data_r,
        flag_zero => flag_zero,
        flag_bigger => flag_bigger,
        flag_equals => flag_equals
    );

end architecture arch_ulaacumuladora;