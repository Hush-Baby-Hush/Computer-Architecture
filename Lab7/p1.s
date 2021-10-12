.text

# // part 1 p1.s
# unsigned char find_payment(TreeNode* trav) { 
# 	// Base case
# 	if (trav == NULL) {
# 		return 0;
# 	}
# 	// Recurse once for each child
# 	unsigned char payment_left = find_payment(trav->left);
# 	unsigned char payment_center = find_payment(trav->center);
# 	unsigned char payment_right = find_payment(trav->right);
# 	unsigned char value = payment_left + payment_center + payment_right + trav->value;
# 	return value / 2;
# }

.globl find_payment
find_payment:
	bne		$a0, 0, recursive
	li		$v0, 0
	jr 		$ra
recursive:
	sub   	$sp, $sp, 36
	sw    	$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw 		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s4, 20($sp)
	sw 		$s5, 24($sp)
	sw		$s6, 28($sp)
	sw		$s7, 32($sp)

	move	$s0, $a0	# s0 = base address

	lw		$s1, 0($s0)	# s1 = TreeNode* left
	move 	$a0, $s1
	jal		find_payment
	move	$s2, $v0	# s2 = payment_left

	lw		$s3, 4($s0) # s3 = TreeNode* center
	move	$a0, $s3
	jal 	find_payment
	move	$s4, $v0	# s4 = payment_center

	lw		$s5, 8($s0) # s5 = TreeNode* right
	move	$a0, $s5
	jal 	find_payment
	move	$s6, $v0	# s6 = payment_right

	add 	$s7, $s2, $s4
	add 	$s7, $s7, $s6
	lbu		$t0, 12($s0)
	add		$s7, $s7, $t0	# s7 = all income
	srl		$v0, $s7, 1		# v0 = s7/2
	

	lw    	$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw 		$s2, 12($sp)
	lw		$s3, 16($sp)
	lw		$s4, 20($sp)
	lw 		$s5, 24($sp)
	lw		$s6, 28($sp)
	lw		$s7, 32($sp)
	add   	$sp, $sp, 36

	jr 		$ra