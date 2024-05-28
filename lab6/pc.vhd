library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		clk_i : in std_logic;
		write_en_i : in std_logic;
		data_i : in unsigned (6 downto 0);
		data_o : out unsigned (6 downto 0);
		rst_i : in std_logic
	);
end entity;

architecture arch_pc of pc is

	signal data_s : unsigned (6 downto 0) := "0000000";

begin

	process(clk_i, write_en_i, rst_i)
	begin
		if (rst_i = '1') then
			data_s <= "0000000";
		elsif(write_en_i = '1') then
			if rising_edge(clk_i) then
				data_s <= data_i;
			end if;
		end if;
	end process;
		
	data_o <= data_s;

end architecture;
