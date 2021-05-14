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
flagM: .word 0
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
        //Muestra de menu
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

        ldreq r1, =msg1
        bleq _print

        ldreq r0, =receptor
        bleq _keybread

        ldreq r0, =receptor
        ldreq r1, =strNumVal
        ldreq r2, =flagM
        bleq _convertirNumero

        ldreq r0,=receptor
        ldreq r1,=strNumVal
        bleq _char2Num
        
        ldreq r0,=actual
        ldreq r0,[r0]
        ldreq r1,=strNumVal
        ldreq r1,[r1]
        ldreq r2,=actual
        bleq _suma

        ldreq R1,=actual
        ldreq R1,[R1]
        ldreq r0,=format
        bleq printf

        ldr r0, =opActual
        ldrb r0, [r0]
        //1 de strings
        cmp r0, #'1'

        ldreq r1, =msg2
        bleq _print
        
        ldreq r0, =string1
        bleq _keybread

        //2 de strings
        cmp r0, #'2'

        ldreq r1, =msg3
        bleq _print

        ldreq r0, =string2
        bleq _keybread

        cmp r0, #'C'
        ldreq r0, =string1
        ldreq r1, =string2
        ldreq r2, =res
        bleq _concatenar

        //ldreq r0, =format3
        //bl puts

        ldreq r0, =res
        bleq puts
        
        
        ldrne R1,=msgerror
        blne _print

        ldr r1, =salto
        bl _print

        b loop


    salida:
    mov r7,#1
    swi 0

