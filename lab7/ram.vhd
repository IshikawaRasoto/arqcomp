library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clk : in std_logic;
        we : in std_logic;
        addr : in unsigned(7 downto 0);
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity ram;

architecture arch_ram of ram is
    type mem is array (0 to 255) of unsigned(15 downto 0);
    signal conteudo_ram : mem : = (others => (others => '0'));
begin
   process(clk,wr_en)
   begin
      if rising_edge(clk) then
         if wr_en='1' then
            conteudo_ram(to_integer(endereco)) <= dado_in;
         end if;
      end if;
   end process;
   dado_out <= conteudo_ram(to_integer(endereco));
end architecture;