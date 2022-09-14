# reads a string (with a maximum of 20 characters) in an endless loop and prints it like this: (if the string is, for example, hello)
# *ello
# h*llo
# he*lo
# hel*o
# hell*

# data segment
.data
	msg1: .asciiz "Give string (max 20 characters): "
	newl: .asciiz "\n"

	buffer: .space 21  # 20 + 1 (eos)

.text
 .globl __start
__start:

MainLoop:
	la $a0, msg1
	jal print_str
	la $a0, buffer  # buffer to write the string into (for example $s1)
	li $a1, 21  # max length of string (n+1)
	jal read_str
	move $t0, $a0  # store word at $t0

	li $t2, '*'
	li $s1, 0
	jal print_newl
	Loop:
		lbu $s0, 0($t0)
		addi $t0, $t0, 1

		beq $s0, $zero, MainLoop

		beqz $s1, current
		sb $s1, -2($t0)

		current:
			move $s1, $s0  # save prev character
			move $s0, $t2
			sb $s0, -1($t0)

		la $a0, buffer
		lbu $s3, 0($t0)
		bnez $s3, print_str

		j Loop

end:
	li $v0, 10
	syscall

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

read_str:
	# call for print
	li $v0, 8
	syscall
	jr $ra
