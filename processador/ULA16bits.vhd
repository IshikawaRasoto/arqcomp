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
			flag_carry_in : in std_logic;
			flag_subb : in std_logic;
			carry_out : out std_logic
		);
end entity;

architecture arch_ULA16bits of ULA16bits is

	component arithmetic is 
		port(	A : in unsigned (15 downto 0);
				B : in unsigned (15 downto 0);
				sum_out : out unsigned (16 downto 0);
				sub_out : out unsigned (16 downto 0)
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

	signal and_A_B, or_A_B, signal_R : unsigned (15 downto 0);
	signal sum_A_B, sub_A_B : unsigned (16 downto 0);
	signal A_16 : unsigned (15 downto 0);
	signal B_16 : unsigned (15 downto 0);
	signal s_flag_zero : std_logic := '0';
	signal s_flag_bigger : std_logic := '0';
	signal carry_sum : std_logic := '0';
	signal carry_sub : std_logic := '0';

begin

	A_16 <= in_A;
	B_16 <= in_B;
	out_R <= signal_R - 1 when flag_subb = '1' else signal_R;	
	s_flag_zero <= '1' when signal_R="0000000000000000" else '0';
	s_flag_bigger <= '1' when in_A > in_B else '0';

	flag_zero <= s_flag_zero;
	flag_bigger <= s_flag_bigger;
	carry_sum <= '1' when sum_A_B(16)= '1' else '0';
	carry_sub <= '0' when signed(in_B) <= signed(in_A) else '1';
	carry_out <= carry_sum when in_op_sel="00" else carry_sub when in_op_sel="01" else '0';
	
	arit : arithmetic port map (A=>A_16, B=>B_16, sum_out=>sum_A_B, sub_out=>sub_A_B);
	log : logic port map (A=>A_16, B=>B_16, and_out=>and_A_B, or_out=>or_A_B);
	mux : mux16x4bits port map (A=>sum_A_B(15 downto 0), B=>sub_A_B (15 downto 0), C=>and_A_B, D=>or_A_B, op_sel=>in_op_sel, R=>signal_R);
	

end architecture;
