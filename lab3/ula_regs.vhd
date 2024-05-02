library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_regs is
    port (
        clk : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        write_address : in std_logic_vector(2 downto 0);
        read_address_1 : in std_logic_vector(2 downto 0);
        read_address_2 : in std_logic_vector(2 downto 0);
        op : in std_logic_vector(1 downto 0);
        result_out : out std_logic_vector(15 downto 0);
        control_B : in std_logic;
        ext_const : in std_logic_vector(15 downto 0);
        flag_zero : out std_logic;
        flag_bigger : out std_logic;
        flag_equals : out std_logic
    );
end entity ula_regs;

architecture arch_ula_regs of ula_regs is

    component bancoRegistradores is
        port(
            clk: in std_logic;
            write_en: in std_logic;
            rst: in std_logic;
            write_data: in std_logic_vector(15 downto 0);
            read_data_1: out std_logic_vector(15 downto 0);
            read_data_2: out std_logic_vector(15 downto 0);
            write_register: in std_logic_vector(2 downto 0);
            read_register_1: in std_logic_vector(2 downto 0);
            read_register_2: in std_logic_vector(2 downto 0)
        );
    end component bancoRegistradores;

    component ULA16bits is
        port(	in_A : in unsigned (15 downto 0);
			in_B : in unsigned (15 downto 0);
			in_op_sel : in unsigned (1 downto 0);
			out_R : out unsigned (15 downto 0);
			flag_zero : out std_logic;
			flag_bigger : out std_logic;
			flag_equals : out std_logic
		);
    end component ULA16bits;

    signal A, B, result : std_logic_vector(15 downto 0);
    signal read_data_2 : std_logic_vector(15 downto 0);

begin

    B <= read_data_2 when control_B = '0' else ext_const;



    ULA16bits_inst : ULA16bits
        port map(
            in_A => unsigned(A),
            in_B => unsigned(B),
            in_op_sel => unsigned(op),
            std_logic_vector(out_R) => result,
            flag_zero => flag_zero,
            flag_bigger => flag_bigger,
            flag_equals => flag_equals
        );

    bancoRegistradores_inst : bancoRegistradores
        port map(
            clk => clk,
            write_en => write_enable,
            rst => reset,
            write_data => result,
            read_data_1 => A,
            read_data_2 => read_data_2,
            write_register => write_address,
            read_register_1 => read_address_1,
            read_register_2 => read_address_2
        );

    result_out <= result;

end architecture arch_ula_regs;
