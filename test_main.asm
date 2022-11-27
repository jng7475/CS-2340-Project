.data
	test: .asciiz "test"
.text
main:
	#la $a0, test
	#li $v0, 4
	#syscall
	
	jal print_board
	