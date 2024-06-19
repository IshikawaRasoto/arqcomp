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

-- Endereços dos Registradores

-- R0 0000
-- R1 0001
-- R2 0010
-- R3 0011
-- R4 0100
-- R5 0101
-- R6 0110
-- R7 0111
-- A  1010

-- Operações

-- xxxx - Bits não utilizados
-- dddd - Registrador de Destino
-- ssss - Registrador de Origem
-- aaaa - Registrador que aponta para o endereço de Memória
-- cccc - Constantes de 8 bits

-- NOP: 1111 1000 0100 1010

-- MOV: 0001 dddd ssss xxxx
-- LD : 0010 dddd cccc cccc -- dddd NÃO PODE SER O ACUMULADOR
-- ADD: 0011 dddd ssss xxxx
-- SUB: 0100 dddd ssss xxxx
-- AND: 0101 dddd ssss xxxx
-- OR : 0110 dddd ssss xxxx
-- SUBB: 0111 dddd ssss xxxx 
-- CMP: 1000 xxxx xsss xxxx -- A comparação é do Acumulador com o Rs
-- JMP: 1001 xxxx cccc cccc -- jmp absoluto
-- BSM: 1010 xxxx cccc cccc -- Branch if Smaller (Relativo)
-- BBG: 1011 xxxx cccc cccc -- Branch if Bigger (Relativo)
-- BEQ: 1100 xxxx cccc cccc -- Branch if Equal (Relativo)
-- LW:  1101 xddd xxxx xaaa -- Ra é o registrador com o endereço para acessar a RAM
-- SW:  1110 xxxx xsss xaaa

-- Begin:

--     LD R1, 1         ; R1 = 1 (contador e valor a ser armazenado)
--     LD R2, 33        ; R2 = 33 (valor máximo + 1) para controle do loop
--	   LD R3, 1

-- Store_Loop:
--     SW R1, R1        ; Armazena R1 no endereço de memória R1
--     MOV A, R1
--     ADD A, R3         ; Incrementa R1
--     MOV R1, A        ; Atualiza R1 com o novo valor
--     CMP R2           ; Compara R1 com R2
--     BSM Store_Loop   ; Se R1 < R2, continua o loop

--     LD R1, 2         ; R1 = 2 (número cujos múltiplos serão eliminados)
--     LD R3, 2         ; R3 = 2 (início da memória a ser verificada)
--     LD R7, 1

-- Clear_Multiples_of_2:
--     LW R4, R3        ; Carrega o valor do endereço R3 em R4
--     MOV A, R4
--     AND A, R7         ; Verifica se R4 é múltiplo de 2 (bit de menor ordem = 0)
--     BEQ Clear_2      ; Se o bit de menor ordem for 1, pula a eliminação
--     JMP Skip_Clear

-- Clear_2:
--     LD R4, 0         
--     SW R4, R3        ; Armazena 0 no endereço R3

-- Skip_Clear:
--     MOV A, R1
--     ADD A, R3        ; Incrementa R3 pelo valor de R1 (próximo múltiplo de 2)
--     MOV R3, A
--     CMP R2           ; Compara R3 com R2
--     BSM Clear_Multiples_of_2 ; Se R3 < R2, continua o loop

--     LD R1, 3         ; R1 = 3 (número cujos múltiplos serão eliminados)
--     LD R3, 3         ; R3 = 3 (início da memória a ser verificada)

-- Clear_Multiples_of_3:
--     LW R4, R3        ; Carrega o valor do endereço R3 em R4

-- Check_Multiples_of_3:
--     MOV A, R4
--     SUB A, R1        ; Subtrai R1 de R4
--     MOV R4, A
--     CMP R0           ; Compara R4 com 0
--     BEQ Clear_3      ; Se R4 = 0, R4 é múltiplo de 3
--     CMP R0
--     BSM Skip_Clear_3 ; Se R4 < 0, R4 não é múltiplo de 3
--     JMP Check_Multiples_of_3

-- Clear_3:
--     LD R4, 0         
--     SW R4, R3        ; Armazena 0 no endereço R3

-- Skip_Clear_3:
--     MOV A, R1
--     ADD A, R3        ; Incrementa R3 pelo valor de R1 (próximo múltiplo de 3)
--     MOV R3, A
--     CMP R2           ; Compara R3 com R2
--     BSM Clear_Multiples_of_3 ; Se R3 < R2, continua o loop

--     LD R1, 5
--     LD R3, 5

-- Clear_Multiples_of_5:
--     LW R4, R3

