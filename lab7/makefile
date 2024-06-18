# Variáveis
GHDL = ghdl

# Alvo principal
all: arithmetic logic registrador16bits mux16x4bits ULA16bits ulaacumuladora bancoRegistradores maqestados rom ram pc uc micro micro_tb onda

# Regras para compilar cada arquivo VHDL
arithmetic: arithmetic.vhd
	$(GHDL) -a arithmetic.vhd    
	$(GHDL) -e arithmetic

logic: logic.vhd
	$(GHDL) -a logic.vhd
	$(GHDL) -e logic

registrador16bits: registrador16bits.vhd
	$(GHDL) -a registrador16bits.vhd
	$(GHDL) -e registrador16bits

mux16x4bits: mux16x4bits.vhd
	$(GHDL) -a mux16x4bits.vhd
	$(GHDL) -e mux16x4bits

ULA16bits: ULA16bits.vhd
	$(GHDL) -a ULA16bits.vhd
	$(GHDL) -e ULA16bits

ulaacumuladora: ulaacumuladora.vhd
	$(GHDL) -a ulaacumuladora.vhd
	$(GHDL) -e ulaacumuladora

bancoRegistradores: bancoRegistradores.vhd
	$(GHDL) -a bancoRegistradores.vhd
	$(GHDL) -e bancoRegistradores

maqestados: maqestados.vhd
	$(GHDL) -a maqestados.vhd
	$(GHDL) -e maqestados

rom: rom.vhd
	$(GHDL) -a rom.vhd
	$(GHDL) -e rom

ram: ram.vhd
	$(GHDL) -a ram.vhd
	$(GHDL) -e ram

pc: pc.vhd
	$(GHDL) -a pc.vhd
	$(GHDL) -e pc

uc: uc.vhd
	$(GHDL) -a uc.vhd
	$(GHDL) -e uc

micro: micro.vhd
	$(GHDL) -a micro.vhd
	$(GHDL) -e micro

micro_tb: micro_tb.vhd
	$(GHDL) -a micro_tb.vhd
	$(GHDL) -e micro_tb

onda: micro_tb.vhd
	$(GHDL) -r micro_tb --wave=micro_tb.ghw