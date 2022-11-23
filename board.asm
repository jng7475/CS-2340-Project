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

occupied: .asciiz "Illegal Move: Space is Full\nPlease Try Again\n"

.eqv        DATA_SIZE 4

	.text

.globl changeBoard
changeBoard:
	#check whose turn
	#take in new move
	#assuming $s0 and $s1 contain rowInd and colInd respectively
	
	la $a0, boardArray
	
	#addr = baseAddr + (rowInd * colSize + colInd) * dataSize
	addi $t0, $t0, size	# $t0 = size
	mult $s0, $t0 		# rowInd * colSize
	mflo $t1		# move lo to $t1
	add $t1, $t1, $s1 	# (rowInd * colSize) + colInd
	addi $t2, $t2, DATA_SIZE # $t1 = data_size = 4
	mult $t1, $t2		# (rowInd * colSize + colInd) * dataSize
	mflo $t3
	
	add $a1, $a0, $t3	# $a1 now contains address for the correct array element
	
	j checkEmpty 		#check if the element at the address is already filled
	
isEmpty:
	#change value at $a1
	sw $s5, $a1		# $s5 is tentative register for player or cpu turn
				# store in $a1
	
	jr $ra
	
	
isFull:
	#print error message
	li $v0, 4
	la $a0, occupied
	syscall
	
	jr $ra
	
	

checkEmpty:
	lw $t5, 0($a1) 		# $t5 contains the value at the input index
	beqz $t5, isEmpty 	# if value is 0 then branch back to changeBoard
	j isFull
	
