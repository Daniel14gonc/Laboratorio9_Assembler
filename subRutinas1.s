/*
 * Autores: Daniel Gonzalez 20293, Juan Carlos Bajan 20109
 * Modificacion: 14/05/2021
 * Descripcion: Subrutinas que permiten la conversion de un numero ascii a decimal y 
 *              concatenacion de dos strings.
 */


.data
.align 2
strLen4print: .word 0
bandera: .word -1


.text
.align 2

.global _keybread
_keybread:
@ Lee el caracter
  MOV R1,R0     @copia el parametro del puntero a la cadena
  MOV R7, #3		@3=llamado a "read" swi
  MOV R0, #0
  mov r2, #27		@0=stdin (teclado)
  //ldr r2, [r8]		@longitud de la cadena: 10 caracteres + enter
  SWI 0
  BX LR

.global _print
_print:
  PUSH {LR}     @ copy of LR because I will call _strlen here
  LDR R8,=strLen4print
  BL _strlen
  LDR R2,[R8]
  MOV R7, #4		@4=llamado a "write" swi
  MOV R0, #1		@1=stdout (monitor)
  SWI 0
  POP {LR}
  BX LR /*-- _print --*/


.global _strlen
_strlen:
  MOV R0,R1
  length .req R5
  MOV length,#0
countchars:
  LDRB R4,[R0],#1
  CMP R4,#'\n'      @CR to check end of line
  BEQ endOfLine
  ADD length,#1
  B countchars
endOfLine:
  ADD length,#1
  STR length,[R8]
  .unreq length
  //SWI 0
  BX LR /*-- _strlen --*/

.global _char2Num
_char2Num:
  mrs r11,CPSR
  charPointer .req R0
  valPointer .req R1
  LDRB R0,[charPointer]
  CMP R0,#0x30      @ Is the hex ascii value between 0
  CMPGE R0,#0x39    @ or 9
  SUBLE R0,#0x30    @ subtract 0x30 only if it's a digit
  MVNGT R0, #1
  STRGT R0, [valPointer]

  STRLE R0,[valPointer] @ store value only if it's a digit
  .unreq charPointer
  .unreq valPointer
  //SWI 0
  MSR CPSR,r11
  BX LR


/*

-------------------------------------         SUMA          -----------------------------------------

La Siguiente Subrutina realiza el proceso de adicion recibiendo en los registros r1 y r2 los
dos valores que se sumaran y en r2 la direccion del registro .word a donde sera almacenado el
resultado.

Se realizo de forma generica, no realiza ninguna traduccion o verificacion de los valores recibidos
para que se pueda utilizar en cualquier contexto.

-----------------------------------------------------------------------------------------------------

 */

.global _suma
_suma:
  valor1s .req r0   //R0 recibe "actual"
  valor2s .req r1   //R1 recibe el valor ingresado por el usuario
  respuestas .req r2  //r2 recibe el registro en donde se almacenara la respuesta 
  add valor1s,valor2s   //se suma r1 y r0
  str valor1s,[respuestas]  // se almacena la respuesta en r2
  .unreq valor1s
  .unreq valor2s
  .unreq respuestas
  BX LR



/*

---------------------------------         Multiplicacion          -----------------------------------

La Siguiente Subrutina realiza el proceso de multiplicacion recibiendo en los registros r1 y r2 los
dos valores que se multiplicaran y en r2 la direccion del registro .word a donde sera almacenado el
resultado.

Se realizo de forma generica, no realiza ninguna traduccion o verificacion de los valores recibidos
para que se pueda utilizar en cualquier contexto. Por ejemplo, este se utiliza en la subrutina de
potencia.

-----------------------------------------------------------------------------------------------------

 */
