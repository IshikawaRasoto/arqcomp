library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
	port(	clk : in std_logic;
			en : in std_logic;
			rst : in std_logic;
			endereco : in unsigned (6 downto 0);
			dado : out unsigned (15 downto 0)
		);
end entity;


architecture arc_rom of rom is 
	type mem is array (0 to 127) of unsigned (15 downto 0);
	constant conteudo_rom : mem := (
	  0  => B"0010_0001_0000_0000", -- LD R1, 0
      1  => B"0010_0010_0000_0001", -- LD R2, 1
	  2  => B"0010_0011_0000_0010", -- LD R3, 2
	  3  => B"0010_0100_0000_0100", -- LD R4, 4
	  4  => B"0010_0101_0000_1000", -- LD R5, 8

	  5  => B"0001_1010_0101_0000", -- MOV A, R5
	  6  => B"0011_1010_0011_0000", -- ADD A, R3
	  7  => B"0011_1010_0010_0000", -- ADD A, R2
	  8  => B"0001_0110_1010_0000", -- MOV R6, A
	  9  => B"1110_0000_0110_0001", -- SW R6, R1

	  10  => B"0011_1010_0100_0000", -- ADD A, R4
	  11  => B"0001_0111_1010_0000", -- MOV R7, A
	  12  => B"0001_1010_0000_0000", -- MOV A, R0
	  13  => B"0011_1010_0100_0000", -- ADD A, R4
	  14  => B"0011_1010_0010_0000", -- ADD A, R2
	  15  => B"0001_0001_1010_0000", -- MOV R1, A
	  16  => B"1110_0000_0111_0001", -- SW R7, R1

	  17  => B"0010_0001_0000_0000", -- LD R1, 0
	  18  => B"1101_0010_0000_0001", -- LW R2, R1
	  19  => B"0001_1010_0010_0000", -- MOV A, R2
	  20  => B"0010_0001_0000_0101", -- LD R1, 5
	  21  => B"1101_0011_0000_0001", -- LW R3 R1
	  22  => B"0011_1010_0011_0000", -- ADD A, R3
	  23  => B"0001_0100_1010_0000", -- MOV R4, A
      -- abaixo: casos omissos => (zero em todos os bits)
	  others => (B"1111_1000_0100_1010")
  	);

	signal dado_s : unsigned (15 downto 0) := "0000000000000000";

begin
	
	process(clk, rst)
	begin
		if rst = '1' then
			dado_s <= (others => '0');
		else 
			if en = '1' then
				if(rising_edge(clk)) then
					dado_s <= conteudo_rom(to_integer(endereco));
				end if;
			end if;
		end if;
	end process;

	dado <= dado_s;
end architecture;
