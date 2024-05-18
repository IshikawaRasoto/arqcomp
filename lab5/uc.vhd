library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk : in std_logic;
        rst : in std_logic;
        data_out : out std_logic_vector(11 downto 0)
    );
end entity uc;

architecture arch_uc of uc is 

    component pc is 
        port(
            clk_i : in std_logic;
            write_en_i : in std_logic;
            data_i : in unsigned (6 downto 0);
            data_o : out unsigned (6 downto 0);
            rst_i : in std_logic
        );
    end component;

    component rom is
        port(	
            clk : in std_logic;
			endereco : in unsigned (6 downto 0);
			dado : out unsigned (11 downto 0)
		);
    end component;

    component maqestados is
        port(
            clk_i : in std_logic;
            data_o : out std_logic;
            rst_i : in std_logic
        );
    end component;

    signal maqestados : std_logic;

    signal data_out_pc : unsigned(6 downto 0);
    signal increment : unsigned(6 downto 0);
    signal jmp_address : unsigned(6 downto 0);
    signal mux_pc : unsigned(6 downto 0);

    signal data_out_rom : unsigned(11 downto 0);
    signal op_code : unsigned(3 downto 0);
    signal jump_enable : std_logic;

begin

    increment <= data_out_pc + 1;

    pc_inst : pc
        port map(
            clk_i => clk,
            write_en_i => maqestados,
            data_i => mux_pc,
            data_o => data_out_pc,
            rst_i => rst
        );

    rom_inst : rom
        port map(
            clk => clk,
            endereco => data_out_pc,
            dado => data_out_rom
        );

    maqestados_inst : maq2estados
        port map(
            clk_i => clk,
            data_o => maqestados,
            rst_i => rst
        );

    
    data_out <= std_logic_vector(data_out_rom);

    op_code <= data_out_rom(11 downto 8);
    jump_enable <= '1' when op_code = "1111" else '0';

    jmp_address <= data_out_rom(7 downto 1);

    mux_pc <= jmp_address when jump_enable = '1' else increment;

end architecture arch_uc;
    