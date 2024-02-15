.data
	nama: .space 11
	input_nama: .asciiz "Siapa nama Anda? "
	input_semester: .asciiz "\nSemester berapakah Anda? "
	output1: .asciiz "Halo mahasiswa dengan nama "
	output2: .asciiz ". Semoga Anda dapat menjalani semester ke-"
	output3: .asciiz " di Fasilkom dengan baik!"

.text
.globl main
main:
    	# Minta input nama
    	li $v0, 4
    	la $a0, input_nama
    	syscall

    	# Baca input nama
    	li $v0, 8
    	li $a1, 11
    	la $a0, nama
    	syscall

    	# Minta input semester
    	li $v0, 4
    	la $a0, input_semester
    	syscall

    	# Baca input semester
    	li $v0, 5
    	syscall
    	move $t0, $v0
    	
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

    	# Cetak semester
    	li $v0, 1
    	move $a0, $t0
    	syscall

    	# Cetak output3
    	li $v0, 4
    	la $a0, output3
    	syscall

	# Exit
	li $v0, 10
	syscall