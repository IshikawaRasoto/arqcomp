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
	  0  => B"0010_0111_0000_0001", -- LD R7, 1
      1  => B"0010_0110_0001_1110", -- LD R6, 30
      2  => B"0010_0011_0000_0000", -- LD R3, 0 -- Operação A
      3  => B"0010_0100_0000_0000", -- LD R4, 0 -- Operação B
      4  => B"0001_1010_0100_0000", -- Loop: MOV A, R4 -- Operação C 
      5  => B"0011_1010_0011_0000", -- ADD A, R3
      6  => B"0001_0100_1010_0000", -- MOV R4, A
      7  => B"0001_1010_0011_0000", -- MOV A, R3 -- Operação D
      8  => B"0011_1010_0111_0000", -- ADD A, R7
      9  => B"0001_0011_1010_0000", -- MOV R3, A
      10 => B"1000_0000_0110_0000", -- CMP R6 -- Operação E
	  11 => B"1010_0000_1111_1001", -- BSM -7
	  12 => B"0001_0101_0100_0000", -- MOV R5, R4 -- Operação F
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
