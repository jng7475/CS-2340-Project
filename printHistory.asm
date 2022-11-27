.data
#global
	history: .asciiz "HISTORY: \n"
	black_side: .asciiz "black"
	white_side: .asciiz "white"
	start: .word 1
	newline: .asciiz "\n"
	space: .asciiz "  "
	move1: .asciiz "A1"
	move2: .asciiz "A2"
	
.text
# .globl

	lw $t1, start
	jal print_history
	jal print_history
	j end_program



print_history:
	la $a0, history
	li $v0, 4
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	la $a0, black_side
	li $v0, 4
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	la $a0, white_side
	li $v0, 4
	syscall
	
	# print newline
	la $a0, newline
	li $v0, 4
	syscall
	
	#lw $t0, start
	li  $v0, 1           
	add $a0, $t1, $zero  
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	# print moves
	la $a0, move1
	li $v0, 4
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	
	la $a0, move2
	li $v0, 4
	syscall
	
	# print newline
	la $a0, newline
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1
	jr $ra
	
end_program:
        li $v0, 10
        syscall
