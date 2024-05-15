.data
    frase:         .asciiz "ARCHITETTURA DEGLI ELABORATORI"    ;frase da cifrare
    newline:       .asciiz "\n"                                ;carattere newline
    frasecifrata:  .asciiz ""                                  ;frase cifrata
    numcar:        .word   31  ;numero di caratteri della frase
    chiave:        .word   13  ;chiave del cifrario
    indice:        .word   0   ;indice del ciclo for
    maxcar:        .word   91  ;'[' carattere massimo
    mincar:        .word   64  ;'@' carattere minimo

    CONTROL:       .word   0x10000 ;indirizzo di CONTROL
    DATA:          .word   0x10008 ;indirizzo di DATA

.text
    start: LWU    r28, DATA(r0)    ;carica DATA in r28
        LWU       r29, CONTROL(r0) ;carica CONTROL in r29
        LW        r1, numcar(r0)   ;carica numero di caratteri  
        LW        r2, chiave(r0)   ;carica chiave cifratura
        LW        r3, indice(r0)   ;carica indice ciclo
        LW        r6, maxcar(r0)   ;carica carattere '['
        LW        r7, mincar(r0)   ;carica carattere '@'

        DADDI     r4, r0, frase           ;puntatore al primo carattere dell'array
        DADDI     r5, r0, frasecifrata    ;puntatore al primo carattere dell'array

        DADDI     r14, r7,   1    ;ottengo 'A'
        DADDI     r15, r6,   -1   ;ottengo 'Z'

        DADDI     r27, r0, 4      ;imposta DATA per stampare una stringa
        DADDI     r26, r0, frase  ;imposta stringa da stampare
        SD        r26, 0(r28)     ;imposta DATA con la stringa
        SD        r27, 0(r29)     ;stampa la stringa

    ;inizio ciclo for
    loop:  LB     r8,  0(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem        ;if1: salta se diverso da zero

        SB        r8,  0(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif           ;salto incondizionato
    
    ;entro in if1
    sem:   BNEZ   r11, set        ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 0(r5)      ;frasecifrata[i] = r16
        J         endif          ;salto incondizionato

    ;entro in if2
    set:   DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 0(r5)      ;frasecifrata[i] = r20
    
    endif: 
    
    2:     LB     r8,  1(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem2       ;if1: salta se diverso da zero

        SB        r8,  1(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif2          ;salto incondizionato
    
    ;entro in if1
    sem2:  BNEZ   r11, set2       ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 1(r5)      ;frasecifrata[i] = r16
        J         endif2          ;salto incondizionato

    ;entro in if2
    set2:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 1(r5)      ;frasecifrata[i] = r20
    
    endif2:

    3:     LB     r8,  2(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem3        ;if1: salta se diverso da zero

        SB        r8,  2(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif3          ;salto incondizionato
    
    ;entro in if1
    sem3:  BNEZ   r11, set3        ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 2(r5)      ;frasecifrata[i] = r16
        J         endif3          ;salto incondizionato

    ;entro in if2
    set3:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 2(r5)      ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif3: DADDI r4,  r4,   3   ;vai alla posizione successiva di frase
        DADDI     r5,  r5,   3   ;vai alla posizione successiva di frasecifrata
        
        SLT       r19, r3,   r1  ;indice < numcar ?
        DADDI     r3,  r3,   1   ;incremento indice
        SLT       r19, r3,   r1  ;indice < numcar ?
        DADDI     r3,  r3,   2   ;incremento indice

        BNEZ      r19, loop      ;salta se diverso da zero
        ;fine ciclo for

        ;stampa carattere newline
        DADDI     r27, r0, 4          ;imposta DATA per stampare una stringa
        DADDI     r26, r0, newline    ;imposta stringa da stampare
        SD        r26, 0(r28)         ;imposta DATA con la stringa
        SD        r27, 0(r29)         ;stampa la stringa
        
        ;stampa la frase cifrata
        DADDI     r27, r0, 4             ;imposta DATA per stampare una stringa
        DADDI     r26, r0, frasecifrata  ;imposta stringa da stampare
        SD        r26, 0(r28)            ;imposta DATA con la stringa
        SD        r27, 0(r29)            ;stampa la stringa
    
    end:   HALT