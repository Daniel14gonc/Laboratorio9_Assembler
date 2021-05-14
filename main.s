/*
 * Autores: Daniel Gonzalez 20293, Juan Carlos Bajan 20109
 * Modificacion: 14/05/2021
 * Descripcion: Programa que permite simular una calculadora con operaciones basicas.
 */


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
        //Se modifica la bandera que indica si se ingreso un numero ascii o no.
        mov r1, #'b'
        ldr r0, =flagM
        strb r1, [r0]

        //Muestra de menu de opciones
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

        //Se obtiene la pcion elegida y se almacena
        ldr r0, =receptor1
        bl _keybread

        ldr r0, =receptor1
        ldrb r0, [r0]
        ldr r1, =opActual
        str r0, [r1]

        //Eleccion de salida por parte del usuario.
        cmp r0, #'q'
        beq salida 
        
        //Eleccion de suma.
        cmp r0, #'+'
        bleq Suma
        beq loopcontinue

        //Eleccion de multiplicacion.
        cmp r0,#'*'
        bleq Multiplicacion
        beq loopcontinue

        //Eleccion de igual.
        cmp r0,#'='
        bleq Igual
        beq loopcontinue

        //Eleccion de modulo
        cmp r0,#'M'
        bleq Modulo
        beq loopcontinue

        //Eleccion de potencia
        cmp r0,#'P'
        bleq Potencia
        beq loopcontinue


        //Ingreso y almacenamiento de primer string por concatenar.
        cmp r0, #'1'

        ldreq r1, =msg2
        bleq _print
        
        ldreq r0, =string1
        bleq _keybread
        beq loopcontinue

        //Ingreso y almacenamiento de segundo string por concatenar.
        cmp r0, #'2'

        ldreq r1, =msg3
        bleq _print

        ldreq r0, =string2
        bleq _keybread
        beq loopcontinue

        //Ingreso de 'C' para mostrar los strings concatenados.

        cmp r0, #'C'
        ldreq r0, =string1
        ldreq r1, =string2
        ldreq r2, =res
        bleq _concatenar //Subrutina de concatenacion.

        //Se imprime el resultado despues de concatenar.
        ldreq r1, =prev
        bleq _print

        ldreq r1, =res
        bleq _print

        beq loopcontinue

        loopcontinue:

        //Se imprime un mensaje de error en caso no se elija ninguna opcion correcta.
        ldrne R1,=msgerror
        blne _print
        
        ldr r1, =salto
        bl _print

        b loop

    //Condiciones de salida
    salida:
    mov r7,#1
    swi 0


solicitudValoresNumericos:
    //Se solicitan los valores para operar al usuaario.

    //Es necesario guardar el CPSR porque en el programa principal se utiliza.
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}

    //Se carga el mensaje que indica al usuario que ingrese el numero.
    ldr r1, =msg1
    bl _print

    //Se almacena el mensaje ingresado.
    ldr r0, =receptor
    bl _keybread

    //Se convierte el numero ingresado ascii a decimal.
    ldr r0, =receptor
    ldr r1, =strNumVal
    ldr r2, =flagM
    bl _convertirNumero

    POP {LR}
    POP {R11}
    MSR CPSR,r11
    bx LR

Suma:
    //Se almacena CPSR en stack porque se necesita en el programa principal.
    mrs r11,CPSR
    PUSH {r11}
    PUSH {LR}

    //Se almacena el valor por operar.
    bl solicitudValoresNumericos

    //Se verifica si el valor ascii no es un numero. En caso no sea, se levanta una bandera.
    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finSuma

    //Se suma el valor ingresado y el valor almacenado previo.
    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _suma

    //Se guarda el valor operado y se imprime.
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

     //Se almacena el valor por operar.
    bl solicitudValoresNumericos

    //Se verifica si el valor ascii no es un numero. En caso no sea, se levanta una bandera.
    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finMultiplacion

    //Se multiplica el valor ingresado y el valor almacenado previo.
    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _multiplicacion

    //Se guarda el valor operado y se imprime.
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

    //Se almacena el valor por operar.
    bl solicitudValoresNumericos

    //Se verifica si el valor ascii no es un numero. En caso no sea, se levanta una bandera.
    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finModulo

     //Se encuentra el modulo del valor ingresado y el valor almacenado previo.
    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _modulo

    //Se guarda el valor operado y se imprime.
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

    //Se almacena el valor por operar.
    bl solicitudValoresNumericos

    //Se verifica si el valor ascii no es un numero. En caso no sea, se levanta una bandera.
    ldr r0, =flagM
    ldrb r0, [r0]
    mov r1, #'a'
    cmp r1, r0
    ldreq r1, =msgerror
    bleq _print
    beq finPotencia

    //Se encuentra del valor actual con el valor ingresado como exponente.
    ldr r0,=actual
    ldr r0,[r0]
    ldr r1,=strNumVal
    ldr r1,[r1]
    ldr r2,=actual
    bl _potencia

    //Se guarda el valor operado y se imprime.
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
    //Se imprime el valor actual.
    PUSH {LR}
    ldr r1,=actual
    ldr r1,[r1]
    ldr r0,=format
    bl printf
    POP {LR}
    bx LR
