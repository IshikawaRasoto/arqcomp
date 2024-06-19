library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clk : in std_logic;
        we : in std_logic;
        rst : in std_logic;
        addr : in unsigned(7 downto 0);
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity ram;

architecture arch_ram of ram is
    type mem is array (0 to 255) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
begin
   process(clk,we,rst)
   begin
      if rst='1' then
         conteudo_ram <= (others => (others => '0'));
      elsif rising_edge(clk) then
         if we='1' then
            conteudo_ram(to_integer(addr)) <= data_in;
         end if;
      end if;
   end process;
   data_out <= conteudo_ram(to_integer(addr));
end architecture;