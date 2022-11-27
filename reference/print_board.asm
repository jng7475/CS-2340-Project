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

.eqv        DATA_SIZE 4

.text
main:
	li $t1, 0
        
print_board: 
        # ($t1 is counter and index of array, $t2 is for loop condition, $t3 is actual array shift based on index)
        
        sll $t3, $t1, 2
        lw $t4, boardArray($t3) # put a zero at board[i]
        # print each position
        li  $v0, 1           
	add $a0, $t4, $zero  
	syscall
	# print space
	la $a0, space
	li $v0, 4
	syscall
	# check for new line
	jal check_for_new_line
	
	#slti  $t2, $t1, 
recursion_call:
        addi $t1, $t1, 1 # increment i
        slti  $t2, $t1, 225 # if i < 144 then loop
        bne $zero, $t2, print_board	
        jal end_program
 
check_for_new_line:
      	move $a1, $t1
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

end_program:
	li $v0, 10
        syscall