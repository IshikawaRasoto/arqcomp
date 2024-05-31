-- Rafael Rasoto
-- Nicolas Riuichi Oda

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic is
	port(	A : in unsigned (15 downto 0);
			B: in unsigned (15 downto 0);
			sum_out	: out unsigned (16 downto 0);
			sub_out : out unsigned (16 downto 0)
	);
end entity;

architecture arch_arithmetic of arithmetic is

	signal A_17 : unsigned (16 downto 0);
	signal B_17 : unsigned (16 downto 0);

begin
	A_17 <= '0' & A;
	B_17 <= '0' & B;
	sum_out <= A_17 + B_17;
	sub_out <= A_17 - B_17;
end architecture;
