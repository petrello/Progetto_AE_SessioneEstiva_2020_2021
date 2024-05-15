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

    1:     LB     r8,  0(r4)      ;leggi frase[i]
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
        J         endif           ;salto incondizionato

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
    sem2: BNEZ   r11, set2        ;if2: salta se diverso da zero

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
        BNEZ      r9,  sem3       ;if1: salta se diverso da zero

        SB        r8,  2(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif3          ;salto incondizionato
    
    ;entro in if1
    sem3:  BNEZ   r11, set3       ;if2: salta se diverso da zero

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
    endif3:

    4:     LB     r8,  3(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem4       ;if1: salta se diverso da zero

        SB        r8,  3(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif4          ;salto incondizionato
    
    ;entro in if1
    sem4:   BNEZ   r11, set4       ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 3(r5)      ;frasecifrata[i] = r16
        J         endif4          ;salto incondizionato

    ;entro in if2
    set4:   DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 3(r5)      ;frasecifrata[i] = r20
    
    endif4: 
    
    5:     LB     r8,  4(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem5       ;if1: salta se diverso da zero

        SB        r8,  4(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif5          ;salto incondizionato
    
    ;entro in if1
    sem5: BNEZ   r11, set5        ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 4(r5)      ;frasecifrata[i] = r16
        J         endif5          ;salto incondizionato

    ;entro in if2
    set5:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 4(r5)      ;frasecifrata[i] = r20
    
    endif5:

    6:     LB     r8,  5(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem6       ;if1: salta se diverso da zero

        SB        r8,  5(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif6          ;salto incondizionato
    
    ;entro in if1
    sem6:  BNEZ   r11, set6       ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 5(r5)      ;frasecifrata[i] = r16
        J         endif6          ;salto incondizionato

    ;entro in if2
    set6:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 5(r5)      ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif6:

    7:     LB     r8,  6(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem7       ;if1: salta se diverso da zero

        SB        r8,  6(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif7          ;salto incondizionato
    
    ;entro in if1
    sem7: BNEZ   r11, set7        ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 6(r5)      ;frasecifrata[i] = r16
        J         endif7          ;salto incondizionato

    ;entro in if2
    set7:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 6(r5)      ;frasecifrata[i] = r20
    
    endif7:

    8:     LB     r8,  7(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem8       ;if1: salta se diverso da zero

        SB        r8,  7(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif8          ;salto incondizionato
    
    ;entro in if1
    sem8:  BNEZ   r11, set8       ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 7(r5)      ;frasecifrata[i] = r16
        J         endif8          ;salto incondizionato

    ;entro in if2
    set8:  DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 7(r5)      ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif8:

    9:     LB     r8,  8(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem9       ;if1: salta se diverso da zero

        SB        r8,  8(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif9          ;salto incondizionato
    
    ;entro in if1
    sem9:   BNEZ   r11, set9       ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 8(r5)      ;frasecifrata[i] = r16
        J         endif9          ;salto incondizionato

    ;entro in if2
    set9:   DADD   r20, r8,   r2   ;frase[i] + chiave
        SB        r20, 8(r5)      ;frasecifrata[i] = r20
    
    endif9: 
    
    10:    LB     r8,  9(r4)      ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem10      ;if1: salta se diverso da zero

        SB        r8,  9(r5)      ;else1: frasecifrata[i] = frase[i]
        J         endif10         ;salto incondizionato
    
    ;entro in if1
    sem10: BNEZ   r11, set10      ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 9(r5)      ;frasecifrata[i] = r16
        J         endif10         ;salto incondizionato

    ;entro in if2
    set10:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 9(r5)      ;frasecifrata[i] = r20
    
    endif10:

    11:    LB     r8,  10(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem11      ;if1: salta se diverso da zero

        SB        r8,  10(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif11         ;salto incondizionato
    
    ;entro in if1
    sem11:  BNEZ   r11, set11     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 10(r5)     ;frasecifrata[i] = r16
        J         endif11         ;salto incondizionato

    ;entro in if2
    set11:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 10(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif11:

    12:    LB     r8,  11(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem12      ;if1: salta se diverso da zero

        SB        r8,  11(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif12         ;salto incondizionato
    
    ;entro in if1
    sem12: BNEZ   r11, set12      ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 11(r5)     ;frasecifrata[i] = r16
        J         endif12         ;salto incondizionato

    ;entro in if2
    set12:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 11(r5)     ;frasecifrata[i] = r20
    
    endif12:

    13:    LB     r8,  12(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem13      ;if1: salta se diverso da zero

        SB        r8,  12(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif13         ;salto incondizionato
    
    ;entro in if1
    sem13:  BNEZ   r11, set13     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 12(r5)     ;frasecifrata[i] = r16
        J         endif13         ;salto incondizionato

    ;entro in if2
    set13:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 12(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif13:

    14:    LB     r8,  13(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem14      ;if1: salta se diverso da zero

        SB        r8,  13(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif14         ;salto incondizionato
    
    ;entro in if1
    sem14: BNEZ   r11, set14      ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 13(r5)     ;frasecifrata[i] = r16
        J         endif14         ;salto incondizionato

    ;entro in if2
    set14:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 13(r5)     ;frasecifrata[i] = r20
    
    endif14:

    15:    LB     r8,  14(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem15      ;if1: salta se diverso da zero

        SB        r8,  14(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif15         ;salto incondizionato
    
    ;entro in if1
    sem15:  BNEZ   r11, set15     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 14(r5)     ;frasecifrata[i] = r16
        J         endif15         ;salto incondizionato

    ;entro in if2
    set15:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 14(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif15:

    16:    LB     r8,  15(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem16      ;if1: salta se diverso da zero

        SB        r8,  15(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif16         ;salto incondizionato
    
    ;entro in if1
    sem16:  BNEZ   r11, set16     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 15(r5)     ;frasecifrata[i] = r16
        J         endif16         ;salto incondizionato

    ;entro in if2
    set16:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 15(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif16:

    17:    LB     r8,  16(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem17      ;if1: salta se diverso da zero

        SB        r8,  16(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif17         ;salto incondizionato
    
    ;entro in if1
    sem17:  BNEZ   r11, set17     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 16(r5)     ;frasecifrata[i] = r16
        J         endif17         ;salto incondizionato

    ;entro in if2
    set17:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 16(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif17:

    18:    LB     r8,  17(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem18      ;if1: salta se diverso da zero

        SB        r8,  17(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif18         ;salto incondizionato
    
    ;entro in if1
    sem18: BNEZ   r11, set18      ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 17(r5)     ;frasecifrata[i] = r16
        J         endif18         ;salto incondizionato

    ;entro in if2
    set18:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 17(r5)     ;frasecifrata[i] = r20
    
    endif18:

    19:    LB     r8,  18(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem19      ;if1: salta se diverso da zero

        SB        r8,  18(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif19         ;salto incondizionato
    
    ;entro in if1
    sem19:  BNEZ   r11, set19     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 18(r5)     ;frasecifrata[i] = r16
        J         endif19         ;salto incondizionato

    ;entro in if2
    set19:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 18(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif19:

    20:    LB     r8,  19(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem20      ;if1: salta se diverso da zero

        SB        r8,  19(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif20         ;salto incondizionato
    
    ;entro in if1
    sem20: BNEZ   r11, set20      ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 19(r5)     ;frasecifrata[i] = r16
        J         endif20         ;salto incondizionato

    ;entro in if2
    set20:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 19(r5)     ;frasecifrata[i] = r20
    
    endif20:

    21:    LB     r8,  20(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem21      ;if1: salta se diverso da zero

        SB        r8,  20(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif21         ;salto incondizionato
    
    ;entro in if1
    sem21:  BNEZ   r11, set21     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 20(r5)     ;frasecifrata[i] = r16
        J         endif21         ;salto incondizionato

    ;entro in if2
    set21:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 20(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif21:

    22:    LB     r8,  21(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem22      ;if1: salta se diverso da zero

        SB        r8,  21(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif22         ;salto incondizionato
    
    ;entro in if1
    sem22:  BNEZ   r11, set22     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 21(r5)     ;frasecifrata[i] = r16
        J         endif22         ;salto incondizionato

    ;entro in if2
    set22:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 21(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif22:

    23:    LB     r8,  22(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem23      ;if1: salta se diverso da zero

        SB        r8,  22(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif23         ;salto incondizionato
    
    ;entro in if1
    sem23:  BNEZ   r11, set23     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 22(r5)     ;frasecifrata[i] = r16
        J         endif23         ;salto incondizionato

    ;entro in if2
    set23:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 22(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif23:

    24:    LB     r8,  23(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem24      ;if1: salta se diverso da zero

        SB        r8,  23(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif24         ;salto incondizionato
    
    ;entro in if1
    sem24:  BNEZ   r11, set24     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 23(r5)     ;frasecifrata[i] = r16
        J         endif24         ;salto incondizionato

    ;entro in if2
    set24:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 23(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif24:

    25:    LB     r8,  24(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem25      ;if1: salta se diverso da zero

        SB        r8,  24(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif25         ;salto incondizionato
    
    ;entro in if1
    sem25:  BNEZ   r11, set25     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 24(r5)     ;frasecifrata[i] = r16
        J         endif25         ;salto incondizionato

    ;entro in if2
    set25:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 24(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif25:

    26:    LB     r8,  25(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem26      ;if1: salta se diverso da zero

        SB        r8,  25(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif26         ;salto incondizionato
    
    ;entro in if1
    sem26:  BNEZ   r11, set26     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 25(r5)     ;frasecifrata[i] = r16
        J         endif26         ;salto incondizionato

    ;entro in if2
    set26:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 25(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif26:

    27:    LB     r8,  26(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem27      ;if1: salta se diverso da zero

        SB        r8,  26(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif27         ;salto incondizionato
    
    ;entro in if1
    sem27:  BNEZ   r11, set27     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 26(r5)     ;frasecifrata[i] = r16
        J         endif27         ;salto incondizionato

    ;entro in if2
    set27:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 26(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif27:

    28:    LB     r8,  27(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem28      ;if1: salta se diverso da zero

        SB        r8,  27(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif28         ;salto incondizionato
    
    ;entro in if1
    sem28:  BNEZ   r11, set28     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 27(r5)     ;frasecifrata[i] = r16
        J         endif28         ;salto incondizionato

    ;entro in if2
    set28:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 27(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif28:

    29:    LB     r8,  28(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem29      ;if1: salta se diverso da zero

        SB        r8,  28(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif29         ;salto incondizionato
    
    ;entro in if1
    sem29:  BNEZ   r11, set29     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 28(r5)     ;frasecifrata[i] = r16
        J         endif29         ;salto incondizionato

    ;entro in if2
    set29:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 28(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif29:

    30:    LB     r8,  29(r4)     ;leggi frase[i]
        DSUB      r11, r6,   r2   ;'[' - chiave
        SLT       r9,  r8,   r6   ;frase[i] < '[' ?
        SLT       r10, r7,   r8   ;'@' < frase[i] ?
        AND       r9,  r9,   r10  ;AND tra i due esiti precedenti
        SLT       r11, r8,   r11  ;frase[i] < ('[' - chiave) ?
        BNEZ      r9,  sem30      ;if1: salta se diverso da zero

        SB        r8,  29(r5)     ;else1: frasecifrata[i] = frase[i]
        J         endif30         ;salto incondizionato
    
    ;entro in if1
    sem30:  BNEZ   r11, set30     ;if2: salta se diverso da zero

        ;else2
        DADD      r12, r14,  r2   ;'A' + chiave in r14
        DADD      r16, r12,  r8   ;r12 + frase[i] in r16
        DSUB      r16, r16,  r15  ;r16 - 'Z' in r16
        DADDI     r16, r16,  -1   ;decremento r16
        SB        r16, 29(r5)     ;frasecifrata[i] = r16
        J         endif30         ;salto incondizionato

    ;entro in if2
    set30:  DADD   r20, r8,   r2  ;frase[i] + chiave
        SB        r20, 29(r5)     ;frasecifrata[i] = r20
    
    ;aggiornamento valori
    endif30:
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