library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA16bits is
	port(	in_A : in unsigned (15 downto 0);
			in_B : in unsigned (15 downto 0);
			in_op_sel : in unsigned (1 downto 0);
			out_R : out unsigned (15 downto 0);
			flag_zero : out std_logic;
			flag_bigger : out std_logic;
			flag_equals : out std_logic
		);
end entity;

architecture arch_ULA16bits of ULA16bits is

	component arithmetic is 
		port(	A : in unsigned (15 downto 0);
				B : in unsigned (15 downto 0);
				sum_out : out unsigned (15 downto 0);
				sub_out : out unsigned (15 downto 0)
		);
	end component;

	component logic is 
		port(	A : in unsigned (15 downto 0);
				B : in unsigned (15 downto 0);
				and_out : out unsigned (15 downto 0);
				or_out : out unsigned (15 downto 0)
			);
	end component;
		
	component mux16x4bits  is 
		port(	A : in unsigned (15 downto 0);
				B : in unsigned (15 downto 0);
				C : in unsigned (15 downto 0);
				D : in unsigned (15 downto 0);
				op_sel : in unsigned (1 downto 0);
				R : out unsigned (15 downto 0)
		);
	end component;

	signal sum_A_B, sub_A_B, and_A_B, or_A_B, signal_R : unsigned (15 downto 0);

begin

	arit : arithmetic port map (A=>in_A, B=>in_B, sum_out=>sum_A_B, sub_out=>sub_A_B);
	log : logic port map (A=>in_A, B=>in_B, and_out=>and_A_B, or_out=>or_A_B);
	mux : mux16x4bits port map (A=>sum_A_B, B=>sub_A_B, C=>and_A_B, D=>or_A_B, op_sel=>in_op_sel, R=>signal_R);
	out_R <= signal_R;	
	flag_zero <= '1' when signal_R="0000000000000000" else '0';
	flag_bigger <= '1' when in_A > in_B else '0';
	flag_equals <= '1' when in_A = in_B else '0';

end architecture;
