# reads a float in a loop (until the number is 0) and prints "big" if its higher than 1000 or "too small" if it's lower than it

# data segment
.data
    msg1: .asciiz "big\n"
    msg2: .asciiz "too small\n"
    msg3: .asciiz "Give number:\n"
    newl: .asciiz "\n"

    buffer: .space 11

.text
 .globl __start
__start:

li.s $f1, 1000.0
li.s $f2, 0.0
Loop:
	la $a0, msg3
	jal print_str

	jal read_float

	c.eq.s $f0, $f2  # check if number is zero
	bc1t end

	mov.s $f12, $f0
	
	jal print_float_from_reg
	jal print_newl
	
	c.lt.s $f1, $f12  # f12 >= 1000
	bc1t print_big

	jal print_small  # f12 < 1000
	
	j Loop

end:
	li $v0, 10
	syscall

print_small:
	la $a0, msg2
	li $v0, 4
	syscall
	jal print_newl
	j Loop

print_big:
	la $a0, msg1
	li $v0, 4
	syscall
	jal print_newl
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
