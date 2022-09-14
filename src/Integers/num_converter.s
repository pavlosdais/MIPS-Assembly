# reads a 5-digit number and its base, and prints that number in decimal form. For example if the number is 00001, in base 2 (binary), the output is:
# "the number in decimal is: 1"

# data segment
.data
	msg1: .asciiz "Give base:\n"
	msg2: .asciiz "Wrong base; give again:\n"
	msg3: .asciiz "Give 5-digit number in base "
	msg4: .asciiz ":\n"
	msg5: .asciiz "Wrong number; give again:\n"
	msg6: .asciiz "Number in decimal is:\n"
	newl: .asciiz "\n"

.text
 .globl __start
__start:

li $t0, 2
li $t1, 10

# get base
la $a0, msg1
jal print_str

GetCorrectBase:
	li $v0, 5
	syscall
	move $s0, $v0

	move $a0, $s0
	jal print_int_from_reg
	jal print_newl
	blt $s0, $t0, Error1
	bgt $s0, $t1, Error1

# base is at $s0

la $a0, msg3
jal print_str
move $a0, $s0
jal print_int_from_reg
la $a0, msg4
jal print_str

GetCorrectNum:
	li $v0, 5
	syscall
	move $s1, $v0
	move $a0, $s1
	jal print_int_from_reg
	jal print_newl

	li $t0, 0  # result
	li $t1, 1  # current power
	li $t2, 10
	move $t3, $zero

	FindNum:
		addi $t3, 1
		div $s1, $t2
		mfhi $t3  # store mod
		mflo $s1  # store div

		bltz $t3, Error2
		bgt $t3, $s0, Error2

		mult $t3, $t1
		mflo $t3

		add $t0, $t0, $t3

		mult $t1, $s0
		mflo $t1

		beqz $s1, exit
		j FindNum

exit:
	la $a0, msg6
	jal print_str
	move $a0, $t0
	jal print_int_from_reg
	jal print_newl
	li $v0, 10
	syscall

Error1:
	la $a0, msg2
	li $v0, 4
	syscall
	j GetCorrectBase

Error2:
	la $a0, msg5
	li $v0, 4
	syscall
	j GetCorrectNum

print_newl:	
	la $a0, newl
	li $v0, 4
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
