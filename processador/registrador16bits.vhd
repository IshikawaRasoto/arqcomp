library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador16bits is
    port(
        clk: in std_logic;
        reset: in std_logic;
        wr_enable: in std_logic;
        A: in std_logic_vector(15 downto 0);
        S: out std_logic_vector(15 downto 0)
    );
end registrador16bits;

architecture arq_registrador16bits of registrador16bits is
    signal reg: std_logic_vector(15 downto 0);

    begin
        process(clk, reset, wr_enable)
        begin
            if reset='1' then
                reg <= "0000000000000000";
            elsif wr_enable='1' then
                if rising_edge(clk) then
                    reg <= A;
                end if;
            end if;
        end process;

    S <= reg;
end architecture;