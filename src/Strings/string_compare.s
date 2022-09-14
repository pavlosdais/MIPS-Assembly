# reads 2 strings (with a maximum of 10 characters) and prints the characters they have in common

# data segment
.data
    msg1: .asciiz "Character "
    msg2: .asciiz " is the same at places: "
    msg3: .asciiz " and "
    msg4: .asciiz "(string1)"
    msg5: .asciiz "(string2)"
    msg6: .asciiz "Give string 1:\n"
    msg7: .asciiz "Give string 2:\n"
    msg8: .asciiz "No same characters between string 1 and string 2\n"
    newl: .asciiz "\n"
	
    buffer1: .space 11  # 10 + 1 (eos)
    buffer2: .space 11  # 10 + 1 (eos)

.text
 .globl __start
__start:

# read and print string1
la $a0, msg6
jal print_str

la $a0, buffer1
li $a1, 11
jal read_str
move $t0, $a0  # save string1 at reg t0
jal print_str
jal print_newl

# read and print string2
la $a0, msg7
jal print_str

la $a0, buffer2
li $a1, 11
jal read_str

jal print_str
jal print_newl

li $t9, '\n'
li $t2, 0
li $t3, 0  # number of same characters between string 1 and string 2

# for each character at string 1, search if it exists at string 2
Loop1:
	la $t1, buffer2  # load string2 at reg t1
	
	lbu $s0, 0($t0)  # load ch from string 1 (at place t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 1  # counter1
	
	beq $s0, $zero, exit  # terminate when you find eos for string 1
	beq $s0, $t9, Loop1  # if you find new line, move to the next character
	
	li $t4, 0  # counter 2
	
	# search string 2 for the char at reg $s0
	Loop2:
		lbu $s1, 0($t1)  # load ch from string 2 (at place t4)
		addi $t1, $t1, 1
		
		addi $t4, $t4, 1  # counter2
		
		beq $s0, $t9, Loop2  # if you find new line, move to the next char
		beq $s1, $zero, Loop1  # terminate when you find eos
		
		bne $s0, $s1, NotEqual  # characters are not equal
		
		# if we reach this point, characters are equal, print them 
		# as well as their place (counters) at string1 and string 2
		
		la $a0, msg1
		jal print_str
		
		move $a0, $s1
		jal print_char
		
		la $a0, msg2
		jal print_str
		
		move $a0, $t2  # counter for str1
		jal print_int_from_reg
		
		la $a0, msg4
		jal print_str
		
		la $a0, msg3
		jal print_str
		
		move $a0, $t4  # counter for str2
		jal print_int_from_reg
		
		la $a0, msg5
		jal print_str
		
		addi $t3, $t3, 1  # same character found, increase counter
		jal print_newl
		
		NotEqual:
			# characters are not equal, loop to the new character
			j Loop2

exit:
	beqz $t3, print_no_common  # if there are no same characters, print a message
	
	terminate:
		li $v0, 10
		syscall

print_no_common:
	la $a0, msg8
	li $v0, 4
	syscall
	j terminate

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

print_char:
	# call for print
	li $v0, 11
	syscall
	jr $ra

print_int_from_reg:
	# call for print
	li $v0, 1
	syscall
	jr $ra
