
.data
matrix: .space 32 # 4 x 4 matrix of 2-byte words
rows: .word 4
columns: .word 4
newLine: .word '\n'
.text
.globl _start

_start:
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	jal clear_board
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 0
	addi $sp, $sp, -8
	li $s1, 0
	li $s2, 2
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 1
	addi $sp, $sp, -8
	li $s1, 0
	li $s2, 8
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 2
	addi $sp, $sp, -8
	li $s1, 0
	li $s2, 2
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 3
	addi $sp, $sp, -8
	li $s1, 0
	li $s2, 8
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 0
	addi $sp, $sp, -8
	li $s1, 1
	li $s2, 8
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 1
	addi $sp, $sp, -8
	li $s1, 1
	li $s2, 4
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 2
	addi $sp, $sp, -8
	li $s1, 1
	li $s2, 16
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 3
	addi $sp, $sp, -8
	li $s1, 1
	li $s2, 64
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 0
	addi $sp, $sp, -8
	li $s1, 2
	li $s2, 4
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 1
	addi $sp, $sp, -8
	li $s1, 2
	li $s2, 2
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 2
	addi $sp, $sp, -8
	li $s1, 2
	li $s2, 256
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 3
	addi $sp, $sp, -8
	li $s1, 2
	li $s2, 16
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 0
	addi $sp, $sp, -8
	li $s1, 3
	li $s2, 2
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 1
	addi $sp, $sp, -8
	li $s1, 3
	li $s2, 8
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 2
	addi $sp, $sp, -8
	li $s1, 3
	li $s2, 64
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
	la $a0, matrix 
	lw $a1, rows    # number of rows
	lw $a2, columns # number of columns
	li $a3, 3
	addi $sp, $sp, -8
	li $s1, 3
	li $s2, 4
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	jal place
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	
#	lw $a0, matrix
#	lw $a1, rows    # number of rows
#	lw $a2, columns # number of columns
#	li $a3, 0
#	addi $sp, $sp, -4
#	li $s0, 1
#	sw $s0, 0($sp)
#	jal shift_col
#	lw $s1, 0($sp)
#	addi $sp, $sp, 4
	
#	move $a0, $v0 
#	li $v0, 1
#	syscall
#	la $a0, newLine
#	li $v0, 4
#	syscall
	
	la $a0, matrix
	lw $a1, rows
	lw $a2, columns
	jal check_state
		
	move $a0, $v1
	li $v0, 1
	syscall
	la $a0, newLine
	li $v0, 4
	syscall

	li $v0, 10
	syscall

.include "hw4.asm"