.data
	row_prompt: .asciiz "Enter a row number (0-14): "
	col_prompt: .asciiz "\nEnter a column number (0-14): "
	buffer: .space 20
.text
.globl random_number
random_number:
	li $a1, 14  #max bound 15
    	li $v0, 42  #generate random number.
    	syscall
    	
    	move $s0, $a0
    	
    	li $a1, 14  #max bound 15
    	li $v0, 42  #generate random number.
    	syscall
    	
    	move $s1, $a0
    	
    	#li $v0, 1   #1 print integer
    	#syscall
    	
    	#li $v0, 10
    	#syscall

    	jr $ra

.globl make_move    	
make_move:
	#prompt for row number
	la $a0, row_prompt
	li $v0, 4
	syscall
	
	#read string row number (ascii board)
	li $v0, 5
	#la $a0, buffer
	#li $a1, 20
	syscall
	move $s0, $v0
	
	
	#prompt for column number
	la $a0, col_prompt
	li $v0, 4
	syscall
	
	#read string column number (ascii board)
	li $v0, 5
	#la $a0, buffer
	#li $a1, 20
	syscall
	move $s1, $v0 #move to s0
	
	
	#PRINT FOR DEBUGGING
	#la $a0, buffer  # reload byte space to primary address
   	#move $a0, $s0   # primary address = t0 address (load pointer)
    	#li $v0, 4       # print string
    	#syscall
    	
	jr $ra
	#li $v0, 10
	#syscall
