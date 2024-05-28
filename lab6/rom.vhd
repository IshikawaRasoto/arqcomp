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
	  0  => B"0010_0011_0000_0101", -- LD R3, 5 -- Operação A
      1  => B"0010_0100_0000_1000", -- LD R4, 8 -- Operação B
      2  => B"0001_1010_0011_0000", -- MOV A, R3 -- Operação C
      3  => B"0011_1010_0100_0000", -- ADD A, R4
      4  => B"0001_0101_1010_0000", -- MOV R5, A
      5  => B"0010_0001_0000_0001", -- LD R1, 1 -- Operação D
      6  => B"0100_1010_0001_0000", -- SUB A, R1
      7  => B"0001_0101_1010_0000", -- MOV R5, A
      8  => B"1000_0000_0001_0100", -- JMP 20 -- Operação E
      9  => B"0010_0101_0000_0000", -- LD R5, 0 -- Operação F
      20 => B"0001_1010_0101_0000", -- MOV A, R5 -- Operação G
	  21 => B"0001_0011_1010_0000", -- MOV R3, A
	  22 => B"1000_0000_0000_0010", -- JMP 2 -- Operação H
	  23 => B"0010_0011_0000_0000", -- LD R3, 0 -- Operação I
      -- abaixo: casos omissos => (zero em todos os bits)
	  others => (others => '0')
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
