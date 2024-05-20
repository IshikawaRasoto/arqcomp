LD R3, 5 -- Operação A
LD R4, 8 -- Operação B
MOV A, R3 -- Operação C
ADD A, R4
MOV R5, A
LD R1, 1 -- Operação D
SUB A, R1
MOV R5, A
JMP 20 -- Operação E
LD R5, 0 -- Operação F
MOV A, R5 -- Operação G
MOV R3, A
JMP 2 -- Operação H
LD R3, 0 -- Operação I