.include "m328pdef.inc"

.EQU LONG_VEC = 6

.DSEG 
	
	VEC1: .BYTE LONG_VEC
	VEC2: .BYTE LONG_VEC

.CSEG 
	
	RJMP MAIN

MAIN: 
	LDI XL, LOW(VEC1)
	LDI XH, HIGH(VEC1)
	
	LDI YL, LOW(VEC2)
	LDI YH, HIGH(VEC2)
	
	LDI R20, LONG_VEC
	CALL ORDENAR
	
FIN: RJMP FIN

ORDENAR: 
	LD R17, X+
	ST Y+, R17
	DEC R20
	;CPI R20, 0		; línea comentada
	;BREQ INICIALIZAR	; línea comentada
	;RJMP ORDENAR		; línea comentada
	brne	ORDENAR		; es más simple

INICIALIZAR:
	LDI YL, LOW(VEC2)
	LDI YH, HIGH(VEC2)
	LDI R20, LONG_VEC
	
BURBUJEO:
	LD R17, Y+
	LD R18, Y
	
	DEC R20
	;CPI R20, 0	; de más, DEC te deja el flag Z calculado
	BREQ VOLVER

	CP R18, R17
	BRSH BURBUJEO
	
	; MOV R21, R17
	; MOV R17, R18
	; MOV R18, R21
	;ST Y , R18
	;ST -Y , R17
	
	st	Y, r17	; estas 2 líneas reemplazan a las 5 anteriores
	st 	-Y, r18
	RJMP BURBUJEO


VOLVER:   ; Si esta todo ordenado RET,sino INICIALIAR
	LDI YL, LOW(VEC2)
	LDI YH, HIGH(VEC2)
	LDI R20, LONG_VEC

VERIFICAR:
	
	LD R17, Y+
	LD R18, Y
	
	CP R18, R17
	BRLO INICIALIZAR

	DEC R20
	; CPI R20, 0
	; BREQ TERMINAR
	; RJMP VERIFICAR
	brne	VERIFICAR	; reemplaza a las 3 líneas anteriores

TERMINAR: 
	RET
