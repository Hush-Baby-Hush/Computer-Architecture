.text

# void toggle_light(int row, int col, LightsOut* puzzle, int action_num){
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     unsigned char* board = (puzzle-> board);
#     board[row*num_cols + col] = (board[row*num_cols + col] + action_num) % num_colors;

#     if (row > 0){
#         board[(row-1)*num_cols + col] = (board[(row-1)*num_cols + col] + action_num) % num_colors;
#     }
#     if (col > 0){
#         board[(row)*num_cols + col-1] = (board[(row)*num_cols + col-1] + action_num) % num_colors;
#     }
#     
#     if (row < num_rows - 1){
#         board[(row+1)*num_cols + col] = (board[(row+1)*num_cols + col] + action_num) % num_colors;
#     }
# 
#     if (col < num_cols - 1){
#         board[(row)*num_cols + col+1] = (board[(row)*num_cols + col+1] + action_num) % num_colors;
#     }
# }
# $a0 row
# $a1 col
# $a2 puzzle
# $a3 action_num

.globl toggle_light
toggle_light:
	sub   	$sp, $sp, 20
	sw    	$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw 		$s2, 12($sp)
	sw		$s3, 16($sp)

	lw		$s0, 0($a2)		# s0 = puzzle->num_rows
	lw		$s1, 4($a2)		# s1 = puzzle->num_cols
	lw		$s2, 8($a2)		# s2 = puzzle->num_colors
	addi	$s3, $a2, 12 	# s3 = char* board = (puzzle-> board)

	mul		$t0, $a0, $s1	# t0 = row*num_cols
	add		$t0, $t0, $a1	# t0 = row*num_cols + col
	add 	$t0, $t0, $s3	# t0 = address of board[row*num_cols + col]
	lbu		$t1, 0($t0)		# t0 = board[row*num_cols + col]

	add 	$t1, $t1, $a3	# t0 = board[row*num_cols + col] + action_num
	rem		$t1, $t1, $s2	# t0 = (board[row*num_cols + col] + action_num) % num_colors
	sb		$t1, 0($t0)		# t1 = board[row*num_cols + col]

	ble		$a0, $zero, second_if
	sub		$t0, $a0, 1
	mul		$t0, $t0, $s1
	add		$t0, $t0, $a1
	add		$t0, $t0, $s3	# t0 = address of board[(row-1)*num_cols + col]
	lbu		$t1, 0($t0)	
	add		$t1, $t1, $a3
	rem		$t1, $t1, $s2
	sb		$t1, 0($t0)

second_if:
	ble		$a1, $zero, third_if
	mul		$t0, $a0, $s1
	add		$t0, $t0, $a1
	sub		$t0, $t0, 1
	add		$t0, $t0, $s3
	lbu		$t1, 0($t0)
	add		$t1, $t1, $a3
	rem		$t1, $t1, $s2
	sb		$t1, 0($t0)

third_if:
	sub		$t2, $s0, 1
	bge		$a0, $t2, forth_if
	addi	$t0, $a0, 1
	mul		$t0, $t0, $s1
	add		$t0, $t0, $a1
	add		$t0, $t0, $s3
	lbu		$t1, 0($t0)
	add		$t1, $t1, $a3
	rem		$t1, $t1, $s2
	sb		$t1, 0($t0)

forth_if:
	sub		$t2, $s1, 1
	bge		$a1, $t2, over
	mul		$t0, $a0, $s1
	add		$t0, $t0, $a1
	add		$t0, $t0, 1
	add		$t0, $t0, $s3
	lbu		$t1, 0($t0)
	add		$t1, $t1, $a3
	rem		$t1, $t1, $s2
	sb		$t1, 0($t0)

over:
	lw    	$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw 		$s2, 12($sp)
	lw		$s3, 16($sp)
	add   	$sp, $sp, 20

	jr		$ra



# bool solve(LightsOut* puzzle, unsigned char* solution, int row, int col){
#     int num_rows = puzzle->num_rows; 
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     int next_row = ((col == num_cols-1) ? row + 1 : row);
#     if (row >= num_rows || col >= num_cols) {
#          return board_done(num_rows,num_cols,puzzle->board);
#     }
#
#     if (puzzle->clue[row*num_cols + col]) {
#          return solve(puzzle,solution, next_row, (col+1) % num_cols);
#     }
# 
#     for(char actions = 0; actions < num_colors; actions++) {
#         solution[row*num_cols + col] = actions;
#         toggle_light(row, col, puzzle, actions);
#         if (solve(puzzle,solution, next_row, (col + 1) % num_cols)) {
#             return true;
#         }
#         toggle_light(row, col, puzzle, num_colors - actions); 
#         solution[row*num_cols + col] = 0;
#     }
#     return false;
# }
# $a0 puzzle
# $a1 solution
# $a2 row
# $a3 col

