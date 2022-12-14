	.data
boardArray: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  
size : 	    .word 15
newLine: .asciiz "\n"
space: .asciiz "  "
occupied: .asciiz "Illegal Move: Space is Full\nPlease Try Again\n"
you_win: .asciiz "YOU WIN!\n"
you_lost: .asciiz "YOU LOST!\n"

.eqv        DATA_SIZE 4


	.text
.globl changeBoard
changeBoard:
	
	# increment move counter
	addi $s6, $s6, 1
	
	la $a0, boardArray
	
	#inputAddress = baseAddress + (rowInput * size + colInput) * dataSize
	lw $t0, size		
	mult $s0, $t0 		
	mflo $t1		
	add $t1, $t1, $s1 	
	addi $t2, $t2, DATA_SIZE 
	mult $t1, $t2		
	mflo $t3
	
	add $a1, $a0, $t3		# $a1 now contains address for the input array element
	
	j checkValidPosition 		#check if the element at the address is already filled
	
isValid:
	
	add $s5, $zero, $s7		# $s5 contains current player piece
	sw $s5, 0($a1) 			# store in $a1
	
	li $t2, 0			# reset $t2
	
	jr $ra
	
	
notValid:

	#print error message
	li $v0, 4
	la $a0, occupied
	syscall
	
	li $t2, 0
	
	beq $s7, 2, computer_turn 	# if the computer makes an invalid move computer goes again
					
	j continue_game			# if issue is during player turn, the function jumps back to continue
					# and does player turn again
	
	

checkValidPosition:
	lw $t5, 0($a1) 		# $t5 contains the value at the input index
	beqz $t5, isValid 	# if value is 0 then move is valid
	j notValid		# else move is not valid
	
	
.globl print_board
print_board: 
        
        sll $t3, $t9, 2
        lw $t4, boardArray($t3) # load value at board[i]
        
        # print loaded value
        li  $v0, 1           
	add $a0, $t4, $zero  
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	# check if end of row
	j check_for_new_line
	 
loop_print:
        addi $t9, $t9, 1 	# increment i
        slti  $t2, $t9, 225 	# if i < 225 then loop
        bne $zero, $t2, print_board
        
        # reset counter
        li $t9, 0
        
        bne $t8, 999, continue_game # if game is not ended continue
        li $v0, 10		    # else end the game
        syscall
 	
check_for_new_line:
	
	# counter % 15 = current col index
      	move $a1, $t9
        li $a2, 15
        jal mod
        
        move $t4, $v0		# stores current col index
        
        # if curr col ind is 14 then print a new line
        sub $t4, $t4, 14	
        bne $zero, $t4, noNewLine
        
        li $v0, 4
        la $a0, newLine
        syscall
        
	noNewLine:
        	j loop_print

mod:
        div $v0, $a1, $a2
        mulo $v0, $v0, $a2
        sub $v0, $a1, $v0
        jr $ra
        
        
#inputAddress = baseAddress + (rowInput * size + colInput) * dataSize
.globl checkCols
checkCols:
	#add $t5, $zero, $s0	#current row
	li $t6, 0	#score counter
	li $t7, 0	#loop counter
	
	li $t8, 14	#col size
	
	j loop_col
	
loop_col:
	beq $t6, 5, win		# exit if score is 5
	bgt $t7, $t8, exit	# exit when the column iteration finishes
	
	la $a0, boardArray	# loads base address of the board
	
	#inputAddress = baseAddress + (rowInput * size + colInput) * dataSize
	lw $t0, size
	mult $t7, $t0 		
	mflo $t1		
	add $t1, $t1, $s1 	
	addi $t2, $t2, DATA_SIZE 
	mult $t1, $t2		
	mflo $t3
	
	add $a1, $a0, $t3	# $a1 now contains address for the input array element
	
	
	lw $t4, 0($a1)		# get value at $a1
	li $t2, 0		# reset $t2
	beq $s7, $t4, increment # if the value matches the current player, increment score
	
	addi $t7, $t7, 1 	#increment loop counter
	li $t6, 0		# else reset the score counter
	j loop_col
	
increment:
	addi $t7, $t7, 1 	#increment loop counter
	addi $t6, $t6, 1	#increment score sounter
	j loop_col
	
exit:
	jr $ra
	
win:	
	beq $s7, 2, lost 	#if player 2 won then you lost
	
	#else you won
	la $a0, you_win  
	li $v0, 4
	syscall
	
	li $t8, 999 		# $t8 becomes 999 when the game is over
	
	jal print_board		# print final board
	
	#terminate program
	li $v0, 10
	syscall
	
lost:
	la $a0, you_lost
	li $v0, 4
	syscall
	
	li $t8, 999		# $t8 becomes 999 when the game is over
	
	jal print_board		# print final board
	
	#terminate program
	li $v0, 10
	syscall
	
.globl checkRows
checkRows:
	
	li $t6, 0		#score counter
	li $t7, 0		#loop counter
	
	li $t8, 14		#col size
	
	j loop_row
	
