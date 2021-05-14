/*
 * Autores: Daniel Gonzalez 20293, Juan Carlos Bajan 20109
 * Modificacion: 14/05/2021
 * Descripcion: Subrutinas que permiten la conversion de un numero ascii a decimal y 
 *              concatenacion de dos strings.
 */

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

//Subrutina que permite convertir un numero ascii a decimal
.global _convertirNumero
_convertirNumero:
    //Se resetea el numero donde se guarda el valor convertido de ascii
    ldr r5, =numFinal
    mov r6, #0
    str r6, [r5]

    //Se almacena el CPSR en stack debido a que en el programa principal se necesita
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}

    numPointer .req r8 //Numero en ascii
    store .req r9 //Place to store
    flag .req r10 //Flag por si no es un numero
    size .req r5

    //Etiquetas de registros para el numero ascii, el lugar donde se almacena y la bandera.
    mov numPointer, r0
    mov store, r1
    mov flag, r2

    mov r7, numPointer
    mov size, #0

    //Se realiza un loop que obtiene el tamaño del numero.
    countLoop:
        //Se cuenta hasta que se llega a encontrar un salto de linea o un espacio.
        ldrb r6, [r7], #1
        cmp r6, #32
        beq continue
        cmp r6, #'\n'
        beq continue
        add size, #1
        b countLoop

continue:
    //Se hace la conversion.
    mov r7, numPointer
    sub size, #1
    loopNumeros:
        ldrb r6, [r7], #1
        
        //Se verifica que no se llegue a un espacio o a un salto de linea
        cmp r6, #32
        beq endLoop

        cmp r6, #'\n'
        beq endLoop

        //Se almacena el numero ascii
        ldr r4, =string
        str r6, [r4]
        
        //Se llama a una subrutina que convierte digitos ascii a decimales.
        ldr r0, =string
        ldr r1, =conversion
        bl _char2Num

        //Se determina si es o no un digito
        ldr r0, =conversion
        ldr r0, [r0]
        mvn r1, #1
        cmp r1, r0
        //Si no es un numero, se usa una bandera para indicar que no se almaceno nada y se termina la subrutina.
        moveq r1, #'a'
        streqb r1, [flag]
        bleq final

        //Si es un digito se convierte a su valor decimal, multiplicado por una potencia de 10.
        ldr r0, =conversion
        mov r1, size
        bl _multip10

        //Se usa el tamaño del numero para saber que potencia de 10 se debe usar. Este tamaño se reduce con cada iteración.
        subs size, #1

        bge loopNumeros

endLoop:
    
    //Se almacena el número final
    ldr r1, =numFinal
    ldr r1, [r1]
    str r1, [store]


final:
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

    //Se encuentra la potencia de 10.
    ldr r4, [r0]
    bl _pot10

    //Se multiplica el digito por la potencia de 10.
    ldr r6, =potencia
    ldr r6, [r6]
    mul r4,r6

    //Se añade al numero final.
    ldr r0, =numFinal
    ldr r1, [r0]
    add r1, r4
    str r1, [r0]

    pop {lr}

    bx lr
        

//Subrutina que encuentra una potencia de 10
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


//Subrutina que concatena dos strings
.global _concatenar
_concatenar:
    mrs r11,CPSR

    string1 .req r5
    string2 .req r6
    store .req r7

    mov string1, r0
    mov string2, r1
    mov store, r2

    //Se obtiene cada byte del primer string y se almacena en otro string.
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

    //Se obtiene cada byte de un segundo string y se almacena en el tercer string mencionado.
    concatenar2:
        ldrb r3, [string2], #1

        cmp r3, #32
        beq end2

        cmp r3, #'\n'
        beq end2

        strb r3, [store], #1

        b concatenar2
    
    end2:
    mov r3, #'\n'
    streqb r3, [store], #1

    .unreq string1
    .unreq string2
    .unreq store

    MSR CPSR,r11

    BX LR
