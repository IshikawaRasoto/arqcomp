LD R7, 1
LD R6, 30
LD R3, 0 ; Operação A
LD R4, 0 ; Operação B

Loop:
MOV A, R4 ; Operação C
ADD A, R3
MOV R4, A
MOV A, R3 ; Operação D
ADD A, R7
MOV R3, A
CMP R6 ; Operação E
BSM -7

MOV R5, R4; Operação F