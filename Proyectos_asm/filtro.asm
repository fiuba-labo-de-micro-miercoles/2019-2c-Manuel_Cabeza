;Programar en Assembly una rutina (FILTRO) que calcula la respuesta del siguiente filtro
;de 1er orden:
;S(k+1) = (1/4)*E(k) + (3/4)*S(k),
;donde E(k), S(k) y S(k+1) son variables de 8 bits alojadas en RAM.
;Sugerencia: Se supone que la rutina lee los valores E y S (en el tiempo k) calcula la
;nueva salida S(k+1) y pisa el viejo valor en RAM de S(k).

.include "m328def.inc"

.EQU CI = 0
.EQU LONG_FIL = 6	; no! E(k), S(k) y S(k+1) son variables de 8 bits alojadas en RAM, es decir, 1 byte (no 6)

.DSEG
	S: .BYTE LONG_FIL
	E: .BYTE LONG_FIL

.CSEG 
	RJMP MAIN

.ORG	INT_VECTORS_SIZE	; Saltear los vectores de interrupción
MAIN:	
	LDI XL, LOW(S)
	LDI XH, HIGH(S)
	LDI YL, LOW(E)
	LDI YH, HIGH(E)
	LDI R20, LONG_FIL
	CALL FILTRO
	
; acá faltaría un while(1);


FILTRO:
	LD R16, X	; S
	LD R17, Y+	; E
	LDI R18, 3

	ASR R16
	ASR R16		; S/4
	ASR R17
	ASR R17		; E/4
	MULS R17, R18	; error! este micro no tiene MULS, sólo MUL
	MOV R17, R0	; se puede mejorar el error de la operación si primero se multiplica x 3 y luego se shiftean r1 y r0 2 veces
	ADD R16, R17
	
	ST X+, R16 

	DEC R20		; no va
	CPI R20, 0	; no va
	BRNE FILTRO	; no va
	RET