-- Check_Multiples_of_5:
--     MOV A, R4
--     SUB A, R1
--     MOV R4, A
--     CMP R0
--     BEQ Clear_5
--     CMP R0
--     BSM Skip_Clear_5
--     JMP Skip_Clear_5

-- Clear_5:
--     LD R4, 0
--     SW R4, R3

-- Skip_Clear_5:
--     MOV A, R1
--     ADD A, R3
--     MOV R3, A
--     CMP R2
--     BSM Clear_Multiples_of_5

-- Read_RAM:
--     LD R1, 1
--     LD R3, 1
--     LD R4, 33

--     MOV A, R1

-- Read_Loop:
--     CMP R4
--     BEQ Begin
--     LW R5, R3
--     ADD A, R1
--     MOV R3, A
--     JMP Read_Loop




-- Teste 2


-- Begin:
-- LD R1, 0x12 -- Parte Baixa A
-- LD R2, 0x34 -- Parte Alta A
-- LD R3, 0xBC -- Parte Baixa B
-- LD R4, 0x0A -- Parte Alta B

-- sub_32_1:
--     MOV A, R1     -- Move a parte baixa de A para o acumulador
--     SUB A, R3     -- Subtrai a parte baixa de B da parte baixa de A
--     MOV R5, A     -- Armazena o resultado em R5 (parte baixa do resultado)

--     MOV A, R1     -- Move novamente a parte baixa de A para o acumulador
--     CMP R3        -- Compara a parte baixa de A com a parte baixa de B
--     BSM borrow_1  -- Se A < B, ocorre borrow e pula para a label 'borrow_1'
--     JMP no_borrow_1 -- Se não houver borrow, pula para a label 'no_borrow_1'

-- borrow_1:
--     MOV A, R2     -- Move a parte alta de A para o acumulador
--     SUBB A, R4    -- Subtrai a parte alta de B da parte alta de A considerando borrow
--     JMP teste_2   -- Pula para a label 'teste_2'

-- no_borrow_1:
--     MOV A, R2     -- Move a parte alta de A para o acumulador
--     SUB A, R4     -- Subtrai a parte alta de B da parte alta de A sem considerar borrow

-- teste_2:

-- MOV R6, A

-- LD R1, 0x12 -- Parte Baixa A
-- LD R2, 0x34 -- Parte Alta A
-- LD R3, 0x01 -- Parte Baixa B
-- LD R4, 0x01 -- Parte Alta B
    
-- sub_32_2:
--     MOV A, R1     -- Move a parte baixa de A para o acumulador
--     SUB A, R3     -- Subtrai a parte baixa de B da parte baixa de A
--     MOV R5, A     -- Armazena o resultado em R5 (parte baixa do resultado)

--     MOV A, R1     -- Move novamente a parte baixa de A para o acumulador
--     CMP R3        -- Compara a parte baixa de A com a parte baixa de B
--     BSM borrow_2  -- Se A < B, ocorre borrow e pula para a label 'borrow_2'
--     JMP no_borrow_2 -- Se não houver borrow, pula para a label 'no_borrow_2'

-- borrow_2:
--     MOV A, R2     -- Move a parte alta de A para o acumulador
--     SUBB A, R4    -- Subtrai a parte alta de B da parte alta de A considerando borrow
--     JMP exception -- Pula para a label 'exception'

-- no_borrow_2:
--     MOV A, R2     -- Move a parte alta de A para o acumulador
--     SUB A, R4     -- Subtrai a parte alta de B da parte alta de A sem considerar borrow

-- exception:

-- MOV R6, A

-- 0xffff            -- Finaliza o programa ou indica uma exceção




