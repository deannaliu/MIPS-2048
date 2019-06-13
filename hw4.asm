##############################################################
# name: Mei Qi Deanna Liu
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

clear_board:
	# $a0 is the 2D Board
	# $a1 is numRows
	# $a2 is numColumns
	
	blt $a1, 2, clearBoardError
	blt $a2, 2, clearBoardError
	
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	li $s0, 0  				# i, row counter
	li $s1, -1  				# value to store in array

	clearBoardRow:
		li $s2, 0  			# j = column counter
	clearBoardColumn:			
		mul $s3, $s0, $a2 		# $t3 = i * numColumns
		add $s3, $s3, $s2 		# $t3 = i * numColumns + j
		sll $s3, $s3, 1   		# $t3 = 2 * (i * numColumns + j) 
		add $s3, $s3, $a0 		# $t3 = baseAddress + 2 * (i * numColumns + j)
		sh $s1, 0($s3)
		addi $s2, $s2, 1  		# j++
		blt $s2, $a2, clearBoardColumn	# j < numColumns
	clearBoardLoopDone:
		addi $s0, $s0, 1  		# i++
		blt $s0, $a1, clearBoardRow	# i < numRows
		j endClearBoard			# end
	clearBoardError:
		li $v0, -1
		jr $ra
	endClearBoard:
		li $v0, 0			# return 0 for success
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		jr $ra
powerOf2:
						# $a0 is the value
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	blt $a0, 2, errorPower
	
	li $s1, 0 				# counter = 0
	li $t4, 1 				# position = 1
	li $t5, 0 				# i = 0
	loopPower:
		and $s2, $a0, $t4 		# bit = num & position
		beqz $s2, endPowerLoop		# bit == 0, so leave if-statement
		addi $s1, $s1, 1		# bit == 1, so add 1 to counter
		bgt $s1, 1, errorPower	
	endPowerLoop:
		sll $t4, $t4, 1			# position = position << 1
		addi $t5, $t5, 1		# i++
		blt $t5, 32, loopPower		# if i < 32 then iterate again	
		j successPower
	errorPower:
		li $v0, -1	
		j endPower	
	successPower:
		li $v0, 0
	endPower:
		lw $ra, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
		jr $ra	
place:
						# $a0 is the board address
						# $a1 is the nRows
						# $a2 is the nColumns
						# $a3 is the row
	lw $s1, 0($sp)				# $s1 is col 
	lw $s2, 4($sp)				# $s2 is val
	addi $sp, $sp, 8			# reset Stack Pointer
	
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	move $s4, $a0				# $s4 is the board address [baseAddress]
	blt $a1, 2, errorPlace			# check if nRows < 2
	blt $a2, 2, errorPlace			# check if nColumns < 2
	bltz $a3, errorPlace			# check that the row < = 0
	bge $a3, $a1, errorPlace		# check that the row > nRows
	bltz $s1, errorPlace			# check that the col < = 0
	bge $s1, $a2, errorPlace		# check that the col > nColumns
	bne $s2, -1, checkPower			# check that val is not -1
	j startPlace
	checkPower:			
		move $a0, $s2		
		jal powerOf2
		beq $v0, -1, errorPlace
		j startPlace
	startPlace:
		mul $s3, $a3, $a2 		# $t3 = i * numColumns
		add $s3, $s3, $s1 		# $t3 = i * numColumns + j
		sll $s3, $s3, 1   		# $t3 = 2 * (i * numColumns + j) 
		add $s3, $s3, $s4 		# $t3 = baseAddress + 2 * (i * numColumns + j)
		sh $s2, 0($s3)			
		li $v0, 0
		j endPlace
	errorPlace:	
		li $v0, -1
	endPlace:
		lw $ra, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
		jr $ra

