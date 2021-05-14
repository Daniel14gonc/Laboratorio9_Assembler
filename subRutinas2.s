.data
.align 2
format: .asciz "%d \n"
format2: .asciz "%c \n"
conversion: .word 0
numFinal: .word 0
potencia: .word 0
temporal: .word 0
string: .asciz "                   "

.text
.align 2

.global _convertirNumero
_convertirNumero:
    PUSH {LR}

    numPointer .req r8
    store .req r9
    flag .req r10
    size .req r5

    mov numPointer, r0
    mov r0, numPointer
    bl puts
    mov store, r1
    mov flag, r2

    mov r7, numPointer
    mov size, #0

    countLoop:
        ldrb r6, [r7], #1
        cmp r6, #' '
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
    ldr r0, =format
    bl printf

    POP {LR}

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

