# capitalizes a string (with a maximum of 20 characters)

# data segment
.data
	msg: .asciiz "Give string (max 20 characters): "
	str: .space 21  # 20 + 1 (eos)

.text
 .globl __start
__start:
	la $a0, msg
	jal print_str

	# read string with max of 20 characters
	la $a0, str
	li $a1, 21
	li $v0, 8
	syscall

	move $t0, $a0
	li $t1, 'a'  # store 'a' at t1
	li $t2, 'z'  # store 'z' at t2
while:
	lbu $s0, 0($t0)
	addi $t0, $t0, 1

	# check to see if it's end of string (\0), if so exit
	beq $s0, $zero, exit  # end of string // str[s0] == '\0'

	# check to see if character is lower, if not continue
	blt $s0, $t1, while  # str[s0] < 'a' // not a lower char
	bgt $s0, $t2, while  # str[s0] > 'z' // not a lower char

	# lower char
	addi $s0, $s0, -32  # 'A'-'a' = -32

	# store the low byte from register(s0) at address (t0-1 - because earlier we incremented) 
	sb $s0, -1($t0)
	
	j while

exit:
	# print string
	li $v0, 4
	syscall
	# exit
	li $v0, 10
	syscall

print_str:
	# call for print
	li $v0, 4
	syscall
	jr $ra
