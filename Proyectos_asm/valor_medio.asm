.include "m328pdef.inc"
; Promedia 8 numeros y guarda el resultado en R17

.DSEG
	V: .BYTE 8
	M: .BYTE 1

.CSEG
	RJMP MAIN

.ORG INT_VECTORS_SIZE

MAIN:
	LDI XH, HIGH(V)
	LDI XL, LOW(V) 
	LDI R16, 8
	LDI R17, 0
	CALL PROMEDIO
	RJMP FIN

PROMEDIO: 
	LD R19, X+	
; 1ero hay que determinar si R19 es negativo o no
; luego se suma ajustando el byte alto.

	ADD R17, R19	; esto en general modifica el carry (y hay que sumarlo el byte alto luego)
	CPI R19, 0	; esto vuelve a modificr el carry (en general) con lo cual perdiste el estado del carry anterior
	BRLT SUMA_NEG
	CLR R20
	ADC R18, R20
	DEC R16	
	BRNE PROMEDIO
	CALL DIV_8
RET

SUMA_NEG:
	SER R20
	ADC R18, R20
	DEC R16	
	BRNE PROMEDIO

DIV_8: 
	ASR R17
	ROR R18
	ASR R17
	ROR R18
	ASR R17
	ROR R18
RET

FIN: RJMP FIN