.global _multiplicacion
_multiplicacion:
  mrs r11,CPSR  // Para que los cambios en el CPSR en esta subrutina no afecten al main,
                //  se almacena el valor proveniente del main a r11 para posteriormente
                //  retornarlo a su valor inicial y no afectar los procesos del archivo principal.
  valor1 .req r0  // R0 recibe el valor que se multiplicara
  valor2 .req r1  // R1 reicbe el valor que multiplicara a R0
  respuesta .req r2 // R2 recibe el valor en donde se almacenara la respuesta
  pivote .req r5  // Como, la multiplicacion es un valor n cantidad de veces sumado con 
                  //si mismo, inicialmente se almacena una copia de r0 en r5 para que
                  //ese primer valor no se pierda.
  contador .req R4  //Este registro indica si se realiza o no el loop de nuevo. Cuando este
                    //contador sea igual a r2, el loop finaliza.
  mov pivote,valor1 //se guarda una copia de r0 en r5
  mov contador,#1 //El contador debe iniciar en 1
  loop:
    add valor1,pivote //Se le suma a r0, su valor inicial (pivote)
    add contador,#1 // Se incrementa el contador
    cmp contador,valor2 //Si el contador es igual a r1 entonces finaliza el loop
    blt loop
  str valor1,[respuesta]  //Se almacena la respuesta en r0
  .unreq valor1
  .unreq valor2
  .unreq respuesta
  .unreq pivote
  .unreq contador
  MSR CPSR,r11
  BX LR

/*

-------------------------------------         Modulo          ---------------------------------------

La Siguiente Subrutina realiza el proceso de modulo recibiendo en los registros r1 y r2 los
dos valores que se operaran y en r2 la direccion del registro .word a donde sera almacenado el
resultado.

Se realizo de forma generica, no realiza ninguna traduccion o verificacion de los valores recibidos
para que se pueda utilizar en cualquier contexto.

-----------------------------------------------------------------------------------------------------

 */
.global _modulo
_modulo:
  mrs r11,CPSR// Para que los cambios en el CPSR en esta subrutina no afecten al main,
              //  se almacena el valor proveniente del main a r11 para posteriormente
              //  retornarlo a su valor inicial y no afectar los procesos del archivo principal.
  valor1m .req r0 //R0 recibe el dividendo
  valor2m .req r1 //R1 recibe el divisor
  respuestam .req r2  //R2 recibe el valor en donde se almacenara la respuesta
  loop1:
    sub valor1m,valor1m,valor2m //Se le resta al dividendo el divisor
    cmp valor1m,valor2m //Se verifica si el dividendo es mayor o igual que el divisor
    bge loop1 //En caso que si sea mayor o igual, se realiza de nuevo el loop
  str valor1m,[respuestam]  // Se almacena r0 en r2
  .unreq valor1m
  .unreq valor2m
  .unreq respuestam
  MSR CPSR,r11
  BX LR


/*

-------------------------------------         Modulo          ---------------------------------------

La Siguiente Subrutina realiza el proceso de potencia recibiendo en los registros r1 y r2 los
dos valores que se operaran y en r2 la direccion del registro .word a donde sera almacenado el
resultado.

Se realizo de forma generica, no realiza ninguna traduccion o verificacion de los valores recibidos
para que se pueda utilizar en cualquier contexto. Utiliza la subrutina multiplicacion para operar
los valores.

-----------------------------------------------------------------------------------------------------

 */
.global _potencia
_potencia:
  PUSH {LR} // Como dentro de esta subrutina se llama otra subrutina, se debe hacer un PUSH y POP del LR en el stack.
  valor1a .req r0 // R0 recibe el valor que se elevara a la potencia
  exponente .req r9 // R9 recibe la potencia
  respuestaa .req R2  //R2 recibe el valor donde se almacenara la respuesta
  contadora .req R8 // R8 es un contador para verificar si se ha realizado el proces
                    // la cantidad de veces necesarias
  mov exponente,r1  // Se realiza una copia de r1 en r9 para no estropear el proceso de la subrutina multiplicacion
  mov contadora,#1  // El contador inicia en 1
  mov r1,valor1a  // Como la subrutina multiplicacion recibe uno de sus factores en r1 y al elevar la potencia se esta 
                  // multiplicando un factor por si mismo, se copia r0 en r1 para completar este proceso
  loop2:
    bl _multiplicacion  // Se llama a la subrutina multiplicacion
    add contadora,#1  // Se incrementa el contador
    cmp contadora,exponente // Se compara el contador con el exponente ya que el exponente dice la cantidad de veces que
                            // Se repetira el proceso
    blt loop2 // En caso sea menor, se vuelve a realizar en proceso
  str valor1a,[respuestaa]  // Se almacena la respuesta en r2
  .unreq respuestaa
  .unreq contadora
  .unreq valor1a
  POP {LR}
  BX LR

