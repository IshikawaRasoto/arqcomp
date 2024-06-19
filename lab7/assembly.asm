LD R1, 0; Endereço da RAM
LD R2, 1
LD R3, 2
LD R4, 4
LD R5, 8

MOV A, R5
ADD A, R3
ADD A, R2
MOV R6, A
SW R6, R1; Salva o resultado no endereço apontado por R1 (0)

ADD A, R4
MOV R7, A
MOV A, R0
ADD A, R4
ADD A, R2
MOV R1, A
SW R7, R1; Salva o resultado no endereço apontado por R1 (15)

LD R1, 0; Endereço da RAM
LW R2, R1; Carrega o valor do endereço apontado por R1 em R2
MOV A, R2
LD R1, 15
LW R3, R1; Carrega o valor do endereço apontado por R1 em R3    
ADD A, R3
MOV R4, A