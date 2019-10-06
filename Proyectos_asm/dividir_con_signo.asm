.include "m328pdef.inc"
; Realizar una division de dos registros con signo.

.DEF DIVISOR = R16
.DEF DIVIDENDO = R17
.DEF RESTO = R18
.DEF COCIENTE = R19
.DEF signo = R21  ; Tiene el signo de DIVIDENDO Y DIVISOR EN b1-b0

.EQU bit_signo_dividendo = 1
.EQU bit_signo_divisor = 0

.CSEG
	RJMP MAIN
.ORG INT_VECTORS_SIZE

MAIN:
	; Ejemplo numerico
	LDI DIVISOR, -4
	LDI DIVIDENDO, -10

	CALL DIV

FIN: RJMP FIN

DIV:
	; Pongo dividendo y divisor como positivos, guardo sus signos en "signo"
	CLR signo
	SBRC DIVIDENDO, 7
	CALL CONV_POSITIVO_DIVIDENDO
	SBRC DIVISOR, 7
	CALL CONV_POSITIVO_DIVISOR
	
	CALL LOOP
	; Devuelvo el signo al resto y cociente
	CALL SIGNO_RESTO
	CALL SIGNO_COCIENTE
RET

; Logica para la division
LOOP:
	INC COCIENTE
	SUB DIVIDENDO, DIVISOR
	BRGE LOOP
	DEC COCIENTE
	ADD DIVIDENDO, DIVISOR
	MOV RESTO, DIVIDENDO 
RET

; Convierte el dividendo a postivo y pone "signo" bit_signo_dividendo en 1
CONV_POSITIVO_DIVIDENDO:
	COM DIVIDENDO
	INC DIVIDENDO
	ORI signo, (1<<bit_signo_dividendo)
RET

; Convierte el divisor a postivo y pone "signo" bit_signo_divisor en 1
CONV_POSITIVO_DIVISOR:
	COM DIVISOR
	INC DIVISOR
	ORI signo, (1<<bit_signo_divisor)
RET

; Cambia el signo del resto si el dividendo es negativo
SIGNO_RESTO:
	SBRC signo, bit_signo_dividendo
	COM RESTO
RET

; Cambia el signo del cociente si el dividendo o el divisor son negativos
SIGNO_COCIENTE:
	CPI signo, 0b00000000
	BREQ VOLVER
	CPI signo, 0b00000011
	BREQ VOLVER
	COM COCIENTE
	
VOLVER:	RET	
