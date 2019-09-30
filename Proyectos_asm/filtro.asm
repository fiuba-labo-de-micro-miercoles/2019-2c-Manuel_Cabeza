;Programar en Assembly una rutina (FILTRO) que calcula la respuesta del siguiente filtro
;de 1er orden:
;S(k+1) = (1/4)*E(k) + (3/4)*S(k),
;donde E(k), S(k) y S(k+1) son variables de 8 bits alojadas en RAM.
;Sugerencia: Se supone que la rutina lee los valores E y S (en el tiempo k) calcula la
;nueva salida S(k+1) y pisa el viejo valor en RAM de S(k).

.include "m328def.inc"

.EQU CI = 0
.EQU LONG_FIL = 6

.DSEG
	S: .BYTE LONG_FIL
	E: .BYTE LONG_FIL

.CSEG 
	RJMP MAIN

MAIN:	
	LDI XL, LOW(S)
	LDI XH, HIGH(S)
	LDI YL, LOW(E)
	LDI YH, HIGH(E)
	LDI R20, LONG_FIL
	CALL FILTRO


FILTRO:
	LD R16, X
	LD R17, Y+
	LDI R18, 3

	ASR R16
	ASR R16
	ASR R17
	ASR R17
	MULS R17, R18
	MOV R17, R0
	ADD R16, R17
	
	ST X+, R16 
	
	DEC R20
	CPI R20, 0
	BRNE FILTRO
RET

	
