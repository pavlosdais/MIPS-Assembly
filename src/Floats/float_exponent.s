# reads a float in a loop (until the number is 0) and prints its exponenet in floating-point arithmetic

# data segment
.data
    msg1: .asciiz "Give float number: \n"
    msg2: .asciiz "The exponent is: "
    newl: .asciiz "\n"

.text
 .globl __start
__start:

Loop:
	la $a0, msg1
	jal print_str

	jal read_float

	c.eq.s $f0, $f2  # check if number is zero
	bc1t end

	mov.s $f12, $f0

	mfc1 $t0, $f12
	
	# isolate exponent
	sll $t0, $t0, 1
	srl $t0, $t0, 24

	addi $t0, $t0, -127

	la $a0, msg2
	jal print_str

	move $a0, $t0
	jal print_int_from_reg
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

read_float:
	# call for read
	li $v0, 6
	syscall
	jr $ra

print_float_from_reg:
	# call for print
	li $v0, 2
	syscall
	jr $ra

print_int_from_reg:
	# call for print
	li $v0, 1
	syscall
	jr $ra