start_game:
						# $a0 is the board Address
						# $a1 is the num_rows
						# $a2 is the num_cols
						# $a3 is r1
	lw $s1, 0($sp)				# $s1 is c1
	lw $s3, 4($sp)				# $s3 is r2
	lw $s4, 8($sp)				# $s4 is c2
	addi $sp, $sp, -8
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s5, $a0 
	
	blt $a1, 2, errorStartGame
	blt $a2, 2, errorStartGame
	bltz $a3, errorStartGame
	bltz $s1, errorStartGame
	bltz $s3, errorStartGame
	bltz $s4, errorStartGame
	bge $a3, $a1, errorStartGame
	bge $s3, $a1, errorStartGame
	bge $s1, $a2, errorStartGame
	bge $s4, $a2, errorStartGame
	beq $a3, $s3, checkColumnEqual
	j startGame
	
	checkColumnEqual:
		beq $s1, $s4, errorStartGame
	startGame:
		jal clear_board
		addi $sp, $sp, -8
		li $s2, 2
		sw $s1, 0($sp)
		sw $s2, 4($sp)
		jal place
		move $a0, $s5
		move $a3, $s3
		move $s1, $s4
		li $s2, 2
		addi $sp, $sp, -8
		sw $s1, 0($sp)
		sw $s2, 4($sp)
		jal place
		j successStartGame
	successStartGame:
		li $v0, 0
		j endStartGame
	errorStartGame:
		li $v0, -1
	endStartGame:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
 		jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
								# $a0 is board address
								# $a1 is numRows
								# $a2 is numColumns
								# $a3 is row
	lw $s1, 0($sp)						# $s1 is direction
	addi $sp, $sp, 4
	
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	bltz $a3, errorMergeRow
	bge $a3, $a1, errorMergeRow
	blt $a1, 2, errorMergeRow
	blt $a2, 2, errorMergeRow
	bnez $s1, checkIfOne
	j startMergeRow
	
	checkIfOne:
		bne $s1, 1, errorMergeRow	
	startMergeRow:
		li $s2, 0 					# $s2 will hold number of cells with nonempty values after the merge
		mul $s3, $a2, $a3 				# $s3 = row * numColumns
		sll $s3, $s3, 1   				# $s3 = 2 * (row * numColumns) 
		add $s3, $s3, $a0 				# $s3 = baseAddress + 2 * (row * numColumns)
		move $s7, $a2					# $s7 is numColumns
		sll $t6, $s7, 1					# $t6 is numColumns * 2 to get the bits
		addi $s7, $s7, -1				# $s7 decrement 1 to match the last index
		move $s2, $s3					# $s2 = row address that we are looking at
		li $t9, 0					# column counter 
		li $t8, 0					# counter for number of cells leftover
		beqz $s1, leftToRight				# if direction = 0, left to right Merge
								# else, direction = 1, right to left merge
		rightToLeft:	
			add $s3, $s3, $t6			# $s3 = end address
			addi $s3, $s3, -2			
			loopMatrixRL:
				bge $t9, $s7, checkLeftover	
				addi $s4, $s3, -2		# $s4 will hold the adjacent to $s3
				lh $s5, 0($s3)		
				lh $s6, 0($s4)
				beq $s5, $s6, checkNeg1RL	# compare the 2 cells
			contLoopMatrixRL:
				addi $s3, $s3, -2		# decrement the cell
				addi $t9, $t9, 1		# increment the counter
				j loopMatrixRL
			checkNeg1RL:
				bne $s5, -1, mergeRL
				j contLoopMatrixRL
			mergeRL:
				sll $s6, $s6, 1			# multiply the right cell by 2
				sh $s6, 0($s3)			# store it back into the right cell
				li $s5, -1
				sh $s5, 0($s4)			# store -1 into the left cell
				addi $s3, $s3, -2		# decrement the cell
				addi $t9, $t9, 1		# increment the column counter
				j loopMatrixRL
		leftToRight:
			loopMatrixLR:
				bge $t9, $s7, checkLeftover
				addi $s4, $s3, 2		# $s4 will hold the adjacent to $s3
				lh $s5, 0($s3)
				lh $s6, 0($s4)
				beq $s5, $s6, checkNeg1LR	# compare the 2 adjacent cells
			contLoopMatrixLR:
				addi $s3, $s3, 2		# decrement the cell
				addi $t9, $t9, 1		# increment the counter
				j loopMatrixLR		
			checkNeg1LR:
				bne $s5, -1, mergeLR
				j contLoopMatrixLR	
			mergeLR: 
				sll $s5, $s5, 1			# multiply the left cell by 2
				sh $s5, 0($s3)			# store it back into the left cell
				li $s6, -1
				sh $s6, 0($s4)			# store -1 into the right cell
				addi $s3, $s3, 2		#increment the cell
				addi $t9, $t9, 1		# increment the column counter
				j loopMatrixLR
	checkLeftover:
		li $t7, 0					# $t7 = i
		checkBoard:
			bge $t7, $a2, doneLoopMatrix
			lh $s0, 0($s2)
			bne $s0, -1, incrementCounter
			addi $t7, $t7, 1
			addi $s2, $s2, 2
			j checkBoard
		incrementCounter:
			addi $t7, $t7, 1
			addi $t8, $t8, 1
			addi $s2, $s2, 2
			j checkBoard
	doneLoopMatrix:
		move $v0, $t8
		j endMergeRow
	errorMergeRow:
		li $v0, -1
	endMergeRow:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		addi $sp, $sp, 32
		jr $ra

