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
comando: .asciz "Ingrese un comando: "
salto: .asciz " \n"
receptor: .asciz "                          "
receptor1: .asciz "                          "
format: .asciz "%d \n"
msgerror: .asciz "Ha ingresado un dato invalido\n"
actual: .word 10
strNumVal: .word 0

.text
.global main
.func main

main:

    loop:
        ldr r1, =suma
        bl _print

        ldr r1, =multip
        bl _print

        ldr r1, =modulo
        bl _print

        ldr r1, =potencia
        bl _print

        ldr r1, =primera
        bl _print

        ldr r1, =segunda
        bl _print

        ldr r1, =concat
        bl _print

        ldr r1, =salir
        bl _print

        ldr r0, =receptor1
        bl _keybread

        ldr r0, =receptor1
        ldrb r0, [r0]

        cmp r0, #'q'
        beq salida 
        
        cmp r0, #'+'
        //moveq r11,#1

        ldr r1, =msg1
        bleq _print

        ldr r0, =receptor
        bleq _keybread

        ldr r0,=receptor
        ldr r1,=strNumVal
        bleq _char2Num
        
        ldr r0,=actual
        ldr r0,[r0]
        ldr r1,=strNumVal
        ldr r1,[r1]
        ldr r2,=actual
        bleq _suma

        LDR R1,=actual
        ldr R1,[R1]
        ldr r0,=format
        bleq printf
        
        ldrne R1,=msgerror
        blne _print

        ldr r1, =salto
        bl _print

        b loop


    salida:
    mov r7,#1
    swi 0

