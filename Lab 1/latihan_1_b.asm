.data
    # Define variabel
    input1: .asciiz "Banyak name tag: "
    input2: .asciiz "Name Tag "
    input3: .asciiz ": \n"
    input4: .asciiz "Daftar bentuk name tag:\n[1] Persegi Panjang \n[2] Segitiga\nPilih bentuk name tag: "
    input5: .asciiz "Masukkan alas: "
    input6: .asciiz "Masukkan tinggi: "
    divider: .asciiz "--------------------\n"
    output1: .asciiz "Total biaya untuk memproduksi name tag tersebut yaitu Rp"
    output2: .asciiz "\nHore! Name tag dapat dibayar dengan kepingan Rp70 :D"
    output3: .asciiz "\nYah! Name tag tidak dapat dibayar dengan kepingan Rp70 :("

.text
.globl main
main:
    # Print input banyak name tag
    li $v0, 4
    la $a0, input1
    syscall
    # Membaca dan menyimpan input banyak name tag
    li $v0, 5
    syscall
    move $t0, $v0
    # Print divider
    li $v0, 4
    la $a0, divider
    syscall

    # Define counter untuk looping banyak name tag
    li $t1, 0
    # Define nilai harga per cm^2 dan pengali harga (100)
    li $t7, 100
    li $t2, 0
    # Define integer 2 untuk segitiga
    li $t9, 2

# Looping untuk memproses input name tag
LoopNameTag:
    # Print input name tag
    li $v0, 4
    la $a0, input2
    syscall
    # Menambahkan 1 ke counter name tag
    addi $t1, $t1, 1
    # Print index name tag
    move $a0, $t1
    li $v0, 1
    syscall
    # Print new line
    li $v0, 4
    la $a0, input3
    syscall
    # Print pilihan bentuk name tag)
    li $v0, 4
    la $a0, input4
    syscall
    # Membaca dan menyimpan input pilihan bentuk name tag
    li $v0, 5
    syscall
    move $t3, $v0
    # Print input masukkan alas
    li $v0, 4
    la $a0, input5
    syscall
    # Membaca dan menyimpan input alas
    li $v0, 5
    syscall
    move $t4, $v0
    # Print input masukkan tinggi
    li $v0, 4
    la $a0, input6
    syscall
    # Membaca dan menyimpan input tinggi
    li $v0, 5
    syscall
    move $t5, $v0

    # Conditional bentuk name tag
    beq $t3, 1, PersegiPanjang
    beq $t3, 2, Segitiga

PersegiPanjang:
    # Menghitung luas persegi panjang menggunakan mult
    mult $t4, $t5
    mflo $t6
    # Menghitung harga persegi panjang
    mult $t6, $t7
    mflo $t8
    # Menambahkan harga persegi panjang ke total harga
    add $t2, $t2, $t8
    # Lompat ke CekLoop
    j CekLoop

Segitiga:
    # Menghitung luas segitiga menggunakan mult
    mult $t4, $t5
    mflo $t6
    div $t6, $t9
    mflo $t6
    # Menghitung harga segitiga
    mult $t6, $t7
    mflo $t8
    # Menambahkan harga segitiga ke total harga
    add $t2, $t2, $t8

CekLoop:
    # Print divider
    li $v0, 4
    la $a0, divider
    syscall
    # Cek apakah sudah selesai memproses semua name tag
    bne $t1, $t0, LoopNameTag
    # Lompat ke FinalOutput
    j FinalOutput

FinalOutput:
    # Print output
    li $v0, 4
    la $a0, output1
    syscall
    # Print total harga
    move $a0, $t2
    li $v0, 1
    syscall

    # Cek apakah total harga bisa dibagi dengan 70
    li $t0, 70
    div $t2, $t0
    mfhi $t1
    # Jika sisa bagi bukan 0, lompat ke NotDivisible
    bne $t1, $zero, NotDivisible

    # Print output divisible
    li $v0, 4
    la $a0, output2
    syscall
    j Exit

NotDivisible:
    # Print output not divisible
    li $v0, 4
    la $a0, output3
    syscall

Exit:
    # Exit program
    li $v0, 10
    syscall
