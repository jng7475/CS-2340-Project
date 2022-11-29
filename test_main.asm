.data
	test: .asciiz "test"
	newLine: .asciiz "\n"
.text
main:
	
	
	#jal print_board
	li $s7, 1
.globl continue
continue:	
	#la $a0, test
	#li $v0, 4
	#syscall
	li $v0, 4
        la $a0, newLine
        syscall
	#beq $s7, 1, player_turn
	#beq $s7, 2, computer_turn
	
player_turn:
	jal make_move
	jal changeBoard
	jal checkCols
	li $s7, 2
	
.globl computer_turn
computer_turn:
	jal random_number
	jal changeBoard
	jal checkCols
	li $s7, 1
	jal print_board
	j continue
	

end_program:
	li $v0, 10
	syscall
