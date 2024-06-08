.include "m8515def.inc"

; Declare variables
.def tempi = r2
.def aN = r3
.def aNN = r4
.def result = r19
.def tempN = r6
.def n = r16
.def rthree = r17
.def counter = r18
.def rtwo = r20
.def tempx = r5

ldi YL, low(RAMEND)
out SPL, YL
ldi YH, high(RAMEND)
out SPH, YH

ldi XH, $00         			; Set X ke awal array
ldi XL, $90

ldi n, 5         				; Load value awal
ldi rthree, 3
ldi rtwo, 2
ldi counter, 0        			; Mulai counter P(0)

; Input
DATA:
	.db 4

; Load nilai 
main:
	ldi ZL, LOW(DATA*2)
	lpm n, Z			

; Loop utama program
loop:
	mov tempN, n
	mov n, counter          	; Pindah counter ke n
	rcall pekSec           		; Call P(n)
	mov n, tempN

	st X+, result        		; Save ke memory
	cp counter, n
	breq forever
	inc counter
	rjmp loop

; Hentikan program
forever:
	rjmp forever

ekSec:
	push n          			; Push ke stack
	push aN
	push aNN
	push tempi
	push tempx

	cpi n, 0
	breq zero
    cpi n, 1
    breq one

; Recursive case
recCase:
    dec n
    mov aN, n
    dec n
    mov aNN, n

    mov n, aN         			; Masukkan P(n-1)
    rcall pekSec
    mov tempi, result
    mul tempi, rtwo 
    mov tempx, r0     			; Kali dengan 2

    mov n, aNN         			; Masukkan P(n-2)
    rcall pekSec
    mul result, rthree       	; Kali dengan 3
    mov result, r0
    add result, tempx       	; Jumlahkan

    rjmp done

zero:           				; Base case P(0)
    ldi result, 1
    rjmp done

one:           					; Base case P(1)
    ldi result, 2
    rjmp done

done:
    pop tempx
    pop tempi         			; Pop dari stack
    pop aNN
    pop aN
    pop n
    ret
