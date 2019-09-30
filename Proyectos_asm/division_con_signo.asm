;
; Incluir el enunciado del problema para evitar interpretaciones incorrectas del código
;

.include "m328pdef.inc"

.DEF DIVIDENDO = R16
.DEF DIVISOR = R17
.DEF COCIENTE = R18
.DEF RESTO = R19

; Ejemplo numérico: 100 / 3 = 33 + 1/3
.EQU NUMERADOR = 0x64
.EQU DENOMINADOR = 0x03

.MACRO SIGNO
	SBRS @0, 7
	RJMP FIN
	NEG @0 
	INC R20
;FIN: NOP
FIN:	; no es necesario el NOP anterior
.ENDMACRO

.CSEG 
	RJMP MAIN

.ORG INT_VECTORS_SIZE
MAIN:
	LDI DIVIDENDO, NUMERADOR
	LDI DIVISOR, DENOMINADOR
	CLR COCIENTE
	CLR RESTO
	RCALL DIVIDIR

TERMINO: RJMP TERMINO

DIVIDIR: 
	CPI DIVISOR, 0
	BREQ DIVISOR_NULO
; falta inicializar R20 (en cero?)
	SIGNO DIVIDENDO
;	MOV R21, R20	; línea de más
	SIGNO DIVISOR 

OPERACION:
	INC COCIENTE
	SUB DIVIDENDO, DIVISOR
	BRCC OPERACION
	DEC COCIENTE
	ADD DIVIDENDO, DIVISOR
	MOV RESTO, DIVIDENDO

	CLT
	SBRS R20,0	; un comentario please!! 
	rjmp FIN_OPERACION
			; si R20 es impar, Numerado y denominador tienen distintos signos
	NEG COCIENTE	; como la operación se hizo sin signo, se complementa a 2
	; SBRC R21, 0	; línea innecesaria
	NEG RESTO
	; CLT
	; RET
	rjmp FIN_OPERACION
	
DIVISOR_NULO:
	SET
FIN_OPERACION:	
	RET
