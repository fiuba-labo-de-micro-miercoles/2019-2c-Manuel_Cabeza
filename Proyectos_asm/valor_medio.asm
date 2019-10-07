.include "m328pdef.inc"
; Promedia 8 numeros y guarda el resultado en R20.R21

.DEF temp = R16
.DEF temp_2 = R17

.EQU long_vec = 8

.DSEG
	V: .BYTE long_vec

.CSEG
	RJMP MAIN
.ORG INT_VECTORS_SIZE

MAIN:
	LDI XH, HIGH(V)
	LDI XL, LOW(V)
	
	CALL PROMEDIO
	RJMP FIN

; 1ero hay que determinar si R19 es negativo o no
; luego se suma ajustando el byte alto.
PROMEDIO:
	LDI temp, long_vec	
	CLR R20
	CLR R21
	CALL LOOP
	CALL DIV_8
	RET
	
LOOP:	 
	LD R19, X+
	CPI R19, 0
	BRGE SUMAR_POS
	BRLT SUMAR_NEG

SUMAR_POS:
	CLR temp_2
	ADD R20, R19
	ADC R21, temp_2
	DEC temp
	BRNE LOOP
RET

SUMAR_NEG:
	SER temp_2
	ADD R20, R19
	ADC R21, temp_2		
	DEC temp
	BRNE LOOP
RET

DIV_8: 
	ASR R20
	ROR R21
	ASR R20
	ROR R21
	ASR R20
	ROR R20
RET

FIN: RJMP FIN
