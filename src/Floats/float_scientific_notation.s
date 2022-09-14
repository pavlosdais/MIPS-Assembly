# reads a float in a loop (until the number is 0) and prints its form in scientific notation

# data segment
.data
	mantissa: .space 5
	give_num: .asciiz "Give real number"
	msg_science: .asciiz "Number in scientific notation is:"
	zero: .float 0.0
	msg_pos: .asciiz "+"
	msg_neg: .asciiz "-"
	first_digits: .asciiz "1."
	power: .asciiz " x 2^"
	msg_zero: .asciiz "0"
	newl: .asciiz "\n"

.text
 .globl __start	
__start:

# read first int and move it to a temp reg
l.s $f1, zero

while:	
	jal print_give_num
	jal print_newl
	jal read_float
	c.eq.s $f0, $f1
	bc1t exit
	jal print_newl
	jal print_float_from_reg
	jal print_newl
	jal print_msg_science
	jal print_newl

neg_or_pos: 
	c.lt.s $f0,$f1
	bc1t case002  # this condition/case is not valid, check next case 	
	jal print_pos
	j exit_neg_or_pos

case002:
	jal print_neg					

exit_neg_or_pos:
	mfc1 $t0,$f0
	li $t1, 0x007fffff
	and $t3,$t0,$t1
	move $t7,$t3
	li $t2,2
	li $s0,0  # counter
	jal print_first_digits

	li $s3, 23 # needed for operations for correcting missing leading zeroes in mantissa

Loop_correct:
	li $t6,0x00000001
	and $t5,$t6,$t7
	beqz $t5, zero_case
	j exit1

zero_case:
	srl $t7,$t7,1
	addi $s0,$s0,1
	j Loop_correct	

exit1:
	move $t8,$t7
	sub $s1,$s3,$s0	 # s1 is our for loop counter
	li $s5,1

for_loop:
	beqz $s1, exit2
	li $t6, 0x00000001
	and $t5, $t6, $t8
	beqz $t5, zero_case1
	li $s4,0
	j continue_for

zero_case1:
	addi $s4, $s4, 1  # s4 is the leading zero counter	

continue_for:
	srl $t8,$t8,1
	sub $s1, $s1, $s5
	j for_loop

exit2:
	beqz $s4, division_loop
	jal print_zero
	sub $s4,$s4,$s5
	j exit2

division_loop:
	div $t7,$t2
	mflo $t7
	mfhi $t5
	move $t8,$t5
	jal print_int_from_reg
	add $t4,$t4,$t5	
	sll $t4, $t4,1
	bnez $t7, division_loop
					
	sll $t0,$t0,1
	srl $t0,$t0, 24
	addi $t0,$t0, -127
	jal print_power
	move $t8,$t0
	jal print_int_from_reg
	jal print_newl
	j while

exit:
	li $v0, 10
	syscall

print_give_num:		
	li $v0, 4
	la $a0, give_num
	syscall
	jr $ra

print_newl:
	li $v0, 4
	la $a0, newl
	syscall
	jr $ra

read_float:
	li $v0, 6
	syscall
	jr $ra

print_float_from_reg:
	mov.s $f12, $f0
	li $v0, 2
	syscall
	jr $ra

print_msg_science:
	li $v0, 4
	la $a0, msg_science
	syscall
	jr $ra

print_pos:
	li $v0, 4
	la $a0, msg_pos
	syscall
	jr $ra

print_neg:
	li $v0, 4
	la $a0, msg_neg
	syscall
	jr $ra

print_int_from_reg:
	move $a0, $t8
	li $v0, 1
	syscall
	jr $ra

print_first_digits:
	li $v0, 4
	la $a0, first_digits
	syscall
	jr $ra

print_power:
	li $v0, 4
	la $a0, power
	syscall
	jr $ra

print_zero:
	li $v0, 4
	la $a0, msg_zero
	syscall
	jr $ra
