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
you_win: .asciiz "YOU WIN!"

.eqv        DATA_SIZE 4

.text

.globl changeBoard
changeBoard:
	li  $v0, 1           
	add $a0, $s0, $zero  
	syscall
	li $v0, 4
        la $a0, newLine
        syscall
	li  $v0, 1           
	add $a0, $s1, $zero  
	syscall
	li $v0, 4
        la $a0, newLine
        syscall
	#check whose turn
	#take in new move
	#assuming $s0 and $s1 contain rowInd and colInd respectively
	
	la $a0, boardArray
	
	#addr = baseAddr + (rowInd * colSize + colInd) * dataSize
	lw $t0, size	# $t0 = size
	mult $s0, $t0 		# rowInd * colSize
	mflo $t1		# move lo to $t1
	add $t1, $t1, $s1 	# (rowInd * colSize) + colInd
	addi $t2, $t2, DATA_SIZE # $t2 = data_size = 4
	mult $t1, $t2		# (rowInd * colSize + colInd) * dataSize
	mflo $t3
	
	add $a1, $a0, $t3	# $a1 now contains address for the correct array element
	
	j checkValidPosition 		#check if the element at the address is already filled
	
isValid:
	#change value at $a1
	#sw $s5, $a1
	add $s5, $zero, $s7		# $s5 is tentative register for player or cpu turn
	sw $s5, 0($a1) 			# store in $a1
	#beq $s7, 1, change_to_computer
	#beq $s7, 2, change_to_player
	
#change_to_computer:
	#li $s7, 2
	#jr $ra
#change_to_player:
	#li $s7, 1
	
	### ERROR should be fixed
	li $t2 0
	jr $ra
	
	
notValid:
	#print error message
	li $v0, 4
	la $a0, occupied
	syscall
	### ERROR should be fixed
	li $t2 0
	beq $s7, 2, computer_turn # if the computer makes an invalid move computer goes again
	
	j continue
	
	

checkValidPosition:
	lw $t5, 0($a1) 		# $t5 contains the value at the input index
	beqz $t5, isValid 	# if value is 0 then branch back to changeBoard
	j notValid
	
	
.globl print_board
print_board: 
        # ($t1 is counter and index of array, $t2 is for loop condition, $t3 is actual array shift based on index)
        
        sll $t3, $t9, 2
        lw $t4, boardArray($t3) # print a zero at board[i]
        # print each position
        li  $v0, 1           
	add $a0, $t4, $zero  
	syscall
	# print space
	la $a0, space
	li $v0, 4
	syscall
	#slti  $t2, $t1, 225 # if i < 144 then loop
        #beq $zero, $t2, end_program
	
	# check for new line
	j check_for_new_line
	
	#slti  $t2, $t1, 
recursion_call:
        addi $t9, $t9, 1 # increment i
        slti  $t2, $t9, 225 # if i < 144 then loop
        bne $zero, $t2, print_board	
        # SWITCH PLAYER HERE
        li $t9, 0
        j continue
 	
check_for_new_line:
      	move $a1, $t9
        li $a2, 15
        jal mod
        
        move $t4, $v0
        
        sub $t4, $t4, 14
        bne $zero, $t4, noNewLine
        
        li $v0, 4
        la $a0, newLine
        syscall
        
        noNewLine:
        
        j recursion_call


# $v0 = $a1 % $a2
mod:
        div $v0, $a1, $a2
        mulo $v0, $v0, $a2
        sub $v0, $a1, $v0
        jr $ra
        
        
#addr = baseAddr + (rowInd * colSize + colInd) * dataSize
.globl checkCols
checkCols:
	#add $t5, $zero, $s0	#current row
	li $t6, 0	#score counter
	li $t7, 0	#loop counter
	
	li $t8, 14	#col size
	
	j loop
	
loop:
	beq $t6, 5, win		 #exit if score 5
	bgt $t7, $t8, exit
	la $a0, boardArray
	
	#addr = baseAddr + (rowInd * colSize + colInd) * dataSize
	lw $t0, size	# $t0 = size
	mult $t7, $t0 		# rowInd * colSize
	mflo $t1		# move lo to $t1
	add $t1, $t1, $s1 	# (rowInd * colSize) + colInd
	addi $t2, $t2, DATA_SIZE # $t2 = data_size = 4
	mult $t1, $t2		# (rowInd * colSize + colInd) * dataSize
	mflo $t3
	
	add $a1, $a0, $t3	# $a1 now contains address for the correct array element
	lw $t4, 0($a1)
	li $t2, 0
	beq $s7, $t4, increment
	
	addi $t7, $t7, 1 #increment loop counter
	li $t6, 0
	j loop
	
increment:
	addi $t7, $t7, 1 #increment loop counter
	addi $t6, $t6, 1 #increment score sounter
	j loop
	
	
exit:
	jr $ra
	
win:
	la $a0, you_win
	li $v0, 4
	syscall
	
	#terminate program
	li $v0, 10
	syscall
	


