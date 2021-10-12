.text

# void matrix_mult(int *matr_a, int *matr_b, int *output, unsigned int width) {
#     for (int i = 0; i < width; i++) {
#         for (int j = 0; j < width; j++) {
#             output[i*width + j] = 0;
#             for (int k = 0; k < width; k++) {
#                 output[i*width + j] += matr_a[i*width + k] * matr_b[k*width + j];
#             }
#         }
#     }
# }
#
# // a0: int *matr_a
# // a1: int *matr_b
# // a2: int *output
# // a3: unsigned int width

.globl matrix_mult
matrix_mult:
	; move	$t0, $a0	# t0 = base address of matr_a
	; move 	$t1, $a1 	# t1 = base address of matr_b
	; move	$t2, $a2	# t2 = base address of output
	; move 	$t3, $a3	# t3 = width

	sub		$sp, $sp, 48
	sw		$ra, 0($sp)
	sw		$t0, 4($sp)
	sw		$t1, 8($sp)
	sw		$t2, 12($sp)
	sw		$t3, 16($sp)
	sw		$t4, 20($sp)
	sw		$t5, 24($sp)
	sw		$t6, 28($sp)
	sw		$a0, 32($sp)
	sw		$a1, 36($sp)
	sw		$a2, 40($sp)
	sw		$a3, 44($sp)





	li		$t4, 0		# t4 = i
	; li 		$t5, 0		# t5 = j
out_loop:
	bge		$t4, $a3, done_outerloop		# see if i<width
	; sll		$t6, $t4, 2		# t6=i*4
	li 		$t5, 0		# t5 = j
inner_loop:
	bge		$t5, $a3, done_innerloop		# see if j<width
	; sll		$t7, $t5, 2		# t7=j*4
	mul 	$t0, $t4, $a3	# t0 = i*width
	add		$t2, $t0, $t5	# t2 = i*width + j
	mul		$t1, $t2, 4		# t1 = 4*(i*width + j)		
	add		$t6, $t1, $a2 	# t6 = offset = 4*(i*width + j) + output
	sw		$zero, 0($t6)	# output[i*width + j] = 0;

	li		$t3, 0			# t3 = k;
kloop:
	bge		$t3, $a3, done_kloop		# see if k<width
	mul 	$t0, $t4, $a3	# t0 = i*width
	add		$t0, $t0, $t3	# t0 = i*width + k
	mul		$t0, $t0, 4		# t0 = 4(i*width + k)
	add 	$t0, $t0, $a0	# t0 = offset = 4*(i*width + k) + matr_a
	lw		$t1, 0($t0)		# t1 = matr_a[i*width + k]
	mul		$t0, $t3, $a3 	# t0 = k*width
	add 	$t0, $t0, $t5	# t0 = k*width + j
	mul		$t0, $t0, 4		# t0 = 4(k*width + j)
	add 	$t0, $t0, $a1	# t0 = offset = 4*(k*width + j) + matr_b
	lw		$t2, 0($t0)		# t2 = matr_b[k*width + j]
	mul		$t0, $t1, $t2	# t0 = matr_a[i*width + k] * matr_b[k*width + j]
	lw		$t1, 0($t6)		# t1 = output[i*width + j]
	add 	$t1, $t1, $t0	# t1 = output[i*width + j] + matr_a[i*width + k] * matr_b[k*width + j]
	sw		$t1, 0($t6)		# done
	addi	$t3, $t3, 1		# k++ 	
	j		kloop

done_kloop:
	addi	$t5, $t5, 1    	# j++
	j 		inner_loop
done_innerloop:
	addi		$t4, $t4, 1    	# i++
	; li 		$t5, 0			# t5 = j
	j		out_loop
done_outerloop:
	lw		$ra, 0($sp)
	lw		$t0, 4($sp)
	lw		$t1, 8($sp)
	lw		$t2, 12($sp)
	lw		$t3, 16($sp)
	lw		$t4, 20($sp)
	lw		$t5, 24($sp)
	lw		$t6, 28($sp)
	lw		$a0, 32($sp)
	lw		$a1, 36($sp)
	lw		$a2, 40($sp)
	lw		$a3, 44($sp)
	add 	$sp, $sp, 48

	jr	$ra


# #define MAX_WIDTH 100
# int working_matrix[MAX_WIDTH*MAX_WIDTH];

# void markov_chain(int *state, int *transitions, unsigned int width, int times) {
#     for (int i = 0; i < times; i++) {
#         matrix_mult(state, transitions, working_matrix, width);
#         copy(state, working_matrix, width);
#     }
# }
#
# // a0: int *state
# // a1: int *transitions
# // a2: unsigned int width
# // a3: int times

.globl markov_chain
markov_chain:
	# Can access working_matrix from p2_main.s
	sub		$sp, $sp, 28
	sw		$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s4, 20($sp)
	sw		$s5, 24($sp)

	la		$t4, working_matrix		

	move 	$s0, $a0
	move 	$s1, $a1
	move 	$s2, $a2
	move 	$s3, $a3
	move 	$s4, $t4

	li		$s5, 0 		# t1 = i
for_loop:
	bge		$s5, $s3, done_loop		# see if i<times
# // a0: int *matr_a
# // a1: int *matr_b
# // a2: int *output
# // a3: unsigned int width
	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s4
	move 	$a3, $s2

	jal		matrix_mult
# argument $a0: pointer to start of destination matrix
# argument $a1: pointer to start of source matrix
# argument $a2: width of matrix	

	move 	$a0, $s0
	move 	$a1, $s4
	move 	$a2, $s2

	jal		copy

	addi 	$s5, $s5, 1
	j 		for_loop


done_loop:
	lw		$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw		$s2, 12($sp)
	lw		$s3, 16($sp)
	lw		$s4, 20($sp)
	lw		$s5, 24($sp)
	add 	$sp, $sp, 28
	jr	$ra
	