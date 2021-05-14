.data 
.align 2
suma: .asciz "+ Suma \n"
multip: .asciz "* Multiplicacion \n"
modulo: .asciz "M Modulo \n"
potencia: .asciz "P Potencia de un numero \n"
resultado: .asciz "= Mostrar resultado \n"
primera: .asciz "1 Ingresar primera cadena de caracteres \n"
segunda: .asciz "2 Ingresar segunda cadena de caracteres \n"
concat: .asciz "C Concatenar cadena de caracteres 1 y 2 \n"
salir: .asciz "q Mostrar mensaje de despedida y salir al sistema \n"
msg1: .asciz "Ingrese un numero de 0 a 9999:\n"
msg2: .asciz "Ingrese la primera palabra para concatenar:\n"
msg3: .asciz "Ingrese la segunda palabra para concatenar:\n"
comando: .asciz "Ingrese un comando: "
salto: .asciz " \n"
receptor: .asciz "                          "
receptor1: .asciz "                          "
receptor3: .asciz "                          "
format: .asciz ">> %d \n"
msgerror: .asciz "Ha ingresado un dato invalido\n"
prev: .asciz "Concatenacion:\n"
flagM: .asciz "b"
actual: .word 0
strNumVal: .word 0
string1: .asciz "                               "
string2: .asciz "                               "
format3: .asciz ">>"
res: .asciz "                                                                  \n"
opActual: .asciz " "

.text
.global main
.func main

main:

    loop:

        mov r1, #'b'
        ldr r0, =flagM
        strb r1, [r0]

        //Muestra de menu
        ldr r1, =suma
        bl _print

        ldr r1, =multip
        bl _print

        ldr r1, =modulo
        bl _print

        ldr r1, =potencia
        bl _print

        ldr r1, =resultado
        bl _print

        ldr r1, =primera
        bl _print

        ldr r1, =segunda
        bl _print

        ldr r1, =concat
        bl _print

        ldr r1, =salir
        bl _print

        //Opcion elegida
        ldr r0, =receptor1
        bl _keybread

        ldr r0, =receptor1
        ldrb r0, [r0]
        ldr r1, =opActual
        str r0, [r1]

        //Salida
        cmp r0, #'q'
        beq salida 
        
        //Suma
        cmp r0, #'+'
        bleq Suma
        beq loopcontinue

        cmp r0,#'*'
        bleq Multiplicacion
        beq loopcontinue

        cmp r0,#'='
        bleq Igual
        beq loopcontinue

        cmp r0,#'M'
        bleq Modulo
        beq loopcontinue

        cmp r0,#'P'
        bleq Potencia
        beq loopcontinue


        //1 de strings
        cmp r0, #'1'

        ldreq r1, =msg2
        bleq _print
        
        ldreq r0, =string1
        bleq _keybread
        beq loopcontinue

        //2 de strings
        cmp r0, #'2'

        ldreq r1, =msg3
        bleq _print

        ldreq r0, =string2
        bleq _keybread
        beq loopcontinue

        //Ingreso de 'C'

        cmp r0, #'C'
        ldreq r0, =string1
        ldreq r1, =string2
        ldreq r2, =res
        bleq _concatenar

        ldreq r1, =prev
        bleq _print

        ldreq r1, =res
        bleq _print

        beq loopcontinue

        loopcontinue:


        ldrne R1,=msgerror
        blne _print
        
        ldr r1, =salto
        bl _print

        b loop


    salida:
    mov r7,#1
    swi 0


solicitudValoresNumericos:
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}
    ldr r1, =msg1
    bl _print
    ldr r0, =receptor
    bl _keybread
    ldr r0, =receptor
    ldr r1, =strNumVal
    ldr r2, =flagM
    bl _convertirNumero

    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Suma:
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}
    bl solicitudValoresNumericos

    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finSuma

    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _suma

    ldr R1,=actual
    ldr R1,[R1]
    ldr r0,=format
    bl printf

    finSuma:
    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Multiplicacion:
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}
    bl solicitudValoresNumericos

    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finMultiplacion

    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _multiplicacion

    ldr R1,=actual
    ldr R1,[R1]
    ldr r0,=format
    bl printf

    finMultiplacion:
    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Modulo:
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}
    bl solicitudValoresNumericos

    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finModulo

    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _modulo

    ldr R1,=actual
    ldr R1,[R1]
    ldr r0,=format
    bl printf

    finModulo:
    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Potencia:
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}
    bl solicitudValoresNumericos

    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finPotencia

    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _potencia

    ldr R1,=actual
    ldr R1,[R1]
    ldr r0,=format
    bl printf

    finPotencia:
    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Igual:
    PUSH {LR}
    ldr r1,=actual
    ldr r1,[r1]
    ldr r0,=format
    bl printf
    POP {LR}
    bx LR
