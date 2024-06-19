library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maqestados is
	port(
		clk_i : in std_logic;
		data_o : out unsigned(1 downto 0);
		rst_i : in std_logic
	);
end entity;

architecture arch_maqestados of maqestados is

	signal dado_s : unsigned (1 downto 0) := "00";

begin

	process(clk_i, rst_i)
	begin

		if (rst_i = '1') then
			dado_s <= "00";
		elsif rising_edge(clk_i) then
			if dado_s = "10" then
				dado_s <= "00";
			else
				dado_s <= dado_s + 1;
			end if;
		end if;
	end process;

	data_o <= dado_s;

end architecture;
