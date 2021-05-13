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
