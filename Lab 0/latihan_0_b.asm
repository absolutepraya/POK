.data
    nama: .space 11
    input_nama: .asciiz "Siapa nama Anda? "
    input_angkatan: .asciiz "\nTahun angkatan Anda? "
    input_semester: .asciiz "Semester berapakah Anda? "
    output1: .asciiz "Halo mahasiswa dengan nama "
    output2: .asciiz " dari angkatan "
    output3: .asciiz ". Semoga Anda dapat menjalani semester ke-"
    output4: .asciiz " di Fasilkom dengan baik!"
    
    # Nama angkatan
    chronos: .asciiz "Chronos"
    bakung: .asciiz "Bakung"
    apollo: .asciiz "Apollo"
    gaung: .asciiz "Gaung"

.text
.globl main
main:
    # Minta input nama
    li $v0, 4
    la $a0, input_nama
    syscall
    
    # Baca input nama
    li $v0, 8
    la $a0, nama
    li $a1, 11
    syscall
    
    # Minta input angkatan
    li $v0, 4
    la $a0, input_angkatan
    syscall
    
    # Baca input angkatan
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Minta input semester
    li $v0, 4
    la $a0, input_semester
    syscall
    
    # Baca input semester
    li $v0, 5
    syscall
    move $t1, $v0
    
    # ———————————————————————————————————
    
    # Cetak output1
    li $v0, 4
    la $a0, output1
    syscall
    
    # Cetak nama
    li $v0, 4
    la $a0, nama
    syscall
    
    # Cetak output2
    li $v0, 4
    la $a0, output2
    syscall
    
    # Cetak angkatan
    li $t2, 2020
    beq $t0, $t2, print_chronos
    li $t2, 2021
    beq $t0, $t2, print_bakung
    li $t2, 2022
    beq $t0, $t2, print_apollo
    li $t2, 2023
    beq $t0, $t2, print_gaung

print_chronos:
    li $v0, 4
    la $a0, chronos
    syscall
    j continue

print_bakung:
    li $v0, 4
    la $a0, bakung
    syscall
    j continue

print_apollo:
    li $v0, 4
    la $a0, apollo
    syscall
    j continue

print_gaung:
    li $v0, 4
    la $a0, gaung
    syscall
    j continue

continue:
    # Cetak output3
    li $v0, 4
    la $a0, output3
    syscall
    
    # Cetak semester
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Cetak output4
    li $v0, 4
    la $a0, output4
    syscall

    # Exit
    li $v0, 10
    syscall