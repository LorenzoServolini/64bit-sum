.INCLUDE "./files/utility.s"

.GLOBAL _main

.DATA
X: .FILL 8,1,0 # Numero X
Y: .FILL 8,1,0 # Numero Y
R: .FILL 8,1,0 # Risultato (X+Y)

.TEXT
_main:  NOP

        # Input di X e Y
        LEA X, %EBP
        CALL in64bit
        MOV %DL, %DH
        LEA Y, %EBP
        CALL in64bit
        OR %DL, %DH # Se X o Y sono nulli, termina
        JNZ fine

        # Somma: X+Y
        XOR %BL, %BL # BL = riporto entrante/uscente (Carry Flag)
        MOV $7, %ECX
somma:  MOV X(%ECX), %AL
        ADD Y(%ECX), %AL
        SETC %BH # Riporto per la prossima somma
        ADD %BL, %AL
        SETC %BL
        OR %BH, %BL
        MOV %AL, R(%ECX)
        DEC %ECX
        CMP $-1, %ECX
        JNE somma

        # Stampa a video X+Y e il riporto uscente
        XOR %ECX, %ECX
stampa: MOV R(%ECX), %AL
        CALL outbyte
        INC %ECX
        CMP $8, %ECX
        JNE stampa
        MOV $' ', %AL
        CALL outchar
        MOV %BL, %AL
        CALL outdecimal_byte
        CALL newline
        CALL newline
        JMP _main

fine:   RET



# ############## Sottoprogramma in64bit ##############
# Prende in input 16 cifre esadecimali e le memorizza nel vettore puntato da EBP.
# Mette DL ad 1 se il numero è nullo, altrimenti a 0.
# Ingresso: EBP -> Indirizzo del vettore
# Uscita: DL -> Zero Flag
in64bit:
        PUSH %ECX
        PUSH %AX

        MOV $1, %DL
        XOR %ECX, %ECX
ciclo:  CALL inbyte
        CMP $0, %AL
        JE dopo
        XOR %DL, %DL # Numero non nullo
dopo:   MOV %AL, (%EBP, %ECX, 1)
        INC %ECX
        CMP $8, %ECX
        JNE ciclo
        CALL newline

        POP %AX
        POP %ECX
        RET
