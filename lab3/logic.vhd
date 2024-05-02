library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic is
	port(	A : in unsigned (15 downto 0);
			B : in unsigned (15 downto 0);
			and_out : out unsigned (15 downto 0);
			or_out : out unsigned (15 downto 0)
	);
end entity;

architecture arch_logic of logic is
begin
	and_out <= A and B;
	or_out <= A or B;
end architecture;
