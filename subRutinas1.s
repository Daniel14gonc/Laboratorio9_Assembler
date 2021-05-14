.data
.align 2
strLen4print: .word 0


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
  STRLE R0,[valPointer] @ store value only if it's a digit
  .unreq charPointer
  .unreq valPointer
  //SWI 0
  MSR CPSR,r11
  BX LR


.global _suma
_suma:
  valor1s .req r0
  valor2s .req r1
  respuestas .req r2
  add valor1s,valor2s
  str valor1s,[respuestas]
  .unreq valor1s
  .unreq valor2s
  .unreq respuestas
  BX LR

.global _multiplicacion
_multiplicacion:
  mrs r11,CPSR
  valor1 .req r0
  valor2 .req r1
  respuesta .req r2
  pivote .req r5
  contador .req R4
  mov pivote,valor1
  mov contador,#1
  loop:
    add valor1,pivote
    add contador,#1
    cmp contador,valor2
    blt loop
  str valor1,[respuesta]
  .unreq valor1
  .unreq valor2
  .unreq respuesta
  .unreq pivote
  .unreq contador
  MSR CPSR,r11
  BX LR


.global _modulo
_modulo:
  mrs r11,CPSR
  valor1m .req r0
  valor2m .req r1
  respuestam .req r2
  loop1:
    sub valor1m,valor1m,valor2m
    cmp valor1m,valor2m
    bge loop1
  str valor1m,[respuestam]
  .unreq valor1m
  .unreq valor2m
  .unreq respuestam
  MSR CPSR,r11
  BX LR


.global _potencia
_potencia:
  PUSH {LR}
  valor1a .req r0
  exponente .req r9
  respuestaa .req R2
  contadora .req R8
  mov exponente,r1
  mov contadora,#1
  mov r1,valor1a
  loop2:
    bl _multiplicacion
    add contadora,#1
    cmp contadora,exponente
    blt loop2
  str valor1a,[respuestaa]
  .unreq respuestaa
  .unreq contadora
  .unreq valor1a
  POP {LR}
  BX LR

