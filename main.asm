
.text
main:
	li $s7, 1 		# $t7 contains current player (1: user   2: computer)
	li $s6, 0		# move counter
	
	
.globl continue_game
continue_game:
	beq $s6, 225, game_tied	# check for tie
	
player_turn:
	jal make_move
	jal changeBoard		# apply input to boardArray
	
	# Check for win
	jal checkCols
	jal checkRows
	jal check_diagonal_backward
	jal check_diagonal_forward
	
	li $s7, 2 		# switch player
	
.globl computer_turn
computer_turn:

	jal random_number 	# generate random move for computer
	jal changeBoard
	
	jal checkCols
	jal checkRows
	jal check_diagonal_backward
	jal check_diagonal_forward
	
	li $s7, 1
	
	jal print_board
	
	j continue_game
	

game_tied:
	li $v0, 10
	syscall
