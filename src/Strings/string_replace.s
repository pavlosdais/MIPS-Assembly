# reads a string (with a maximum of 20 characters) in an endless loop replaces the characters of a string with * , from a read index until its end

# data segment
.data
	msg1: .asciiz "Give string:\n"
	msg2: .asciiz "Give num: [1,20] (or 0 to exit)\n"
	newl: .asciiz "\n"

    buffer: .space 21  # 20 + 1 (eos)

.text
 .globl __start
__start:

li $s1, '*'
li $s2, '\n'
Loop:
	la $a0, msg1
	jal print_str

	la $a0, buffer
	li $a1, 21
	jal read_str
	jal print_str

	move $t0, $a0  # store string at t0

	la $a0, msg2
	jal print_str

	li $v0, 5
	syscall
	move $t1, $v0

	move $a0, $t1  # store num at t1
	jal print_int_from_reg
	jal print_newl

	beqz $t1, end

	add $t0, $t0, $t1
	addi $t0, -1

	Replace:
		lbu $s0, 0($t0)
		addi $t0, $t0, 1
		
		beq $s0, $s2, Replace
		beq $s0, $zero, printRes

		move $s0, $s1
		sb $s0, -1($t0)

		j Replace
	
	j Loop

end:
	jal print_newl
	li $v0, 10
	syscall

printRes:
	la $a0, buffer
	li $v0, 4
	syscall

	j Loop

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

read_int:
	# call for read
	li $v0, 5
	syscall
	jr $ra

print_int_from_reg:
	# call for print
	li $v0, 1
	syscall
	jr $ra
