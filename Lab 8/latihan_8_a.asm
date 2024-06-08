;====================================================================
; Processor  : ATmega8515
; Compiler  : AVRASM
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

.include "m8515def.inc"

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

.org $00 ; JUMP to MAIN to initialze
rjmp MAIN
.org $01 ; When Reset Button pressed, jump to BUTTON_PRESS1
rjmp BUTTON_PRESS1
.org $02 ; When Change Speed Button pressed, jump to BUTTON_PRESS2
rjmp BUTTON_PRESS2
.org $06 ; When Timer0 overflows, jump to OVERFLOW
rjmp OVERFLOW

; For determining LED cycle
.def CYCLE = r17

; For toggling speed and modes
.def TOGGLE_S = r18
.def TOGGLE_M = r19
.def TOGGLE = r20
.def LED_COUNTER = r21

;====================================================================
; CODE SEGMENT
;====================================================================

; Initialize stack pointer
MAIN:
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16

    ldi TOGGLE_S, (1<<CS00)
    ldi TOGGLE_M, 1
    clr LED_COUNTER ; Initialize LED counter to 0

; Initialize Interrupt on INT0
INIT_INTERRUPT:
    ;Falling edge trigger
    ldi r16, 0b00001010
    out MCUCR, r16
    
    ;INT0 enable
    ldi r16, 0b11000000
    out GICR, r16

; Setup LED PORT
INIT_LED:
    ser r16   ; Load $FF to temp  
    out DDRB, r16 ; Set PORTB to output 

; Setup Overflow Timer0
INIT_TIMER:
    ; Timer speed = clock/256 (set CS02 in TCCR1B) overflow about once every second on 4MHz
    ldi r16, (1<<CS01)
    out TCCR1B, r16

    ; Execute an internal interrupt when Timer1 overflows
    ldi r16, (1<<TOV1)
    out TIFR, r16

    ; Set Timer1 overflow as the timer
    ldi r16, (1<<TOIE1)
    out TIMSK, r16

    ; Set global interrupt flag
    sei

; While waiting for interrupt, loop infinitely
FOREVER:

    rjmp FOREVER

; Program executed on button press
BUTTON_PRESS1:
    push r16
    in r16, SREG
    push r16

    clr LED_COUNTER ; Reset LED counter
    out PORTB, r16 ; Turn off all LEDs

    pop r16
    out SREG, r16
    pop r16

    reti

; Program executed on button press
BUTTON_PRESS2:
    push r16
    in r16, SREG
    push r16

    ; Toggle timer speed between clock/64 and clock/256
    in r16, TCCR1B
    cpi r16, (1<<CS01) ; Check if current speed is clock/64
    breq FASTER
    ldi r16, (1<<CS01) ; If not, set speed to clock/64
    rjmp DONE

FASTER:
    ldi r16, (1<<CS00) ; If current speed is clock/64, set speed to clock/256

DONE:
    out TCCR1B, r16 ; Update timer speed

    pop r16
    out SREG, r16
    pop r16

    reti

; Program executed on timer overflow
OVERFLOW:
    push r16
    in r16, SREG
    push r16

    rcall CHANGE_STATE
    out PORTB, r16
    
    pop r16
    out SREG, r16
    pop r16

    reti

; Change LED state
CHANGE_STATE:
    mov r16, LED_COUNTER ; Copy LED counter to r16
    inc LED_COUNTER ; Increment LED counter
    ret
