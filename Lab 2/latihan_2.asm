.data:
    output1: .asciiz "Nilai terendah = "
    output2: .asciiz "\nNilai tertinggi = "
    output3: .asciiz "\nRata-rata nilai = "
    output4: .asciiz "\nRange nilai = "
    divider: .asciiz "\n--------------------"
    output5: .asciiz "\nPeokra: \"Sepertinya soal lab perlu dipermudah\""
    output6: .asciiz "\nPeokra: \"Sepertinya soal lab perlu dipersulit\""
    scores: .word 95,85,55,100,80,87,94,86,-1

.text:
    # Memasukkan alamat scores ke dalam register $t0
    la $t0, scores

    # Inisialisasi nilai terendah dengan nilai pertama dalam array
    lw $t1, 0($t0)

    # Inisiaisasi nilai tertinggi dengan nilai pertama dalam array
    lw $t2, 0($t0)

    # Inisialisasi jumlah dengan 0
    li $t3, 0

    # Inisialisasi indeks dengan 1
    li $t4, 0

loop:
    # Hitung alamat elemen saat ini
    sll $t5, $t4, 2
    add $t5, $t0, $t5

    # Load elemen saat ini
    lw $t6, 0($t5)

    # Jika elemen saat ini adalah -1, berarti kita sudah mencapai akhir array
    beq $t6, -1, continue

    # Tambahkan elemen saat ini ke jumlah
    add $t3, $t3, $t6

    # Jika elemen saat ini lebih rendah dari nilai terendah, update nilai terendah
    blt $t6, $t1, updateLowerThan

    # Jika elemen saat ini lebih tinggi dari nilai tertinggi, update nilai tertinggi
    bgt $t6, $t2, updateBiggerThan

    # Lanjutkan ke elemen berikutnya
    addi $t4, $t4, 1
    j loop

updateLowerThan:
    # Update nilai terendah
    move $t1, $t6

    # Lanjutkan ke elemen berikutnya
    addi $t4, $t4, 1
    j loop

updateBiggerThan:
    # Update nilai tertinggi
    move $t2, $t6

    # Lanjutkan ke elemen berikutnya
    addi $t4, $t4, 1
    j loop

continue:
    # Cetak string nilai terendah
    li $v0, 4
    la $a0, output1
    syscall
    # Cetak angka nilai terendah
    li $v0, 1
    move $a0, $t1
    syscall

    # Cetak string nilai tertinggi
    li $v0, 4
    la $a0, output2
    syscall
    # Cetak angka nilai tertinggi
    li $v0, 1
    move $a0, $t2
    syscall

    # Cetak string rata-rata
    li $v0, 4
    la $a0, output3
    syscall
    # Hitung rata-rata
    div $t3, $t4
    mflo $t7
    # Cetak angka rata-rata
    li $v0, 1
    move $a0, $t7
    syscall

    # Cetak string range
    li $v0, 4
    la $a0, output4
    syscall
    # Hitung range
    sub $t8, $t2, $t1
    # Cetak angka range
    li $v0, 1
    move $a0, $t8
    syscall

    # Cetak string pembatas
    li $v0, 4
    la $a0, divider
    syscall

    # Kondisional untuk menampilkan output Peokra Dipersulit
    bgt $t7, 79, printPeokraDipersulit

    # Cetak output Peokra Dipermudah
    li $v0, 4
    la $a0, output5
    syscall
    j end

printPeokraDipersulit:
    # Cetak output Peokra Dipersulit
    li $v0, 4
    la $a0, output6
    syscall

end:
    # Akhiri program
    li $v0, 10
    syscall
