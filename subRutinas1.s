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
  SWI 0
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
  valor1 .req r0
  valor2 .req r1
  respuesta .req r2
  add valor1,valor2,valor1
  str valor1,[respuesta]
  .unreq valor1
  .unreq valor2
  .unreq respuesta
  BX LR

/* 
.global _multiplicacion
_multiplicacion:
  valor1 .req r0
  valor2 .req r1
  respuesta .req r2
  sub r2,r0,r1
  .unreq valor1
  .unreq valor2
  .unreq respuesta
  BX LR*/