.globl solve
solve:
	sub   	$sp, $sp, 44
	sw    	$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw 		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s4, 20($sp)
	sw 		$s5, 24($sp)
	sw		$s6, 28($sp)
	sw		$s7, 32($sp)

	move	$s5, $a1		# s5 = a1	char* solution
	move 	$s6, $a2		# s6 = a2	int row
	move	$s7, $a3		# s7 = a3	int col

#     int num_rows = puzzle->num_rows; 
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
	lw		$s0, 0($a0)		# s0 = puzzle->num_rows
	lw		$s1, 4($a0)		# s1 = puzzle->num_cols
	lw		$s2, 8($a0)		# s2 = puzzle->num_colors
	addi	$s3, $a0, 12 	# s3 = char* board = (puzzle-> board)
	addi	$s4, $a0, 268	# s4 = char* clue


#     int next_row = ((col == num_cols-1) ? row + 1 : row);
	sub		$t7, $s1, 1
	beq		$s7, $t7, EQUAL
	move	$t7, $s6
	j		NEXT
EQUAL:
	addi	$t7, $s6, 1		# t7 = next_row 

#     if (row >= num_rows || col >= num_cols) {	
NEXT:
	sw		$t7, 36($sp)	# store t7, the next_row

	bge		$s6, $s0, first_if2
	bge		$s7, $s1, first_if2

#     if (puzzle->clue[row*num_cols + col]) {
	mul		$t1, $s6, $s1
	add		$t1, $t1, $s7
	add		$t1, $t1, $s4
	lbu		$t2, 0($t1)
	bne		$t2, $zero, second_if2


#     for(char actions = 0; actions < num_colors; actions++) {
	li 		$t6, 0			# t6 = actions
	sb		$t6, 40($sp)
for_loop:
	lb		$t6, 40($sp)
	bge		$t6, $s2, done_loop

#         solution[row*num_cols + col] = actions;
	mul		$t5, $s6, $s1
	add		$t5, $t5, $s7
	add		$t5, $s5, $t5
	sb		$t6, 0($t5)

#         toggle_light(row, col, puzzle, actions);
	move	$a0, $s6
	move	$a1, $s7
	sub		$a2, $s3, 12
	move	$a3, $t6
	jal		toggle_light


#         if (solve(puzzle,solution, next_row, (col + 1) % num_cols)) {
	sub		$a0, $s3, 12
	move 	$a1, $s5
	lw		$t7, 36($sp)
	move	$a2, $t7 
	addi	$t5, $s7, 1
	rem		$a3, $t5, $s1

	jal		solve
	move	$t5, $v0
	bne		$t5, $zero, RETURN_TRUE

#         toggle_light(row, col, puzzle, num_colors - actions); 
	move	$a0, $s6
	move	$a1, $s7
	sub		$a2, $s3, 12
	lb		$t6, 40($sp)
	sub		$a3, $s2, $t6
	jal		toggle_light


#         solution[row*num_cols + col] = 0;
	mul		$t5, $s6, $s1
	add		$t5, $t5, $s7
	add		$t5, $t5, $s5
	sb		$zero, 0($t5)
	lb		$t6, 40($sp)
	addi	$t6, $t6, 1
	sb		$t6, 40($sp)
	j		for_loop

#             return true;
RETURN_TRUE:
	li		$v0, 1
	j 		clean_up


#          return board_done(num_rows,num_cols,puzzle->board);
first_if2:
	move	$a0, $s0
	move	$a1, $s1
	move 	$a2, $s3
	jal		board_done
	j     	clean_up


#          return solve(puzzle,solution, next_row, (col+1) % num_cols);
second_if2:
	sub		$a0, $s3, 12
	move	$a1, $s5
	lw		$t7, 36($sp)
	move	$a2, $t7
	addi	$t3, $s7, 1
	rem		$a3, $t3, $s1
	jal		solve
	j		clean_up


#     return false;
done_loop:
	li		$v0, 0
	j 		clean_up
clean_up:
	lw    	$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw 		$s2, 12($sp)
	lw		$s3, 16($sp)
	lw		$s4, 20($sp)
	lw 		$s5, 24($sp)
	lw		$s6, 28($sp)
	lw		$s7, 32($sp)
	add   	$sp, $sp, 44

	jr $ra