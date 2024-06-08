; Meng-include header dari ATmega8515
.include "m8515def.inc"

; Membuat register yang akan digunakan menggunakan .def
.def result = R1
.def result_dummy = R16
.def i = R18
.def N = R19
.def temp = R20

DATA:
    .db 7   ; Angka yang akan dicek apakah prima atau bukan 

Main:                       ; Program utama
    ldi ZL, LOW(DATA*2)     ; Load low dari DATA ke ZL
    ldi ZH, HIGH(DATA*2)    ; Load high dari DATA ke ZH, sekarang Z = DATA
    lpm R0, Z               ; Load data dari Z ke R0
    mov N, R0               ; Move the value from R0 to N
    ldi result_dummy, 0     ; Load immediate 0 ke result
    ldi i, 2                ; Load immediate 2 ke i

Loop:                       ; Outer loop untuk mengiterasi i
    cp i, N                 ; Compare i dengan N
    breq IsPrime            ; "Branch Equals", jika i = N, maka ke IsPrime
    mov temp, N             ; Memindahkan N ke temp

SubtractLoop:               ; Inner loop untuk melakukan division secara manual
    sub temp, i             ; Kurangi temp dengan i
    brmi IsPrime            ; "Branch if Minus", jika hasil kurangnya negatif, maka ke IsPrime
    tst temp                ; Test temp
    breq NotPrime           ; "Branch Equals", jika temp = 0, maka ke NotPrime
    rjmp SubtractLoop       ; Return ke SubtractLoop untuk pengurangan berikutnya

    inc i                   ; Increment i
    rjmp Loop               ; Return ke Loop

IsPrime:                    ; Label jika bilangannya adalah prima
    ldi result_dummy, 1     ; Load immediate 1 ke result
	mov result, result_dummy; Memindahkan ke R1
    rjmp End                ; Return ke End

NotPrime:					; Label jika bilangannya bukan prima
	ldi result_dummy, 0		; Load immediate 0 ke result (untuk memastikan)
	mov result, result_dummy; Memindahkan ke R1
	rjmp End				; Return ke End

End:                        ; Label untuk mengakhiri program
	rjmp End				; Infinite loop
