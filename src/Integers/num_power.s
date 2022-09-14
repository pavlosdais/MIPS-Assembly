# reads in a loop a base and a positive power and prints the number (stops if the the base is 0)

# data segment
.data
	msg1: .asciiz "Give the base: "
	msg2: .asciiz "Give the power: "
	msg3: .asciiz "The result is: "
	newl: .asciiz "\n"

.text
 .globl __start
__start:

Loop:
	la $a0, msg1
	jal print_str
	jal read_int
	
	# if the number is 0, exit
	beqz $v0, exit

	move $s0, $v0  # store base at s0

	move $a0, $s0
	jal print_int_from_reg
	jal print_newl

	la $a0, msg2
	jal print_str
	jal read_int
	move $s1, $v0  # store power at s1

	move $a0, $s1
	jal print_int_from_reg
	jal print_newl

	li $t0, 1
	move $t1, $s0
	findNum: 
		addi $t0, 1
		bgt $t0, $s1, printResult
		mult $s0, $t1
		mflo $s0
		j findNum

exit:
	jal print_newl
	li $v0, 10
	syscall

printResult:
	la $a0, msg3
	jal print_str
	move $a0, $s0
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

print_int_from_reg:
	# the restister of whom we want the contents to print (for example $s0)

	# call for print
	li $v0, 1
	syscall
	jr $ra

print_str:
	# call for print
	li $v0, 4
	syscall
	jr $ra
