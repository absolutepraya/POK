; Meng-include header dari ATmega8515
.include "m8515def.inc"

; Membuat register yang akan digunakan menggunakan .def
.def result  = R1
.def value1  = R18
.def value2  = R19
.def temp    = R24

MY_DATA:    ; Data yang akan diolah
.db 32, 5   ; Men-define byte pertama (high) dengan 32 dan byte kedua (low) dengan 5

Main:                       ; Program utama
	ldi ZL, LOW(MY_DATA*2)  ; Load immediate ZL dengan low dari alamat MY_DATA dikalikan 2, karena program memory adalah word-addressed, maka alamat data dikalikan 2
	ldi ZH, HIGH(MY_DATA*2) ; Load immediate ZH dengan high dari alamat MY_DATA dikalikan 2, karena program memory adalah word-addressed, maka alamat data dikalikan 2
	lpm value1, Z+          ; Load program memory ke register value1, setelah itu Z di-increment 1
	lpm value2, Z           ; Load program memory ke register value2

Loop:                       ; Looping untuk menghitung selisih value1 dan value2
	cp value1, value2       ; Compare value1 dan value2
	brlt Stop               ; "Branch If Less Than", jika value1 < value2, maka akan lompat ke Stop
	sub value1, value2      ; Kurangkan value1 dengan value2, hasilnya disimpan di value1
	adiw temp, 1            ; Tambahkan immediate 1 ke temp, temp adalah register spesial (pair register, 1 word), sehingga menggunakan adiw
	rjmp Loop               ; Lompat ke Loop

Stop:                       ; Label stop sebagai akhir dari program
	mov result, temp        ; Pindahkan nilai temp ke result

Forever:                    ; Looping forever
	rjmp Forever            ; Lompat ke Forever, membuat infinite loop

; Nilai akhir dari program disimpan di register result, yaitu 6