merge_col:
    						 		# $a0 is board address
								# $a1 is numRows
								# $a2 is numColumns
								# $a3 is col
	lw $s1, 0($sp)						# $s1 is direction
	addi $sp, $sp, 4
	
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	bltz $a3, errorMergeColumn
	bge $a3, $a1, errorMergeColumn
	blt $a1, 2, errorMergeColumn
	blt $a2, 2, errorMergeColumn
	bnez $s1, checkIfOneColumn
	j startMergeColumn
	
	checkIfOneColumn:
		bne $s1, 1, errorMergeColumn	
	startMergeColumn:
		li $s2, 0 					# $s2 will hold number of cells with nonempty values after the merge
		sll $s3, $a3, 1   				# $s3 = 2 * (col) 
		add $s3, $s3, $a0 				# $s3 = baseAddress + 2 * (col)
		move $s7, $a1					# $s7 is numRows
		sll $t6, $s7, 1					# $t6 is numRows * 2 to get the bits
		sll $t5, $a2, 1					# $t5 is numColumns * 2 to get the bits
		addi $s7, $s7, -1				# $s7 decrement 1 to match the last index
		mul $t4, $a1, $a2				# $t4 is the end address 
		sll $t4, $t4, 1					# $t4 is the end address bits
		move $s2, $s3					# $s2 = row address that we are looking at
		li $t9, 0					# column counter 
		li $t8, 0					# counter for number of cells leftover
		beqz $s1, bottomToTop				# if direction = 0, bottom to top merge
								# else, direction = 1, top to bottom merge
		topToBottom:
			loopMatrixTB:
				bge $t9, $s7, checkLeftoverColumn
				add $s4, $s3, $t5		# $s4 will hold the under to $s3
				lh $s5, 0($s3)			
				lh $s6, 0($s4)
				beq $s5, $s6, checkNeg1TB	# compare the 2 adjacent cells
			contLoopMatrixTB:
				add $s3, $s3, $t5		# decrement the cell
				addi $t9, $t9, 1		# increment the counter
				j loopMatrixTB	
			checkNeg1TB:
				bne $s5, -1, mergeTB
				j contLoopMatrixTB		
			mergeTB: 
				sll $s5, $s5, 1			# multiply the top cell by 2
				sh $s5, 0($s3)			# store it back into the top cell
				li $s6, -1
				sh $s6, 0($s4)			# store -1 into the bottom cell
				add $s3, $s3, $t5		# increment the cell
				addi $t9, $t9, 1		# increment the column counter
				j loopMatrixTB
		bottomToTop:	
			add $s3, $s3, $t4			# $s3 = end address
			sub $s3, $s3, $t5			# $s3 = endAddress - last cell 
			loopMatrixBT:
				bge $t9, $s7, checkLeftoverColumn	
				sub $s4, $s3, $t5		# $s4 will hold the under to $s3
				lh $s5, 0($s3)		
				lh $s6, 0($s4)
				beq $s5, $s6, checkNeg1BT	# compare the 2 cells
			contLoopMatrixBT:
				sub $s3, $s3, $t5		# decrement the cell
				addi $t9, $t9, 1		# increment the counter
				j loopMatrixBT
			checkNeg1BT:
				bne $s5, -1, mergeBT
				j contLoopMatrixBT
			mergeBT:
				sll $s6, $s6, 1			# multiply the bottom cell by 2
				sh $s6, 0($s3)			# store it back into the bottom cell
				li $s5, -1
				sh $s5, 0($s4)			# store -1 into the bottom cell
				sub $s3, $s3, $t5		# decrement the cell
				addi $t9, $t9, 1		# increment the column counter
				j loopMatrixBT
		
	checkLeftoverColumn:
		li $t7, 0					# $t7 = i
		checkBoardColumn:
			bge $t7, $a1, doneLoopMatrixColumn
			lh $s0, 0($s2)
			bne $s0, -1, incrementCounterColumn
			addi $t7, $t7, 1
			add $s2, $s2, $t5
			j checkBoardColumn
		incrementCounterColumn:
			addi $t7, $t7, 1
			addi $t8, $t8, 1
			add $s2, $s2, $t5
			j checkBoardColumn
	doneLoopMatrixColumn:
		move $v0, $t8
		j endMergeColumn
	errorMergeColumn:
		li $v0, -1
	endMergeColumn:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		addi $sp, $sp, 32
		jr $ra
