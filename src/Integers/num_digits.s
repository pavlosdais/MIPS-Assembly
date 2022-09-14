# reads a number in a loop (until the number is 0) and prints its digits and the its power. For example if the number read is 100:
# 1*10^2+0*10^1+0*10^0

# data segment
.data
	msg: .asciiz "Give integer: "
	add_symbol: .asciiz "+"
	star: .asciiz "*"
	power: .asciiz "10^"
	newl: .asciiz "\n"

	digits:	.space 10  # buffer to store the digits of the number

.text
 .globl __start
__start:

loop:
	# print message
	la $a0, msg
	jal print_str
	
	# read int and store it at $t9
	li $v0, 5
	syscall
	move $t9, $v0
	
	# print the read int
	move $a0, $v0
	jal print_int
	jal print_newl
	
	beqz $t9, exit  # if int is 0, exit

	move $s1, $t9  # int is at s1
	li $t0, 10
	li $t2, 0  # t0 stores the number of digits (of the read number)
	
	# find and store all the integers at "digits"
	loop2:
		div $s1, $t0
		mfhi $t1  # store mod
		mflo $s1  # store div

		sb $t1, digits($t2)  # store the remainder at digits

		addi $t2, 1
		bnez $s1, loop2	
	
	print:
		addi $t2, $t2, -1
		
		# print the digit
		lb $a0, digits($t2)
		jal print_int
		
		# print '*'
		la $a0, star
		jal print_str

		# print 10^
		la $a0, power
		jal print_str
		
		# print t2
		move $a0, $t2
		jal print_int
		
		# if t2 != 0, print '+'
		bnez $t2, print_add
		
		# print new line
		jal print_newl
		
	j loop

exit:
	li $v0, 10
	syscall

print_add:
	la $a0, add_symbol
	jal print_str
	j print

print_int:
	li $v0, 1
	syscall
	jr $ra

print_str:
	li $v0, 4		
	syscall
	jr $ra
	
print_newl:
	la $a0, newl
	li $v0, 4
	syscall
	jr $ra