constant conteudo_rom : mem := (
	-- Begin
	0  => B"0010_0001_0000_0001", -- LD R1 1
	1  => B"0010_0010_0010_0001", -- LD R2 33
	2  => B"0010_0011_0000_0001", -- LD R3 1
	-- Store Loop
	3  => B"1110_0000_0001_0001", -- SW R1 R1
	4  => B"0001_1010_0001_0000", -- MOV A R1
	5  => B"0011_1010_0011_0000", -- ADD A R3
	6  => B"0001_0001_1010_0000", -- MOV R1 A
	7  => B"1000_0000_0010_0000", -- CMP R2
	8  => B"1010_0000_1111_1011", -- BSM Store Loop (-5)

	9  => B"0010_0001_0000_0010", -- LD R1 2
	10 => B"0010_0011_0000_0100", -- LD R3 4

	-- Clear Multiples of 2
	11 => B"1101_0100_0000_0011", -- LW R4 R3
	12 => B"0001_1010_0100_0000", -- MOV A R4
	13 => B"0101_1010_0111_0000", -- AND A R7
	14 => B"1100_0000_0000_0010", -- BEQ Clear 2 (+2)
	15 => B"1001_0000_0001_0010", -- JMP Skip Clear (18)

	-- Clear 2
	16 => B"0010_0100_0000_0000", -- LD R4 0
	17 => B"1110_0000_0100_0011", -- SW R4 R3

	-- Skip Clear
	18 => B"0001_1010_0001_0000", -- MOV A R1
	19 => B"0011_1010_0011_0000", -- ADD A R3
	20 => B"0001_0011_1010_0000", -- MOV R3 A
	21 => B"1000_0000_0010_0000", -- CMP R2
	22 => B"1010_0000_1111_0101", -- BSM Clear Multiples of 2 (-11)

	23 => B"0010_0001_0000_0011", -- LD R1 3
	24 => B"0010_0011_0000_0110", -- LD R3 6
  
	-- Clear Multiples of 3
	25 => B"1101_0100_0000_0011", -- LW R4 R3
  
	-- Check Multiples of 3
	26 => B"0001_1010_0100_0000", -- MOV A R4
	27 => B"0100_1010_0001_0000", -- SUB A R1
	28 => B"0001_0100_1010_0000", -- MOV R4 A
	29 => B"1000_0000_0000_0000", -- CMP R0
	30 => B"1100_0000_0000_0100", -- BEQ Clear 3 (+4)
	31 => B"1000_0000_0000_0000", -- CMP R0
	32 => B"1010_0000_0000_0100", -- BSM Skip Clear 3 (+4)
	33 => B"1001_0000_0001_1010", -- JMP Check_Multiples_of_3 (26)

	-- Clear 3
	34 => B"0010_0100_0000_0000", -- LD R4 0
	35 => B"1110_0000_0100_0011", -- SW R4 R3

	-- Skip Clear 3
	36 => B"0001_1010_0001_0000", -- MOV A R1
	37 => B"0011_1010_0011_0000", -- ADD A R3
	38 => B"0001_0011_1010_0000", -- MOV R3 A
	39 => B"1000_0000_0010_0000", -- CMP R2
	40 => B"1010_0000_1111_0001", -- BSM Clear Multiples of 3 (-15)

	41 => B"0010_0001_0000_0101", -- LD R1 5
	42 => B"0010_0011_0000_1010", -- LD R3 10

	-- Clear Multiples of 5
	43 => B"1101_0100_0000_0011", -- LW R4 R3

	-- Check Multiples of 5
	44 => B"0001_1010_0100_0000", -- MOV A R4
	45 => B"0100_1010_0001_0000", -- SUB A R1
	46 => B"0001_0100_1010_0000", -- MOV R4 A
	47 => B"1000_0000_0000_0000", -- CMP R0
	48 => B"1100_0000_0000_0100", -- BEQ Clear 5 (+4)
	49 => B"1000_0000_0000_0000", -- CMP R0
	50 => B"1010_0000_0000_0100", -- BSM Skip Clear 5 (+4)
	51 => B"1001_0000_0010_1100", -- JMP Check_Multiples_of_5 (44)

	-- Clear 5
	52 => B"0010_0100_0000_0000", -- LD R4 0
	53 => B"1110_0000_0100_0011", -- SW R4 R3

	-- Skip Clear 5
	54 => B"0001_1010_0001_0000", -- MOV A R1
	55 => B"0011_1010_0011_0000", -- ADD A R3
	56 => B"0001_0011_1010_0000", -- MOV R3 A
	57 => B"1000_0000_0010_0000", -- CMP R2
	58 => B"1010_0000_1111_0001", -- BSM Clear Multiples of 5 (-15)

	-- Read RAM
	59 => B"0010_0001_0000_0001", -- LD R1 1
	60 => B"0010_0011_0000_0001", -- LD R3 1
	61 => B"0010_0100_0010_0001", -- LD R4 33

	62 => B"0001_1010_0001_0000", -- MOV A R1

	-- Read Loop
	63 => B"1000_0000_0100_0000", -- CMP R4
	64 => B"1100_0000_1100_0000", -- BEQ Begin (-64)
	65 => B"1101_0101_0000_0011", -- LW R5 R3
	66 => B"0011_1010_0001_0000", -- ADD A R1
	67 => B"0001_0011_1010_0000", -- MOV R3 A
	68 => B"1001_0000_0011_1111",  -- JMP Read_Loop (63)


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