shift_row:
    								# $a0 is the board address
    								# $a1 is numRows
    								# $a2 is numColumns
    								# $a3 is row
	lw $s0, 0($sp)						# $s0 is direction 
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -28
    	sw $s0, 0($sp)
    	sw $s1, 4($sp)
    	sw $s2, 8($sp)
    	sw $s3, 12($sp)
    	sw $s4, 16($sp)
    	sw $s5, 20($sp)
    	sw $s7, 24($sp)
    	
    	bltz $a3, errorShiftRow
    	bge $a3, $a1, errorShiftRow
    	blt $a1, 2, errorShiftRow
    	blt $a2, 2, errorShiftRow
    	bnez $s0, checkIfOneSR
	j startShiftRow
	checkIfOneSR:
		bne $s0, 1, errorShiftRow
	startShiftRow:
		mul $s3, $a2, $a3 					# $s3 = row * numColumns
		sll $s3, $s3, 1   					# $s3 = 2 * (row * numColumns) 
		add $s3, $s3, $a0 					# $s3 = baseAddress + 2 * (row * numColumns)
		move $s1, $s3						# $s1 is a copy of the row address [not altering]
		move $s2, $s3						# $s2 is a copy of the row address
		li $t0, 1						# $t0 is the column counter
		li $t1, 0						# $t1 is the amount shifted
		move $s7, $a2						# $s7 is numColumns
		sll $t6, $s7, 1						# $t6 is numColumns * 2 to get the bits
		addi $s7, $s7, -1					# $s7 decrement 1 to match the last index
		beqz $s0, shiftLeft					# if direction = 0, shift left
		shiftRightOut:						# if direction = 1, shiftRight
			add $s3, $s3, $t6				# $s3 = end address
			addi $s3, $s3, -2				# $s3 = board[numCol - 1]
			move $s1, $s3					# $s1 is copy of board[numCol - 1]
			move $s2, $s3					# $s2 is copy of board[numCol - 1]
			shiftRight:
				bge $t0, $a2, loadShiftAmount		
				move $s2, $s1				# reset $s2 to board[numCol - 1]
				addi $s3, $s3, -2			# start at column #1
				lh $s4, 0($s3)				# $s4 = the current cell
				addi $t0, $t0, 1			# increment counter for the cell column
				bne $s4, -1, shiftRightLoop
				j shiftRight
				shiftRightLoop:
					beq $s3, $s2, shiftRight	
					lh $s5, 0($s2)
					beq $s5, -1, moveRight
					addi $s2, $s2, -2
					j shiftRightLoop
				moveRight:
					sh $s4, 0($s2)
					sh $s5, 0($s3)
					addi $t1, $t1, 1
					j shiftRight
		shiftLeft:
			bge $t0, $a2, loadShiftAmount
			move $s2, $s1
			addi $s3, $s3, 2				# start at column #1
			lh $s4, 0($s3)					# $s4 = the current cell
			addi $t0, $t0, 1
			bne $s4, -1, shiftLeftLoop
			j shiftLeft
			shiftLeftLoop:
				beq $s3, $s2, shiftLeft
				lh $s5, 0($s2)
				beq $s5, -1, moveLeft
				addi $s2, $s2, 2
				j shiftLeftLoop
			moveLeft:
				sh $s4, 0($s2)
				sh $s5, 0($s3)
				addi $t1, $t1, 1
				j shiftLeft
	loadShiftAmount:
		move $v0, $t1
		j endShiftRow
    	errorShiftRow:
    		li $v0, -1
    	endShiftRow:
    		lw $s0, 0($sp)
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $s3, 12($sp)
    		lw $s4, 16($sp)
    		lw $s5, 20($sp)
    		lw $s7, 24($sp)
    		addi $sp, $sp, 28
    		jr $ra

