library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16x4bits is
	port(	A : in unsigned (15 downto 0);
			B : in unsigned (15 downto 0);
			C : in unsigned (15 downto 0);
			D : in unsigned (15 downto 0);
			op_sel : in unsigned (1 downto 0);
			R : out unsigned (15 downto 0)
	);
end entity;

architecture arch_mux16x4bits of mux16x4bits is
begin
	R <= A when op_sel="00" else
		 B when op_sel="01" else
		 C when op_sel="10" else
		 D when op_sel="11" else
		 "0000000000000000";
end architecture;
