;====================================================================
; Processor		: ATmega8515
; Compiler		: AVRASM
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

.include "m8515def.inc"
.def temp = r16 ; temporary register
.def EW = r23 ; for PORTA
.def PB = r24 ; for PORTB
.def A  = r25
.def count = r21

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

.org $00
rjmp MAIN
.org $01
rjmp EXT_INT0
.org $02
rjmp EXT_INT1

;====================================================================
; CODE SEGMENT
;====================================================================

EXT_INT0: ; Button interrupt
	rcall INIT_LCD_MAIN
	reti

EXT_INT1: ; Button interrupt
	rcall INIT_LCD_MAIN_2
	reti

MAIN:

INIT_INTERRUPT: ; Initialize Interrupt on INT0
	ldi temp,0b00001010 ; Set INT0 to trigger on falling edge
	out MCUCR,temp
	ldi temp,0b11000000 ; Enable INT0
	out GICR,temp
	sei

INIT_STACK:
	ldi temp, low(RAMEND)
	ldi temp, high(RAMEND)
	out SPH, temp

rcall INIT_LCD_MAIN

EXIT:
	rjmp EXIT

INPUT_TEXT:
	ldi ZH,high(2*message) ; Load high part of byte address into ZH
	ldi ZL,low(2*message) ; Load low part of byte address into ZL
	ret

INPUT_TEXT_2:
	ldi ZH,high(2*message2) ; Load high part of byte address into ZH
	ldi ZL,low(2*message2) ; Load low part of byte address into ZL
	ret

INIT_LCD_MAIN:
	ser temp
	out DDRA,temp ; Set port A as output
	out DDRB,temp ; Set port B as output

	rcall INIT_LCD
	rcall INPUT_TEXT

WRITE_NPM: ; Write NPM
	lpm ; Load byte from program memory into r0

	cpi count, 10 ; Check if we've reached the end for the first line
	breq PAUSE ; If so, change line

	mov A, r0 ; Put the character onto Port B
	rcall WRITE_TEXT
	inc count
	adiw ZL,1 ; Increase Z registers
	rjmp WRITE_NPM

PAUSE:
	rcall NEWLINE ; Untuk new line
	ldi count, 0

WRITE_HADIR: ; Write hadir
	lpm ; Load byte from program memory into r0

	tst r0 ; Check if we've reached the end of the message
	breq LOOP_LCD ; If so, quit

	mov A, r0 ; Put the character onto Port B
	rcall WRITE_TEXT
	adiw ZL,1 ; Increase Z registers
	rjmp WRITE_HADIR

LOOP_LCD:
	ret

INIT_LCD_MAIN_2:
	ser temp
	out DDRA,temp ; Set port A as output
	out DDRB,temp ; Set port B as output

	rcall INIT_LCD
	rcall INPUT_TEXT_2

WRITE_TANGGAL: ; Write tanggal
	lpm ; Load byte from program memory into r0

	tst r0 ; Check if we've reached the end of the message
	breq LOOP_LCD_2 ; If so, quit

	mov A, r0 ; Put the character onto Port B
	rcall WRITE_TEXT
	adiw ZL,1 ; Increase Z registers
	rjmp WRITE_TANGGAL

LOOP_LCD_2:
	ret

INIT_LCD:
	cbi PORTA,1 ; CLR RS
	ldi PB,0x38 ; MOV DATA,0x38 --> 8bit, 2line, 5x7
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN

	cbi PORTA,1 ; CLR RS
	ldi PB,$0E ; MOV DATA,0x0E --> disp ON, cursor ON, blink OFF
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN

	rcall CLEAR_LCD ; CLEAR LCD

	cbi PORTA,1 ; CLR RS
	ldi PB,$06 ; MOV DATA,0x06 --> increase cursor, display sroll OFF
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	ret

CLEAR_LCD:
	cbi PORTA,1 ; CLR RS
	ldi PB,$01 ; MOV DATA,0x01
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	ret

NEWLINE:
	cbi PORTA,1 ; Instruction
	ldi PB, $C0 ; set DDRAM address to 64 (second line start point)
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	ret

WRITE_TEXT:
	sbi PORTA,1 ; SETB RS
	out PORTB, A
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	ret

;====================================================================
; DATA
;====================================================================

message:
.db "2306245131HADIR", 0

message2:
.db "2024-05-09", 0
