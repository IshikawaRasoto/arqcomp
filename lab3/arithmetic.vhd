-- Rafael Rasoto
-- Nicolas Riuichi Oda

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic is
	port(	A : in unsigned (15 downto 0);
			B: in unsigned (15 downto 0);
			sum_out	: out unsigned (15 downto 0);
			sub_out : out unsigned (15 downto 0)
	);
end entity;

architecture arch_arithmetic of arithmetic is
begin
	sum_out <= A + B;
	sub_out <= A - B;
end architecture;
