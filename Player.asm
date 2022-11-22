.data
	row_prompt: .asciiz "Enter a row number (0-14): "
	col_prompt: .asciiz "\nEnter a column number (0-14): "
	buffer: .space 20
.text
#.globl
random_number:
	li $a1, 15  #max bound 15
    	li $v0, 42  #generate random number.
    	syscall
    	li $v0, 1   #1 print integer
    	syscall
    	
    	li $v0, 10
    	syscall
    	
make_move:
	#prompt for row number
	la $a0, row_prompt
	li $v0, 4
	syscall
	
	#read string row number (ascii board)
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	move $s0, $a0
	syscall
	
	#prompt for column number
	la $a0, col_prompt
	li $v0, 4
	syscall
	
	#read string column number (ascii board)
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	move $s1, $a0 #move to s0
	syscall
	
	#PRINT FOR DEBUGGING
	#la $a0, buffer  # reload byte space to primary address
   	#move $a0, $s0   # primary address = t0 address (load pointer)
    	#li $v0, 4       # print string
    	#syscall
	
	li $v0, 10
	syscall