shift_col:	
    									# $a0 is the board address
    									# $a1 is numRows
    									# $a2 is numColumns
    									# $a3 is col
	lw $s0, 0($sp)							# $s0 is direction 
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -24
    	sw $s0, 0($sp)
    	sw $s1, 4($sp)
    	sw $s2, 8($sp)
    	sw $s3, 12($sp)
    	sw $s4, 16($sp)
    	sw $s5, 20($sp)
    	
    	bltz $a3, errorShiftColumn
    	bge $a3, $a1, errorShiftColumn
    	blt $a1, 2, errorShiftColumn
    	blt $a2, 2, errorShiftColumn
    	bnez $s0, checkIfOneSC
	j startShiftColumn
	checkIfOneSC:
		bne $s0, 1, errorShiftColumn
	startShiftColumn:
		#mul $s3, $a1, $a3 					# $s3 = col * numRows
		sll $s3, $a3, 1   					# $s3 = 2 * (col * numRows) 
		add $s3, $s3, $a0 					# $s3 = baseAddress + 2 * (col * numRows)
		move $s1, $s3						# $s1 is a copy of the column address [not altering]
		move $s2, $s3						# $s2 is a copy of the column address
		li $t0, 1						# $t0 is the row counter
		li $t1, 0						# $t1 is the amount shifted
		sll $t5, $a2, 1						# $t5 is numColumns * 2 to get the bits
		mul $t4, $a1, $a2					# $t4 is the end address 
		sll $t4, $t4, 1						# $t4 is the end address bits
		beqz $s0, shiftUp					# if direction = 0, shift up
		shiftDownOut:						# if direction = 1, shift down
			add $s3, $s3, $t4				# $s3 = end address
			sub $s3, $s3, $t5				# $s3 = board[numRow - 1]
			move $s1, $s3					# $s1 is copy of board[numRow - 1]
			move $s2, $s3					# $s2 is copy of board[numRow - 1]
			shiftDown:
				bge $t0, $a1, loadShiftAmountSC		
				move $s2, $s1				# reset $s2 to board[numRow - 1]
				sub $s3, $s3, $t5			# start at board[numRow - 1]
				lh $s4, 0($s3)				# $s4 = the current cell
				addi $t0, $t0, 1			# increment counter for the cell row
				bne $s4, -1, shiftDownLoop
				j shiftDown
				shiftDownLoop:
					beq $s3, $s2, shiftDown	
					lh $s5, 0($s2)
					beq $s5, -1, moveDown
					sub $s2, $s2, $t5
					j shiftDownLoop
				moveDown:
					sh $s4, 0($s2)
					sh $s5, 0($s3)
					addi $t1, $t1, 1
					j shiftDown
		shiftUp:
			bge $t0, $a1, loadShiftAmountSC
			move $s2, $s1
			add $s3, $s3, $t5				# start at column #1
			lh $s4, 0($s3)					# $s4 = the current cell
			addi $t0, $t0, 1
			bne $s4, -1, shiftUpLoop
			j shiftUp
			shiftUpLoop:
				beq $s3, $s2, shiftUp
				lh $s5, 0($s2)
				beq $s5, -1, moveUp
				add $s2, $s2, $t5
				j shiftUpLoop
			moveUp:
				sh $s4, 0($s2)
				sh $s5, 0($s3)
				addi $t1, $t1, 1
				j shiftUp
	loadShiftAmountSC:
		move $v0, $t1
		j endShiftColumn
    	errorShiftColumn:
    		li $v0, -1
    	endShiftColumn:
    		lw $s0, 0($sp)
    		lw $s1, 4($sp)
    		lw $s2, 8($sp)
    		lw $s3, 12($sp)
    		lw $s4, 16($sp)
    		lw $s5, 20($sp)
    		addi $sp, $sp, 24
    		jr $ra
