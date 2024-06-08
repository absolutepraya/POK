.data
String1: .asciiz "Kolom Matriks Pertama: "
String2: .asciiz "Baris Matriks Pertama: "
String3: .asciiz "Kolom Matriks Kedua: "
String4: .asciiz "Baris Matriks Kedua: "
String5: .asciiz "Matriks: \n"
String6: .asciiz "Yahh, Matriks memiliki ordo beda D:"
String7: .asciiz "Yeyy Matriks memiliki ordo sama :DD"
barrier: .asciiz "|"
space: .asciiz " "
enter: .asciiz "\n"
nextLine: .asciiz "|\n"
baris1: .word 1,2,3,4
kolom1: .word 2,3,4,5
baris2: .word 3,4,5,6
kolom2: .word 4,5,6,7
matriks1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
matriks2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
.globl main
main:
# Print String
    li $v0, 4
    la $a0, String1
    syscall

# Minta input untuk kolom matriks pertama
    li $v0, 5
    syscall
    move $t1, $v0 

# Print string   
    li $v0, 4
    la $a0, String2
    syscall

# Minta input untuk baris matriks pertama
    li $v0, 5
    syscall
    move $t0, $v0 

# Load address
    la $s0, baris1
    la $s1, kolom1
    la $s4, matriks1

Outerloop:
    lw $t6, 0($s0) 					# Ambil indeks baris 1
    
    # Increment baris1
    addi $t4, $t4, 1 
    addi $s0, $s0, 4
    
    # Restart loop counter  
    la $s1, kolom1
    add $t5, $zero, $zero

Innerloop:
    # Ambil indeks kolom 1
    lw $t7, 0($s1)
    
    # Kalikan dan simpan di matriks 1
    mult $t6, $t7
    mflo $t8
    sw $t8, 0($s4)
    
    # Increment matriks1 
    addi $s4, $s4, 4
    
    # Add loop counter, increment kolom 1
    addi $t5, $t5, 1
    addi $s1, $s1, 4

    bne $t5, $t1, Innerloop 		# Jika loop counter sama dgn panjang kolom 1, lanjut ke Outerloop
    bne $t4, $t0, Outerloop 		# Jika loop counter sama dgn panjang baris 1, lanjut ke langkah berikutnya

    # Print elements matriks1
    li $t4, 0        				# Reset $t4 
    la $s4, matriks1   				# Reload address matriks 1

print_loop:
    li $t5, 0        				# Reset $t5
    li $v0, 4      
    la $a0, barrier    				# Print barrier
    syscall

print_inner_loop:
    lw $t8, 0($s4)   				# Load elemen matriks1
    move $a0, $t8   
    li $v0, 1        				# Print integer
    syscall

    # Print spasi diantara element
    li $v0, 4
    la $a0, space
    syscall

    addi $s4, $s4, 4       			# Lanjut ke elemen berikutnya di matriks1
    addi $t5, $t5, 1       			# Increment counter
    bne $t5, $t1, print_inner_loop  # Cek jika semua kolom sudah di print

    li $v0, 4
    la $a0, nextLine				# Print nextline
    syscall

    addi $t4, $t4, 1       			# Increment row counter
    bne $t4, $t0, print_loop      	# Cek jika semua row telah diprint

second_matrix:
    li $v0, 4
    la $a0, String3
    syscall
    li $v0, 5
    syscall
    move $t3, $v0 					# Simpan kolom untuk matriks kedua
    
    li $v0, 4
    la $a0, String4
    syscall
    li $v0, 5
    syscall
    move $t2, $v0 					# Simpan baris untuk matriks kedua
    
    add $t4, $zero, $zero
    la $s2, baris2
    la $s3, kolom2
    la $s5, matriks2

Outerloop2:
    lw $t6, 0($s2) 					# Ambil indeks baris 2
    
    # Increment baris2
    addi $t4, $t4, 1 
    addi $s2, $s2, 4
    
    # Restart loop counter  
    la $s3, kolom2
    add $t5, $zero, $zero

Innerloop2:
    # Ambil indeks kolom2
    lw $t7, 0($s3)
    
    # Multiply untuk matriks2  
    mult $t6, $t7
    mflo $t9
    sw $t9, 0($s5)
    
    # Increment matriks2  
    addi $s5, $s5, 4
    
    # Add loop counter, increment kolom2
    addi $t5, $t5, 1
    addi $s3, $s3, 4

    bne $t5, $t3, Innerloop2 		# Jika loop counter sama dengan panjang kolom 2, lanjut ke outerloop
    bne $t4, $t2, Outerloop2 		# Jika loop counter sama dengan panjang baris 2, lanjut ke langkah berikutnya

    # Print element matriks2
    li $t4, 0        				# Reset $t4
    la $s5, matriks2   				# Reload address matriks 2

print_loop2:
    li $t5, 0        				# Reset $t5
    li $v0, 4       				# Print barrier
    la $a0, barrier
    syscall

print_inner_loop2:
    lw $t9, 0($s5)   				# Load element matriks2
    
    move $a0, $t9    
    li $v0, 1        				# Print integer
    syscall

    # Print spasi
    li $v0, 4
    la $a0, space
    syscall

    addi $s5, $s5, 4       			# Pindah pointer ke elemen selanjutnya
    addi $t5, $t5, 1       			# Increment column counter
    bne $t5, $t3, print_inner_loop2 # Cek jika semua kolom sudah diprint

    li $v0, 4
    la $a0, nextLine
    syscall

    addi $t4, $t4, 1       			# Increment row counter
    bne $t4, $t2, print_loop2      	# Cek jika semua kolom sdh diprint
    
    bne $t0, $t2, ordoBeda 			# Jika ordo tidak sama, print ordoBeda
    beq $t1, $t3, ordoSama 			# Jika ordo sama, print ordoSama

ordoBeda:
    li $v0, 4
    la $a0, String6
    syscall # Print String 6
    j exit

ordoSama:
    li $v0, 4
    la $a0, String7
    syscall # Print String 7
    j exit

exit:
    li $v0, 10 # Exit program
    syscall