loop_row:
	beq $t6, 5, win		# exit if score 5
	bgt $t7, $t8, exit	# exit when the column iteration finishes
	
	la $a0, boardArray	# loads base address of the board
	
	#inputAddress = baseAddress + (rowInput * size + colInput) * dataSize
	lw $t0, size
	mult $s0, $t0 		
	mflo $t1		
	add $t1, $t1, $t7 	
	addi $t2, $t2, DATA_SIZE 
	mult $t1, $t2		
	mflo $t3
	
	add $a1, $a0, $t3	# $a1 now contains address for the correct array element
	
	lw $t4, 0($a1)
	li $t2, 0
	beq $s7, $t4, increment_row
	
	addi $t7, $t7, 1 	#increment loop counter
	li $t6, 0
	j loop_row
	
increment_row:
	addi $t7, $t7, 1 	#increment loop counter
	addi $t6, $t6, 1 	#increment score sounter
	j loop_row
	

# when calculating for diagonals, treat the array like a 1-D array
.globl check_diagonal_backward
check_diagonal_backward:
	la $a0, boardArray
	li $t8, 14		#max diagonal size
	li $t6, 0		#score counter
	
	# if the row index is larger than the col index then input is on the bottom half
	sub $t5, $s0, $s1	# difference of row and column of chosen coordinate
	bgt $t5, 0, bottom_half_backward	# if input is on bottom half
	j top_half_backward			# else input is on top half
	
bottom_half_backward:
	
	
	# current = row * 15 + current column
	li $t7, 15	
	mult $s0, $t7
	mflo $t7
	add $t7, $t7, $s1	# t7 = current index
	
	# start = current - 16 * column
	li $s3, 16
	mult $s1, $s3
	mflo $s3
	sub $t7, $t7, $s3	# t7 -> starting index
	
	li $t6, 0
	
	j loop_diagonal_backward

top_half_backward:
	# current row * 15 + current column
	li $t7, 15
	mult $s0, $t7
	mflo $t7
	add $t7, $t7, $s1	# t7 = current index
	
	# start = current - 16 * row
	li $s3, 16
	mult $s0, $s3
	mflo $s3
	sub $t7, $t7, $s3	# t7 -> starting index
	
	li $t6, 0
	
	j loop_diagonal_backward
		
loop_diagonal_backward:
	beq $t6, 5, win		 #exit if score 5
	
	bgt $t7, 224, exit	# exit if loop finishes
	
	# get current index address
	li $t2, 4
	mult $t7, $t2
	mflo $s4
	add $a1, $a0, $s4	# $a1 stores address at current index
	
	#get value at current index
	lw $t4, 0($a1)
	
	li $t2, 0
	
	beq $s7, $t4, increment_row_diagonal	# if value matches current player increment score
	addi $t7, $t7, 16 			#increment loop counter
	li $t6, 0				# else reset score
	j loop_diagonal_backward
	
increment_row_diagonal:
	addi $t7, $t7, 16 			#increment loop counter
	addi $t6, $t6, 1 			#increment score sounter
	j loop_diagonal_backward
	
.globl check_diagonal_forward
check_diagonal_forward:
	la $a0, boardArray
	li $t8, 14	#col size
	li $t6, 0	#score counter
	sub $t5, $s0, $s1	# sum of row and column of chosen coordinate
	bgt $t5, 0, bottom_half_forward
	j top_half_forward
	
bottom_half_forward:
	# current row * 15 + current column
	li $t7, 15
	mult $s0, $t7
	mflo $t7
	add $t7, $t7, $s1	# t7 = current index
	
	# start = current - 14 * (14 - column)
	li $s3, 14
	sub $s5, $s3, $s1
	mult $s5, $s3
	mflo $s3
	sub $t7, $t7, $s3	# t7 -> starting index
	
	li $t6, 0
	
	j loop_diagonal_forward

top_half_forward:
	# current = row * 15 + current column
	li $t7, 15
	mult $s0, $t7
	mflo $t7
	add $t7, $t7, $s1	# t7 = current index
	
	# start = current - 14 * row
	li $s3, 14
	mult $s0, $s3
	mflo $s3
	sub $t7, $t7, $s3	# t7 -> starting index
	
	li $t6, 0
	
	j loop_diagonal_forward
		
loop_diagonal_forward:
	beq $t6, 5, win		 #exit if score 5
	bgt $t7, 224, exit
	li $t2, 4
	mult $t7, $t2
	mflo $s4
	add $a1, $a0, $s4
	
	lw $t4, 0($a1)
	li $t2, 0
	beq $s7, $t4, increment_row_diagonal_forward
	addi $t7, $t7, 14 #increment loop counter
	li $t6, 0
	j loop_diagonal_forward
	
increment_row_diagonal_forward:
	addi $t7, $t7, 14 #increment loop counter
	
	addi $t6, $t6, 1 #increment score sounter
	j loop_diagonal_forward
	
	
	


