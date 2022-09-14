# reads two 4-digit integers in an endless loop and prints the number of digits they have in common

# data segment
.data
	msg1: .asciiz "Give the first 4-digit number: "
	msg2: .asciiz "Give the second 4-digit number: "
	msg3: .asciiz "ERROR! Number does not contain 4 digits\n"
	msg4: .asciiz "They have this many digits in common: "
	newl: .asciiz "\n"

.text
 .globl __start
__start:

Loop:
	# FIRST NUMBER
	la $a0, msg1
	jal print_str

	jal read_int
	move $s0, $v0  # store first num at s0

	move $a0, $s0
	jal print_int_from_reg
	jal print_newl

	li $t0, 0  # t0 stores the number of digits of num1
	li $t1, 10
	move $t2, $s0
	li $t3, 4
	findNumOfDigits1:
		div $t2, $t1
		mflo $t2
		addi $t0, 1
		bgt $t0, $t3, Error
		bnez $t2, findNumOfDigits1
	bne $t0, $t3, Error

	# SECOND NUMBER
	la $a0, msg2
	jal print_str

	jal read_int
	move $s1, $v0  # store first num at s0

	move $a0, $s1
	jal print_int_from_reg
	jal print_newl

	li $t0, 0  # t0 stores the number of digits of num2
	move $t2, $s1
	findNumOfDigits2:
		div $t2, $t1
		mflo $t2
		addi $t0, 1
		bgt $t0, $t3, Error
		bnez $t2, findNumOfDigits2
	bne $t0, $t3, Error

	# By now we know that num1 ($s0) and num2 ($s1) both have 4 digits
	# all we need to check is the number of digits they have in common

	li $t0, 0  # i
	li $t4, 0  # number of common digits
	for_loop:
		addi $t0, 1

		div $s0, $t1
		mflo $s0
		mfhi $t5

		div $s1, $t1
		mflo $s1
		mfhi $t6

		seq $t7, $t5, $t6
		add $t4, $t4, $t7

		blt $t0, $t3, for_loop
	
	la $a0, msg4
	jal print_str

	move $a0, $t4
	jal print_int_from_reg

	jal print_newl
	jal print_newl
	j Loop

print_newl:	
	la $a0, newl
	li $v0, 4
	syscall
	jr $ra

read_int:
	# call for read
	li $v0, 5
	syscall
	jr $ra

print_str:
	# call for print
	li $v0, 4
	syscall
	jr $ra

print_int_from_reg:
	# call for print
	li $v0, 1
	syscall
	jr $ra

Error:
	la $a0, msg3
	jal print_str
	jal print_newl
	j Loop
