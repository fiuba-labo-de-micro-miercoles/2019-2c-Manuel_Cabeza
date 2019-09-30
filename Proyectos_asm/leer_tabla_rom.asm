;Programar una rutina que levante una tabla ubicada en ROM (TABLA_ROM) y copie a
;una tabla ubicada en SRAM (TABLA_RAM) solamente los ASCII de números
;(ASCII(‘0’)=30h … ASCII(‘9’)=39h). La Tabla en ROM termina con 0xFF y no tiene
;más de 1000 posiciones.

.include "m328def.inc"

.EQU FIN_TABLA = 0xFF
.EQU MIN_ASCII = 0x30
.EQU MAX_ASCII = 0x40

.DSEG

 TABLA_RAM: .BYTE 1000 ;Guardo 1000 posiciones en mem. (peor caso)

.CSEG
	RJMP MAIN

TABLA_ROM:
		.DW	0x31,0x39,0x49,0xFF,0x21,0x35,0x30

MAIN:
	LDI ZH, HIGH(TABLA_ROM << 1)
	LDI ZL, LOW(TABLA_ROM << 1)
	LDI XH, HIGH(TABLA_RAM)
	LDI XL, LOW(TABLA_RAM)

	CALL LOOP

FIN: RJMP FIN

LOOP: 
	LPM R16, Z+
	
	CPI R16, FIN_TABLA
	BREQ VOLVER
	CPI R16, MAX_ASCII
	BRSH LOOP
	CPI R16, MIN_ASCII
	BRLO LOOP	
	ST X+, R16 
	RJMP LOOP

VOLVER: RET