checkMergeButDontMergeRow:
								# $a0 is board address
								# $a1 is numRows
								# $a2 is numColumns
								# $a3 is row
	addi $sp, $sp, -24
	sw $s2, 0($sp)
	sw $s3, 4($sp)
	sw $s4, 8($sp)
	sw $s5, 12($sp)
	sw $s6, 16($sp)
	sw $s7, 20($sp)
	
	bltz $a3, errorCheckMergeRow
	bge $a3, $a1, errorCheckMergeRow
	blt $a1, 2, errorCheckMergeRow
	blt $a2, 2, errorCheckMergeRow
		
	startCheckMergeRow:
		mul $s3, $a2, $a3 				# $s3 = row * numColumns
		sll $s3, $s3, 1   				# $s3 = 2 * (row * numColumns) 
		add $s3, $s3, $a0 				# $s3 = baseAddress + 2 * (row * numColumns)
		move $s7, $a2					# $s7 is numColumns
		addi $s7, $s7, -1				# $s7 decrement 1 to match the last index
		
		li $s2, 0					# column counter 
		
		loopCheckMatrix:
			bge $s2, $s7, doneLoopCheckMatrix
			addi $s4, $s3, 2		# $s4 will hold the adjacent to $s3
			lh $s5, 0($s3)
			lh $s6, 0($s4)
			beq $s5, $s6, checkNeg1R	# compare the 2 adjacent cells
		contLoopCheckMatrix:
			addi $s3, $s3, 2		# decrement the cell
			addi $s2, $s2, 1		# increment the counter
			j loopCheckMatrix		
		checkNeg1R:
			bne $s5, -1, mergeableRow
			j contLoopCheckMatrix	
		mergeableRow:
			li $v0, 1
			j endCheckMergeRow
	doneLoopCheckMatrix:
		li $v0, 0
		j endCheckMergeRow
	errorCheckMergeRow:
		li $v0, -1
	endCheckMergeRow:
		lw $s2, 0($sp)
		lw $s3, 4($sp)
		lw $s4, 8($sp)
		lw $s5, 12($sp)
		lw $s6, 16($sp)
		lw $s7, 20($sp)
		addi $sp, $sp, 24
		jr $ra

checkMergeButDontMergeColumn:
								# $a0 is board address
								# $a1 is numRows
								# $a2 is numColumns
								# $a3 is col
	addi $sp, $sp, -28
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	sw $s6, 20($sp)
	sw $s7, 24($sp)
	
	bltz $a3, errorCheckMergeColumn
	bge $a3, $a1, errorCheckMergeColumn
	blt $a1, 2, errorCheckMergeColumn
	blt $a2, 2, errorCheckMergeColumn
		
	startCheckMergeColumn:
		sll $s3, $a3, 1   				# $s3 = 2 * (col)
		add $s3, $s3, $a0 				# $s3 = baseAddress + 2 * (col)
		move $s7, $a1					# $s7 is numRows
		sll $s2, $a2, 1
		addi $s7, $s7, -1				# $s7 decrement 1 to match the last index
		
		li $s1, 0					# row counter 
		
		loopCheckMatrixColumn:
			bge $s1, $s7, doneLoopCheckMatrixColumn
			add $s4, $s3, $s2		# $s4 will hold the adjacent to $s3
			lh $s5, 0($s3)
			lh $s6, 0($s4)
			beq $s5, $s6, checkNeg1C	# compare the 2 adjacent cells
		contLoopCheckMatrixColumn:
			add $s3, $s3, $s2		# decrement the cell
			addi $s1, $s1, 1		# increment the counter
			j loopCheckMatrixColumn		
		checkNeg1C:
			bne $s5, -1, mergeableColumn
			j contLoopCheckMatrixColumn	
		mergeableColumn:
			li $v0, 1
			j endCheckMergeColumn
	doneLoopCheckMatrixColumn:
		li $v0, 0
		j endCheckMergeColumn
	errorCheckMergeColumn:
		li $v0, -1
	endCheckMergeColumn:
		lw $s1, 0($sp)
		lw $s2, 4($sp)
		lw $s3, 8($sp)
		lw $s4, 12($sp)
		lw $s5, 16($sp)
		lw $s6, 20($sp)
		lw $s7, 24($sp)
		addi $sp, $sp, 28
		jr $ra
