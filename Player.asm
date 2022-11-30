.data
	row_prompt: .asciiz "Enter a row number (0-14): "
	col_prompt: .asciiz "\nEnter a column number (0-14): "
	buffer: .space 20
	error_message: .asciiz "Oops! You entered an invalid number. Please try again and enter a number from 0 to 14.\n"
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

    	jr $ra

.globl make_move    	
make_move:
	#prompt for row number
	la $a0, row_prompt
	li $v0, 4
	syscall
	
	#read integer row number
	li $v0, 5
	syscall
	move $s0, $v0
	
	#prompt for column number
	la $a0, col_prompt
	li $v0, 4
	syscall
	
	#read integer column number
	li $v0, 5
	syscall
	move $s1, $v0 #move to s1
	
	#check for invalid inputs
	blt $s0, 0, invalid_input		#check if row < 0
	bgt $s0, 14, invalid_input	#check if row > 14
	blt $s1, 0, invalid_input		#check if col < 0
	bgt $s1, 14, invalid_input	#check if col >14
    	
	jr $ra

invalid_input:
	la $a0, error_message
	li $v0, 4
	syscall
	
	j make_move