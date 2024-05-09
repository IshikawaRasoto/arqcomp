library ieee;
use ieee.std_logic_1164.all;

entity maq2estados is
	port(
		clk_i : in std_logic;
		data_o : out std_logic;
		rst_i : in std_logic
	);
end entity;

architecture arch_maq2estados of maq2estados is

	signal dado_s : std_logic := '0';

begin

	process(clk_i, rst_i)
	begin

		if (rst_i = '1') then
			dado_s <= '0';
		elsif rising_edge(clk_i) then
			dado_s <= not dado_s;
		end if;
	end process;

	data_o <= dado_s;

end architecture;
