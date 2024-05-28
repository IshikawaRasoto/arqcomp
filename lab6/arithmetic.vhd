-- Rafael Rasoto
-- Nicolas Riuichi Oda

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic is
	port(	A : in unsigned (15 downto 0);
			B: in unsigned (15 downto 0);
			sum_out	: out unsigned (15 downto 0);
			sub_out : out unsigned (15 downto 0);
			carry_out_sum : out std_logic;
			carry_out_sub : out std_logic
	);
end entity;

architecture arch_arithmetic of arithmetic is

	signal in_A_17, in_B_17, sum_17, sub_17 : unsigned (15 downto 0);

begin

	in_A_17 <= '0' & A;
	in_B_17 <= '0' & B;
	sum_17 <= in_A_17 + in_B_17;
	sub_17 <= in_A_17 - in_B_17;

	carry_out_sum <= sum_17(16);
	sum_out <= sum_17(15 downto 0);
	sub_out <= sub_17(15 downto 0);

	carry_out_sub <= '0' when B <= A else '1';
end architecture;
