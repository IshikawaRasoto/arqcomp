library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA16bits_tb is
end entity;

architecture arch_ULA16tb of ULA16bits_tb is
	component ULA16bits is
		port(	in_A : in unsigned (15 downto 0);
				in_B : in unsigned (15 downto 0);
				in_op_sel : in unsigned (1 downto 0);
				out_R : out unsigned (15 downto 0);
				flag_zero : out std_logic;
				flag_bigger : out std_logic;
				flag_equals : out std_logic
			);
	end component;

	signal sig_A, sig_B, sig_R : unsigned (15 downto 0);
	signal sig_op : unsigned (1 downto 0);
	signal sig_zero, sig_bigger, sig_equals : std_logic;

begin

	ula : ULA16bits port map (in_A=>sig_A, in_B=>sig_B, in_op_sel=>sig_op, out_R=>sig_R, flag_zero=>sig_zero, flag_bigger=>sig_bigger, flag_equals=>sig_equals);

	process
	begin

		-- Primeiro Caso: soma, 10 + 2 (Flag Bigger) 

		sig_A <= "0000000000001010";
		sig_B <= "0000000000000010";
		sig_op <= "00";
		wait for 50 ns;
		
		-- Segundo Caso: subtracao, 10 - 12 
		sig_A <= "0000000000001010";
		sig_B <= "0000000000001100";
		sig_op <= "01";
		wait for 50 ns;

		-- Terceiro Caso, 10 - 10 (Flag Equals, Flag Zero)
		sig_A <= "0000000000001010";
		sig_B <= "0000000000001010";
		sig_op <= "01";
		wait for 50 ns;

		-- Quarto Caso, 10 + 10 (Flag Equals)
		sig_A <= "0000000000001010";
		sig_b <= "0000000000001010";
		sig_op <= "00";
		wait for 50 ns;

		-- Quinto caso: and 7 & 12 
		sig_A <= "0000000000000111";
		sig_B <= "0000000000001100";
		sig_op <= "10";
		wait for 50 ns;

		-- Sexto caso: and 12 & 7 (Flag Bigger)
		sig_A <= "0000000000001100";
		sig_B <= "0000000000000111";
		sig_op <= "10";
		wait for 50 ns;

		-- Setimo Caso: and 12 & 3 (Flag Zero, Flag Bigger)
		sig_A <= "0000000000001100";
		sig_B <= "0000000000000011";
		sig_op <= "10";
		wait for 50 ns;

		-- Oitavo Caso : or 5 & 17
		sig_A <= "0000000000000101";
		sig_B <= "0000000000010001";
		sig_op <= "11";

		wait for 50 ns;
		wait;

	end process;
end architecture;
