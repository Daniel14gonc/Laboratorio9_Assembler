.data
.align 2
format: .asciz "%d \n"
format2: .asciz "%c \n"
conversion: .word 0
numFinal: .word 0
potencia: .word 0
temporal: .word 0
string: .asciz "                   "
mensaje: .asciz "siuuuuuuuu\n"

.text
.align 2

.global _convertirNumero
_convertirNumero:
    ldr r5, =numFinal
    mov r6, #0
    str r6, [r5]

    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}

    numPointer .req r8 //Numero
    store .req r9 //Place to store
    flag .req r10 //Flag
    size .req r5

    mov numPointer, r0
    mov store, r1
    mov flag, r2

    mov r7, numPointer
    mov size, #0

    countLoop:
        ldrb r6, [r7], #1
        cmp r6, #32
        beq continue
        cmp r6, #'\n'
        beq continue
        add size, #1
        b countLoop

continue:
    mov r3, #0
    mov r7, numPointer
    sub size, #1
    loopNumeros:
        ldrb r6, [r7], #1

        cmp r6, #' '
        beq endLoop

        cmp r6, #'\n'
        beq endLoop

        ldr r4, =string
        str r6, [r4]
        
        ldr r0, =string
        ldr r1, =conversion
        bl _char2Num

        ldr r0, =conversion
        mov r1, size
        bl _multip10

        subs size, #1

        bge loopNumeros

endLoop:

    ldr r1, =numFinal
    ldr r1, [r1]
    str r1, [store]
    /*ldr r0, =format
    bl printf*/

    .unreq numPointer
    .unreq store
    .unreq flag
    .unreq size

    POP {LR}

    POP {r11}

    MSR CPSR,r11

    BX LR


.global _multip10
_multip10:
    push {lr}

    ldr r4, [r0]
    bl _pot10

    ldr r6, =potencia
    ldr r6, [r6]
    mul r4,r6

    ldr r0, =numFinal
    ldr r1, [r0]
    add r1, r4
    str r1, [r0]

    pop {lr}

    bx lr
        


.global _pot10
_pot10:
    mov r2, #0
    mov r0, #1
    mov r6, #10

    potLoop:
        cmp r2, r1
        beq fin
        mul r0, r0, r6
        add r2, #1
        b potLoop
    
    fin:
    ldr r2, =potencia
    str r0, [r2]
    BX LR


.global _concatenar
_concatenar:
    mrs r11,CPSR

    string1 .req r5
    string2 .req r6
    store .req r7

    mov string1, r0
    mov string2, r1
    mov store, r2

    concatenar1:
        ldrb r3, [string1], #1

        cmp r3, #32
        beq end1

       cmp r3, #'\n'
       beq end1

        strb r3, [store], #1

        b concatenar1

    end1:
    mov r0, #' '
    strb r0, [store], #1
    //bl puts

    concatenar2:
        ldrb r3, [string2], #1

        cmp r3, #32
        beq end2

        cmp r3, #'\n'
        beq end2

        strb r3, [store], #1

        b concatenar2
    
    end2:

    .unreq string1
    .unreq string2
    .unreq store

    MSR CPSR,r11

    BX LR