check_state:
    	# $a0 is the board address
   	# $a1 is the numRows
   	# $a2 is the numColumns
    
	addi $sp, $sp, -4
	sw $ra, 0($sp)
   
	li $t5, 0						# count -1
	li $t0, 0						# $t0 = row counter
	
	checkStateRowLoop:
		li $t2, 0  					# j = column counter
	checkStateLoop:			
		mul $t3, $t0, $a2 				# $t3 = i * numColumns
		add $t3, $t3, $t2 				# $t3 = i * numColumns + j
		sll $t3, $t3, 1   				# $t3 = 2 * (i * numColumns + j) 
		add $t3, $t3, $a0 				# $t3 = baseAddress + 2 * (i * numColumns + j)
		lh $t1, 0($t3)
		bge $t1, 2048, success
		beq $t1, -1, incNeg1Counter
	continueCheckStateLoop:
		addi $t2, $t2, 1  				# j++
		blt $t2, $a2, checkStateLoop			# j < numColumns
	checkStateDone:
		addi $t0, $t0, 1  				# i++
		blt $t0, $a1, checkStateRowLoop			# i < numRows
		j checkEmptySpaces				# check if there are empty spaces
	incNeg1Counter:
		addi $t5, $t5, 1				# increment the number of -1
		j continueCheckStateLoop
	checkEmptySpaces:
		bgtz $t5, gamePlayable				# if amount of empty spaces > 0 then the game is still playable
								# else check if mergable
	checkMergesRow:
		li $t2, 0					# $t2 = row counter
		rowCheckLoop:
			bge $t2, $a1, checkMergesColumn 
			move $a3, $t2
			jal checkMergeButDontMergeRow
			bnez $v0, gamePlayable
			addi $t2, $t2, 1
			j rowCheckLoop
	checkMergesColumn:
		li $t2, 0					# $t2 = column counter
		columnCheckLoop:
			bge $t2, $a2, lost
			move $a3, $t2
			jal checkMergeButDontMergeColumn
			bnez $v0, gamePlayable
			addi $t2, $t2, 1
			j columnCheckLoop
	lost:
		li $v0, -1					# return -1 if lost
		j endCheckState
	success:
		li $v0, 1					# return 1 if won
		j endCheckState
	gamePlayable:
		li $v0, 0					# return 0 for other than success and lost
	endCheckState:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
user_move:
    	# $a0 is the board address
    	# $a1 is numRows
    	# $a2 is numColumns
    	# $a3 is dir - 'L', 'R', 'U', 'D'
    
    	addi $sp, $sp, -8
	sw $ra, 4($sp)
    
   	startUserMove:
    		beq $a3, 'L', shiftMergeLeftRow
    		beq $a3, 'R', shiftMergeRightRow
    		beq $a3, 'U', shiftMergeUpColumn
    		beq $a3, 'D', shiftMergeDownColumn
    		j errorUserMove					# if it's not LRUD then it's an error
   	shiftMergeLeftRow:
		li $t2, 0					# $t2 = row counter
		rowShiftLoopLeft:
			bge $t2, $a1, checkGameState 
			move $a3, $t2
			li $s0, 0
			sw $s0, 0($sp)
			jal shift_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s1, 0
			sw $s1, 0($sp)
			jal merge_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s0, 0
			sw $s0, 0($sp)
			jal shift_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			addi $t2, $t2, 1
			j rowShiftLoopLeft
   		shiftMergeRightRow:
    			li $t2, 0					# $t2 = row counter
		rowShiftLoopRight:
    			bge $t2, $a1, checkGameState 
			move $a3, $t2
			li $s0, 1
			sw $s0, 0($sp)
			jal shift_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s1, 1
			sw $s1, 0($sp)
			jal merge_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s0, 1
			sw $s0, 0($sp)
			jal shift_row
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			addi $t2, $t2, 1
			j rowShiftLoopRight
    	shiftMergeUpColumn:
    		li $t2, 0					# $t2 = column counter
		colShiftLoopUp:
    			bge $t2, $a1, checkGameState 
			move $a3, $t2
			li $s0, 0
			sw $s0, 0($sp)
			jal shift_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s1, 1
			sw $s1, 0($sp)
			jal merge_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s0, 0
			sw $s0, 0($sp)
			jal shift_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			addi $t2, $t2, 1
			j colShiftLoopUp
  	shiftMergeDownColumn:
    		li $t2, 0					# $t2 = column counter
		colShiftLoopDown:
			bge $t2, $a1, checkGameState 
			move $a3, $t2
			li $s0, 1
			sw $s0, 0($sp)
			jal shift_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s1, 0
			sw $s1, 0($sp)
			jal merge_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			li $s0, 1
			sw $s0, 0($sp)
			jal shift_col
			addi $sp, $sp, -4
			beq $v0, -1, errorUserMove
			addi $t2, $t2, 1
			j colShiftLoopDown
    	checkGameState:
    		jal check_state
    		move $v1, $v0
    		li $v0, 0
    		j endUserMove
    	errorUserMove:
    		li $v0, -1
    		li $v1, -1
   	 endUserMove:
    		lw $ra, 4($sp)
    		addi $sp, $sp, 4
    		jr $ra

#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here
