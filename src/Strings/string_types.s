# reads a string (with a maximum of 20 characters) in an loop (until the string is "end") and prints the types of its characters (uppercase/ lowercase/ other)

# data segment
.data
	msg1: .asciiz "Give string:\n"
	msg2: .asciiz " uppercase English letters: "
	msg3: .asciiz " lowercase English letters: "
	msg4: .asciiz " other English letters: "
	msg5: .asciiz "The string contains:\n"
	newl: .asciiz "\n"

	S: .space 21  # 20 + 1 (eos)
	
	# buffers to store uppercase, lowercase and other characters
	uppercase: .space 21
	lowercase: .space 21
	other: .space 21

.text
 .globl __start
__start:

li $t1, 'a'
li $t2, 'z'
li $t3, 'A'
li $t4, 'Z'
li $s4, '\n' 
Loop:
	la $a0, msg1
	jal print_str

	# read string
	la $a0, S
	li $a1, 21
	jal read_str
	move $t0, $a0
	move $t6, $a0
	jal print_str

	# check if string is "end"
	lbu $s0, 0($t6)
	beqz $s0, EndOfCheck
	li $t5, 'e'
	bne $s0, $t5, EndOfCheck

	lbu $s0, 1($t6)
	beqz $s0, EndOfCheck
	li $t5, 'n'
	bne $s0, $t5, EndOfCheck

	lbu $s0, 2($t6)
	beqz $s0, EndOfCheck
	li $t5, 'd'
	bne $s0, $t5, EndOfCheck

	lbu $s0, 3($t6)
	beqz $s0, EndOfCheck
	beq $s0, $s4, end  # terminate

	EndOfCheck:
	li $s1, 0  # upper counter
	li $s2, 0  # lower counter
	li $s3, 0  # other counter

	la $t5, uppercase
	la $t6, lowercase
	la $t7, other
	Search:
		addi $t0, 1
		lbu $s0, -1($t0)
		beq $s0, $zero, printStr

		beq $s0, $s4, Search  # character is new line, skip
		bgt $s0, $t4, Lowercase
		j Uppercase
		
		Uppercase:
			blt $s0, $t3, Other
			sb $s0, 0($t5)
			addi $t5, 1
			addi $s1, 1
			j Search
		Lowercase:
			bgt $s0, $t2, Other
			blt $s0, $t1, Other
			sb $s0, 0($t6)
			addi $t6, 1
			addi $s2, 1
			j Search
		Other:
			sb $s0, 0($t7)
			addi $s3, 1
			addi $t7, 1

		j Search
	
	printStr:
		la $a0, msg5
		jal print_str

		# terminate strings with \0
		sb $zero, 0($t5)
		sb $zero, 0($t6)
		sb $zero, 0($t7)

		# print uppercase
		move $a0, $s1
		jal print_int_from_reg
		la $a0, msg2
		jal print_str

		la $a0, uppercase
		jal print_str
		jal print_newl

		# print lowercase
		move $a0, $s2
		jal print_int_from_reg
		la $a0, msg3
		jal print_str
		la $a0, lowercase
		jal print_str
		jal print_newl

		# print other
		move $a0, $s3
		jal print_int_from_reg
		la $a0, msg4
		jal print_str

		la $a0, other
		jal print_str
		jal print_newl

		jal print_newl
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

print_int_from_reg:
	# call for print
	li $v0, 1
	syscall
	jr $ra
